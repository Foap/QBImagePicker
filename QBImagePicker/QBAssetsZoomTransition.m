//
//  QBAssetsViewControllerTransition.m
//  QBImagePicker
//
//  Created by Knut Inge Grosland on 2015-07-16.
//  Copyright (c) 2015 Knut Inge Grosland. All rights reserved.
//

#import "QBAssetsZoomTransition.h"
#import "QBAssetsZoomTransitionProtocol.h"

@interface QBAssetsZoomTransition ()

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
    
    UIViewController<QBAssetsZoomTransitionProtocol> *fromViewController = (UIViewController <QBAssetsZoomTransitionProtocol>*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController<QBAssetsZoomTransitionProtocol> *toViewController = (UIViewController <QBAssetsZoomTransitionProtocol>*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSAssert([fromViewController conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)], @"FromViewController must conform to QBAssetsZoomTransitionProtocol");
    NSAssert([toViewController conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)], @"ToViewController must conform to QBAssetsZoomTransitionProtocol");
    
    if (![fromViewController conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)] || ![toViewController conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)]) {
        return;
    }
    
    UIView *toView = [toViewController viewForTransition];
    UIView *fromView = [fromViewController viewForTransition];

    toViewController.view.frame = [self.transitionContext finalFrameForViewController:toViewController];
    [toViewController updateViewConstraints];
    
    UIView *container = [self.transitionContext containerView];
    // add toViewController to Transition Container
    if (self.isPresenting) {
        [container addSubview:toViewController.view];
    } else {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
    }
    [toViewController.view layoutIfNeeded];
    
    // Calculate animation frames within container view
    CGRect fromFrame = [container convertRect:fromView.bounds fromView:fromView];
    CGRect toFrame = [container convertRect:toView.bounds fromView:toView];
    
    // Create a copy of the fromView and add it to the Transition Container
    UIView *transitionView = [[UIImageView alloc] initWithImage:[fromViewController imageForTransition]];
    transitionView.clipsToBounds = YES;
    transitionView.frame = fromFrame;
    [container addSubview:transitionView];
    
    
    if (self.isPresenting) {
        [self animateZoomInTransitionFromViewController: fromViewController fromView:fromView fromFrame:fromFrame toViewController:toViewController toView:toView transitionView:transitionView toFrame:toFrame ];
    } else {
        [self animateZoomOutTransitionFromViewController: fromViewController fromView:fromView fromFrame:fromFrame toViewController:toViewController toView:toView transitionView:transitionView toFrame:toFrame ];
    }
}

- (void)animateZoomInTransitionFromViewController:(UIViewController *)fromViewController fromView:(UIView *)fromView fromFrame:(CGRect)fromFrame toViewController:(UIViewController *)toViewController toView:(UIView *)toView transitionView:(UIView *)transitionView toFrame:(CGRect)toFrame{
    
    transitionView.contentMode = toView.contentMode;
    toViewController.view.alpha = 0;
    toView.hidden = YES;
    fromView.alpha = 0;
    
    NSTimeInterval duration = [self transitionDuration:self.transitionContext];
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^(void) {
        toViewController.view.alpha = 1;
        transitionView.frame = toFrame;
    } completion:^(BOOL finished) {
        [transitionView removeFromSuperview];
        fromViewController.view.alpha = 1;
        toView.hidden = NO;
        fromView.alpha = 1;
        
        if ([self.transitionContext transitionWasCancelled]) {
            [toViewController.view removeFromSuperview];
            self.isPresenting = NO;
            [self.transitionContext completeTransition:NO];
        } else {
            self.isPresenting = YES;
            [self.transitionContext completeTransition:YES];
        }
    }];
}

- (void)animateZoomOutTransitionFromViewController:(UIViewController <QBAssetsZoomTransitionProtocol> *)fromViewController fromView:(UIView *)fromView fromFrame:(CGRect)fromFrame toViewController:(UIViewController <QBAssetsZoomTransitionProtocol> *)toViewController toView:(UIView *)toView transitionView:(UIView *)transitionView toFrame:(CGRect)toFrame{
    
    CGSize originalImageSize = [fromViewController imageForTransition].size;

    float startScale    = MAX(fromView.frame.size.width / originalImageSize.width,
                              fromView.frame.size.height /originalImageSize.height);
    
    float endScale      = MAX(toView.frame.size.width / originalImageSize.width,
                              toView.frame.size.height / originalImageSize.height);

    CGPoint originalCenter = CGPointMake(CGRectGetMidX(fromViewController.view.frame), CGRectGetMidY(fromViewController.view.frame));
    CGPoint center = CGPointMake(CGRectGetMidX(toFrame), CGRectGetMidY(toFrame));

    transitionView.frame = CGRectMake(0, 0, originalImageSize.width, originalImageSize.height);
    transitionView.backgroundColor = [UIColor clearColor];
    transitionView.center = originalCenter;
    transitionView.contentMode = fromView.contentMode;
    CGFloat side = MIN(transitionView.frame.size.width, transitionView.frame.size.height);
    CGRect endMask = CGRectMake((transitionView.frame.size.width / 2) - (side / 2), (transitionView.frame.size.height / 2) - (side / 2), side, side);

    UIView *mask            = [[UIView alloc] initWithFrame:endMask];
    mask.backgroundColor    = [UIColor whiteColor];
    transitionView.layer.mask = mask.layer;
    transitionView.transform      = CGAffineTransformMakeScale(startScale, startScale);

    toViewController.view.alpha = 1;
    toView.hidden = YES;
    fromView.alpha = 0;
    NSTimeInterval duration = [self transitionDuration:self.transitionContext];
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^(void) {
        fromViewController.view.alpha = 0;
        transitionView.transform      = CGAffineTransformMakeScale(endScale, endScale);
        transitionView.center = center;
    } completion:^(BOOL finished) {
        
        if (transitionView.superview == nil) {
            return;
        }
        fromViewController.view.alpha = 1;
        toView.hidden = NO;
        fromView.alpha = 1;
        [transitionView removeFromSuperview];
        
        if ([self.transitionContext transitionWasCancelled]) {
            [toViewController.view removeFromSuperview];
            self.isPresenting = NO;
            [self.transitionContext completeTransition:NO];
        } else {
            self.isPresenting = YES;
            [self.transitionContext completeTransition:YES];
        }
        
    }];
}

@end
