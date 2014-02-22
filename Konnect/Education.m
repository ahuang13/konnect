//
//  Education.m
//  Konnect
//
//  Created by fxie on 2/20/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "Education.h"

@implementation Education

- (id)initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.degree = dictionary[@"degree"];
        self.school = dictionary[@"schoolName"];
        self.major = dictionary[@"fieldOfStudy"];
        
        NSDictionary *endDate = dictionary[@"endDate"];
        if (endDate){
            self.endYear = endDate[@"year"];
        }
    }
    
    return self;
}

@end
