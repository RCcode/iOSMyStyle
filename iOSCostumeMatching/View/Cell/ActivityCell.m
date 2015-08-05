//
//  ActivityCell.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/23.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ActivityCell.h"

@interface ActivityCell ()

@end

@implementation ActivityCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = colorWithHexString(@"#eeeeee");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
