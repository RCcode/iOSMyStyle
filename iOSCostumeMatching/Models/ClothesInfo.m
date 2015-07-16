//
//  ClothesInfo.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/16.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ClothesInfo.h"

@implementation ClothesInfo

- (void)dealloc
{
    self.numClId = nil;
    self.numCateId = nil;
    self.numScateId = nil;
    self.numSeaId = nil;
    self.strBrand = nil;
    self.file = nil;
    self.date = nil;
}

@end
