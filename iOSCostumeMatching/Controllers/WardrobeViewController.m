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
#import "SelectViewController.h"
#import "UIImage+SubImage.h"

#import "ShowClothesDetailsViewController.h"

#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

#define SHOWHELPKEY @"showWardrobeHelp"

@interface WardrobeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
{
    WardrobeType type;
    WardrobeCategory category;
    WardrobeSeason season;
    
    UIView *alertView;
    UIButton *btnAdd;
    UIButton *btnAlbum;
    UIButton *btnCamera;
}
@property (nonatomic, strong) NSMutableArray *arrClothes;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cellSizes;

@property (weak, nonatomic) IBOutlet UIButton *btnSeason;
@property (weak, nonatomic) IBOutlet UIButton *btnType;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (weak, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UILabel *lblHelp1;
@property (weak, nonatomic) IBOutlet UILabel *lblHelp2;
@property (weak, nonatomic) IBOutlet UILabel *lblHelp3;

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
        
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.headerHeight = 0;
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_btnType.frame), ScreenWidth, ScreenHeight-CGRectGetHeight(_btnType.frame)-64) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = colorWithHexString(@"#f4f4f4");
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
    
    [self setNavTitle:LocalizedString(@"Closet", nil)];
    self.showReturn = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_sideslip"] andHighlightedImage:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCollectionView) name:NOTIFICATION_UPDATEVIEW object:nil];
    [_btnSeason setTitle:LocalizedString(@"Season", nil) forState:UIControlStateNormal];
    [_btnType setTitle:LocalizedString(@"Category", nil) forState:UIControlStateNormal];
    [_btnCategory setTitle:LocalizedString(@"Subcategory", nil) forState:UIControlStateNormal];
    _btnCategory.enabled = NO;
    
    self.arrClothes = [[RC_SQLiteManager shareManager]getAllClothesFromWardrobe];
    [self.view insertSubview:self.collectionView atIndex:0];
    
    [_lblHelp1 setText:LocalizedString(@"helpCloset1", nil)];
    [_lblHelp2 setText:LocalizedString(@"helpCloset2", nil)];
    [_lblHelp3 setText:LocalizedString(@"helpCloset3", nil)];
    NSString *showHelp = [[NSUserDefaults standardUserDefaults]objectForKey:SHOWHELPKEY];
    if (showHelp) {
        _helpView.hidden = YES;
        [_collectionView setFrame:CGRectMake(0, CGRectGetHeight(_btnType.frame), ScreenWidth, ScreenHeight-CGRectGetHeight(_btnType.frame)-64)];
    }
    else
    {
        _helpView.hidden = NO;
        [_collectionView setFrame:CGRectMake(0, CGRectGetMaxY(_helpView.frame), ScreenWidth, ScreenHeight-CGRectGetMaxY(_helpView.frame)-64)];
    }
    
    btnAlbum = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 53, 53)];
    btnAlbum.center = CGPointMake(ScreenWidth/2, ScreenHeight-53/2-13);
    [btnAlbum setImage:[UIImage imageNamed:@"ic_img"] forState:UIControlStateNormal];
    [btnAlbum addTarget:self action:@selector(photoAlbumBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    btnCamera = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 53, 53)];
    btnCamera.center = CGPointMake(ScreenWidth/2, ScreenHeight-53/2-13);
    [btnCamera setImage:[UIImage imageNamed:@"ic_camera"] forState:UIControlStateNormal];
    [btnCamera addTarget:self action:@selector(cameraBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    alertView = [[UIAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window addSubview:alertView];
    alertView.hidden = YES;
    alertView.backgroundColor = [UIColor clearColor];
    btnAdd = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 53, 53)];
    btnAdd.center = CGPointMake(ScreenWidth/2, ScreenHeight-53/2-13);
    [btnAdd setImage:[UIImage imageNamed:@"ic_clothes"] forState:UIControlStateNormal];
    [btnAdd setImage:[UIImage imageNamed:@"ic_clothes_close"] forState:UIControlStateSelected];
    [btnAdd addTarget:self action:@selector(addClothes:) forControlEvents:UIControlEventTouchUpInside];
    
    [alertView addSubview:btnCamera];
    [alertView addSubview:btnAlbum];
    btnAlbum.hidden = YES;
    btnCamera.hidden = YES;
    [alertView addSubview:btnAdd];
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
    CGFloat viewHeight = ((ScreenWidth-15)/(2.0*width))*height;
    return CGSizeMake((ScreenWidth-15)/2.0, viewHeight);
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

-(void)updateCollectionView
{
    self.arrClothes = [[RC_SQLiteManager shareManager]getClothesFromWardrobeWithSeason:season Type:type Category:category];
    [_collectionView reloadData];
}

- (IBAction)closeHelp:(id)sender {
    [_helpView removeFromSuperview];
    [_collectionView setFrame:CGRectMake(0, CGRectGetHeight(_btnType.frame), ScreenWidth, ScreenHeight-CGRectGetHeight(_btnType.frame)-64)];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:SHOWHELPKEY];
}

- (IBAction)selectSeason:(id)sender {
    SelectViewController *selectCategory = [[SelectViewController alloc]init];
    [selectCategory setNavagationTitle:LocalizedString(@"Season", nil)];
    selectCategory.array = getAllWardrobeSeason();
    __weak WardrobeViewController *weakSelf = self;
    [selectCategory setSelectedBlock:^(int index) {
        season = index;
        [weakSelf.btnSeason setTitle:getWardrobeSeasonName(season) forState:UIControlStateNormal];
        [weakSelf updateCollectionView];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectCategory];
    [self presentViewController:nav animated:YES completion:nil];

}

- (IBAction)selectType:(id)sender {
    SelectViewController *selectStyle = [[SelectViewController alloc]init];
    [selectStyle setNavagationTitle:LocalizedString(@"Category", nil)];
    selectStyle.array = getAllWardrobeType();
    __weak WardrobeViewController *weakSelf = self;
    [selectStyle setSelectedBlock:^(int index) {
        if(index == 0)
        {
            type = 0;
        }
        else
        {
            type = index+9;
            category = 0;
            [weakSelf.btnCategory setTitle:LocalizedString(@"Subcategory", nil) forState:UIControlStateNormal];
        }
        [weakSelf.btnType setTitle:getWardrobeTypeName(type) forState:UIControlStateNormal] ;
        [weakSelf updateCollectionView];
        weakSelf.btnCategory.enabled = YES;
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectStyle];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)selectCategory:(id)sender {
    SelectViewController *selectCategory = [[SelectViewController alloc]init];
    [selectCategory setNavagationTitle:LocalizedString(@"Subcategory", nil)];
    selectCategory.array = getAllWardrobeCategorye(type);
    __weak WardrobeViewController *weakSelf = self;
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
                    category = index+1000;
                }
                break;
            }
            case WTBottoms:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1100;
                }
                break;
            }
            case WTShoes:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1200;
                }
                break;
            }
            case WTBag:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1300;
                }
                break;
            }
            case WTAccessory:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1400;
                }
                break;
            }
            case WTJewelry:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1500;
                }
                break;
            }
            case WTUnderwear:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1600;
                }
                break;
            }
            default:
                break;
        }
        [weakSelf.btnCategory setTitle:getWardrobeCategoryeName(category) forState:UIControlStateNormal];
        [weakSelf updateCollectionView];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectCategory];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  添加衣服
 *
 *  @param sender <#sender description#>
 */

- (IBAction)addClothes:(id)sender {
    
    btnAdd.selected = !btnAdd.selected;
    
    if (btnAdd.selected) {
        
        btnAlbum.hidden = NO;
        btnCamera.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            btnAlbum.center = CGPointMake(ScreenWidth/2-70, ScreenHeight-53/2-13);
            btnCamera.center = CGPointMake(ScreenWidth/2+70, ScreenHeight-53/2-13);
        }];
        alertView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.77];
        alertView.hidden = NO;
    }
    else
    {
        [self close];
    }
}

-(void)close
{
    alertView.backgroundColor = [UIColor clearColor];
    btnAdd.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        btnAlbum.center = CGPointMake(ScreenWidth/2, ScreenHeight-53/2-13);
        btnCamera.center = CGPointMake(ScreenWidth/2, ScreenHeight-53/2-13);
    } completion:^(BOOL finished) {
        btnAlbum.hidden = YES;
        btnCamera.hidden = YES;
        alertView.hidden = YES;
    }];
}

- (void)cameraBtnOnClick{
    
    [self close];
    
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
    
    [self close];
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
    image = [image rescaleImageToPX:1080];
    __weak WardrobeViewController *weakSelf = self;
    [weekImagePickerController dismissViewControllerAnimated:YES completion:^{
        [weakSelf gotoCutAndWipe:image];
    }];
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    //    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    //    if (width > kMaxResolution || height > kMaxResolution) {
    //        CGFloat ratio = width/height;
    //        if (ratio > 1) {
    //            bounds.size.width = kMaxResolution;
    //            bounds.size.height = roundf(bounds.size.width / ratio);
    //        }
    //        else {
    //            bounds.size.height = kMaxResolution;
    //            bounds.size.width = roundf(bounds.size.height * ratio);
    //        }
    //    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
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
    [[RC_SQLiteManager shareManager]addClothesToWardrobe:info];
    self.arrClothes = [[RC_SQLiteManager shareManager]getAllClothesFromWardrobe];
    [self.collectionView reloadData];
    
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (userInfo) {
        __weak WardrobeViewController *weakSelf = self;
        [[RC_RequestManager shareManager]addClothingWithColothesInfo:info success:^(id responseObject) {
            CLog(@"%@",responseObject);
            hideMBProgressHUD();
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                if ([[responseObject objectForKey:@"stat"]integerValue] == 10000) {
                    NSDictionary *dic = responseObject;
                    info.numClId = [NSNumber numberWithInt:[[dic objectForKey:@"clId"] intValue]];
                    [[RC_SQLiteManager shareManager]addClothesToWardrobe:info];
                    weakSelf.arrClothes = [[RC_SQLiteManager shareManager]getAllClothesFromWardrobe];
                    [weakSelf.collectionView reloadData];
                }
            }
        } andFailed:^(NSError *error) {
            CLog(@"%@",error);
            hideMBProgressHUD();
        }];
    }
    else
    {
        hideMBProgressHUD();
    }
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
