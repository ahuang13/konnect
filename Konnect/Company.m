//
//  Company.m
//  Konnect
//
//  Created by fxie on 2/20/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "Company.h"
#import "AFHTTPRequestOperation.h"
#import "LinkedInClient.h"

@implementation Company

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        
        NSDictionary *company = dictionary[@"company"];
        if (company)
        {
            self.id = [company[@"id"] integerValue];
            self.name = company[@"name"];
            self.size = company[@"size"];
            self.industry = company[@"industry"];
        }
    }
    return self;
}

@end
