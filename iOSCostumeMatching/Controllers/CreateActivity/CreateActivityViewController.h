//
//  CreateActivityViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/21.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface CreateActivityViewController : RC_BaseViewController

@property (nonatomic) NSInteger type;
@property (nonatomic, strong) ActivityInfo *activityInfo;

-(void)setActivityFinishBlock:(void(^)(ActivityInfo *info))activityfinishBlock;
-(void)setDeleteBlock:(void(^)(ActivityInfo *info))deleteBlock;

@end
