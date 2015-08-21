//
//  LeftMenuViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/9.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "LeftMenuViewController.h"
//#import "InstagramLoginViewController.h"
#import "UIImageView+WebCache.h"
#import "FacebookManager.h"
#import "LoginView.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface LeftMenuViewController ()<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnWardrobe;
@property (weak, nonatomic) IBOutlet UIButton *btnMatching;
@property (weak, nonatomic) IBOutlet UIButton *btnCalendar;
@property (weak, nonatomic) IBOutlet UIButton *btnCollectionInspiration;
@property (weak, nonatomic) IBOutlet UIButton *btnMyLike;
@property (weak, nonatomic) IBOutlet UIButton *btnRate;
@property (weak, nonatomic) IBOutlet UIButton *btnFeedback;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;

@end

@implementation LeftMenuViewController

-(void)setLocalizableText
{
    [_btnWardrobe setTitle:LocalizedString(@"Closet", nil) forState:UIControlStateNormal];
    [_btnMatching setTitle:LocalizedString(@"Lookbook", nil) forState:UIControlStateNormal];
    [_btnCalendar setTitle:LocalizedString(@"Calendar", nil) forState:UIControlStateNormal];
    [_btnCollectionInspiration setTitle:LocalizedString(@"Inspiration", nil) forState:UIControlStateNormal];
    [_btnMyLike setTitle:LocalizedString(@"My_Likes", nil) forState:UIControlStateNormal];
    [_btnRate setTitle:LocalizedString(@"Rate_5_Star", nil) forState:UIControlStateNormal];
    [_btnFeedback setTitle:LocalizedString(@"Feedback", nil) forState:UIControlStateNormal];
    [_btnShare setTitle:LocalizedString(@"Share_this_app", nil) forState:UIControlStateNormal];
}

-(void)updateView{
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (userInfo) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.strPicURL]];
        [_btnLogin setTitle:LocalizedString(@"Logout", nil) forState:UIControlStateNormal];
    }
    else
    {
        [_btnLogin setTitle:LocalizedString(@"Login", nil) forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateView) name:NOTIFICATION_UPDATEVIEW object:nil];
    
    [self setLocalizableText];
    
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (userInfo) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.strPicURL]];
        [[RC_RequestManager shareManager]loginWith:userInfo success:^(id responseObject) {
            CLog(@"%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"stat"]integerValue] == 10000) {
                    userInfo.numId = [responseObject objectForKey:@"id"];
                    [UserInfo archiverUserInfo:userInfo];
                    [[RC_SQLiteManager shareManager]addUser:userInfo];
                }
            }
        } andFailed:^(NSError *error) {
            CLog(@"%@",error);
        }];
    }
    _headImageView.layer.cornerRadius = CGRectGetWidth(_headImageView.frame)/2;
    _headImageView.clipsToBounds = YES;
    
    [_scrollView addSubview:_actionView];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_actionView.frame), CGRectGetHeight(_actionView.frame));
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (userInfo) {
        [_btnLogin setTitle:LocalizedString(@"Logout", nil) forState:UIControlStateNormal];
    }
    else
    {
        [_btnLogin setTitle:LocalizedString(@"Login", nil) forState:UIControlStateNormal];
    }
}

-(void)updateViewLoginSuccess
{
    [super updateViewLoginSuccess];
    UserInfo *userIn = [UserInfo unarchiverUserData];
    [self.btnLogin setTitle:LocalizedString(@"Logout", nil) forState:UIControlStateNormal];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userIn.strPicURL]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UserInfo *userInfo = [UserInfo unarchiverUserData];
        NSInteger plat = [userInfo.numTplat integerValue];
        [UserInfo deleteArchieveData];
        userInfo = nil;
        if (plat == 1) {//in
            
        }
        else
        {
            [[FacebookManager shareManager]logOut];
        }
        [_btnLogin setTitle:LocalizedString(@"Login", nil) forState:UIControlStateNormal];
        [_headImageView setImage:[UIImage imageNamed:@"icon"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATEVIEW object:nil];
    }
}

- (IBAction)pressLogin:(id)sender {
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (userInfo) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@?",LocalizedString(@"Logout", nil)] message:nil delegate:self cancelButtonTitle:LocalizedString(@"No", nil) otherButtonTitles:LocalizedString(@"Yes", nil), nil];
        [alertView show];
    }
    else
    {
        [loginView show:YES];
    }
}

-(void)setAllBtnBackgroundColor
{
    _btnWardrobe.backgroundColor = [UIColor whiteColor];
    _btnMatching.backgroundColor = [UIColor whiteColor];
    _btnCalendar.backgroundColor = [UIColor whiteColor];
    _btnCollectionInspiration.backgroundColor = [UIColor whiteColor];
    _btnMyLike.backgroundColor = [UIColor whiteColor];
}

- (IBAction)pressWardrobe:(id)sender {
    [IS_MobAndAnalyticsManager event:@"Menu" label:@"menu_closet"];
    [self setAllBtnBackgroundColor];
    _btnWardrobe.backgroundColor = colorWithHexString(@"#f4f4f4");
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navWardrobeController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)pressMatching:(id)sender {
    [IS_MobAndAnalyticsManager event:@"Menu" label:@"menu_lookbook"];
    [self setAllBtnBackgroundColor];
    _btnMatching.backgroundColor = colorWithHexString(@"#f4f4f4");
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navMatchingController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)pressCalendar:(id)sender {
    [IS_MobAndAnalyticsManager event:@"Menu" label:@"menu_calendar"];
    [self setAllBtnBackgroundColor];
    _btnCalendar.backgroundColor = colorWithHexString(@"#f4f4f4");
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navCalendarController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)pressCollectionInspiration:(id)sender {
    [IS_MobAndAnalyticsManager event:@"Menu" label:@"menu_inspiration"];
    [self setAllBtnBackgroundColor];
    _btnCollectionInspiration.backgroundColor = colorWithHexString(@"#f4f4f4");
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navCollectionInspirationController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)pressLike:(id)sender {
    [IS_MobAndAnalyticsManager event:@"Menu" label:@"menu_likes"];
    
    if (![UserInfo unarchiverUserData]) {
        [self pressLogin:nil];
        return;
    }
    
    [self setAllBtnBackgroundColor];
    _btnMyLike.backgroundColor = colorWithHexString(@"#f4f4f4");
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navLikeController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)rate:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreScoreURL]];
}

- (IBAction)feedBack:(id)sender {
    // app名称 版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //设备型号 系统版本
    NSString *deviceName = doDevicePlatform();
    NSString *deviceSystemName = [[UIDevice currentDevice] systemName];
    NSString *deviceSystemVer = [[UIDevice currentDevice] systemVersion];
    
    //设备分辨率
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat resolutionW = [UIScreen mainScreen].bounds.size.width * scale;
    CGFloat resolutionH = [UIScreen mainScreen].bounds.size.height * scale;
    NSString *resolution = [NSString stringWithFormat:@"%.f * %.f", resolutionW, resolutionH];
    
    //本地语言
    NSString *language = [[NSLocale preferredLanguages] firstObject];
    
    //            NSString *diveceInfo = @"app版本号 手机型号 手机系统版本 分辨率 语言";
    NSString *diveceInfo = [NSString stringWithFormat:@"%@ %@, %@, %@ %@, %@, %@", app_Name, app_Version, deviceName, deviceSystemName, deviceSystemVer,  resolution, language];
    
    //直接发邮件
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    if(!picker) return;
    picker.mailComposeDelegate =self;
    NSString *subject = [NSString stringWithFormat:@"%@ %@ (iOS)",AppName, LocalizedString(@"feedback", nil)];
    [picker setSubject:subject];
    [picker setToRecipients:@[kFeedbackEmail]];
    [picker setMessageBody:diveceInfo isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)share:(id)sender {
    //需要分享的内容
    NSString *shareContent = LocalizedString(@"Share_app", nil);
    NSArray *activityItems = @[shareContent];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    __weak UIActivityViewController *blockActivityVC = activityVC;
    if ( [activityVC respondsToSelector:@selector(popoverPresentationController)] ) {
        // iOS8
        activityVC.popoverPresentationController.sourceView = _btnShare;
    }
    activityVC.completionHandler = ^(NSString *activityType,BOOL completed){
        [blockActivityVC dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:activityVC animated:YES completion:nil];
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
