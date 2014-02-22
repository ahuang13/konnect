//
//  CurrentPosition.h
//  Konnect
//
//  Created by fxie on 2/20/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"

@interface CurrentPosition : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) Company *company;

@end
