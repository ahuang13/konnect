//
//  Company.m
//  Konnect
//
//  Created by fxie on 2/20/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "Company.h"

@implementation Company

- (id)initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSDictionary *company = dictionary[@"company"];
        if (company)
        {
            self.name = company[@"name"];
            self.companyId = company[@"id"];
            self.size = company[@"size"];
            self.industry = company[@"industry"];
        }
    }
    
    return self;
}

- (NSString *)description {
    //TODO fetch company description from api
    return nil;
}
@end
