//
//  CollocationInfo.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/16.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "CollocationInfo.h"

@implementation CollocationInfo

- (void)dealloc
{
    self.numStyleId = nil;
    self.numOccId = nil;
    self.strDescription = nil;
    self.file = nil;
    self.dicList = nil;
}

@end
