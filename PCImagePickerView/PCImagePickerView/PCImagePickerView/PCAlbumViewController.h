//
//  PCAlbumViewController.h
//  PCImagePickerView
//
//  Created by 张培创 on 15/4/20.
//  Copyright (c) 2015年 com.duowan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PCAlbumViewControllerDelegate <NSObject>

/**
 *  选中的图片数组，都是UIImage
 *
 *  @param images 数组
 */
- (void)didSelectedImages:(NSArray *)images;

@end

@interface PCAlbumViewController : UIViewController

@property (weak, nonatomic) id<PCAlbumViewControllerDelegate> delegate;

@end
