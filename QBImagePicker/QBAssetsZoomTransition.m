//
//  QBAssetsViewControllerTransition.m
//  QBImagePicker
//
//  Created by Knut Inge Grosland on 2015-04-23.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsZoomTransition.h"
#import "QBAssetsZoomTransitionProtocol.h"

@interface QBAssetsZoomTransition ()

@property (nonatomic, strong) UIViewController<QBAssetsZoomTransitionProtocol> *fromViewController;
@property (nonatomic, strong) UIViewController<QBAssetsZoomTransitionProtocol> *toViewController;
@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, strong) UIView *toView;

@property (nonatomic, assign) CGRect fromFrame;
@property (nonatomic, assign) CGRect toFrame;
@property (nonatomic, assign) CGSize originalImageSize;

@property (nonatomic, strong) UIView *transitionView;
@property (nonatomic, assign) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, assign) BOOL isPresenting;
@end

@implementation QBAssetsZoomTransition

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    self.transitionContext = transitionContext;
    self.isPresenting = (self.operation == UINavigationControllerOperationPush);
    
    self.fromViewController = (UIViewController <QBAssetsZoomTransitionProtocol>*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toViewController = (UIViewController <QBAssetsZoomTransitionProtocol>*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSAssert([self.fromViewController conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)], @"FromViewController must conform to QBAssetsZoomTransitionProtocol");
    NSAssert([self.toViewController conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)], @"ToViewController must conform to QBAssetsZoomTransitionProtocol");
    
    if (![self.fromViewController conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)] || ![self.toViewController conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)]) {
        return;
    }
    
    self.toView = [self.toViewController viewForTransition];
    self.fromView = [self.fromViewController viewForTransition];

    self.toViewController.view.frame = [self.transitionContext finalFrameForViewController:self.toViewController];
    [self.toViewController updateViewConstraints];
    
    UIView *container = [self.transitionContext containerView];
    // add toViewController to Transition Container
    if (self.isPresenting) {
        [container addSubview:self.toViewController.view];
    } else {
        [container insertSubview:self.toViewController.view belowSubview:self.fromViewController.view];
    }
    [self.toViewController.view layoutIfNeeded];
    
    // Calculate animation frames within container view
    self.fromFrame = [container convertRect:self.fromView.bounds fromView:self.fromView];
    self.toFrame = [container convertRect:self.toView.bounds fromView:self.toView];
    
    // Create a copy of the fromView and add it to the Transition Container
    if ([self.fromView isKindOfClass:[UIImageView class]]) {
        self.transitionView = [[UIImageView alloc] initWithImage:((UIImageView *)self.fromView).image];
        self.originalImageSize = ((UIImageView *)self.fromView).image.size;
    } else if ([self.fromViewController respondsToSelector:@selector(imageForTransition)]) {
        self.transitionView = [[UIImageView alloc] initWithImage:[self.fromViewController imageForTransition]];
        self.originalImageSize = [self.fromViewController imageForTransition].size;
    } else {
        self.transitionView = [self.fromView snapshotViewAfterScreenUpdates:NO];
    }
    
    self.transitionView.clipsToBounds = YES;
    self.transitionView.frame = self.fromFrame;
    [container addSubview:self.transitionView];
    
    if (self.isPresenting) {
        [self animateZoomInTransition];
    } else {
        [self animateZoomOutTransition];
    }
}

- (void)animateZoomInTransition {
    
    self.transitionView.contentMode = self.toView.contentMode;
    self.toViewController.view.alpha = 0;
    self.toView.hidden = YES;
    self.fromView.alpha = 0;
    
    NSTimeInterval duration = [self transitionDuration:self.transitionContext];
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^(void) {
        self.toViewController.view.alpha = 1;
        self.transitionView.frame = self.toFrame;
    } completion:^(BOOL finished) {
        [self.transitionView removeFromSuperview];
        self.fromViewController.view.alpha = 1;
        self.toView.hidden = NO;
        self.fromView.alpha = 1;
        
        if ([self.transitionContext transitionWasCancelled]) {
            [self.toViewController.view removeFromSuperview];
            self.isPresenting = NO;
            [self.transitionContext completeTransition:NO];
        } else {
            self.isPresenting = YES;
            [self.transitionContext completeTransition:YES];
        }
    }];
}

- (void)animateZoomOutTransition {

    float startScale    = MIN(self.fromView.frame.size.width / self.originalImageSize.width,
                              self.fromView.frame.size.height / self.originalImageSize.height);
    
    float endScale      = MAX(self.toView.frame.size.width / self.originalImageSize.width,
                              self.toView.frame.size.height / self.originalImageSize.height);

    CGPoint originalCenter = CGPointMake(CGRectGetMidX(self.fromViewController.view.frame), CGRectGetMidY(self.fromViewController.view.frame));
    CGPoint center = CGPointMake(CGRectGetMidX(self.toFrame), CGRectGetMidY(self.toFrame));

    self.transitionView.frame = CGRectMake(0, 0, self.originalImageSize.width, self.originalImageSize.height);
    self.transitionView.center = originalCenter;
    self.transitionView.contentMode = self.fromView.contentMode;
    CGFloat side = MIN(self.transitionView.frame.size.width, self.transitionView.frame.size.height);
    CGRect endMask = CGRectMake((self.transitionView.frame.size.width / 2) - (side / 2), (self.transitionView.frame.size.height / 2) - (side / 2), side, side);

    UIView *mask            = [[UIView alloc] initWithFrame:endMask];
    mask.backgroundColor    = [UIColor whiteColor];
    self.transitionView.layer.mask = mask.layer;
    self.transitionView.transform      = CGAffineTransformMakeScale(startScale, startScale);


    self.toViewController.view.alpha = 1;
    self.toView.hidden = YES;
    self.fromView.alpha = 0;
    NSTimeInterval duration = [self transitionDuration:self.transitionContext];
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^(void) {
        self.fromViewController.view.alpha = 0;
        self.transitionView.transform      = CGAffineTransformMakeScale(endScale, endScale);
        self.transitionView.center = center;
    } completion:^(BOOL finished) {
        
        if (self.transitionView.superview == nil) {
            return;
        }
        self.fromViewController.view.alpha = 1;
        self.toView.hidden = NO;
        self.fromView.alpha = 1;
        [self.transitionView removeFromSuperview];
        
        if ([self.transitionContext transitionWasCancelled]) {
            [self.toViewController.view removeFromSuperview];
            self.isPresenting = NO;
            [self.transitionContext completeTransition:NO];
        } else {
            self.isPresenting = YES;
            [self.transitionContext completeTransition:YES];
        }
        
    }];
}

@end
