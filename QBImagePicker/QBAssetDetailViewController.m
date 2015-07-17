//
//  QBAssetDetailViewController.m
//  QBImagePicker
//
//  Created by Knut Inge Grosland on 2015-07-16.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetDetailViewController.h"
#import <Photos/Photos.h>

@interface QBAssetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButton;

@end

@implementation QBAssetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = self.image;
    self.selectButton.title = self.isSelected ? NSLocalizedString(@"Deselect", nil) : NSLocalizedString(@"Select", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
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
