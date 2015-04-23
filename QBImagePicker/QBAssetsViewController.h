//
//  QBAssetsViewController.h
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/06.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBAssetsZoomTransitionProtocol.h"

@class QBImagePickerController;
@class ALAssetsGroup;

@interface QBAssetsViewController : UICollectionViewController<QBAssetsZoomTransitionProtocol>

@property (nonatomic, weak) QBImagePickerController *imagePickerController;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end
