//
//  ViewController.m
//  PCImagePickerView
//
//  Created by 张培创 on 15/4/20.
//  Copyright (c) 2015年 com.duowan. All rights reserved.
//

#import "ViewController.h"
#import "PCAlbumViewController.h"

@interface ViewController ()
- (IBAction)openPicturesAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openPicturesAction:(id)sender {
    PCAlbumViewController *albumController = [[PCAlbumViewController alloc] initWithNibName:@"PCAlbumViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:albumController];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
