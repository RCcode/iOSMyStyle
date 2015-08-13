//
//  ColorCell.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/8/5.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ColorCell.h"

@implementation ColorCell

- (void)awakeFromNib {
    // Initialization code
    _colorView.layer.cornerRadius = CGRectGetWidth(_colorView.frame)/2;
    _colorView.clipsToBounds = YES;
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = colorWithHexString(@"#f4f4f4");
    self.selectedBackgroundView = v;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
