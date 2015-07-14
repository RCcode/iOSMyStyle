//
//  IS_MobAndAnalyticsManager.m
//  iOSNoCropVideo
//
//  Created by TCH on 14-8-14.
//  Copyright (c) 2014年 com.rcplatformhk. All rights reserved.
//

#import "IS_MobAndAnalyticsManager.h"

#import "MobClick.h"

@implementation IS_MobAndAnalyticsManager

static IS_MobAndAnalyticsManager *mobAndAnalyticsManager = nil;

+ (IS_MobAndAnalyticsManager *)shareInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        mobAndAnalyticsManager = [[IS_MobAndAnalyticsManager alloc]init];
    });
    return mobAndAnalyticsManager;
}

+ (void)event:(NSString *)eventID label:(NSString *)desc{
    
    //友盟
    [MobClick event:eventID label:desc];
    
//    //Flurry
//    [Flurry logEvent:eventID];
    
}

@end
