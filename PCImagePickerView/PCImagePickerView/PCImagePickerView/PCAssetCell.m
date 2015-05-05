//
//  PCAssetCell.m
//  PCImagePickerView
//
//  Created by 张培创 on 15/4/20.
//  Copyright (c) 2015年 com.duowan. All rights reserved.
//

#import "PCAssetCell.h"

@implementation PCAssetCell

- (void)awakeFromNib {
    // Initialization code
    self.modelView.alpha = 0;
}

- (void)updateViewWithSelected:(BOOL)selected
{
    if (selected) {
        [self hideSelectedViewWithAnimate:YES];
    } else {
        [self showSelectedViewWithAnimate:YES];
    }
}

- (void)setupViewWithSelected:(BOOL)selected
{
    if (selected) {
        [self showSelectedViewWithAnimate:NO];
    } else {
        [self hideSelectedViewWithAnimate:NO];
    }
}

- (void)showSelectedViewWithAnimate:(BOOL)animate
{
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            self.modelView.alpha = 1;
        }];
    } else {
        self.modelView.alpha = 1;
    }
}

- (void)hideSelectedViewWithAnimate:(BOOL)animate
{
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            self.modelView.alpha = 0;
        }];
    } else {
        self.modelView.alpha = 0;
    }
}

@end
