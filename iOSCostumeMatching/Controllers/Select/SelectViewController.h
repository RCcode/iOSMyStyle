//
//  SelectViewController.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/28.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_BaseViewController.h"

@interface SelectViewController : RC_BaseViewController

@property (nonatomic) NSInteger type; //type = 1 选择颜色
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSString *navagationTitle;
@property (nonatomic, strong) NSString *selectCellTitle;

-(void)setSelectedBlock:(void(^)(int index))selectedBlock;

@end
