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

#pragma mark - QBAssetsZoomTransitionProtocol

- (UIView *)viewForTransition {
    return self.imageView;
}

@end
