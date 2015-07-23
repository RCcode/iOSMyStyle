//
//  CollocationInfo.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/16.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "CollocationInfo.h"

@implementation CollocationInfo

- (void)dealloc
{
    self.numCoId = nil;
    self.numStyleId = nil;
    self.numOccId = nil;
    self.strDescription = nil;
    self.file = nil;
    self.dicList = nil;
    self.date = nil;
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.numCoId forKey:@"numCoId"];
    [encoder encodeObject:self.numStyleId forKey:@"numStyleId"];
    [encoder encodeObject:self.numOccId forKey:@"numOccId"];
    [encoder encodeObject:self.strDescription forKey:@"strDescription"];
    [encoder encodeObject:self.file forKey:@"file"];
    [encoder encodeObject:self.dicList forKey:@"dicList"];
    [encoder encodeObject:self.date forKey:@"date"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.numCoId = [decoder decodeObjectForKey:@"numCoId"];
        self.numStyleId = [decoder decodeObjectForKey:@"numStyleId"];
        self.numOccId = [decoder decodeObjectForKey:@"numOccId"];
        self.strDescription = [decoder decodeObjectForKey:@"strDescription"];
        self.file = [decoder decodeObjectForKey:@"file"];
        self.dicList = [decoder decodeObjectForKey:@"dicList"];
        self.date = [decoder decodeObjectForKey:@"date"];
    }
    return self;
}

@end
