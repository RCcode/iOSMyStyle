//
//  ItemView.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/22.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_View.h"

@interface ItemView : RC_View

@property (nonatomic,strong) id info;

-(void)setDeleteBlock:(void(^)(id info,id item))deleteBlock;

@end
