//
//  ApiNetworkController.m
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#import <Foundation/Foundation.h>
#import "ApiNetworkController.h"
#import "SwapiError.h"

@implementation ApiNetworkController

+(void) getUrl:(nonnull NSURL *)url
    completion:(void (^)(NSData * _Nullable data, NSError * _Nullable error)) completion {
    NSLog(@"ApiNetworkController ");
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithURL:url
                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        // checking error first and returning to skip any other processing.
        if (error) {
            NSLog(@"--> %s %s:%d - network error %@", __FILE__, __FUNCTION__, __LINE__, error.localizedDescription);
            completion(nil, error);
            return;
        }

        // if there's no data then the GET request can be assumed as failed as nothing came back.
        if (data == nil) {
            NSLog(@"--> %s %s:%d - no data to decode.", __FILE__, __FUNCTION__, __LINE__);
            completion(nil, [SwapiError errorWithCode:SwapiErrorFailedNetworkError message:@"Endpoint did not return data"]);
            return;
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode < 300 && httpResponse.statusCode > 199) {
            completion(data, nil);
        } else {
            // This would be logged to analytics or other service for tracking. For now just printing
            NSLog(@"--> %s %s:%d - invalid response.", __FILE__, __FUNCTION__, __LINE__);
            completion(nil, [SwapiError errorWithCode:SwapiErrorFailedNetworkError message:@"API invalid response."]);
        }
    }];
    [task resume];
}

@end
