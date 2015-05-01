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
@property (nonatomic, strong) IBOutlet UIBarButtonItem *selectButton;

@end

@implementation QBAssetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.asset) {
        self.imageView.image = [UIImage imageWithCGImage:[self.asset defaultRepresentation].fullScreenImage];
    }
    
    self.selectButton.title = self.isSelected ? NSLocalizedString(@"Deselect", nil) : NSLocalizedString(@"Select", nil);
}

#pragma mark - Actions

- (IBAction)selectClicked:(id)sender
{
    self.selected = !self.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(qb_assetDetailViewController:didSelect:asset:indexPath:)]) {
        [self.delegate qb_assetDetailViewController:self didSelect: self.selected asset:self.asset indexPath:self.indexPath];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - QBAssetsZoomTransitionProtocol

- (UIView *)viewForTransition {
    return self.imageView;
}

- (UIImage *)imageForTransition {
    return self.imageView.image;
}

@end
