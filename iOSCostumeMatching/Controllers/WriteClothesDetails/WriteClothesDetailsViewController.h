//
//  WriteClothesDetailsViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/17.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"
#import "RC_LoginBaseViewController.h"

@interface WriteClothesDetailsViewController : RC_LoginBaseViewController

@property (nonatomic, strong) UIImage *image;

-(void)setFinishImageBlock:(void(^)(ClothesInfo *info))finishBlock;

@end
