//
//  LeftMenuViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/9.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "InstagramLoginViewController.h"
#import "UIImageView+WebCache.h"
#import "FacebookManager.h"
#import "LoginView.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface LeftMenuViewController ()<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
{
    LoginView *loginView;
    UserInfo *userInfo;
}
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLocalizableText];
    
    userInfo = [UserInfo unarchiverUserData];
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
    
    loginView = [LoginView instanceLoginView];
    [loginView addTapRemove];
    [loginView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    loginView.backgroundColor = [colorWithHexString(@"#000000") colorWithAlphaComponent:0.25];
    __weak LeftMenuViewController *weakSelf = self;
    [loginView setLoginInstagramBlock:^{
        [weakSelf loginInstagram];
    }];
    [loginView setLoginFacebookBlock:^{
        [weakSelf loginFaceBook];
    }];
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    [app.window addSubview:loginView];
//    loginView.hidden = YES;
    [loginView show:NO];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    userInfo = [UserInfo unarchiverUserData];
    if (userInfo) {
        [_btnLogin setTitle:LocalizedString(@"Logout", nil) forState:UIControlStateNormal];
    }
    else
    {
        [_btnLogin setTitle:LocalizedString(@"Login", nil) forState:UIControlStateNormal];
    }
}

-(void)getTokenSuccess:(id)responseObject
{
    NSDictionary *dic = responseObject;
    userInfo = [[UserInfo alloc]init];
    userInfo.strToken = [dic objectForKey:@"access_token"];
    userInfo.strUid = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"user"] objectForKey:@"id"]];
    userInfo.strTname = [[dic objectForKey:@"user"]objectForKey:@"username"];
    userInfo.strPicURL = [[dic objectForKey:@"user"] objectForKey:@"profile_picture"];
    userInfo.numTplat = [NSNumber numberWithShort:1];
    [self saveUserInfo:userInfo];
}

-(void)saveUserInfo:(UserInfo *)_userInfo
{
    [_btnLogin setTitle:LocalizedString(@"Logout", nil) forState:UIControlStateNormal];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.strPicURL]];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATEVIEW object:nil];
    
    _userInfo.numPlat = [NSNumber numberWithShort:1];
    [UserInfo archiverUserInfo:_userInfo];
//    __weak LeftMenuViewController *weakSelf = self;
    [[RC_RequestManager shareManager]loginWith:_userInfo success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"stat"]integerValue] == 10000) {
                _userInfo.numId = [responseObject objectForKey:@"id"];
                [UserInfo archiverUserInfo:userInfo];
                [[RC_SQLiteManager shareManager]addUser:userInfo];
            }
        }
    } andFailed:^(NSError *error) {
        CLog(@"%@",error);
    }];
}

/**
 *  成功登陆服务器
 *
 *  @param responseObject <#responseObject description#>
 */
-(void)loginServerSuccess:(id)responseObject
{
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if ([[responseObject objectForKey:@"stat"]integerValue] == 10000) {
            
        }
    }
}

-(void)successLogin:(NSString *)code
{
    NSDictionary *params = @{@"client_id":INSTAGRAM_CLIENT_ID,
                             @"client_secret":INSTAGRAM_CLIENT_SECRET,
                             @"grant_type":@"authorization_code",
                             @"redirect_uri":INSTAGRAM_REDIRECT_URI,
                             @"code":code
                             };
    __weak LeftMenuViewController *weakSelf = self;
    [[RC_RequestManager shareManager]getInstagramToken:params success:^(id responseObject) {
        CLog(@"%@",responseObject);
        [weakSelf getTokenSuccess:responseObject];
    } andFailed:^(NSError *error) {
        CLog(@"%@",error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSInteger plat = [userInfo.numTplat integerValue];
        [UserInfo deleteArchieveData];
        if (plat == 1) {//in
            
        }
        else
        {
            [[FacebookManager shareManager]logOut];
        }
        [_btnLogin setTitle:LocalizedString(@"Login", nil) forState:UIControlStateNormal];
        [_headImageView setImage:nil];
    }
}

- (IBAction)pressLogin:(id)sender {
    userInfo = [UserInfo unarchiverUserData];
    if (userInfo) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@?",LocalizedString(@"Logout", nil)] message:nil delegate:self cancelButtonTitle:LocalizedString(@"No", nil) otherButtonTitles:LocalizedString(@"Yes", nil), nil];
        [alertView show];
    }
    else
    {
//        loginView.hidden = NO;
        [loginView show:YES];
    }
}

- (void)loginInstagram {
    InstagramLoginViewController *instagramLoginViewController = [[InstagramLoginViewController alloc]init];
    __weak LeftMenuViewController *weakSelf = self;
    [instagramLoginViewController setSuccessLoginBlock:^(NSString *code) {
        [weakSelf successLogin:code];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:instagramLoginViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)loginFaceBook {
    __weak LeftMenuViewController *weakSelf = self;
    [[FacebookManager shareManager]loginSuccess:^(NSString *token) {
        userInfo = [[UserInfo alloc]init];
        userInfo.strToken = token;
        [weakSelf getFacebookUserInfo];
    } andFailed:^(NSError *error) {
         NSLog(@"%@",error);
    }];
}

-(void)getFacebookUserInfo
{
    __weak LeftMenuViewController *weakSelf = self;
    [[FacebookManager shareManager] getUserInfoSuccess:^(NSDictionary *_userInfo) {
        NSLog(@"userInfo:%@",_userInfo);
        userInfo.strUid = [_userInfo objectForKey:@"id"];
        userInfo.strTname = [_userInfo objectForKey:@"name"];
        userInfo.numTplat = [NSNumber numberWithShort:2];
        [weakSelf saveUserInfo:userInfo];
    } andFailed:^(NSError *error) {
        
    }];
    [[FacebookManager shareManager] getHeadPicturePathSuccess:^(NSDictionary *dic) {
        NSLog(@"headurl:%@",dic);
        userInfo.strPicURL = [[[dic objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"];
        userInfo.numTplat = [NSNumber numberWithShort:2];
        [weakSelf saveUserInfo:userInfo];
    } andFailed:^(NSError *error) {
        
    }];
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
    [self setAllBtnBackgroundColor];
    _btnWardrobe.backgroundColor = colorWithHexString(@"#f4f4f4");
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navWardrobeController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)pressMatching:(id)sender {
    [self setAllBtnBackgroundColor];
    _btnMatching.backgroundColor = colorWithHexString(@"#f4f4f4");
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navMatchingController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)pressCalendar:(id)sender {
    [self setAllBtnBackgroundColor];
    _btnCalendar.backgroundColor = colorWithHexString(@"#f4f4f4");
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navCalendarController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)pressCollectionInspiration:(id)sender {
    [self setAllBtnBackgroundColor];
    _btnCollectionInspiration.backgroundColor = colorWithHexString(@"#f4f4f4");
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navCollectionInspirationController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)pressLike:(id)sender {
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
