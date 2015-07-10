//
//  AppDelegate.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/3.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) YRSideViewController *sideViewController;
@property (strong, nonatomic) RC_NavigationController *navWardrobeController;
@property (strong, nonatomic) RC_NavigationController *navMatchingController;

@end

