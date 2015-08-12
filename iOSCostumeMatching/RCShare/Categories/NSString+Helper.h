//
//  NSString+Helper.h
//  IOSPhotoCollage
//
//  Created by herui on 25/7/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)

/**
 *  根据字体及限制宽高获取占用的实际size
 */
- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize;


/**
 *  给定字体名称及限定size，计算此size范围内可接受的最大fontSize
 */
- (CGFloat)fontSizeFromFontName:(NSString *)fontName ToSize:(CGSize)toSize;
@end
