//
//  SwapiResponse.m
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#import <Foundation/Foundation.h>
#import "SwapiResponse.h"

@implementation SwapiResponse

-(id) initWithJson:(nonnull NSDictionary *)json {
    self = [super init];
    if (self) {
        self.count = [[json valueForKey:@"count"] integerValue];
        self.next = [json valueForKey:@"next"];
        self.previous = [json valueForKey:@"previous"];
        self.results = [json mutableArrayValueForKey:@"results"];
    }
    return self;
}

-(NSArray<SwapiPerson *>*)resultsAsPeople {
    NSMutableArray<SwapiPerson *> *people = [NSMutableArray arrayWithCapacity: self.results.count];
    for (NSDictionary *properties in self.results) {
        SwapiPerson *person = [[SwapiPerson alloc] initWithJson: properties];
        [people addObject:person];
    }
    return people;
}

@end
