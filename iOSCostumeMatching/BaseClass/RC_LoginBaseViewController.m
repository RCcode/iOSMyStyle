//
//  RC_LoginBaseViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/8/21.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_LoginBaseViewController.h"
#import "InstagramLoginViewController.h"
#import "FacebookManager.h"

@interface RC_LoginBaseViewController ()
{
    UserInfo *userInfo;
}
@end

@implementation RC_LoginBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loginView = [LoginView instanceLoginView];
    [loginView addTapRemove];
    [loginView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    loginView.backgroundColor = [colorWithHexString(@"#000000") colorWithAlphaComponent:0.25];
    __weak RC_LoginBaseViewController *weakSelf = self;
    [loginView setLoginInstagramBlock:^{
        [weakSelf loginInstagram];
    }];
    [loginView setLoginFacebookBlock:^{
        [weakSelf loginFaceBook];
    }];
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    [app.window addSubview:loginView];
    [loginView show:NO];
}

-(void)updateViewLoginSuccess{
    
}

-(void)saveUserInfo:(UserInfo *)_userInfo
{
    __weak RC_LoginBaseViewController *weakSelf = self;
    _userInfo.numPlat = [NSNumber numberWithShort:1];
    if (!_userInfo.strUid) {
        return;
    }
    
    [[RC_RequestManager shareManager]loginWith:_userInfo success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"stat"]integerValue] == 10000) {
                
                _userInfo.numId = [responseObject objectForKey:@"id"];
                [UserInfo archiverUserInfo:_userInfo];
                [[RC_SQLiteManager shareManager]addUser:_userInfo];
                
                [weakSelf updateViewLoginSuccess];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATEVIEW object:nil];
            }
        }
    } andFailed:^(NSError *error) {
        CLog(@"%@",error);
    }];
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

-(void)successLogin:(NSString *)code
{
    NSDictionary *params = @{@"client_id":INSTAGRAM_CLIENT_ID,
                             @"client_secret":INSTAGRAM_CLIENT_SECRET,
                             @"grant_type":@"authorization_code",
                             @"redirect_uri":INSTAGRAM_REDIRECT_URI,
                             @"code":code
                             };
    __weak RC_LoginBaseViewController *weakSelf = self;
    [[RC_RequestManager shareManager]getInstagramToken:params success:^(id responseObject) {
        CLog(@"%@",responseObject);
        [weakSelf getTokenSuccess:responseObject];
    } andFailed:^(NSError *error) {
        CLog(@"%@",error);
    }];
}

- (void)loginInstagram {
    InstagramLoginViewController *instagramLoginViewController = [[InstagramLoginViewController alloc]init];
    __weak RC_LoginBaseViewController *weakSelf = self;
    [instagramLoginViewController setSuccessLoginBlock:^(NSString *code) {
        [weakSelf successLogin:code];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:instagramLoginViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)loginFaceBook {
    __weak RC_LoginBaseViewController *weakSelf = self;
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
    __weak RC_LoginBaseViewController *weakSelf = self;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
