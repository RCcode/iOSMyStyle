//
//  CutViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/10.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface CutViewController : RC_BaseViewController

@property (nonatomic, strong) UIImage *originalImage;

-(void)setCroppedImageSuccessBlock:(void(^)(UIImage *image))croppedImageSuccessBlock;

@end
