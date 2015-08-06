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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    self.userInteractionEnabled = YES;
    [tap addTarget:self action:@selector(close)];
    [self addGestureRecognizer:tap];
}

-(void)close
{
    self.hidden = YES;
}

- (IBAction)loginInstagram:(id)sender {
    if (_loginInstagram) {
        _loginInstagram();
    }
    self.hidden = YES;
}

- (IBAction)loginFacebook:(id)sender {
    if (_loginFacebook) {
        _loginFacebook();
    }
    self.hidden = YES;
}

@end
