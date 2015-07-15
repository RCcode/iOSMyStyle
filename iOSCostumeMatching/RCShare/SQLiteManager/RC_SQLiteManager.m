//
//  RC_SQLiteManager.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/14.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_SQLiteManager.h"

@implementation RC_SQLiteManager

static RC_SQLiteManager *sqliteManager = nil;

+ (RC_SQLiteManager *)shareManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sqliteManager = [[RC_SQLiteManager alloc]init];
    });
    return sqliteManager;
}

@end
