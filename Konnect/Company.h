//
//  Company.h
//  Konnect
//
//  Created by fxie on 2/20/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject

@property (nonatomic, strong) NSDictionary *companyDetails;

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *industry;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *logoUrl;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
