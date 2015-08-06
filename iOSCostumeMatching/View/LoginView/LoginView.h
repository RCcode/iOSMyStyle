//
//  LoginView.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/8/6.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_View.h"

@interface LoginView : RC_View

+ (id)instanceLoginView;
-(void)addTapRemove;

-(void)setLoginInstagramBlock:(void(^)())loginInstagramBlock;
-(void)setLoginFacebookBlock:(void(^)())loginFacebookBlock;

@end
