//
//  CollocationInfo.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/16.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollocationInfo : NSObject

/**
 styleId        风格id                            int		N
 occId          场合id                            int		N
 description	描述                              String	255	Y
 file           图片文件                           File		N
 list           搭配服饰信息列表(传brand不为空衣服)              N
 (
 clId	服饰id,可为空	int		Y
 cateId	一级分类id,所有为0	int		N
 scateId	一级分类id,所有为0	int		N
 seaId	季节id:0.所有; 1.春夏;2.秋冬	int		N
 brand	品牌	String	255	N
 )
 coId       搭配ID
 */

@property (nonatomic, copy) NSNumber *numCoId;
@property (nonatomic, copy) NSNumber *numStyleId;
@property (nonatomic, copy) NSNumber *numOccId;
@property (nonatomic, copy) NSString *strDescription;
@property (nonatomic, copy) UIImage *file;
@property (nonatomic, copy) NSMutableArray *arrList;
@property (nonatomic, copy) NSString *date;

@end
