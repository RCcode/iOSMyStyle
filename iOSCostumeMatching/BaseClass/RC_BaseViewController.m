//
//  RC_BaseViewController.m
//  iOSIdeagram
//
//  Created by TCH on 15/3/18.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface RC_BaseViewController ()
{
    UIButton *btnReturn;
    UIButton *btnDone;
    UILabel *titleLabel;
}
@end

@implementation RC_BaseViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight+1)];
//    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = colorWithHexString(@"#222222");
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = titleLabel;
    
    btnReturn = [[UIButton alloc]init];
    btnReturn.frame=CGRectMake(0, 0, 44, 44);
    [btnReturn addTarget:self action:@selector(returnBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnReturn.hidden = YES;
    
    btnDone = [[UIButton alloc]init];
    btnDone.frame = CGRectMake(ScreenWidth-NavBarHeight-5, 0, NavBarHeight, NavBarHeight);
    [btnDone.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnDone addTarget:self action:@selector(doneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnDone.hidden = YES;
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:titleLabel];
    [self.navigationController.navigationBar addSubview:btnReturn];
    [self.navigationController.navigationBar addSubview:btnDone];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [titleLabel removeFromSuperview];
    [btnReturn removeFromSuperview];
    [btnDone removeFromSuperview];
}

-(void)setNavTitle:(NSString *)navTitle
{
    titleLabel.text = navTitle;
}

-(void)setNavTitleColor:(UIColor *)color
{
    [titleLabel setTextColor:color];
}

-(void)setShowDone:(BOOL)showDone
{
    _showDone = showDone;
    btnDone.hidden = !showDone;
}

-(void)setShowReturn:(BOOL)showReturn
{
    _showReturn = showReturn;
    btnReturn.hidden = !showReturn;
}

-(void)setEnableReturn:(BOOL)enableReturn
{
    _enableReturn = enableReturn;
    btnReturn.enabled = enableReturn;
}

-(void)setEnableDone:(BOOL)enableDone
{
    _enableDone = enableDone;
    btnDone.enabled = enableDone;
}

-(void)setReturnBtnNormalImage:(UIImage *)normalImage andHighlightedImage:(UIImage *)highlightedImage
{
    if (normalImage) {
        [btnReturn setImage:normalImage forState:UIControlStateNormal];
    }
    if (highlightedImage) {
        [btnReturn setImage:highlightedImage forState:UIControlStateHighlighted];
    }
}

-(void)setDoneBtnNormalImage:(UIImage *)normalImage andHighlightedImage:(UIImage *)highlightedImage
{
    if (normalImage) {
        [btnDone setImage:normalImage forState:UIControlStateNormal];
    }
    if (highlightedImage) {
        [btnDone setImage:highlightedImage forState:UIControlStateHighlighted];
    }
}

-(void)setReturnBtnTitle:(NSString *)title
{
    [btnReturn setTitle:title forState:UIControlStateNormal];
}

-(void)setDoneBtnTitle:(NSString *)title
{
    [btnDone setTitle:title forState:UIControlStateNormal];
}

-(void)setReturnBtnTitleColor:(UIColor *)color
{
    [btnReturn setTintColor:color];
}

-(void)setDoneBtnTitleColor:(UIColor *)color
{
    [btnDone setTitleColor:color forState:UIControlStateNormal];
}

-(void)setNavBarColor:(UIColor *)color
{
    [titleLabel setBackgroundColor:color];
}

-(void)returnBtnPressed:(id)sender
{
}

-(void)doneBtnPressed:(id)sender
{
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
