//
//  QBAssetsZoomTransitionProtocol.h
//  QBImagePicker
//
//  Created by Knut Inge Grosland on 2015-07-16.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QBAssetsZoomTransitionProtocol <NSObject>

- (UIView *)viewForTransition;
- (UIImage *)imageForTransition;

@end
