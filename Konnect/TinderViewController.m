//
//  TinderViewController.m
//  Konnect
//
//  Created by Angus Huang on 3/4/14.
//  Copyright (c) 2014 Angus Huang. All rights reserved.
//

#import "TinderViewController.h"

@interface TinderViewController ()

@property (nonatomic, strong) UIViewController *topViewController;
@property (nonatomic, strong) UIViewController *bottomViewController;

@property (nonatomic, assign) CGPoint lastPoint;

@end

@implementation TinderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(onPanGesture:)];
    panGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // TODO: Check for nil.
    
    UIViewController *firstVC = [self.dataSource nextViewController];
    [self addViewController:firstVC];
    
    UIViewController *secondVC = [self.dataSource nextViewController];
    [self addViewController:secondVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)removeTopViewController {
    
    [self.topViewController willMoveToParentViewController:nil];  // 1
    [self.topViewController.view removeFromSuperview];            // 2
    [self.topViewController removeFromParentViewController];      // 3
    
    self.topViewController = self.bottomViewController;
    self.bottomViewController = nil;
}

- (void)addViewController:(UIViewController *)vc {
    
    [self addChildViewController:vc];
    vc.view.frame = self.view.frame;
    [self.view addSubview:vc.view];
    [self.view sendSubviewToBack:vc.view];
    [vc didMoveToParentViewController:self];
    
    if (self.topViewController == nil) {
        self.topViewController = vc;
    } else if (self.bottomViewController == nil) {
        self.bottomViewController = vc;
    } else {
        self.topViewController = self.bottomViewController;
        self.bottomViewController = vc;
    }
}

- (void)onPanGesture:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint point = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        // Initialize the touch point offset relative to center
        self.lastPoint = point;
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        // Update center based on touch point change.
        [TinderViewController updateXPositionForView:self.topViewController.view
                                           withDelta:point.x - self.lastPoint.x];
        
        // Update height of the view controller based on distance from center.
        [TinderViewController updateHeightForView:self.topViewController.view
                                     inParentView:self.view
                                     atTouchPoint:point];
        
        self.lastPoint = point;
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat currentX = self.topViewController.view.center.x;
        CGFloat originalX = self.view.center.x;
        
        // If velocity is positive and center is to the right, finish animation towards Like.
        if (velocity.x >= 0 && currentX - originalX > 0) {
            [self animateLikeWithVelocity:velocity.x];
        } else if (velocity.x <= 0 && currentX - originalX < 0) {
            [self animateDislikeWithVelocity:velocity.x];
        } else {
            [self animateReturnToCenter];
        }
    }
}

+ (void)updateHeightForView:(UIView *)view
               inParentView:(UIView *)parentView
               atTouchPoint:(CGPoint)touchPoint {
    
    CGFloat distanceFromCenter = fabsf(view.center.x - parentView.center.x);
    CGFloat xRange = parentView.frame.size.width;
    CGFloat percentageFromCenter = distanceFromCenter / xRange;
    
    CGFloat originalHeight = parentView.frame.size.height;
    CGFloat heightPercentage = (cos(percentageFromCenter * M_PI) + 1) / 2;
    CGFloat newHeight = originalHeight * heightPercentage;
    
    CGFloat heightDiff = originalHeight - newHeight;
    
    view.frame = CGRectMake(view.frame.origin.x,
                            parentView.frame.origin.y + heightDiff / 2,
                            view.frame.size.width,
                            newHeight);
}

+ (void)updateXPositionForView:(UIView *)view withDelta:(CGFloat)delta {
    
    CGPoint newCenter = CGPointMake(view.center.x + delta, view.center.y);
    view.center = newCenter;
}

- (void)animateLikeWithVelocity:(CGFloat)velocity {
    
    CGFloat distance = fabsf(self.topViewController.view.frame.origin.x);
    CGFloat speed = MAX(velocity / 2, 160); // points per second
    NSTimeInterval duration = distance / speed;
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.topViewController.view.frame = CGRectMake(self.view.frame.size.width,
                                                                        self.view.frame.size.height/2,
                                                                        0,
                                                                        0);
                     }
                     completion:^(BOOL finished){
                         [self.delegate didLikeViewController:self.topViewController];
                         [self removeTopViewController];
                         [self addViewController:[self.dataSource nextViewController]];
                     }];
    
}

- (void)animateDislikeWithVelocity:(CGFloat)velocity {
    
    CGFloat distance = fabsf(self.topViewController.view.frame.origin.x);
    CGFloat speed = MAX(fabsf(velocity / 2), 160); // points per second
    NSTimeInterval duration = distance / speed;
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.topViewController.view.frame = CGRectMake(0,
                                                                        self.view.frame.size.height/2,
                                                                        0,
                                                                        0);
                     }
                     completion:^(BOOL finished){
                         [self.delegate didDislikeViewController:self.topViewController];
                         [self removeTopViewController];
                         [self addViewController:[self.dataSource nextViewController]];
                     }];
    
}

- (void)animateReturnToCenter {
    
    CGFloat distance = fabsf(self.topViewController.view.center.x - self.view.center.x);
    CGFloat speed = 160; // points per second
    NSTimeInterval duration = distance / speed;
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.topViewController.view.frame = self.view.frame;
                     }
                     completion:nil];
}

@end
