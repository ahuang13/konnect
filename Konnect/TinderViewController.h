//
//  TinderViewController.h
//  Konnect
//
//  Created by Angus Huang on 3/4/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TinderViewControllerDataSource.h"
#import "TinderViewControllerDelegate.h"

@interface TinderViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<TinderViewControllerDelegate> delegate;
@property (nonatomic, weak) id<TinderViewControllerDataSource> dataSource;

@end
