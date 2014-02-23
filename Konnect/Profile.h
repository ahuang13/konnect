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

- (id)initWithDictionary: (NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *pictureUrl;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) NSArray *currentPositions;
@property (nonatomic, strong) NSArray *educations;

@end

