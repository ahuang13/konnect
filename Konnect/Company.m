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

- (NSString *)description {
    if (!self.companyDetails){
        // Company details not yet downloaded
        [self loadCompanyDetails];
    }
    return self.companyDetails[@"description"];
}

- (NSString *)logoUrl {
    if (!self.companyDetails){
        // Company details not yet downloaded
        [self loadCompanyDetails];
    }
    return self.companyDetails[@"logo-url"];
}



#pragma mark - Private Methods
- (void)loadCompanyDetails {
    // Download the current user's company profile and set the app's user company.
    void (^success)(AFHTTPRequestOperation *, id) = ^void(AFHTTPRequestOperation *operation, id response) {
        
        NSLog(@"company description: %@", response);
        self.companyDetails = response;
    };
    
    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^void(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to download current company: %@", error);//error.localizedDescription);
    };
    
    [[LinkedInClient instance] currentCompanyWithId: self.companyId success:success failure:failure];
}
@end
