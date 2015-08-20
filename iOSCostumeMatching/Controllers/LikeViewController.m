//
//  LikeViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/23.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "LikeViewController.h"
#import "LikeDetailViewController.h"
#import "SelectViewController.h"
#import "InspirationCollectionViewCell.h"
#import "ShowCollectionInspirationDetailsViewController.h"
#import "MJRefresh.h"

#define CELL_IDENTIFIER @"LikeCell"

@interface LikeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    int style;
    int occasion;
}

@property (weak, nonatomic) IBOutlet UIButton *btnStyle;
@property (weak, nonatomic) IBOutlet UIButton *btnOccasion;
@property (weak, nonatomic) IBOutlet UILabel *lblStyle;
@property (weak, nonatomic) IBOutlet UILabel *lblOccasion;

@property (nonatomic, strong) UICollectionView *collectionView;  // 集合视图

@property (nonatomic, strong) NSMutableArray *arrCollection;
@property (nonatomic) int mId;

@end

@implementation LikeViewController

-(void)returnBtnPressed:(id)sender
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:true];
}

-(void)updateView{
    _mId = 0;
    [self updateCollectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showReturn = YES;
    [self setNavTitle:LocalizedString(@"My_Likes", nil)];
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_sideslip"] andHighlightedImage:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateView) name:NOTIFICATION_UPDATEVIEW object:nil];
    
    [_lblStyle setText:LocalizedString(@"Style", nil)];
    [_lblOccasion setText:LocalizedString(@"Occasion", nil)];
    
    [self createCollectionView];
    
    self.arrCollection = [[NSMutableArray alloc]init];
    
    __weak UICollectionView *weakCollectionView = self.collectionView;
    __weak LikeViewController *weakSelf = self;
    // 下拉刷新
    weakCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.mId = 0;
        [weakSelf updateCollectionView];
    }];
    
    // 上拉刷新
    weakCollectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf updateCollectionView];
    }];
    
//    [self updateCollectionView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mId = 0;
    [self updateCollectionView];
}

- (void)createCollectionView
{
    // 创建布局对象，需要对显示图片的布局进行调整所有传递给布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;

    // layout 决定来 collectionView 中所有 cell (单元格) 的布局
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lblOccasion.frame), ScreenWidth, ScreenHeight-64-CGRectGetHeight(_btnOccasion.frame)) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    // 创建 集合视图单元格 ，放在重用队列里面
    [_collectionView registerNib:[UINib nibWithNibName:@"InspirationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view insertSubview:_collectionView atIndex:0];
} // 创建集合视图

-(void)updateCollectionView
{
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (!userInfo) {
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        [_arrCollection removeAllObjects];
        [self.collectionView reloadData];
        return;
    }
    
    if (_mId == 0) {
        [_arrCollection removeAllObjects];
    }
    
    __weak LikeViewController *weakSelf = self;
    
    [[RC_RequestManager shareManager]getLikedCollocationWithStyleId:style OccId:occasion MinId:_mId Count:10 success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            CLog(@"%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject;
                if ([[dic objectForKey:@"stat"] integerValue]== 10000) {
                    NSArray *arr = [dic objectForKey:@"list"];
                    if (arr && (![arr isKindOfClass:[NSNull class]])) {
                        [weakSelf.arrCollection addObjectsFromArray:arr];
                        weakSelf.mId = [[dic objectForKey:@"mId"]intValue];
                    }
                }
            }
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.header endRefreshing];
            [weakSelf.collectionView.footer endRefreshing];
        }
    } andFailed:^(NSError *error) {
        CLog(@"%@",error);
        [weakSelf.collectionView.header endRefreshing];
        [weakSelf.collectionView.footer endRefreshing];
    }];
}

- (IBAction)selectStyle:(id)sender {
    SelectViewController *selectStyle = [[SelectViewController alloc]init];
    [selectStyle setNavagationTitle:LocalizedString(@"Style", nil)];
    selectStyle.array = getAllCollocationStyle();
    selectStyle.selectCellTitle = _lblStyle.text;
    __weak LikeViewController *weakSelf = self;
    [selectStyle setSelectedBlock:^(int index) {
        style = index;
        [weakSelf.lblStyle setText:getCollocationStyleName(style)];
        weakSelf.mId = 0;
        [weakSelf updateCollectionView];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectStyle];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (IBAction)selectOccasion:(id)sender {
    SelectViewController *selectOccasion = [[SelectViewController alloc]init];
    [selectOccasion setNavagationTitle:LocalizedString(@"Occasion", nil)];
    selectOccasion.array = getAllCollocationOccasion();
    selectOccasion.selectCellTitle = _lblOccasion.text;
    __weak LikeViewController *weakSelf = self;
    [selectOccasion setSelectedBlock:^(int index) {
        occasion = index;
        [weakSelf.lblOccasion setText:getCollocationOccasionName(occasion)];
        weakSelf.mId = 0;
        [weakSelf updateCollectionView];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectOccasion];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrCollection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InspirationCollectionViewCell *cell =
    (InspirationCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                               forIndexPath:indexPath];
    if(_arrCollection.count>indexPath.row)
    {
        NSDictionary *dic = [_arrCollection objectAtIndex:indexPath.row];
        NSString *url = [dic objectForKey:@"url"];
        if (url) {
            [cell.collectionImageView sd_setImageWithURL:[NSURL URLWithString:url]];
        }
        NSString *pic = [dic objectForKey:@"pic"];
        if (pic && (![pic isKindOfClass:[NSNull class]])) {
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:pic]];
        }
        else
        {
            [cell.headImageView setImage:nil];
        }
        NSString *name = [dic objectForKey:@"tname"];
        if(name)
        {
            [cell.lblName setText:name];
        }
        cell.likeImageView.hidden = YES;

    }
    return cell;
}

#pragma mark - UICollectionViewDelegate UICollectionViewDelegateFlowLayout

//设置整个分区相对上下左右的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth-15)/2.0, (ScreenWidth-15)/2.0+38);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    __weak LikeViewController *weakSelf = self;
    NSDictionary *dic = [_arrCollection objectAtIndex:indexPath.row];
    int coId = [[dic objectForKey:@"coId"] intValue];
    ShowCollectionInspirationDetailsViewController *showDetail = [[ShowCollectionInspirationDetailsViewController alloc]init];
    showDetail.coId = coId;
    showDetail.dic = dic;
    showDetail.isLiked = YES;
//    [showDetail setDicChangeBlock:^{
//        CLog(@"change");
//        [weakSelf.collectionView reloadData];
//    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:showDetail];
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
