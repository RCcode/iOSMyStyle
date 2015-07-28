//
//  WardrobeViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/9.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "WardrobeViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "CutAndWipeViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"

#import "ShowClothesDetailsViewController.h"

#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface WardrobeViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) NSMutableArray *arrClothes;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cellSizes;
@property (weak, nonatomic) IBOutlet UIButton *btnStyle;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;

@end

@implementation WardrobeViewController

-(void)returnBtnPressed:(id)sender
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:true];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 0;
        layout.footerHeight = 0;
//        layout.minimumColumnSpacing = 20;
//        layout.minimumInteritemSpacing = 30;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_btnStyle.frame), ScreenWidth, ScreenHeight-CGRectGetHeight(_btnStyle.frame)-64) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"我的衣橱"];
    self.showReturn = YES;
    [self setReturnBtnTitle:@"菜单"];
    
    self.arrClothes = [[RC_SQLiteManager shareManager]getAllClothesFromWardrobe];
    [self.view insertSubview:self.collectionView atIndex:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
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
    ShowClothesDetailsViewController *showDetails = [[ShowClothesDetailsViewController alloc]init];
    showDetails.clothesInfo = info;
    __weak WardrobeViewController *weakSelf = self;
    [showDetails setDeleteBlock:^(ClothesInfo *info) {
        [weakSelf deleteClothes:info];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:showDetails];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)deleteClothes:(ClothesInfo *)info
{
    [[RC_SQLiteManager shareManager]deleteClotheFromWardrobe:info];
    self.arrClothes = [[RC_SQLiteManager shareManager]getAllClothesFromWardrobe];
    [_collectionView reloadData];
}

- (IBAction)selectStyle:(id)sender {
    
}

- (IBAction)selectCategory:(id)sender {
}

/**
 *  添加衣服
 *
 *  @param sender <#sender description#>
 */

- (IBAction)addClothes:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"添加衣服" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            CLog(@"相机");
            [self cameraBtnOnClick];
            break;
        }
        case 1:
        {
            CLog(@"相册");
            [self photoAlbumBtnOnClick];
            break;
        }
        default:
            break;
    }
}

- (void)cameraBtnOnClick{
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        return;
    }
    
    //判断权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"camena_not_availabel", @"")
                                                        message:LocalizedString(@"user_camera_step", @"")
                                                       delegate:nil
                                              cancelButtonTitle:LocalizedString(@"confirm", @"")
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = NO;
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void)photoAlbumBtnOnClick{
    
//    判断权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"library_not_availabel", @"")
                                                        message:LocalizedString(@"user_library_step", @"")
                                                       delegate:nil
                                              cancelButtonTitle:LocalizedString(@"confirm", @"")
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = NO;
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePickerController.videoQuality=UIImagePickerControllerQualityTypeMedium;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    __weak UIImagePickerController *weekImagePickerController = picker;
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"pickerDismiss"];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    __weak WardrobeViewController *weakSelf = self;
    [weekImagePickerController dismissViewControllerAnimated:YES completion:^{
        [weakSelf gotoCutAndWipe:image];
    }];
}

-(void)gotoCutAndWipe:(UIImage *)image
{
    CutAndWipeViewController *cutAndWipeViewController = [[CutAndWipeViewController alloc]init];
    cutAndWipeViewController.originalImage = image;
    __weak WardrobeViewController *weakSelf = self;
    [cutAndWipeViewController setFinishImageBlock:^(ClothesInfo *info) {
        [weakSelf addClothesToWardrobe:info];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:cutAndWipeViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)addClothesToWardrobe:(ClothesInfo *)info
{
    showMBProgressHUD(nil, YES);
    __weak WardrobeViewController *weakSelf = self;
    [[RC_RequestManager shareManager]addClothingWithColothesInfo:info success:^(id responseObject) {
        CLog(@"%@",responseObject);
        hideMBProgressHUD();
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dic = responseObject;
            info.numClId = [NSNumber numberWithInt:[[dic objectForKey:@"clId"] intValue]];
            [[RC_SQLiteManager shareManager]addClothesToWardrobe:info];
            weakSelf.arrClothes = [[RC_SQLiteManager shareManager]getAllClothesFromWardrobe];
            [weakSelf.collectionView reloadData];
        }
        
    } andFailed:^(NSError *error) {
        CLog(@"%@",error);
        hideMBProgressHUD();
    }];
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
