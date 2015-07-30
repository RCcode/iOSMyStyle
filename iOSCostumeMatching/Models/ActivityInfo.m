//
//  ActivityInfo.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/22.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ActivityInfo.h"

@implementation ActivityInfo

- (void)dealloc
{
    self.numId = nil;
    self.numColor = nil;
    self.numIsAllDay = nil;
    self.numDay = nil;
    self.strLocation = nil;
    self.numMonth = nil;
    self.strTitle = nil;
    self.numYear = nil;
    self.dateFinishTime = nil;
    self.dateFirstRemindTime = nil;
    self.dateSecondRemindTime = nil;
    self.dateStartTime = nil;
    self.arrData = nil;
}

@end
