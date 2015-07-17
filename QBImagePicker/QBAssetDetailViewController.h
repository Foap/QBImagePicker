//
//  QBAssetDetailViewController.h
//  QBImagePicker
//
//  Created by Knut Inge Grosland on 2015-07-16.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBAssetsZoomTransitionProtocol.h"

@class QBAssetDetailViewController;
@class PHAsset;

@protocol QBAssetDetailViewControllerDelegate <NSObject>

@optional
- (void)qb_assetDetailViewController:(QBAssetDetailViewController *)assetDetailViewController didSelect:(BOOL)select asset:(PHAsset *)asset indexPath:(NSIndexPath *)indexPath;

@end


@interface QBAssetDetailViewController : UIViewController<QBAssetsZoomTransitionProtocol>

@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property(nonatomic,getter=isSelected) BOOL selected;

@property (nonatomic, weak) id<QBAssetDetailViewControllerDelegate> delegate;

@end
