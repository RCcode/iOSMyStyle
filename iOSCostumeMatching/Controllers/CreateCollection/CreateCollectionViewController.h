//
//  CreateCollectionViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/20.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface CreateCollectionViewController : RC_BaseViewController

-(void)setCollectionFinishBlock:(void(^)(CollocationInfo *info))collectionfinishBlock;

@property (nonatomic,strong) ClothesInfo *addClothesInfo;

@end
