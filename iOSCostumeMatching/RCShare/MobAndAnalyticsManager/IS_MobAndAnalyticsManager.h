//
//  IS_MobAndAnalyticsManager.h
//  iOSNoCropVideo
//
//  Created by TCH on 14-8-14.
//  Copyright (c) 2014年 com.rcplatformhk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IS_MobAndAnalyticsManager : NSObject

+ (IS_MobAndAnalyticsManager *)shareInstance;

/**
 *  全局公用统计分析方法
 */
+ (void)event:(NSString *)event label:(NSString *)label;

@end
