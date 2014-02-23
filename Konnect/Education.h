//
//  Education.h
//  Konnect
//
//  Created by fxie on 2/20/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Education : NSObject

@property (nonatomic, strong) NSString *degree;
@property (nonatomic, strong) NSString *endYear;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *major;

- (id)initWithDictionary: (NSDictionary *)dictionary;

@end
