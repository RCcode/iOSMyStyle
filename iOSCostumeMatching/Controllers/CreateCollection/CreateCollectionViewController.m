//
//  CreateCollectionViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/20.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "CreateCollectionViewController.h"
#import "WriteCollectionDetailsViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "ZDStickerView.h"
#import "SelectViewController.h"

#define CELL_IDENTIFIER @"WaterfallCell1"

@interface CreateCollectionViewController ()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout,ZDStickerViewDelegate,UIGestureRecognizerDelegate>
{
    WardrobeType type;
    WardrobeCategory category;
    WardrobeSeason season;
    
    int _lastPosition;
}
@property (weak, nonatomic) IBOutlet UIView *createImageView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrClothes;
@property (nonatomic, strong) NSMutableArray *arrList;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *lblSeason;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;


@property (nonatomic, copy) void(^finish)(CollocationInfo *info);

@end

@implementation CreateCollectionViewController

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    [self hideAllHandles];
    CGSize contextSize = CGSizeMake(ScreenWidth, ScreenWidth);
    UIGraphicsBeginImageContextWithOptions(contextSize, YES, 1.0);
    [_createImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    WriteCollectionDetailsViewController *writeCollection = [[WriteCollectionDetailsViewController alloc]init];
    __weak CreateCollectionViewController *weakSelf = self;
    [writeCollection setCollectionFinishBlock:^(CollocationInfo *info) {
        weakSelf.finish(info);
    }];
    writeCollection.image = image;
    writeCollection.arrList = _arrList;
    [self.navigationController pushViewController:writeCollection animated:YES];
}

-(void)setCollectionFinishBlock:(void (^)(CollocationInfo *))collectionfinishBlock
{
    _finish = collectionfinishBlock;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 0;
        layout.footerHeight = 0;
        //        layout.minimumColumnSpacing = 20;
        //        layout.minimumInteritemSpacing = 30;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:_selectView.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = colorWithHexString(@"#eeeeee");
        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"衣服搭配"];
    self.showReturn = YES;
    self.showDone = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    [self setDoneBtnTitleColor:colorWithHexString(@"#44dcca")];
    [self setDoneBtnTitle:@"下一步"];
    
    self.arrList = [[NSMutableArray alloc]init];
    
    self.arrClothes = [[RC_SQLiteManager shareManager]getAllClothesFromWardrobe];
    [self.selectView insertSubview:self.collectionView atIndex:0];
    
    [_collectionView setFrame:CGRectMake(0, CGRectGetMaxY(_lblCategory.frame), CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_collectionView.frame)-CGRectGetMaxY(_lblCategory.frame))];
    [_bottomView addSubview:_collectionView];
    
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = 2;
    
    [self addTapGestureWithView:_createImageView];
    // Do any additional setup after loading the view from its nib.
}

- (void)addTapGestureWithView:(UIView *)v
{
    UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideAllHandles)];
    sigleTap.delegate = self;
    sigleTap.numberOfTapsRequired = 1;
    sigleTap.numberOfTouchesRequired = 1;
    [v addGestureRecognizer:sigleTap];
}

-(void)hideAllHandles
{
    for (UIView *view in _createImageView.subviews)
    {
        if ([view isKindOfClass:[ZDStickerView class]])
        {
            [(ZDStickerView *)view hideEditingHandles];
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[ZDStickerView class]])
    {
        return NO;
    }
    return YES;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrClothes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    ClothesInfo *info = [_arrClothes objectAtIndex:indexPath.row];
    cell.image = info.file;
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ClothesInfo *info = [_arrClothes objectAtIndex:indexPath.row];
    CGFloat width = info.file.size.width;
    CGFloat height = info.file.size.height;
    CGFloat viewHeight = ((ScreenWidth-30)/(2.0*width))*height;
    return CGSizeMake((ScreenWidth-30)/2.0, viewHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClothesInfo *info = _arrClothes[indexPath.row];
    
    [_arrList addObject:info];
    
    CGFloat imageWidth = info.file.size.width;
    CGFloat imageHeight = info.file.size.height;
    CGFloat width,height;
    if (imageWidth > imageHeight) {
        width = 120;
        height = 120/imageWidth *imageHeight;
    }
    else{
        height = 120;
        width = 120/imageHeight*imageWidth;
    }
    CGRect gripFrame = CGRectMake(0, 0, width+17*2, height+17*2);
    
    UIImageView *imageView1 = [[UIImageView alloc]
                               initWithImage:info.file];
    ZDStickerView *userResizableView1 = [[ZDStickerView alloc] initWithFrame:gripFrame];
    userResizableView1.center = _createImageView.center;
    userResizableView1.tag = [info.numLocalId integerValue];
    userResizableView1.stickerViewDelegate = self;
    userResizableView1.contentView = imageView1;//contentView;
    userResizableView1.preventsPositionOutsideSuperview = NO;
    userResizableView1.translucencySticker = NO;
    [userResizableView1 showEditingHandles];
//    userResizableView1.backgroundColor = [UIColor redColor];
    [self.createImageView addSubview:userResizableView1];
    
    //移动
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPhotoPan:)];
    [userResizableView1 addGestureRecognizer:panRecognizer];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    
    if (currentPostion - _lastPosition > 20  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可）
        
        _lastPosition = currentPostion;
        
        NSLog(@"ScrollUp now");
        [self moveUp:YES];
    }
}

#pragma mark - sticker手势相关

- (void)handelPhotoPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

#pragma mark - ZDStickerViewDelegate

- (void)stickerViewDidBeginEditing:(ZDStickerView *)sticker
{
    [self hideAllHandles];
    [_createImageView bringSubviewToFront:sticker];
    [sticker showEditingHandles];
}

- (void)stickerViewDidLongPressed:(ZDStickerView *)sticker
{
    NSLog(@"%s [%zd]",__func__, sticker.tag);
}

- (void)stickerViewDidClose:(ZDStickerView *)sticker
{
    NSLog(@"%s 删除 [%zd]",__func__, sticker.tag);
    for (id object in _arrList) {
        ClothesInfo *info = object;
        if ([info.numLocalId integerValue]==sticker.tag) {
            [_arrList removeObject:info];
            break;
        }
    }
}

- (void)stickerViewDidCustomButtonTap:(ZDStickerView *)sticker
{
    NSLog(@"%s [%zd]",__func__, sticker.tag);
}

-(void)updateCollectionView
{
    self.arrClothes = [[RC_SQLiteManager shareManager]getClothesFromWardrobeWithSeason:season Type:type Category:category];
    [_collectionView reloadData];
}

-(void)moveUp:(BOOL)up
{
    if (up)
    {
        [UIView animateWithDuration:0.5f animations:^{
            _bottomView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
            _collectionView.frame = CGRectMake(0, CGRectGetMaxY(_lblCategory.frame), CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame)-CGRectGetMaxY(_lblCategory.frame));
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            _bottomView.frame = CGRectMake(0, CGRectGetHeight(_createImageView.frame), ScreenWidth, ScreenHeight-CGRectGetHeight(_createImageView.frame)-64);
           _collectionView.frame = CGRectMake(0, CGRectGetMaxY(_lblCategory.frame), CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame)-CGRectGetMaxY(_lblCategory.frame));
        }];
    }
}

- (IBAction)pressUpOrDown:(id)sender {
    if (_bottomView.frame.origin.y == CGRectGetMaxY(_createImageView.frame)) {
        [self moveUp:YES];
    }
    else
    {
        [self moveUp:NO];
    }
}

- (IBAction)selectSeason:(id)sender {
    SelectViewController *selectCategory = [[SelectViewController alloc]init];
    [selectCategory setNavagationTitle:@"选择季节"];
    selectCategory.array = getAllWardrobeSeason();
    __weak CreateCollectionViewController *weakSelf = self;
    [selectCategory setSelectedBlock:^(int index) {
        season = index;
        [weakSelf.lblSeason setText:getWardrobeSeasonName(season)];
        [weakSelf updateCollectionView];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectCategory];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (IBAction)selectType:(id)sender {
    SelectViewController *selectStyle = [[SelectViewController alloc]init];
    [selectStyle setNavagationTitle:@"选择类型"];
    selectStyle.array = getAllWardrobeType();
    __weak CreateCollectionViewController *weakSelf = self;
    [selectStyle setSelectedBlock:^(int index) {
        if(index == 0)
        {
            type = 0;
        }
        else
        {
            type = index+9;
        }
        [weakSelf.lblType setText:getWardrobeTypeName(type)];
        [weakSelf updateCollectionView];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectStyle];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)selectCategory:(id)sender {
    SelectViewController *selectCategory = [[SelectViewController alloc]init];
    [selectCategory setNavagationTitle:@"选择类别"];
    selectCategory.array = getAllWardrobeCategorye(type);
    __weak CreateCollectionViewController *weakSelf = self;
    [selectCategory setSelectedBlock:^(int index) {
        switch (type) {
            case WTAll:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    if (index >0 && index<=12) {
                        category = index+1000;
                    }
                    else if(index>12 && index<=18)
                    {
                        category = index+1100-12;
                    }
                    else if(index>18 && index<=27)
                    {
                        category = index+1200-18;
                    }
                    else if(index>27 && index<=34)
                    {
                        category = index+1300-27;
                    }
                    else if(index>34 && index<=42)
                    {
                        category = index+1400-34;
                    }
                    else if(index>42 && index<=48)
                    {
                        category = index+1500-42;
                    }
                    else if(index>48)
                    {
                        category = index+1600-48;
                    }
                }
                break;
            }
            case WTUpper:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1001;
                }
                break;
            }
            case WTBottoms:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1101;
                }
                break;
            }
            case WTShoes:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1201;
                }
                break;
            }
            case WTBag:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1301;
                }
                break;
            }
            case WTAccessory:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1401;
                }
                break;
            }
            case WTJewelry:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1501;
                }
                break;
            }
            case WTUnderwear:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1601;
                }
                break;
            }
            default:
                break;
        }
        [weakSelf.lblCategory setText:getWardrobeCategoryeName(category)];
        [weakSelf updateCollectionView];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectCategory];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
