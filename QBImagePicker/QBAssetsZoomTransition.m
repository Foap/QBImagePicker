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

@property (nonatomic, strong) UIView *transitionView;
@property (nonatomic, assign) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, assign) BOOL isPresenting;
@end

@implementation QBAssetsZoomTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isPresenting = YES;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
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
    } else if ([self.fromViewController respondsToSelector:@selector(imageForTransition)]) {
        self.transitionView = [[UIImageView alloc] initWithImage:[self.fromViewController imageForTransition]];
    } else {
        self.transitionView = [self.fromView snapshotViewAfterScreenUpdates:NO];
    }
    
    self.transitionView.clipsToBounds = YES;
    self.transitionView.frame = self.fromFrame;
    self.transitionView.contentMode = self.toView.contentMode;
    [container addSubview:self.transitionView];
    
    if (self.isPresenting) {
        [self animateZoomInTransition];
    } else {
        [self animateZoomOutTransition];
    }
}

- (void)animateZoomInTransition {
    
    self.toViewController.view.alpha = 0;
    self.toView.hidden = YES;
    self.fromView.alpha = 0;
    
    NSTimeInterval duration = [self transitionDuration:self.transitionContext];
    
    [UIView animateWithDuration:duration animations:^(void) {
        self.toViewController.view.alpha = 1;
        self.transitionView.frame = self.toFrame;
    } completion:^(BOOL finished) {
        [self.transitionView removeFromSuperview];
        self.fromViewController.view.alpha = 1;
        self.toView.hidden = NO;
        self.fromView.alpha = 1;
        
        if ([self.transitionContext transitionWasCancelled]) {
            [self.toViewController.view removeFromSuperview];
            self.isPresenting = YES;
            [self.transitionContext completeTransition:NO];
        } else {
            self.isPresenting = NO;
            [self.transitionContext completeTransition:YES];
        }
    }];
}

- (void)animateZoomOutTransition {
    
    self.transitionView.contentMode = self.toView.contentMode;
    self.toViewController.view.alpha = 1;
    self.toView.hidden = YES;
    self.fromView.alpha = 0;
    
    NSTimeInterval duration = [self transitionDuration:self.transitionContext];
    
    [UIView animateWithDuration:duration animations:^(void) {
        self.fromViewController.view.alpha = 0;
        self.transitionView.frame = self.toFrame;
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

- (void)animateTransition2:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView           = [transitionContext containerView];
    containerView.backgroundColor   = [UIColor whiteColor];
    
    if (self.operation == UINavigationControllerOperationPush)
    {
        UIViewController<QBAssetsZoomTransitionProtocol> *fromVC      = (UIViewController <QBAssetsZoomTransitionProtocol>*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController<QBAssetsZoomTransitionProtocol> *toVC    = (UIViewController <QBAssetsZoomTransitionProtocol>*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        NSAssert([fromVC conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)], @"FromViewController must conform to QBAssetsZoomTransitionProtocol");
        NSAssert([toVC conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)], @"ToViewController must conform to QBAssetsZoomTransitionProtocol");
        
        if (![fromVC conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)] || ![toVC conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)]) {
            return;
        }

        UIView *cellView        = [fromVC viewForTransition];
        UIImageView *imageView  = (UIImageView *)[toVC viewForTransition];
        UIView *snapshot        = [self resizedSnapshot:imageView];
        
        CGPoint cellCenter  = [fromVC.view convertPoint:cellView.center fromView:cellView.superview];
        CGPoint snapCenter  = toVC.view.center;
        
        // Find the scales of snapshot
        float startScale    = MAX(cellView.frame.size.width / snapshot.frame.size.width,
                                  cellView.frame.size.height / snapshot.frame.size.height);
        
        float endScale      = MIN(toVC.view.frame.size.width / snapshot.frame.size.width,
                                  toVC.view.frame.size.height / snapshot.frame.size.height);
        
        // Find the bounds of the snapshot mask
        float width         = snapshot.bounds.size.width;
        float height        = snapshot.bounds.size.height;
        float length        = MIN(width, height);
        
        CGRect startBounds  = CGRectMake((width-length)/2, (height-length)/2, length, length);
        
        // Create the mask
        UIView *mask            = [[UIView alloc] initWithFrame:startBounds];
        mask.backgroundColor    = [UIColor whiteColor];
        
        // Prepare transition
        snapshot.transform  = CGAffineTransformMakeScale(startScale, startScale);;
        snapshot.layer.mask = mask.layer;
        snapshot.center     = cellCenter;
        
        toVC.view.frame     = [transitionContext finalFrameForViewController:toVC];
        toVC.view.alpha     = 0;
        
        // Add to container view
        [containerView addSubview:toVC.view];
        [containerView addSubview:snapshot];
        
        // Animate
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:0.75
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fromVC.view.alpha          = 0;
                             snapshot.transform         = CGAffineTransformMakeScale(endScale, endScale);
                             snapshot.layer.mask.bounds = snapshot.bounds;
                             snapshot.center            = snapCenter;
                             toVC.navigationController.toolbar.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             toVC.view.alpha   = 1;
                             toVC.navigationController.toolbarHidden = YES;
                             [snapshot removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    }
    
    else
    {
        UIViewController<QBAssetsZoomTransitionProtocol> *fromVC      = (UIViewController <QBAssetsZoomTransitionProtocol>*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController<QBAssetsZoomTransitionProtocol> *toVC    = (UIViewController <QBAssetsZoomTransitionProtocol>*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

        NSAssert([fromVC conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)], @"FromViewController must conform to QBAssetsZoomTransitionProtocol");
        NSAssert([toVC conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)], @"ToViewController must conform to QBAssetsZoomTransitionProtocol");
        
        if (![fromVC conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)] || ![toVC conformsToProtocol:@protocol(QBAssetsZoomTransitionProtocol)]) {
            return;
        }

        UIView *cellView        = [toVC viewForTransition];
        UIImageView *imageView  = (UIImageView *)[fromVC viewForTransition];
        UIView *snapshot        = [self resizedSnapshot:imageView];
        
        CGPoint cellCenter  = [toVC.view convertPoint:cellView.center fromView:cellView.superview];
        CGPoint snapCenter  = fromVC.view.center;
        
        // Find the scales of snapshot
        float startScale    = MIN(fromVC.view.frame.size.width / snapshot.frame.size.width,
                                  fromVC.view.frame.size.height / snapshot.frame.size.height);
        
        float endScale      = MAX(cellView.frame.size.width / snapshot.frame.size.width,
                                  cellView.frame.size.height / snapshot.frame.size.height);
        
        // Find the bounds of the snapshot mask
        float width         = snapshot.bounds.size.width;
        float height        = snapshot.bounds.size.height;
        float length        = MIN(width, height);
        CGRect endBounds    = CGRectMake((width-length)/2, (height-length)/2, length, length);
        
        UIView *mask            = [[UIView alloc] initWithFrame:snapshot.bounds];
        mask.backgroundColor    = [UIColor whiteColor];
        
        // Prepare transition
        snapshot.transform      = CGAffineTransformMakeScale(startScale, startScale);
        snapshot.layer.mask     = mask.layer;
        snapshot.center         = snapCenter;
        
        toVC.view.frame         = [transitionContext finalFrameForViewController:toVC];
        toVC.view.alpha         = 0;
        fromVC.view.alpha       = 0;
        
        // Add to container view
        [containerView addSubview:toVC.view];
        [containerView addSubview:snapshot];
        
        // Animate
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             toVC.view.alpha            = 1;
                             snapshot.transform         = CGAffineTransformMakeScale(endScale, endScale);
                             snapshot.layer.mask.bounds = endBounds;
                             snapshot.center            = cellCenter;
                         }
                         completion:^(BOOL finished){
                             [snapshot removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    }
}



#pragma mark - Snapshot

- (UIView *)resizedSnapshot:(UIImageView *)imageView
{
    CGSize size = imageView.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    [[UIColor whiteColor] set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    [imageView.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resized = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return (UIView *)[[UIImageView alloc] initWithImage:resized];
}

@end
