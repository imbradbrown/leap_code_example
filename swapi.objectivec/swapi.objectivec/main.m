//
//  main.m
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#import <Foundation/Foundation.h>
#import "StarWarsApi.h"
#import "StarWarsApiService.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Using a basic run loop wait for the network call to complete.
        __block BOOL isRunning = true;
        [StarWarsApiService getPeopleWithTerm:@"Luke"
                                   completion:^(SwapiResponse * _Nullable result, NSError * _Nullable error) {
            NSArray<SwapiPerson *>*people = [result resultsAsPeople];

            if (people.count > 0) {
                NSLog(@"Main found result %ld with first result %@", people.count, [[people objectAtIndex:0] name]);
            } else {
                NSLog(@"Main found result no results");
            }

            isRunning = false;
        }];

        while (isRunning) {
            // run loop waiting for the network calls.
            sleep(10);
        }
    }
    return 0;
}
