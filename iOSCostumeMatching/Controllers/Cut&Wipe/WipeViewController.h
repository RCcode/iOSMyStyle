//
//  WipeViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/10.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface WipeViewController : RC_BaseViewController

@property (nonatomic, strong) UIImage *originalImage;

-(void)setWipeImageSuccessBlock:(void(^)(UIImage *image))wipeImageSuccessBlock;

@end
