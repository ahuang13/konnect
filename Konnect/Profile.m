//
//  Profile.m
//  Konnect
//
//  Created by fxie on 2/14/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "Profile.h"
#import "NSDictionary+CPAdditions.h"
#import "LinkedInClient.h"
#import "Notifications.h"

@implementation Profile

//------------------------------------------------------------------------------
#pragma mark - Constants
//------------------------------------------------------------------------------

NSString * const CURRENT_JOB_SEEKER_KEY = @"CurrentJobSeekerKey";

//------------------------------------------------------------------------------
#pragma mark - Static Variables
//------------------------------------------------------------------------------

static Profile *_currentUser;

//------------------------------------------------------------------------------
#pragma mark - Class Methods
//------------------------------------------------------------------------------

+ (Profile *)currentUser {
    if (!_currentUser) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:CURRENT_JOB_SEEKER_KEY];
        if (userData) {
            NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingMutableContainers error:nil];
            _currentUser = [[Profile alloc] initWithDictionary:userDictionary];
        }
    }
    
    return _currentUser;
}

+ (void)setCurrentUser:(Profile *)currentUser {
    
    // Update NSUserDefaults with the new current user.
    if (currentUser) {
        
        NSData *userData = [NSJSONSerialization dataWithJSONObject:currentUser.data
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:CURRENT_JOB_SEEKER_KEY];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENT_JOB_SEEKER_KEY];
        [LinkedInClient instance].accessToken = nil;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _currentUser = currentUser;
}

//------------------------------------------------------------------------------
#pragma mark - Getters
//------------------------------------------------------------------------------

- (NSString *)firstName {
    return [self.data valueOrNilForKeyPath:@"firstName"];
}

- (NSString *)lastName {
    return [self.data valueOrNilForKeyPath:@"lastName"];
}

- (NSString *)location {
    return [[self.data valueOrNilForKeyPath:@"location"] valueOrNilForKeyPath:@"name"];}



@end
