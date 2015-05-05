//
//  PCSelectedAssetCell.h
//  PCImagePickerView
//
//  Created by 张培创 on 15/4/20.
//  Copyright (c) 2015年 com.duowan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const selectedAssetCellIdentifier = @"selectedAssetCellIdentifier";

@protocol PCSelectedAssetCellDelegate <NSObject>

- (void)deselectedAssetWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface PCSelectedAssetCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *numberButton;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;
@property (weak, nonatomic) id<PCSelectedAssetCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;

- (IBAction)deleteAction:(id)sender;
@end
