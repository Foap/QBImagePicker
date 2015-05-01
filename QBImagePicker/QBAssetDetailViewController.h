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

@class QBAssetDetailViewController;

@protocol QBAssetDetailViewControllerDelegate <NSObject>

@optional
- (void)qb_assetDetailViewController:(QBAssetDetailViewController *)assetDetailViewController didSelect:(BOOL)select asset:(ALAsset *)asset indexPath:(NSIndexPath *)indexPath;

@end


@interface QBAssetDetailViewController : UIViewController<QBAssetsZoomTransitionProtocol>

@property (strong, nonatomic) ALAsset *asset;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property(nonatomic,getter=isSelected) BOOL selected;  

@property (nonatomic, weak) id<QBAssetDetailViewControllerDelegate> delegate;

@end
