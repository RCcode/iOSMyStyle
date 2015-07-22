//
//  MyWardrobeViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/22.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "MyWardrobeViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CHTCollectionViewWaterfallCell.h"

#define CELL_IDENTIFIER @"MyWardrobeCell"

@interface MyWardrobeViewController ()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) NSMutableArray *arrClothes;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cellSizes;
@property (nonatomic, copy) void(^select)(ClothesInfo *info);

@end

@implementation MyWardrobeViewController

-(void)setSelectBlock:(void (^)(ClothesInfo *))selectBlock
{
    _select = selectBlock;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 0;
        layout.footerHeight = 0;
        //        layout.minimumColumnSpacing = 20;
        //        layout.minimumInteritemSpacing = 30;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _collectionView;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"我的衣橱"];
    self.showReturn = YES;
    [self setReturnBtnTitle:@"取消"];
    
    self.arrClothes = [[RC_SQLiteManager shareManager]getAllClothesFromWardrobe];
    [self.view addSubview:self.collectionView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (_select) {
        _select(info);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
