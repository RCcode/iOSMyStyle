//
//  WriteCollectionDetailsViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/20.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface WriteCollectionDetailsViewController : RC_BaseViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray *arrList;

-(void)setCollectionFinishBlock:(void(^)(CollocationInfo *info))collectionfinishBlock;

@end
