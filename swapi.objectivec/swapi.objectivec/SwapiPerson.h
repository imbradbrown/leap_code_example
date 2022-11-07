//
//  SwapiPerson.h
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#ifndef SwapiPerson_h
#define SwapiPerson_h

/**
 The definition of the API for a Person.
 */
@interface SwapiPerson: NSObject

/** Their name. */
@property (nonatomic, nonnull) NSString *name;

/**
 Implements a dictionary parsing to turn the JSON object into the properties.
 */
-(nonnull id) initWithJson:(nonnull NSDictionary *)json;

@end

#endif /* SwapiPerson_h */
