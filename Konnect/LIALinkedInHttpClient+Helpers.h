//
//  LIALinkedInHttpClient+Helpers.h
//  Konnect
//
//  Created by Angus Huang on 2/15/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "LIALinkedInHttpClient.h"
@class Profile;

@interface LIALinkedInHttpClient (Helpers)

+ (LIALinkedInHttpClient *)instance;

- (void)login;

@end
