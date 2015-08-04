//
//  PIDrawerView.m
//  PIImageDoodler
//
//  Created by Pavan Itagi on 07/03/14.
//  Copyright (c) 2014 Pavan Itagi. All rights reserved.
//

#import "PIDrawerView.h"

@interface PIDrawerView ()
{
    CGPoint previousPoint;
    CGPoint currentPoint;
    NSMutableArray *undoArr;
    NSMutableArray *redoArr;
    BOOL isEnd;
}
@property (nonatomic, strong) UIImage * viewImage;

@property (nonatomic, copy) void(^magnifyingGlassImage)(UIImage *image);
@property (nonatomic, copy) void(^endMagnifyingGlassImage)();

@end

@implementation PIDrawerView

-(void)setMagnifyingGlassImageBlock:(void (^)(UIImage *))magnifyingGlassImageBlock
{
    _magnifyingGlassImage = magnifyingGlassImageBlock;
}

-(void)setEndMagnifyingGlassImageBlock:(void (^)())endMagnifyingGlassImageBlock
{
    _endMagnifyingGlassImage = endMagnifyingGlassImageBlock;
}

- (void)awakeFromNib
{
    [self initialize];
}

- (void)drawRect:(CGRect)rect
{
    [self.viewImage drawInRect:self.bounds];
}

#pragma mark - setter methods
- (void)setDrawingMode:(DrawingMode)drawingMode
{
    _drawingMode = drawingMode;
}

-(void)setOriginalImage:(UIImage *)originalImage
{
    _originalImage = originalImage;
    [self initialize];
    self.viewImage = _originalImage;
    [undoArr addObject:self.viewImage];
}

#pragma mark - Private methods
- (void)initialize
{
    currentPoint = CGPointMake(0, 0);
    previousPoint = currentPoint;
    
    _drawingMode = DrawingModeNone;
    
    _selectedColor = [UIColor blackColor];
    redoArr = [[NSMutableArray alloc]init];
    undoArr = [[NSMutableArray alloc]init];
    _eraseWidth = 10;
}

- (void)eraseLine
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _eraseWidth);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    
    if (isEnd) {
        [undoArr addObject:self.viewImage];
    }
    
    [self setNeedsDisplay];
}


- (void)drawLineNew
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor.CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}

-(void)drawImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    [self setNeedsDisplay];
}

- (void)handleTouches
{
    if (self.drawingMode == DrawingModeNone) {
        // do nothing
    }
    else if (self.drawingMode == DrawingModePaint) {
        [self drawLineNew];
    }
    else
    {
        [self eraseLine];
    }
}

#pragma mark - Touches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    previousPoint = p;
    isEnd = NO;
    if (redoArr.count>0) {
        UIImage *image = [redoArr objectAtIndex:0];
        [redoArr removeAllObjects];
        [undoArr addObject:image];
    }
    if (_magnifyingGlassImage) {
        _magnifyingGlassImage([self getImageInPoint:p]);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
    
    [self handleTouches];
    if (_magnifyingGlassImage) {
        _magnifyingGlassImage([self getImageInPoint:currentPoint]);
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
    isEnd = YES;
    [self handleTouches];
    if (_endMagnifyingGlassImage) {
        _endMagnifyingGlassImage();
    }
}

-(UIImage *)getImageInPoint:(CGPoint)point{
    UIImage* bigImage= _originalImage;
    CGFloat x = point.x * bigImage.size.width/self.frame.size.width -35;
    CGFloat y = point.y * bigImage.size.height/self.frame.size.height -35;
    CGRect rect = CGRectMake(x, y, 70, 70);
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    CGSize size;
    size.width = 70;
    size.height = 70;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}

-(void)redo
{
    if (redoArr.count>0) {
        if (undoArr.count == 0) {
            UIImage *image = [redoArr objectAtIndex:0];
            [redoArr removeObject:image];
            [undoArr addObject:image];
        }
        UIImage *image = [redoArr objectAtIndex:0];
        self.viewImage = image;
        [redoArr removeObject:image];
        [undoArr addObject:image];
        [self drawImage];
    }
}

-(void)undo
{
    if (undoArr.count>0) {
        if(redoArr.count == 0)
        {
            UIImage *image = [undoArr lastObject];
            [undoArr removeObject:image];
            [redoArr insertObject:image atIndex:0];
        }
        UIImage *image = [undoArr lastObject];
        self.viewImage = image;
        [undoArr removeObject:image];
        [redoArr insertObject:image atIndex:0];
        [self drawImage];
    }
}

-(BOOL)canUnDo
{
    return undoArr.count>1;
}

-(BOOL)canReDo
{
    return redoArr.count>0;
}

@end
