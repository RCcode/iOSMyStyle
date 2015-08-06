//
//  RC_BaseViewController.h
//  iOSIdeagram
//
//  Created by TCH on 15/3/18.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RC_BaseViewController : UIViewController

@property (nonatomic) BOOL showReturn;
@property (nonatomic) BOOL showDone;
@property (nonatomic) BOOL enableReturn;
@property (nonatomic) BOOL enableDone;

-(void)setNavTitle:(NSString *)navTitle;
-(void)setNavTitleColor:(UIColor *)color;
-(void)setReturnBtnNormalImage:(UIImage *)normalImage andHighlightedImage:(UIImage *)highlightedImage;
-(void)setDoneBtnNormalImage:(UIImage *)normalImage andHighlightedImage:(UIImage *)highlightedImage;
-(void)setReturnBtnTitle:(NSString *)title;
-(void)setDoneBtnTitle:(NSString *)title;
-(void)setReturnBtnTitleColor:(UIColor *)color;
-(void)setDoneBtnTitleColor:(UIColor *)color;

-(void)returnBtnPressed:(id)sender;
-(void)doneBtnPressed:(id)sender;


@end
