//
//  ShowCollectionDetailsViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/20.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface ShowCollectionDetailsViewController : RC_BaseViewController

@property (nonatomic, strong) CollocationInfo *collocationInfo;

-(void)setDeleteBlock:(void(^)(CollocationInfo *info))deleteBlock;

@end
