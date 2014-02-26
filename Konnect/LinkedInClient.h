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

- (void)currentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (void)currentCompanyWithId:(NSInteger)companyId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
