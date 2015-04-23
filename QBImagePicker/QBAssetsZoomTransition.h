//
//  QBAssetsViewControllerTransition.h
//  QBImagePicker
//
//  Created by Knut Inge Grosland on 2015-04-23.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBAssetsZoomTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation operation;

@end

