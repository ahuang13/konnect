//
//  NSString+URLString.m
//  Konnect
//
//  Created by Angus Huang on 2/15/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "NSString+URLString.h"

@implementation NSString (URLString)

- (BOOL)hasQueryParameters {
    return ([self rangeOfString:@"?"].location != NSNotFound);
}

@end
