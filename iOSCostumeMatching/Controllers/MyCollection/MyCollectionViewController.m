//
//  MyCollectionViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/22.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "CHTCollectionViewWaterfallCell.h"
#define CELL_IDENTIFIER @"MyCollectionCell"

@interface MyCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collectionView;  // 集合视图
}

@property (nonatomic, strong) NSMutableArray *arrCollection;
@property (nonatomic, copy) void(^select)(CollocationInfo *info);

@end

@implementation MyCollectionViewController

-(void)setSelectBlock:(void (^)(CollocationInfo *))selectBlock
{
    _select = selectBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showReturn = YES;
    [self setNavTitle:LocalizedString(@"Lookbook", nil)];
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    
    self.arrCollection = [[RC_SQLiteManager shareManager]getAllCollection];
    [self createCollectionView];
    // Do any additional setup after loading the view from its nib.
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
    CollocationInfo *info = [_arrCollection objectAtIndex:indexPath.row];
    if (_select) {
        _select(info);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
