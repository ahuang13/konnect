//
//  CurrentPosition.m
//  Konnect
//
//  Created by fxie on 2/20/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "CurrentPosition.h"

@implementation CurrentPosition

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        self.company = [[Company alloc] initWithDictionary:dictionary];
        self.title = dictionary[@"title"];
        self.summary = dictionary[@"summary"];
    }
    
    return self;
}

// TODO: Format actual date object into string.
- (NSString *)dates {
    return @"#TEMP# January 2013 - Present";
}

// TODO: This is for debugging purposes only.
- (NSString *)summary {
    return nil;
}

@end
