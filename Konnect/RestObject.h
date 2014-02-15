//
//  RestObject.h
//  Konnect
//
//  Created by fxie on 2/14/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestObject : NSObject

- (id)initWithDictionary:(NSDictionary *)data;

@property (nonatomic, strong) NSDictionary *data;

@end

@interface RestObject (ForwardedMethods)

- (id)objectForKey:(id)key;
- (id)valueOrNilForKeyPath:(NSString *)keyPath;

@end
