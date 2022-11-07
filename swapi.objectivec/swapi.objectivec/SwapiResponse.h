//
//  SwapiResponse.h
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#ifndef SwapiResponse_h
#define SwapiResponse_h

#import "SwapiPerson.h"

/**
 The definition of the API is a mix of HATEOAS and JSONSchema. The API provides the results for the request in the results property. The others are metadata about the response.
 */
@interface SwapiResponse<ResultType>: NSObject

/** The number of items in the result. */
@property (nonatomic) NSInteger count;

/** The next result set or item if the result was paged. Will be nil if on the last page or there no additional items to fetch. */
@property (nonatomic, nullable) NSString *next;

/** The previous result set or item if the result was paged. Will be nil if on the first page or there no additional items to fetch. */
@property (nonatomic, nullable) NSString *previous;

/** The result set or item for the specific request. */
@property (nonatomic, nonnull) NSArray<ResultType> *results;

/**
 Implements a dictionary parsing to turn the JSON object into the properties.
 */
-(nonnull id) initWithJson:(nonnull NSDictionary *)json;

/**
  Turns the result property into the underlying type. Explicit to lazy deserialize the values.
 */
-(nonnull NSArray<SwapiPerson *>*)resultsAsPeople;

@end

#endif /* SwapiResponse_h */
