//
//  CandidatesContainerViewController.h
//  Konnect
//
//  Created by Angus Huang on 3/5/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TinderViewController.h"
#import "TinderViewControllerDataSource.h"
#import "TinderViewControllerDelegate.h"

@interface CandidatesContainerViewController : TinderViewController <TinderViewControllerDataSource, TinderViewControllerDelegate>

@end
