//
//  QBAssetDetailViewController.m
//  QBImagePicker
//
//  Created by Knut Inge Grosland on 2015-04-23.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetDetailViewController.h"

@interface QBAssetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation QBAssetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.asset) {
        self.imageView.image = [UIImage imageWithCGImage:[self.asset defaultRepresentation].fullScreenImage];
    }
}


#pragma mark - Actions

- (IBAction)selectClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(qb_assetDetailViewController:didSelectAsset:indexPath:)]) {
        [self.delegate qb_assetDetailViewController:self didSelectAsset:self.asset indexPath:self.indexPath];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - QBAssetsZoomTransitionProtocol

- (UIView *)viewForTransition {
    return self.imageView;
}

@end
