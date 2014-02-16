//
//  LinkedInClient.m
//  Konnect
//
//  Created by Angus Huang on 2/2/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "LinkedInClient.h"
#import "Profile.h"
#import "NSString+URLString.h"

@implementation LinkedInClient

//------------------------------------------------------------------------------
#pragma mark - Constants
//------------------------------------------------------------------------------

static NSString *const BASE_URL_STRING = @"https://api.linkedin.com/v1/";

//------------------------------------------------------------------------------
#pragma mark - Public Class Methods
//------------------------------------------------------------------------------

+ (LinkedInClient *)instance
{
    static dispatch_once_t once;
    static LinkedInClient *instance;
    
    dispatch_once(&once, ^{
        
        NSURL *baseURL = [NSURL URLWithString:BASE_URL_STRING];
        instance = [[LinkedInClient alloc] initWithBaseURL:baseURL];
        
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // The preferred method for getting a JSON response from the API.
        // See: https://developer.linkedin.com/documents/reading-data
        [instance.requestSerializer setValue:@"json"
                          forHTTPHeaderField:@"x-li-format"];
        
    });
    
    return instance;
}

//------------------------------------------------------------------------------
#pragma mark - AFHTTPRequestOperationManager Methods
//------------------------------------------------------------------------------

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableString *mutableURLString = [NSMutableString stringWithString:URLString];
    
    // If the request does not already have query parameters, add a `?`.
    if ( ![mutableURLString hasQueryParameters] ) {
        [mutableURLString appendString:@"?"];
    }
    
    // Append the access token query parameter.
    NSString *accessTokenString = [NSString stringWithFormat:@"oauth2_access_token=%@", self.accessToken];
    [mutableURLString appendString:accessTokenString];
    
    return [super GET:mutableURLString parameters:parameters success:success failure:failure];
}

//------------------------------------------------------------------------------
#pragma mark - Public Instance Methods
//------------------------------------------------------------------------------

- (void) getCurrentUserProfile:(NSString *)accessToken {
    
    static NSString *const END_POINT = @"people/~:(first-name,last-name,location:(name),three-current-positions,skills,educations)";
    
    [self GET:END_POINT
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
          Profile *profile = [[Profile alloc] initWithDictionary:result];

          [Profile setCurrentUser:profile];
          
          NSLog(@"current user %@", result);
          NSLog(@"first name: %@", profile.firstName);
          NSLog(@"last name: %@", profile.lastName);
          NSLog(@"location: %@", profile.location);
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"failed to fetch current user %@", error);
      }];
}

@end
