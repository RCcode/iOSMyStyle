//
//  MyWardrobeViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/22.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface MyWardrobeViewController : RC_BaseViewController

-(void)setSelectBlock:(void(^)(ClothesInfo *info))selectBlock;

@end
