//
//  RC_LoginBaseViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/8/21.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"
#import "LoginView.h"

@interface RC_LoginBaseViewController : RC_BaseViewController
{
    LoginView *loginView;
}

-(void)updateViewLoginSuccess;

@end
