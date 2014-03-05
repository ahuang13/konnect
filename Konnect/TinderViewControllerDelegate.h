//
//  TinderViewControllerDelegate.h
//  Konnect
//
//  Created by Angus Huang on 3/4/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TinderViewControllerDelegate <NSObject>

- (void)didLikeViewController:(UIViewController *)viewController;
- (void)didDislikeViewController:(UIViewController *)viewController;

@end
