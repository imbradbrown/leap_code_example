//
//  NetworkController.h
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#import <Foundation/Foundation.h>
#import "SwapiEndpoints.h"

/**
 Provides the actual network request utilizing URLSession. Implementations of the HTTP Verbs will be here. In larger code bases we may need additional configuration for the URLSession. That would be done here.
 */
@protocol NetworkController <NSObject>

NS_ASSUME_NONNULL_BEGIN

/**
 Performs a GET request.

 - Parameters:
    - url: The absolute path to perform the request on
    - completion: Called when the request completes with with success or failure.
 */
+(void) getUrl:(nonnull NSURL *)url
    completion:(void (^)(NSData * _Nullable data, NSError * _Nullable error)) completion;

NS_ASSUME_NONNULL_END

@end
