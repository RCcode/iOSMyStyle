//
//  ShowClothesDetailsViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/17.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface ShowClothesDetailsViewController : RC_BaseViewController

@property (nonatomic, strong) ClothesInfo *clothesInfo;

-(void)setDeleteBlock:(void(^)(ClothesInfo *info))deleteBlock;

@end
