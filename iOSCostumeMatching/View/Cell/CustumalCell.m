//
//  CustumalCell.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/8/7.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "CustumalCell.h"

@implementation CustumalCell

- (void)awakeFromNib {
    // Initialization code
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = colorWithHexString(@"#f4f4f4");
    self.selectedBackgroundView = v;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
