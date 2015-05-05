//
//  PCAssetCell.h
//  PCImagePickerView
//
//  Created by 张培创 on 15/4/20.
//  Copyright (c) 2015年 com.duowan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const assetCellIdentifier = @"assetCellIdentifier";

@interface PCAssetCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *assetImageView;
@property (weak, nonatomic) IBOutlet UIView *modelView;

- (void)updateViewWithSelected:(BOOL)selected;

- (void)setupViewWithSelected:(BOOL)selected;

@end
