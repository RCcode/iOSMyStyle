//
//  WriteCollectionDetailsViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/20.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"
#import "RC_LoginBaseViewController.h"

@interface WriteCollectionDetailsViewController : RC_LoginBaseViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray *arrList;
@property (nonatomic, strong) NSMutableArray *arrSticker;
@property (strong, nonatomic) UIView *createImageView;

-(void)setCollectionFinishBlock:(void(^)(CollocationInfo *info))collectionfinishBlock;

@end
