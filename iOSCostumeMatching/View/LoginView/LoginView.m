//
//  LoginView.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/8/6.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UIView *loginCenterView;


@property (nonatomic,copy) void(^loginInstagram)();
@property (nonatomic,copy) void(^loginFacebook)();

@end

@implementation LoginView

-(void)setLoginInstagramBlock:(void (^)())loginInstagramBlock
{
    _loginInstagram = loginInstagramBlock;
}

-(void)setLoginFacebookBlock:(void (^)())loginFacebookBlock
{
    _loginFacebook = loginFacebookBlock;
}

+ (id)instanceLoginView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(void)addTapRemove
{
    [_lblLogin setText:LocalizedString(@"Log_in_with", nil)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    self.userInteractionEnabled = YES;
    [tap addTarget:self action:@selector(close)];
    [self addGestureRecognizer:tap];
}

-(void)close
{
    self.hidden = YES;
}

-(void)show:(BOOL)show
{
    self.hidden = !show;
    if (show) {
        _loginCenterView.frame = CGRectMake((ScreenWidth-CGRectGetWidth(_loginCenterView.frame))/2.0, ScreenHeight, CGRectGetWidth(_loginCenterView.frame), CGRectGetHeight(_loginCenterView.frame));
        [UIView animateWithDuration:0.5 animations:^{
            _loginCenterView.frame = CGRectMake((ScreenWidth-CGRectGetWidth(_loginCenterView.frame))/2.0, (ScreenHeight-CGRectGetHeight(_loginCenterView.frame))/2, CGRectGetWidth(_loginCenterView.frame), CGRectGetHeight(_loginCenterView.frame));
            
        }];
    }
    else
    {
         _loginCenterView.frame = CGRectMake((ScreenWidth-CGRectGetWidth(_loginCenterView.frame))/2.0, (ScreenHeight-CGRectGetHeight(_loginCenterView.frame))/2, CGRectGetWidth(_loginCenterView.frame), CGRectGetHeight(_loginCenterView.frame));
        [UIView animateWithDuration:0.5 animations:^{
            _loginCenterView.frame = CGRectMake((ScreenWidth-CGRectGetWidth(_loginCenterView.frame))/2.0, ScreenHeight, CGRectGetWidth(_loginCenterView.frame), CGRectGetHeight(_loginCenterView.frame));
        }];
    }
}

- (IBAction)loginInstagram:(id)sender {
    if (_loginInstagram) {
        _loginInstagram();
    }
//    self.hidden = YES;
    [self show:NO];
}

- (IBAction)loginFacebook:(id)sender {
    if (_loginFacebook) {
        _loginFacebook();
    }
//    self.hidden = YES;
    [self show:NO];
}

@end
