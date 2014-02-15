//
//  Profile.m
//  Konnect
//
//  Created by fxie on 2/14/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "Profile.h"
#import "NSDictionary+CPAdditions.h"


@implementation Profile

- (NSString *)firstName {
    return [self.data valueOrNilForKeyPath:@"firstName"];
}

- (NSString *)lastName {
    return [self.data valueOrNilForKeyPath:@"lastName"];
}

- (NSString *)location {
    return [[self.data valueOrNilForKeyPath:@"location"] valueOrNilForKeyPath:@"name"];}



@end
