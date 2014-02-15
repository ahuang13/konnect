//
//  NSDictionary+CPAdditions.h
//  Konnect
//
//  Created by fxie on 2/14/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CPAdditions)

- (id)objectOrNilForKey:(id)key;
- (id)valueOrNilForKeyPath:(id)keyPath;

@end