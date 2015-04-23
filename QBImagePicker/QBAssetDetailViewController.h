//
//  QBAssetDetailViewController.h
//  QBImagePicker
//
//  Created by Knut Inge Grosland on 2015-04-23.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "QBAssetsZoomTransitionProtocol.h"

@interface QBAssetDetailViewController : UIViewController<QBAssetsZoomTransitionProtocol>

@property (strong, nonatomic) ALAsset *asset;


@end
