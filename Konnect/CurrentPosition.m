//
//  CurrentPosition.m
//  Konnect
//
//  Created by fxie on 2/20/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "CurrentPosition.h"

@interface CurrentPosition()

@property (nonatomic, assign) NSInteger startMonth;
@property (nonatomic, assign) NSInteger startYear;

@end

@implementation CurrentPosition

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    NSLog(@"CurrentPosition = %@", dictionary);
    
    if (self) {
        self.company = [[Company alloc] initWithDictionary:dictionary];
        self.title = dictionary[@"title"];
        self.summary = dictionary[@"summary"];
        self.startMonth = [dictionary[@"startDate"][@"month"] integerValue];
        self.startYear = [dictionary[@"startDate"][@"year"] integerValue];
    }
    
    return self;
}

// TODO: Format actual date object into string.
- (NSString *)dates {
    
    NSMutableString *dateString = [[NSMutableString alloc] init];
    
    if (self.startYear > 0) {
        if (self.startMonth > 0) {
            NSString *monthString = [self stringFromMonth:self.startMonth];
            [dateString appendString:monthString];
            [dateString appendString:@" "];
        }
        [dateString appendString:[NSString stringWithFormat:@"%ld", self.startYear]];
    }
    
    [dateString appendString:@" - Present"];
    
    return dateString;
}

- (NSString *)stringFromMonth:(NSInteger)index {
    
    NSArray *months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    
    return months[index];
}

@end
