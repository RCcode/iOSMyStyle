//
//  ShowActivityViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/23.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface ShowActivityViewController : RC_BaseViewController

@property (nonatomic, strong) ActivityInfo *activityInfo;

-(void)setActivityFinishBlock:(void(^)(ActivityInfo *info,BOOL isNew))activityfinishBlock;
-(void)setDeleteBlock:(void(^)(ActivityInfo *info))deleteBlock;

@end
