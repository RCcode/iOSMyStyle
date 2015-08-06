//
//  InspirationCollectionViewCell.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/29.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "InspirationCollectionViewCell.h"

@implementation InspirationCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    _headImageView.layer.cornerRadius = CGRectGetWidth(_headImageView.frame)/2;
    _headImageView.clipsToBounds = YES;
}

@end
