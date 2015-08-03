//
//  AppDelegate.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/3.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftMenuViewController.h"
#import "WardrobeViewController.h"
#import "MatchingViewController.h"
#import "CalendarViewController.h"
#import "CollectionInspirationViewController.h"
#import "LikeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LeftMenuViewController *leftMenuViewController = [[LeftMenuViewController alloc]init];
    
    WardrobeViewController *wardrobeViewController = [[WardrobeViewController alloc]init];
    _navWardrobeController = [[RC_NavigationController alloc]initWithRootViewController:wardrobeViewController];
    
    MatchingViewController *matchingViewController = [[MatchingViewController alloc]init];
    _navMatchingController = [[RC_NavigationController alloc]initWithRootViewController:matchingViewController];
    
    CalendarViewController *calendarViewController = [[CalendarViewController alloc]init];
    _navCalendarController = [[RC_NavigationController alloc]initWithRootViewController:calendarViewController];
    
    CollectionInspirationViewController *collectionInspirationViewController = [[CollectionInspirationViewController alloc]init];
    _navCollectionInspirationController = [[RC_NavigationController alloc]initWithRootViewController:collectionInspirationViewController];
    
    LikeViewController *likeViewController = [[LikeViewController alloc]init];
    _navLikeController = [[RC_NavigationController alloc]initWithRootViewController:likeViewController];
    
    _sideViewController=[[YRSideViewController alloc]initWithNibName:nil bundle:nil];
    _sideViewController.rootViewController=_navWardrobeController;
    _sideViewController.leftViewController=leftMenuViewController;
    
    
    _sideViewController.leftViewShowWidth=200;
//    _sideViewController.needSwipeShowMenu=true;//默认开启的可滑动展示
    //动画效果可以被自己自定义，具体请看api
    
    [_sideViewController setRootViewMoveBlock:^(UIView *rootView, CGRect orginFrame, CGFloat xoffset) {
        //使用简单的平移动画
        rootView.frame=CGRectMake(xoffset, orginFrame.origin.y, orginFrame.size.width, orginFrame.size.height);
    }];
    
    self.window.rootViewController=_sideViewController;
    
    
    [self.window makeKeyAndVisible];

    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
