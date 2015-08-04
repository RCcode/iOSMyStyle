//
//  PIDrawerView.h
//  PIImageDoodler
//
//  Created by Pavan Itagi on 07/03/14.
//  Copyright (c) 2014 Pavan Itagi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DrawingMode) {
    DrawingModeNone = 0,
    DrawingModePaint,
    DrawingModeErase,
};

@interface PIDrawerView : UIView
@property (nonatomic, readwrite) DrawingMode drawingMode;
@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic) CGFloat eraseWidth;

-(void)setMagnifyingGlassImageBlock:(void(^)(UIImage *image))magnifyingGlassImageBlock;
-(void)setEndMagnifyingGlassImageBlock:(void (^)())endMagnifyingGlassImageBlock;

-(void)undo;
-(void)redo;

@end
