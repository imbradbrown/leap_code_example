//
//  SwapiEndpoints.m
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#import <Foundation/Foundation.h>
#import "SwapiEndpoints.h"
#import "SwapiConfiguration.h"

@implementation SwapiEndpoints

+(NSURL *)searchPersonWithTerm:(NSString *)searchTerm {
    NSString *path = [NSString stringWithFormat:@"%@/people/?search=%@", [SwapiConfiguration baseURL], searchTerm];
    return [NSURL URLWithString:path];
}

@end
