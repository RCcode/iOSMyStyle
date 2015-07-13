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

@interface WardrobeViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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
    
}

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
    
    //判断权限
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
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:cutAndWipeViewController];
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
