//
//  SwapiPerson.m
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#import <Foundation/Foundation.h>
#import "SwapiPerson.h"

@implementation SwapiPerson

-(id) initWithJson:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.name = [json valueForKey:@"name"];
    }
    return self;
}

@end
