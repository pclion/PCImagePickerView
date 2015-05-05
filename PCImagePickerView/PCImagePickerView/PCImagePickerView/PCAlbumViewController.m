//
//  PCAlbumViewController.m
//  PCImagePickerView
//
//  Created by 张培创 on 15/4/20.
//  Copyright (c) 2015年 com.duowan. All rights reserved.
//

#import "PCAlbumViewController.h"
#import "PCAssetCell.h"
#import "PCSelectedAssetCell.h"
#import "PCAssetGroupCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define CellMargin      2
#define EdgeMargin      2

@interface PCAlbumViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, PCSelectedAssetCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *selectedCollectionView;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UIControl *assetsGroupView;
@property (weak, nonatomic) IBOutlet UITableView *assetsGroupTableView;
@property (strong, nonatomic) UIButton *titleButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) NSMutableArray *assetsGroups;
@property (nonatomic, strong) NSMutableArray *allAssetsArray;
@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, strong) NSMutableArray *selectedAssetsArray;
@property (nonatomic) CGFloat itemLength;
@property (nonatomic) NSInteger groupIndex;
@property (nonatomic) BOOL showAssetView;

- (IBAction)assetsGroupViewBackAction:(id)sender;

@end

@implementation PCAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNavBar];
    [self setupCollectionView];
    [self setupTableView];
    [self setupDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavBar
{
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.titleButton addTarget:self action:@selector(titleAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleButton;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submitAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupTableView
{
    self.assetsGroupView.alpha = 0;
    UIEdgeInsets inset = self.assetsGroupTableView.contentInset;
    inset.top = 64;
    self.assetsGroupTableView.contentInset = inset;
    [self.assetsGroupTableView registerNib:[UINib nibWithNibName:@"PCAssetGroupCell" bundle:nil] forCellReuseIdentifier:assetGroupCellIdentifier];
}

- (void)setupCollectionView {
    CGFloat itemWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - CellMargin * 3) / 4;
    self.itemLength = itemWidth;
    
    UIEdgeInsets inset = self.collectionView.contentInset;
    inset.bottom = 100;
    self.collectionView.contentInset = inset;
    self.collectionView.backgroundColor = [UIColor colorWithRed:153/255. green:153/255. blue:153/255. alpha:1.0];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PCAssetCell" bundle:nil] forCellWithReuseIdentifier:assetCellIdentifier];
    self.selectedView.backgroundColor =[UIColor colorWithRed:47/255. green:51/255. blue:55/255. alpha:1.0];
    self.selectedCollectionView.backgroundColor = [UIColor colorWithRed:47/255. green:51/255. blue:55/255. alpha:1.0];
    [self.selectedCollectionView registerNib:[UINib nibWithNibName:@"PCSelectedAssetCell" bundle:nil] forCellWithReuseIdentifier:selectedAssetCellIdentifier];
}

- (void)setupDataSource {
    self.library = [[ALAssetsLibrary alloc] init];
    self.assetsGroups = [NSMutableArray array];
    self.assetsArray = [NSMutableArray array];
    self.selectedAssetsArray = [NSMutableArray array];
    self.allAssetsArray = [NSMutableArray array];
    
    //枚举相册的Block
    void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *,BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        [assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
        NSLog(@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyType]);
        if (assetsGroup.numberOfAssets > 0)
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            [assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [tempArray addObject:result];
                }
            }];
            
            if ([[assetsGroup valueForProperty:ALAssetsGroupPropertyType] isEqualToNumber:@(16)]) {
                [_assetsGroups insertObject:assetsGroup atIndex:0];
                [self.allAssetsArray insertObject:tempArray atIndex:0];
            } else {
                [_assetsGroups addObject:assetsGroup];
                [self.allAssetsArray addObject:tempArray];
            }
        }
        
        if (assetsGroup == nil) {
            if (_assetsGroups.count > 0)
            {
                ALAssetsGroup *group = [self.assetsGroups firstObject];
                [self.assetsArray addObjectsFromArray:[self.allAssetsArray firstObject]];
                self.groupIndex = 0;
                [self.titleButton setTitle:[NSString stringWithFormat:@"%@", [group valueForProperty:ALAssetsGroupPropertyName]] forState:UIControlStateNormal];
                [self.titleButton sizeToFit];
                CGFloat height = [self.assetsGroups count] * 60 > 285 ? 285 + 64 : [self.assetsGroups count] * 60 + 64;
                self.tableViewHeightConstraint.constant = height;
                self.assetsGroupTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
                [self.assetsGroupView layoutIfNeeded];
                [self.assetsGroupTableView reloadData];
                [self.collectionView reloadData];
            }
        }
    };
    //查找相册失败block
    void(^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    
    
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
}

- (void)titleAction
{
    if (self.showAssetView) {
        [self hideAssetsGroupView];
    } else {
        [self showAssetsGroupView];
    }
}

- (void)submitAction
{
    if ([self.delegate respondsToSelector:@selector(didSelectedImages:)]) {
        NSMutableArray *tempArray = [NSMutableArray array];
        [self.selectedAssetsArray enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            CGImageRef imageRef = [representation fullScreenImage];
            UIImageOrientation orientation = UIImageOrientationUp;
            UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:orientation];
            [tempArray addObject:image];
        }];
        [self.delegate didSelectedImages:[tempArray copy]];
    }
}

- (void)showAssetsGroupView
{
    self.showAssetView = YES;
    [UIView animateWithDuration:0.15 animations:^{
        self.assetsGroupView.alpha = 1;
    }];
}

- (void)hideAssetsGroupView
{
    self.showAssetView = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.assetsGroupView.alpha = 0;
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionView) {
        return [self.assetsArray count];
    } else {
        return [self.selectedAssetsArray count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        PCAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:assetCellIdentifier forIndexPath:indexPath];
        ALAsset *asset = self.assetsArray[indexPath.row];
        CGImageRef imageRef = [asset aspectRatioThumbnail];
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        cell.assetImageView.image = image;
        BOOL selected = [self.selectedAssetsArray containsObject:asset];
        [cell setupViewWithSelected:selected];
        return cell;
    } else {
        PCSelectedAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:selectedAssetCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexPath = indexPath;
        [cell.numberButton setTitle:[NSString stringWithFormat:@"%ld", indexPath.row] forState:UIControlStateNormal];
        ALAsset *asset = self.selectedAssetsArray[indexPath.row];
        CGImageRef imageRef = [asset aspectRatioThumbnail];
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        cell.selectedImageView.image = image;
        if (indexPath.row == [self.selectedAssetsArray count] - 1) {
            cell.nextImageView.hidden = YES;
        } else {
            cell.nextImageView.hidden = NO;
        }
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        ALAsset *asset = self.assetsArray[indexPath.row];
        BOOL selected = [self.selectedAssetsArray containsObject:asset];
        PCAssetCell *cell = (PCAssetCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell updateViewWithSelected:selected];
        if (selected) {
            [self.selectedAssetsArray removeObject:asset];
            [self.selectedCollectionView reloadData];
        } else {
            [self.selectedAssetsArray addObject:asset];
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForItem:[self.selectedAssetsArray count] - 1 inSection:0];
            [self.selectedCollectionView performBatchUpdates:^{
                [self.selectedCollectionView insertItemsAtIndexPaths:@[insertIndexPath]];
            } completion:^(BOOL finished) {
                [self.selectedCollectionView scrollToItemAtIndexPath:insertIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                [self.selectedCollectionView reloadData];
            }];
        }
    } else {
        
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        return CGSizeMake(self.itemLength, self.itemLength);
    } else {
        return CGSizeMake(100, 100);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.collectionView) {
        return UIEdgeInsetsMake(EdgeMargin, 0, EdgeMargin, 0);
    } else {
        return UIEdgeInsetsZero;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assetsGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCAssetGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:assetGroupCellIdentifier forIndexPath:indexPath];
    ALAssetsGroup *group = self.assetsGroups[indexPath.row];
    cell.assetImageView.image = [UIImage imageWithCGImage:[group posterImage]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", [group valueForProperty:ALAssetsGroupPropertyName]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideAssetsGroupView];
    if (self.groupIndex != indexPath.row) {
        self.groupIndex = indexPath.row;
        ALAssetsGroup *group = self.assetsGroups[indexPath.row];
        [self.assetsArray removeAllObjects];
        [self.assetsArray addObjectsFromArray:self.allAssetsArray[indexPath.row]];
        [self.collectionView reloadData];
        [self.titleButton setTitle:[NSString stringWithFormat:@"%@", [group valueForProperty:ALAssetsGroupPropertyName]] forState:UIControlStateNormal];
        [self.titleButton sizeToFit];
    }
}

#pragma mark - PCSelectedAssetCellDelegate

- (void)deselectedAssetWithIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedAssetsArray removeObjectAtIndex:indexPath.row];
    [self.selectedCollectionView reloadData];
    [self.collectionView reloadData];
}

- (IBAction)assetsGroupViewBackAction:(id)sender {
    [self hideAssetsGroupView];
}
@end
