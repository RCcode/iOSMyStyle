//
//  CMethods.h
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "Public.h"
//#include <stdio.h>

//用户当前的语言环境
#define CURR_LANG   ([[NSLocale preferredLanguages] objectAtIndex:0])

@interface CMethods : NSObject
{
    
}

//十六进制颜色值
UIColor* colorWithHexString(NSString *stringToConvert);
//当前应用的版本
NSString *appVersion();
//统一使用它做 应用本地化 操作
NSString *LocalizedString(NSString *translation_key, id none);
//获取设备型号
NSString *doDevicePlatform();

NSString *stringFromDate(NSDate *date);

void showLabelHUD(NSString *content);

UIImage *getViewImage(UIView *view);

MBProgressHUD * showMBProgressHUD(NSString *content,BOOL showView);
void hideMBProgressHUD();

NSString *getCategoryName(int index);

NSString *getWardrobeTypeName(WardrobeType type);
NSArray *getAllWardrobeType();

NSString *getWardrobeCategoryeName(WardrobeCategory type);
NSArray *getAllWardrobeCategorye(WardrobeType type);

NSString *getWardrobeSeasonName(WardrobeSeason type);
NSArray *getAllWardrobeSeason();

NSString *getCollocationStyleName(CollocationStyle type);
NSArray *getAllCollocationStyle();

NSString *getCollocationOccasionName(CollocationOccasion type);
NSArray *getCollocationOccasion();


@end
