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

@interface LeftMenuViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *actionView;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    // Do any additional setup after loading the view from its nib.
}

-(void)getTokenSuccess:(id)responseObject
{
    NSDictionary *dic = responseObject;
    UserInfo *userInfo = [[UserInfo alloc]init];
    userInfo.strToken = [dic objectForKey:@"access_token"];
    userInfo.strUid = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"user"] objectForKey:@"id"]];
    userInfo.strTname = [[dic objectForKey:@"user"]objectForKey:@"username"];
    userInfo.strPicURL = [[dic objectForKey:@"user"] objectForKey:@"profile_picture"];
    
    userInfo.numTplat = [NSNumber numberWithShort:1];
    userInfo.numPlat = [NSNumber numberWithShort:1];
    
    [UserInfo archiverUserInfo:userInfo];
    __weak LeftMenuViewController *weakSelf = self;
    [[RC_RequestManager shareManager]loginWith:userInfo success:^(id responseObject) {
        CLog(@"%@",responseObject);
//        [weakSelf loginServerSuccess:responseObject];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"stat"]integerValue] == 10000) {
                userInfo.numId = [responseObject objectForKey:@"id"];
                [UserInfo archiverUserInfo:userInfo];
                [[RC_SQLiteManager shareManager]addUser:userInfo];
                [weakSelf.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.strPicURL]];
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

- (IBAction)login:(id)sender {
    InstagramLoginViewController *instagramLoginViewController = [[InstagramLoginViewController alloc]init];
    __weak LeftMenuViewController *weakSelf = self;
    [instagramLoginViewController setSuccessLoginBlock:^(NSString *code) {
        [weakSelf successLogin:code];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:instagramLoginViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)loginFaceBook:(id)sender {
    __weak LeftMenuViewController *weakSelf = self;
    [[FacebookManager shareManager]loginSuccess:^{
        [weakSelf getFacebookUserInfo];
    } andFailed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)getFacebookUserInfo
{
    [[FacebookManager shareManager] getUserInfoSuccess:^(NSDictionary *userInfo) {
        NSLog(@"userInfo:%@",userInfo);
//        weakSelf.userInfo.facebookid = [userInfo objectForKey:@"id"];
//        weakSelf.userInfo.facebookname = [userInfo objectForKey:@"name"];
//        [[NSUserDefaults standardUserDefaults]setObject:[userInfo objectForKey:@"id"] forKey:@"facebookid"];
//        [[NSUserDefaults standardUserDefaults]setObject:[userInfo objectForKey:@"name"] forKey:@"facebookname"];
//        [weakSelf updateUserInfo];
    } andFailed:^(NSError *error) {
        
    }];
    [[FacebookManager shareManager] getCoverGraphPathSuccess:^(NSDictionary *dic) {
        NSLog(@"headurl:%@",dic);
//        weakSelf.userInfo.mainurl = [[dic objectForKey:@"cover"]objectForKey:@"source"];
//        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"cover"]objectForKey:@"source"] forKey:@"mainurl"];
//        [weakSelf updateUserInfo];
    } andFailed:^(NSError *error) {
        
    }];
    [[FacebookManager shareManager] getHeadPicturePathSuccess:^(NSDictionary *dic) {
        NSLog(@"headurl:%@",dic);
//        weakSelf.userInfo.headurl = [[[dic objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"];
//        [[NSUserDefaults standardUserDefaults]setObject:[[[dic objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"] forKey:@"headurl"];
//        [weakSelf updateUserInfo];
    } andFailed:^(NSError *error) {
        
    }];
}

- (IBAction)pressWardrobe:(id)sender {
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navWardrobeController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)pressMatching:(id)sender {
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navMatchingController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)pressCalendar:(id)sender {
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navCalendarController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)pressCollectionInspiration:(id)sender {
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navCollectionInspirationController;
    [sideViewController hideSideViewController:YES];
}

- (IBAction)pressLike:(id)sender {
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    sideViewController.rootViewController=delegate.navLikeController;
    [sideViewController hideSideViewController:YES];
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
