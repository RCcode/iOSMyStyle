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
#import "SelectViewController.h"

#define CELL_IDENTIFIER @"MatchingCell"
#define SHOWHELPKEY @"showMatchingHelp"

@interface MatchingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    int style;
    int occasion;
}

@property (nonatomic, strong) NSMutableArray *arrCollection;
@property (nonatomic, strong) UICollectionView *collectionView;  // 集合视图
@property (weak, nonatomic) IBOutlet UIButton *btnStyle;
@property (weak, nonatomic) IBOutlet UIButton *btnOccasion;
@property (weak, nonatomic) IBOutlet UILabel *lblStyle;
@property (weak, nonatomic) IBOutlet UILabel *lblOccasion;

@property (weak, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UILabel *lblHelp1;
@property (weak, nonatomic) IBOutlet UILabel *lblHelp2;
@property (weak, nonatomic) IBOutlet UIImageView *noticeBgImageView;


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
    [self setNavTitle:LocalizedString(@"Lookbook", nil)];
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_sideslip"] andHighlightedImage:nil];
    
    [_lblStyle setText:LocalizedString(@"Style", nil)];
    [_lblOccasion setText:LocalizedString(@"Occasion", nil)];
    
    if([CURR_LANG isEqualToString:@"zh-Hans"] ){
        [_noticeBgImageView setImage:[UIImage imageNamed:@"notice_bg2"]];
    }
    else
    {
        [_noticeBgImageView setImage:[UIImage imageNamed:@"notice_bg2_en"]];
    }
//    [_lblHelp1 setText:LocalizedString(@"helpLookbook1", nil)];
//    [_lblHelp2 setText:LocalizedString(@"helpLookbook2", nil)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCollectionView) name:NOTIFICATION_UPDATEVIEW object:nil];
    
    self.arrCollection = [[RC_SQLiteManager shareManager]getAllCollection];
    [self createCollectionView];
    
    NSString *showHelp = [[NSUserDefaults standardUserDefaults]objectForKey:SHOWHELPKEY];
    if (showHelp) {
        _helpView.hidden = YES;
        [_collectionView setFrame:CGRectMake(0, CGRectGetMaxY(_btnOccasion.frame), ScreenWidth, ScreenHeight-CGRectGetHeight(_btnOccasion.frame)-64)];
    }
    else
    {
        _helpView.hidden = NO;
        [_collectionView setFrame:CGRectMake(0, CGRectGetMaxY(_helpView.frame), ScreenWidth, ScreenHeight-CGRectGetMaxY(_helpView.frame)-64)];
    }
}

-(void)updateCollectionView
{
    self.arrCollection = [[RC_SQLiteManager shareManager]getCollectionWithStyle:style occasion:occasion];
    [_collectionView reloadData];
}

- (IBAction)helpClose:(id)sender {
    [_helpView removeFromSuperview];
    [_collectionView setFrame:CGRectMake(0, CGRectGetMaxY(_btnOccasion.frame), ScreenWidth, ScreenHeight-CGRectGetHeight(_btnOccasion.frame)-64)];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:SHOWHELPKEY];
}

- (IBAction)selectStyle:(id)sender {
    SelectViewController *selectStyle = [[SelectViewController alloc]init];
    [selectStyle setNavagationTitle:LocalizedString(@"Style", nil)];
    selectStyle.array = getAllCollocationStyle();
    selectStyle.selectCellTitle = _lblStyle.text;
    __weak MatchingViewController *weakSelf = self;
    [selectStyle setSelectedBlock:^(int index) {
        style = index;
        [weakSelf.lblStyle setText:getCollocationStyleName(style)];
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
    __weak MatchingViewController *weakSelf = self;
    [selectOccasion setSelectedBlock:^(int index) {
        occasion = index;
        [weakSelf.lblOccasion setText:getCollocationOccasionName(occasion)];
        [weakSelf updateCollectionView];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectOccasion];
    [self presentViewController:nav animated:YES completion:nil];
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
    [[RC_SQLiteManager shareManager]addCollection:info];
    
    self.arrCollection = [[RC_SQLiteManager shareManager]getCollectionWithStyle:style occasion:occasion];
    [_collectionView reloadData];
    
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (userInfo) {
        showMBProgressHUD(nil, YES);
        __weak MatchingViewController *weakSelf = self;
        [[RC_RequestManager shareManager]addCollocationWithCollocationInfo:info success:^(id responseObject) {
            CLog(@"%@",responseObject);
            hideMBProgressHUD();
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                if([[responseObject objectForKey:@"stat"] integerValue] == 10000)
                {
                    NSDictionary *dic = responseObject;
                    info.numCoId = [NSNumber numberWithInt:[[dic objectForKey:@"coId"] intValue]];
                    [[RC_SQLiteManager shareManager]addCollection:info];;
                    weakSelf.arrCollection = [[RC_SQLiteManager shareManager]getCollectionWithStyle:style occasion:occasion];
                    [weakSelf.collectionView reloadData];
                }
            }
        } andFailed:^(NSError *error) {
            hideMBProgressHUD();
            CLog(@"%@",error);
        }];
    }
}

#pragma mark - View
- (void)createCollectionView
{
    // 创建布局对象，需要对显示图片的布局进行调整所有传递给布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    
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
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth-15)/2.0, (ScreenWidth-15)/2.0);
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
