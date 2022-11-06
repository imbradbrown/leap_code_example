import Foundation

/**
  This is an example of service that talks to https://swapi.dev/

   In a normal project each of the pieces would be in their own file. For simplicity they're in a playground as one file.
 */

/**
 Defines configuration related to the API. Ideally this would be in an configuration file per environment
 */
struct SwapiConfiguration {
    /**
     Defines the base URL for the service. All endpoint calls should append onto this.
     - Example: `"\(SwapiConfiguration.baseURL)/newAPI"`
     */
    static let baseURL = "https://swapi.dev/api"
}

/**
  The definition of the API is a mix of HATEOAS and JSONSchema. The API provides the results for the request in the results property. The others are metadata about the response.
 */
struct SwapiResponse<T: Codable>: Codable {
    /** The number of items in the result. */
    let count: Int

    /** The next result set or item if the result was paged. Will be nil if on the last page or there no additional items to fetch. */
    let next: String?

    /** The previous result set or item if the result was paged. Will be nil if on the first page or there no additional items to fetch. */
    let previous: String?

    /** The result set or item for the specific request. */
    let results: [T]
}

/**
 The definition of the API for a Person.
 */
struct SwapiPerson: Codable {
    /** Their name. */
    let name: String
}

/**
    Defines a networking error.
 */
enum SwapiError: Error {
    /** Results when the provided api to call is malformed and cannot be turned into a valid URL */
    case failedUrlParsing(String)

    /** Results when the network call to the api fails for any reason. This service either works or it doesn't. In other services we may break this down further. */
    case networkError(String, String)

    /** Defines the value to print out when logging or printing the error. */
    var localizedDescription: String {
        switch self {
        case .failedUrlParsing(let url):
            return "Failed to parse URL \(url)"
        case .networkError(let absolutePath, let message):
            return "Error - \(absolutePath) failed with \(message)"
        }
    }
}

/**
 Single listing of all endpoints. Any additonal end points that are exposed should be added here.
 */
enum SwapiEndpoints {
    case searchPerson(query: String)

    var absolutePath: String {
        var result: String
        switch self {
        case .searchPerson(let query):
            result = "\(SwapiConfiguration.baseURL)/people/?search=\(query)"
        }
        return result
    }

    var url: URL? {
        return URL(string: absolutePath)
    }
}

/**
 Provides the actual network request utilizing URLSession. Implementations of the HTTP Verbs will be here. In larger code bases we may need additional configuration for the URLSession. That would be done here.
 */
protocol NetworkController {
    /**
     Performs a GET request to search .

     - Parameters:
     - with: The search term to search
     - completion: Called when the request completes with with success or failure.

     */
    func get<T: Decodable>(url: URL, completion: @escaping (Result<T, SwapiError>) -> Void)
}

/** Implementation for NetworkController. This lets us swap out implementation for future testing of consumers. */
class ApiNetworkController: NetworkController {
    func get<T: Decodable>(url: URL, completion: @escaping (Result<T, SwapiError>) -> Void) {
        let request = URLSession.shared.dataTask(with: url) { data, response, error in
            // Using a let here as we need the value AND if it's not present we have other processing to do.
            if let error = error {
                // This would be logged to analytics or other service for tracking. For now just printing
                print("--> \(#file) \(#function):\(#line): network error \(error.localizedDescription)")
                completion(.failure(.networkError(url.absoluteString, error.localizedDescription)))
                return
            }

            guard
                let data = data
            else {
                // This would be logged to analytics or other service for tracking. For now just printing
                print("--> \(#file) \(#function):\(#line): no data to decode.")
                completion(.failure(.networkError(url.absoluteString, "API provided no data to decode.")))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                do {
                    // These two lines can be helpful to debug why a response is not decoding.
                    // let asString = String(data: data, encoding: .utf8)
                    // print("--> \(#file) \(#function):\(#line): response data \(asString ?? "data isn't utf8??")")
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    // This would be logged to analytics or other service for tracking. For now just printing
                    print("--> \(#file) \(#function):\(#line): network decode error \(error.localizedDescription)")
                    completion(.failure(.networkError(url.absoluteString, error.localizedDescription)))
                }
            } else {
                // This would be logged to analytics or other service for tracking. For now just printing
                // We may also need to expand the processing of errors in the 4xx/5xx series depending on the API design.
                print("--> \(#file) \(#function):\(#line): invalid response.")
                completion(.failure(.networkError(url.absoluteString, "API invalid response.")))
            }
        }
        request.resume()
    }
}

/**
  Generic Service that will expose the currently supported APIs. By convention, the HTTP Verb should begin the name of the function.
  NOTE: This uses closures to demonstrate what is anticipated within the codebase currently.
 */
protocol StarWarsApi {
    /**
     Performs a GET request to search for people.

     - Parameters:
        - with: The search term to search
        - completion: Called when the request completes with with success or failure.

     */
    func getPeople(with searchTerm: String, completion: @escaping (Result<[SwapiPerson], SwapiError>) -> Void)
}

/** Implementation for StarWarsApi. This lets us swap out implementation for future testing of consumers. */
class StarWarsApiService: StarWarsApi {

    /** instance for the network controller. */
    let service: NetworkController

    init(service: NetworkController = ApiNetworkController()) {
        // using constructor injection to allow testing in the future.
        self.service = service
    }

    func getPeople(with searchTerm: String, completion: @escaping (Result<[SwapiPerson], SwapiError>) -> Void) {
        // This would be logged to analytics or other service for tracking. For now just printing
        print("--> \(#file) \(#function):\(#line) - sending request")
        let searchEndpoint = SwapiEndpoints.searchPerson(query: searchTerm)
        guard
            let searchURL = searchEndpoint.url
        else {
            completion(.failure(.failedUrlParsing(searchEndpoint.absolutePath)))
            return
        }
        service.get(url: searchURL) { (result: Result<SwapiResponse<SwapiPerson>, SwapiError>) in
            switch result {
            case .success(let response):
                print("--> \(#file) \(#function):\(#line) - responded with \(response.count) results(s)")
                completion(.success(response.results))
            case .failure(let error):
                print("--> \(#file) \(#function):\(#line) - responded with \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}



let service: StarWarsApi = StarWarsApiService()
service.getPeople(with: "luke") { results in
    switch results {
    case .success(let results):
        let count = results.count
        let personName = results.first?.name ?? "N/A"
        print("Found results \(count) with the first being \(personName)")
    case .failure(let error):
        print("Request has failed with \(error)")
    }
}
