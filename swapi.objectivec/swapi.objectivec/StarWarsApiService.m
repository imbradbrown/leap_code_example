//
//  StarWarsApiService.m
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#import <Foundation/Foundation.h>
#import "StarWarsApiService.h"
#import "ApiNetworkController.h"
#import "SwapiPerson.h"

@implementation StarWarsApiService

+(void) getPeopleWithTerm:(NSString *) searchTerm
               completion:(void (^)(SwapiResponse * _Nullable result, NSError * _Nullable error)) completion {
    [ApiNetworkController getUrl:[SwapiEndpoints searchPersonWithTerm:searchTerm]
                      completion:^(NSData * _Nullable data, NSError * _Nullable error) {

        if (error) {
            NSLog(@"--> %s:%d failed with %@", __FILE__, __LINE__, error.localizedDescription);
            completion(nil, error);
        } else {
            NSError *error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            SwapiResponse *response = [[SwapiResponse alloc] initWithJson:json];
            completion(response, error);
        }
    }];
}

@end
