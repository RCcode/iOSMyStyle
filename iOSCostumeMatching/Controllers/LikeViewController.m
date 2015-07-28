//
//  LikeViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/23.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "LikeViewController.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "LikeDetailViewController.h"

#define CELL_IDENTIFIER @"LikeCell"

@interface LikeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collectionView;  // 集合视图
}

@end

@implementation LikeViewController

-(void)returnBtnPressed:(id)sender
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.showReturn = YES;
    [self setNavTitle:@"我喜欢的搭配"];
    [self setReturnBtnTitle:@"菜单"];
    
    [self createCollectionView];
    [_collectionView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)createCollectionView
{
    // 创建布局对象，需要对显示图片的布局进行调整所有传递给布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    // layout 决定来 collectionView 中所有 cell (单元格) 的布局
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight-20) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    // 创建 集合视图单元格 ，放在重用队列里面
    [_collectionView registerClass:[CHTCollectionViewWaterfallCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_collectionView];
} // 创建集合视图

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    cell.image = [UIImage imageNamed:@"ball"];
    return cell;
}

#pragma mark - UICollectionViewDelegate UICollectionViewDelegateFlowLayout

//设置整个分区相对上下左右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth-30)/2.0, (ScreenWidth-30)/2.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LikeDetailViewController *likeDetail = [[LikeDetailViewController alloc]init];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:likeDetail];
    [self presentViewController:nav animated:YES completion:nil];
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
