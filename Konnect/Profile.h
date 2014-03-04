//
//  Profile.h
//  Konnect
//
//  Created by fxie on 2/14/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestObject.h"
#import "Parse/Parse.h"

@interface Profile : RestObject

- (id)initWithDictionary: (NSDictionary *)dictionary;
- (id)initWithPFObject: (PFObject *)pfObject educations:(NSArray *)educations;


+ (Profile *)currentUser;
+ (void)setCurrentUser:(Profile *)currentUser;

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong, readonly) NSString *fullName;
@property (nonatomic, strong) NSString *pictureUrl;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *linkedInId;

@property (nonatomic, strong) NSMutableArray *currentPositions;
@property (nonatomic, strong) NSMutableArray *educations;

@property (nonatomic, strong) PFObject *pfObject;




@end

