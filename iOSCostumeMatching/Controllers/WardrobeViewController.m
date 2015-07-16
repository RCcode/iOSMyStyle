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
#import "ZBFlowView.h"
#import "ZBWaterView.h"
#import "RC_SQLiteManager.h"

@interface WardrobeViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBWaterViewDatasource,ZBWaterViewDelegate>
{
    ZBWaterView *_waterView;
}

@property (nonatomic, strong) NSMutableArray *arrClothes;

@end

@implementation WardrobeViewController

-(void)returnBtnPressed:(id)sender
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"我的衣橱"];
    self.showReturn = YES;
    [self setReturnBtnTitle:@"菜单"];
    
     self.arrClothes = [[RC_SQLiteManager shareManager]getAllClothesFromWardrobe];
    
    _waterView = [[ZBWaterView alloc]  initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64)];
    _waterView.waterDataSource = self;
    _waterView.waterDelegate = self;
    _waterView.isDataEnd = NO;
    [self.view insertSubview:_waterView atIndex:0];
    
    [_waterView reloadData];
}

#pragma mark - ZBWaterViewDatasource
- (NSInteger)numberOfFlowViewInWaterView:(ZBWaterView *)waterView
{
    return [_arrClothes count];
}

- (CustomWaterInfo *)infoOfWaterView:(ZBWaterView*)waterView
{
    CustomWaterInfo *info = [[CustomWaterInfo alloc] init];
    info.topMargin = 0;
    info.leftMargin = 10;
    info.bottomMargin = 0;
    info.rightMargin = 10;
    info.horizonPadding = 5;
    info.veticalPadding = 5;
    info.numOfColumn = 2;
    return info;
}

- (ZBFlowView *)waterView:(ZBWaterView *)waterView flowViewAtIndex:(NSInteger)index
{
    ClothesInfo *info = [_arrClothes objectAtIndex:index];
    ZBFlowView *flowView = [waterView dequeueReusableCellWithIdentifier:@"cell"];
    if (flowView == nil) {
        flowView = [[ZBFlowView alloc] initWithFrame:CGRectZero];
        flowView.reuseIdentifier = @"cell";
    }
    flowView.index = index;
    flowView.image = info.file;
    flowView.backgroundColor = [UIColor redColor];
    return flowView;
}

- (CGFloat)waterView:(ZBWaterView *)waterView heightOfFlowViewAtIndex:(NSInteger)index
{
    ClothesInfo *info = [_arrClothes objectAtIndex:index];
    CGFloat width = info.file.size.width;
    CGFloat height = info.file.size.height;
    CGFloat viewHeight = (ScreenWidth/(2.0*width))*height;
    return viewHeight;
}

#pragma mark - ZBWaterViewDelegate
- (void)needLoadMoreByWaterView:(ZBWaterView *)waterView;
{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [NSThread sleepForTimeInterval:2.0];
//        for (int i=0; i<20; i++) {
//            TestData *data = [[TestData alloc] init];
//            data.color = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
//            data.height = arc4random()%300;
//            [_testDataArr addObject:data];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_waterView endLoadMore];
//            [_waterView reloadData];
//        });
//    });
}

- (void)phoneWaterViewDidScroll:(ZBWaterView *)waterView
{
    //do what you want to do
    return;
}

- (void)waterView:(ZBWaterView *)waterView didSelectAtIndex:(NSInteger)index
{
//    NSLog(@"didSelectAtIndex%d",index);
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
    [cutAndWipeViewController setFinishImageBlock:^(UIImage *image) {
        [weakSelf addClothesToWardrobe:image];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:cutAndWipeViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)addClothesToWardrobe:(UIImage *)image
{
    ClothesInfo *clothesInfo = [[ClothesInfo alloc]init];
    clothesInfo.numClId = [NSNumber numberWithInt:(int)(_arrClothes.count+1)];
    clothesInfo.numCateId = [NSNumber numberWithInt:0];
    clothesInfo.numScateId = [NSNumber numberWithInt:0];
    clothesInfo.numSeaId = [NSNumber numberWithInt:0];
    clothesInfo.strBrand = @"hhhh";
    clothesInfo.file = image;
    clothesInfo.date = stringFromDate([NSDate date]);
    [[RC_SQLiteManager shareManager]addClothesToWardrobe:clothesInfo];
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
