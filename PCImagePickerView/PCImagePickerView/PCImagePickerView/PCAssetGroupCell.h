//
//  PCAssetGroupCell.h
//  PCImagePickerView
//
//  Created by 张培创 on 15/4/20.
//  Copyright (c) 2015年 com.duowan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const assetGroupCellIdentifier = @"assetGroupCellIdentifier";

@interface PCAssetGroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *assetImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
