//
//  InstagramLoginViewController.m
//  Instagram
//
//  Created by TCH on 15/5/25.
//  Copyright (c) 2015年 zhao liang. All rights reserved.
//

#import "InstagramLoginViewController.h"
#import "CMethods.h"

@interface InstagramLoginViewController ()<UIWebViewDelegate>
{
    UIActivityIndicatorView *indicatorView;
}
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) void (^successLogin)(NSString *code);

@end

@implementation InstagramLoginViewController

-(void)setSuccessLoginBlock:(void (^)(NSString *))successLoginBlock
{
    _successLogin = successLoginBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [_webView stopLoading];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"Log in"];
    self.showReturn = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    
    indicatorView = [[UIActivityIndicatorView alloc]init];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [indicatorView setFrame:CGRectMake(ScreenWidth-NavBarHeight, 0, NavBarHeight, NavBarHeight)];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    self.webView.delegate = self;
    
//    NSString *ownBaseUrl = [NSString stringWithFormat:@"ig%@://authorize", INSTAGRAM_CLIENT_ID];
//    
//    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   INSTAGRAM_CLIENT_ID, @"client_id",
//                                   @"code", @"response_type",//token
//                                   ownBaseUrl, @"redirect_uri",
//                                   nil];
//    
//    NSArray *scopes = [NSArray arrayWithObjects:@"relationships",@"likes", nil];
//    if (scopes!= nil) {
//        NSString* scope = [scopes componentsJoinedByString:@"+"];
//        [params setValue:scope forKey:@"scope"];
//    }
//
//    NSString *igAppUrl = [NSString stringWithFormat:@"https://instagram.com/oauth/authorize?client_id=%@&scope=relationships+likes&redirect_uri=%@&response_type=code",INSTAGRAM_CLIENT_ID,ownBaseUrl];
//    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString: igAppUrl]];
    
    NSString *loginUrl = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code&scope=likes+relationships",INSTAGRAM_CLIENT_ID,INSTAGRAM_WEBSITE_URL];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString: loginUrl]];
    
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:indicatorView];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    if ([request.URL.absoluteString rangeOfString:@"code="].length >0) {
        NSString *codeStr = [[request.URL.absoluteString componentsSeparatedByString:@"code="]lastObject];
        CLog(@"%@",request.URL.absoluteString);
        CLog(@"%@",codeStr);
        __weak InstagramLoginViewController *weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.successLogin) {
                weakSelf.successLogin(codeStr);
            }
        }];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [indicatorView stopAnimating];
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
