//
//  LIALinkedInHttpClient+Helpers.m
//  Konnect
//
//  Created by Angus Huang on 2/15/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "LIALinkedInHttpClient+Helpers.h"
#import "LIALinkedInApplication.h"
#import "LinkedInClient.h"
#import "Profile.h"

@implementation LIALinkedInHttpClient (Helpers)

+ (LIALinkedInHttpClient *)instance
{
    static dispatch_once_t once;
    static LIALinkedInHttpClient *instance;
    
    dispatch_once(&once, ^{
        LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.ancientprogramming.com/liaexample"
                                                                                        clientId:@"772cu46bnok4kw"
                                                                                    clientSecret:@"WpVAXnuGWK1Jsdp3"
                                                                                           state:@"DCEEFWF45453sdffef424"
                                                                                   grantedAccess:@[@"r_fullprofile", @"r_network"]];
        
        instance = [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
    });
    
    return instance;
}

// Displays LinkedIn login screen.
- (void)login {
    
    void (^success)(NSString *) = ^void(NSString *code) {
        [self getAccessToken:code];
    };
    
    void (^cancel)() = ^void() {
        NSLog(@"Authorization was cancelled by user.");
    };
    
    void (^failure)(NSError *) = ^void(NSError *error) {
        NSLog(@"Authorization failed: %@", error);
    };
    
    [self getAuthorizationCode:success cancel:cancel failure:failure];
}

- (void)getAccessToken:(NSString *)authorizationCode {
    
    void (^success)(NSDictionary *) = ^void(NSDictionary *accessTokenData) {
        
        NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
        [LinkedInClient instance].accessToken = accessToken;
    };
    
    void (^failure)(NSError *) = ^void(NSError *error) {
        NSLog(@"Retrieving access token failed: %@", error);
    };
    
    [self getAccessToken:authorizationCode success:success failure:failure];
}

@end
