//
//  PCSelectedAssetCell.m
//  PCImagePickerView
//
//  Created by 张培创 on 15/4/20.
//  Copyright (c) 2015年 com.duowan. All rights reserved.
//

#import "PCSelectedAssetCell.h"

@implementation PCSelectedAssetCell

- (void)awakeFromNib {
    // Initialization code
    self.selectedImageView.layer.masksToBounds = YES;
    self.selectedImageView.layer.cornerRadius = 2;
    self.numberButton.layer.masksToBounds = YES;
    self.numberButton.layer.cornerRadius = 2;
    self.numberButton.backgroundColor = [UIColor colorWithRed:51/255. green:101/255. blue:147/255. alpha:0.8];
}

- (IBAction)deleteAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deselectedAssetWithIndexPath:)]) {
        [self.delegate deselectedAssetWithIndexPath:self.indexPath];
    }
}
@end
