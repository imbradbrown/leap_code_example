//
//  SwapiError.h
//  swapi.objectivec
//
//  Created by Brad on 11/6/22.
//

#ifndef SwapiError_h
#define SwapiError_h

typedef enum {
    /** Results when the provided api to call is malformed and cannot be turned into a valid URL */
    SwapiErrorFailedUrlParsing = 101,

    /** Results when the network call to the api fails for any reason. This service either works or it doesn't. In other services we may break this down further. */
    SwapiErrorFailedNetworkError = 202,
} SwapiErrorCode;

/**
 Defines a networking error.
 */
@interface SwapiError: NSObject

/**
 Consolidates creation of error messages so they are consistent.
 - Parameters:
    - errorWithCode: the error code to set
    - message: Used for localized description of the error
 */
+(NSError *) errorWithCode:(SwapiErrorCode)errorCode
                   message:(NSString *)message;

@end

#endif /* SwapiError_h */
