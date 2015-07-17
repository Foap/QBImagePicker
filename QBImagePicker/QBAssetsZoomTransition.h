//
//  QBAssetsViewControllerTransition.h
//  QBImagePicker
//
//  Created by Knut Inge Grosland on 2015-07-16.
//  Copyright (c) 2015 Knut Inge Grosland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBAssetsZoomTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation operation;

@end

