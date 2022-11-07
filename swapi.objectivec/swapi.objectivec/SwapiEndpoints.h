//
//  SwapiEndpoints.h
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#ifndef SwapiEndpoints_h
#define SwapiEndpoints_h

#import "SwapiResponse.h"

/**
 Single listing of all endpoints. Any additonal end points that are exposed should be added here.
 */
@interface SwapiEndpoints: NSObject

+(NSURL *) searchPersonWithTerm:(NSString *)searchTerm;

@end

#endif /* SwapiEndpoints_h */
