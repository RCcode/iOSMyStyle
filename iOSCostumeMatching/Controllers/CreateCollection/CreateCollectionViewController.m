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

#define CELL_IDENTIFIER @"WaterfallCell1"

@interface CreateCollectionViewController ()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout,ZDStickerViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *createImageView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *arrClothes;

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
        _collectionView.backgroundColor = [UIColor blueColor];
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
    [self setReturnBtnTitle:@"取消"];
    [self setDoneBtnTitle:@"继续"];
    
    self.arrClothes = [[RC_SQLiteManager shareManager]getAllClothesFromWardrobe];
    [self.selectView insertSubview:self.collectionView atIndex:0];
    
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = 3;
    
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
    userResizableView1.tag = 0;
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
    NSLog(@"%s [%zd]",__func__, sticker.tag);
}

- (void)stickerViewDidCustomButtonTap:(ZDStickerView *)sticker
{
    NSLog(@"%s [%zd]",__func__, sticker.tag);
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
