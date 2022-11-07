//
//  StarWarsApi.h
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#import <Foundation/Foundation.h>
#import "SwapiEndpoints.h"
#import "SwapiResponse.h"

/**
 Generic Service that will expose the currently supported APIs. By convention, the HTTP Verb should begin the name of the function.
 NOTE: This uses completion handlers to demonstrate what is anticipated within the codebase currently.
 */
@protocol StarWarsApi <NSObject>

NS_ASSUME_NONNULL_BEGIN

/**
 Performs a GET request to search for people.

 - Parameters:
    - searchTerm: The search term to search
    - completion: Called when the request completes with with success or failure.
 */
+(void) getPeopleWithTerm:(nonnull NSString *) searchTerm
               completion:(void (^_Nonnull)(SwapiResponse * _Nullable result, NSError * _Nullable error)) completion;

NS_ASSUME_NONNULL_END

@end
