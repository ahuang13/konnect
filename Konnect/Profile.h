//
//  Profile.h
//  Konnect
//
//  Created by fxie on 2/14/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestObject.h"

@interface Profile : RestObject

+ (Profile *)currentUser;
+ (void)setCurrentUser:(Profile *)profile;

@property (nonatomic, strong, readonly) NSString *firstName;
@property (nonatomic, strong, readonly) NSString *lastName;
@property (nonatomic, strong, readonly) NSString *location;
@property (nonatomic, strong, readonly) NSString *companyName;
@property (nonatomic, strong, readonly) NSString *currentPosition;
@property (nonatomic, strong, readonly) NSString *positionDescription;

@end

