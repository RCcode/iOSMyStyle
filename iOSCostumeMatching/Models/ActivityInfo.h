//
//  ActivityInfo.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/22.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityInfo : NSObject

/**
 title           标题
 location        位置
 isAllDay        全天
 startTime       开始时间
 finishTime      结束时间
 firstRemindTime     第一次提醒时间
 secondRemindTime    第二次提醒时间
 color           颜色
 arrData        衣服或搭配数组
 year            年
 month           月
 day             日
 
 id              活动标识
 */

@property (nonatomic, copy) NSNumber *numId;
@property (nonatomic, copy) NSString *strTitle;
@property (nonatomic, copy) NSString *strLocation;
@property (nonatomic, copy) NSNumber *numIsAllDay;
@property (nonatomic, copy) NSDate *dateStartTime;
@property (nonatomic, copy) NSDate *dateFinishTime;
@property (nonatomic, copy) NSNumber *firstRemindTime;
@property (nonatomic, copy) NSNumber *secondRemindTime;
@property (nonatomic, copy) NSNumber *numColor;
@property (nonatomic, copy) NSArray *arrData;
@property (nonatomic, copy) NSNumber *numYear;
@property (nonatomic, copy) NSNumber *numMonth;
@property (nonatomic, copy) NSNumber *numDay;

@end
