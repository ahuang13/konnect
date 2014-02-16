//
//  LinkedInClient.h
//  Konnect
//
//  Created by Angus Huang on 2/2/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
@class Profile;

@interface LinkedInClient : AFHTTPRequestOperationManager

@property (nonatomic, strong) NSString *accessToken;

+ (LinkedInClient *)instance;

- (void) getCurrentUserProfile:(NSString *)accessToken;

@end
