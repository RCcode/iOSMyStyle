//
//  MatchingViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/9.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "MatchingViewController.h"
#import "CreateCollectionViewController.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "ShowCollectionDetailsViewController.h"

#define CELL_IDENTIFIER @"MatchingCell"

@interface MatchingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collectionView;  // 集合视图
}

@property (nonatomic, strong) NSMutableArray *arrCollection;

@end

@implementation MatchingViewController

-(void)returnBtnPressed:(id)sender
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showReturn = YES;
    [self setNavTitle:@"我的搭配"];
    [self setReturnBtnTitle:@"菜单"];
    
    self.arrCollection = [[RC_SQLiteManager shareManager]getAllCollection];
    [self createCollectionView];
}

- (IBAction)addCollection:(id)sender {
    CreateCollectionViewController *createCollection = [[CreateCollectionViewController alloc]init];
    __weak MatchingViewController *weakSelf = self;
    [createCollection setCollectionFinishBlock:^(CollocationInfo *info) {
        [weakSelf addCollocation:info];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:createCollection];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)addCollocation:(CollocationInfo *)info
{
    [[RC_RequestManager shareManager]addCollocationWithCollocationInfo:info success:^(id responseObject) {
        CLog(@"%@",responseObject);
    } andFailed:^(NSError *error) {
        CLog(@"%@",error);
    }];
    
//    info.numCoId = [NSNumber numberWithInt:(int)(_arrCollection.count+1)];
//    
//    [[RC_SQLiteManager shareManager]addCollection:info];
//    
//    self.arrCollection = [[RC_SQLiteManager shareManager]getAllCollection];
//    
//    [_collectionView reloadData];
}

#pragma mark - View
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
    
    [self.view insertSubview:_collectionView atIndex:0];
    
} // 创建集合视图

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrCollection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    ClothesInfo *info = [_arrCollection objectAtIndex:indexPath.row];
    cell.image = info.file;
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
    ShowCollectionDetailsViewController *showDetails = [[ShowCollectionDetailsViewController alloc]init];
    [showDetails setCollocationInfo:[_arrCollection objectAtIndex:indexPath.row]];
    __weak MatchingViewController *weakSelf = self;
    [showDetails setDeleteBlock:^(CollocationInfo *info) {
        [weakSelf deleteCollection:info];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:showDetails];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)deleteCollection:(CollocationInfo *)info
{
    [[RC_SQLiteManager shareManager]deleteCollection:info];
    self.arrCollection = [[RC_SQLiteManager shareManager]getAllCollection];
    [_collectionView reloadData];
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
