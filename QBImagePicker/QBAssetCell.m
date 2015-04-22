//
//  QBAssetCell.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/06.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetCell.h"

@interface QBAssetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *overlayView;

@end

@implementation QBAssetCell

- (void)awakeFromNib {

    // Get asset bundle
    static NSBundle *assetBundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assetBundle = [NSBundle bundleForClass:[self class]];
        NSString *bundlePath = [assetBundle pathForResource:@"QBImagePicker" ofType:@"bundle"];
        if (bundlePath) {
            assetBundle = [NSBundle bundleWithPath:bundlePath];
        }
    });
    
    self.overlayView.image = [UIImage imageNamed:@"selectedImage" inBundle:assetBundle compatibleWithTraitCollection:nil];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Show/hide overlay view
    self.overlayView.hidden = !(selected && self.showsOverlayViewWhenSelected);
}

@end
