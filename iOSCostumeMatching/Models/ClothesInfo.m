//
//  ClothesInfo.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/16.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ClothesInfo.h"

@implementation ClothesInfo

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.numClId forKey:@"numClId"];
    [encoder encodeObject:self.numCateId forKey:@"numCateId"];
    [encoder encodeObject:self.numScateId forKey:@"numScateId"];
    [encoder encodeObject:self.numSeaId forKey:@"numSeaId"];
    [encoder encodeObject:self.strBrand forKey:@"strBrand"];
    [encoder encodeObject:self.file forKey:@"file"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.numLocalId forKey:@"numLocalId"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.numClId = [decoder decodeObjectForKey:@"numClId"];
        self.numCateId = [decoder decodeObjectForKey:@"numCateId"];
        self.numScateId = [decoder decodeObjectForKey:@"numScateId"];
        self.numSeaId = [decoder decodeObjectForKey:@"numSeaId"];
        self.strBrand = [decoder decodeObjectForKey:@"strBrand"];
        self.file = [decoder decodeObjectForKey:@"file"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.numLocalId = [decoder decodeObjectForKey:@"numLocalId"];
    }
    return self;
}

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
