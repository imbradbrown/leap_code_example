//
//  SwapiError.m
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#import <Foundation/Foundation.h>
#import "SwapiError.h"

@implementation SwapiError

+(NSError *) errorWithCode:(SwapiErrorCode)errorCode
                   message:(NSString *)message {
    NSArray *objects = [NSArray arrayWithObjects:message, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"NSLocalizedDescriptionKey", nil];

    return [NSError errorWithDomain:NSPOSIXErrorDomain
                               code:errorCode
                           userInfo:[NSDictionary dictionaryWithObjects:objects forKeys:keys]];
}

@end




