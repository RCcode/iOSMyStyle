//
//  ClothesInfo.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/16.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClothesInfo : NSObject
/**
 cateId	    一级分类id,所有为0             int		N
 scateId	一级分类id,所有为0             int		N
 seaId      季节id:0.所有; 1.春夏;2.秋冬	int		N
 brand      品牌                         String	Y
 file       图片文件                      File	N
 clId       服饰id
 
 date       创建或修改日期
 localId    本地自增标识
 */

@property (nonatomic, copy) NSNumber *numClId;

@property (nonatomic, copy) NSNumber *numCateId;
@property (nonatomic, copy) NSNumber *numScateId;
@property (nonatomic, copy) NSNumber *numSeaId;
@property (nonatomic, copy) NSString *strBrand;
@property (nonatomic, copy) UIImage *file;

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSNumber *numLocalId;

@end
