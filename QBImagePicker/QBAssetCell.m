//
//  QBAssetCell.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetCell.h"

@interface QBAssetCell ()

@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIImageView *selectionView;

@end

@implementation QBAssetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionView.image = [UIImage imageNamed:@"selectedImage"];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.selectionView.hidden = !selected;
    
    // Show/hide overlay view
    self.overlayView.hidden = !(selected && self.showsOverlayViewWhenSelected);
}

@end
