//
//  ShowCollectionInspirationDetailsViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/23.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface ShowCollectionInspirationDetailsViewController : RC_BaseViewController

@property (nonatomic) int coId;

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic) BOOL isLiked;

-(void)setDicChangeBlock:(void(^)())dicChangeBlock;

@end
