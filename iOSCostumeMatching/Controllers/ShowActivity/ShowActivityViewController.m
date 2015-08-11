//
//  ShowActivityViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/23.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ShowActivityViewController.h"
#import "CreateActivityViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CHTCollectionViewWaterfallCell.h"

#define CELL_IDENTIFIER @"ShowActivityViewCell"

@interface ShowActivityViewController ()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, copy) void(^finish)(ActivityInfo *info,BOOL isNew);
@property (nonatomic, copy) void(^delete)(ActivityInfo *info);

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *middleView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lblRemind;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ShowActivityViewController

-(void)setActivityFinishBlock:(void (^)(ActivityInfo *,BOOL isNew))activityfinishBlock
{
    _finish = activityfinishBlock;
}

-(void)setDeleteBlock:(void (^)(ActivityInfo *))deleteBlock
{
    _delete = deleteBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    CreateActivityViewController *createActivity = [[CreateActivityViewController alloc]init];
    createActivity.activityInfo = _activityInfo;
    createActivity.type = 1;
    __weak ShowActivityViewController *weakSelf = self;
    [createActivity setDeleteBlock:^(ActivityInfo *info) {
        if (weakSelf.delete) {
            weakSelf.delete(info);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [createActivity setActivityFinishBlock:^(ActivityInfo *info,BOOL isNew) {
        if (weakSelf.finish) {
            weakSelf.finish(info,isNew);
        }
        weakSelf.activityInfo = info;
        [weakSelf updateView];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:createActivity];
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:LocalizedString(@"Details", nil)];
    [self setNavTitleColor:[UIColor whiteColor]];
    
    self.showReturn = YES;
    self.showDone = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back_w"] andHighlightedImage:nil];
    [self setDoneBtnTitleColor:[UIColor whiteColor]];
    [self setDoneBtnTitle:LocalizedString(@"Edit", nil)];
    
    [self.collectionView setFrame:CGRectMake(0, CGRectGetMaxY(_middleView.frame), ScreenWidth, ScreenHeight-CGRectGetMaxY(_middleView.frame)-64)];
    [self.view insertSubview:self.collectionView atIndex:0];
    [self updateView];
    // Do any additional setup after loading the view from its nib.
}

-(void)updateView
{
    [self.lblTitle setText:_activityInfo.strTitle];
    [self.lblLocation setText:_activityInfo.strLocation];
    if (_activityInfo.numIsAllDay) {
        [_lblStartTime setText:stringAllDayFromDate(_activityInfo.dateStartTime)];
        [_lblRemind setText:getAllDayRemindName((AllDayRemind)_activityInfo.firstRemindTime)];
    }
    else
    {
        [_lblStartTime setText:stringNotAllDayFromDate(_activityInfo.dateStartTime)];
        [_lblRemind setText:getNotAllDayRemindName((NotAllDayRemind)_activityInfo.firstRemindTime)];
    }
    [_topView setBackgroundColor:getColor((ActivityColor)[_activityInfo.numColor integerValue])];
    [self.navigationController.navigationBar setBarTintColor:getColor((ActivityColor)[_activityInfo.numColor integerValue])];
//    self.navigationController.navigationBar.clipsToBounds = YES;
    [_collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.minimumColumnSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_middleView.frame), ScreenWidth, ScreenHeight-CGRectGetHeight(_middleView.frame)-64) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = colorWithHexString(@"#f4f4f4");
        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _activityInfo.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    id info = [_activityInfo.arrData objectAtIndex:indexPath.row];
    if ([info isKindOfClass:[ClothesInfo class]]) {
        ClothesInfo *_data = info;
        cell.image = _data.file;
    }
    else
    {
        CollocationInfo *_data = info;
        cell.image = _data.file;
    }
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width;
    CGFloat height;
    id info = [_activityInfo.arrData objectAtIndex:indexPath.row];
    if ([info isKindOfClass:[ClothesInfo class]]) {
        ClothesInfo *_data = info;
        width = _data.file.size.width;
        height = _data.file.size.height;
    }
    else
    {
        CollocationInfo *_data = info;
        width = _data.file.size.width;
        height = _data.file.size.height;
    }
    CGFloat viewHeight = ((ScreenWidth-15)/(2.0*width))*height;
    return CGSizeMake((ScreenWidth-15)/2.0, viewHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
