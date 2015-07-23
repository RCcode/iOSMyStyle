//
//  CreateActivityViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/21.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface CreateActivityViewController : RC_BaseViewController

-(void)setActivityFinishBlock:(void(^)(ActivityInfo *info))activityfinishBlock;

@end
