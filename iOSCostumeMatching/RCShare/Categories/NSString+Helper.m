//
//  NSString+Helper.m
//  IOSPhotoCollage
//
//  Created by herui on 25/7/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize{
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    CGRect returnRect = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil];
    return returnRect.size;
    
}

- (CGFloat)fontSizeFromFontName:(NSString *)fontName ToSize:(CGSize)toSize{

    CGFloat fontSize = 1;
    CGSize descStrSize = [self sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:fontSize]}];
    while (descStrSize.width < (toSize.width) && descStrSize.height < (toSize.height)) {
        fontSize += 0.1;
        descStrSize = [self sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:fontSize]}];
    }
    return fontSize - 0.1;
}

@end
