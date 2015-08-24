//
//  MZCroppableView.m
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import "RCDrawerView.h"
#import "UIBezierPath-Points.h"
#import "UIImage+SubImage.h"

@interface RCDrawerView ()
{
    NSMutableArray *undoArr;
    NSMutableArray *redoArr;
    UIImage *originalImage;
}

@property (nonatomic, copy) void(^magnifyingGlassImage)(UIImage *image);
@property (nonatomic, copy) void(^endMagnifyingGlassImage)();

@end

@implementation RCDrawerView

-(void)setMagnifyingGlassImageBlock:(void (^)(UIImage *))magnifyingGlassImageBlock
{
    _magnifyingGlassImage = magnifyingGlassImageBlock;
}

-(void)setEndMagnifyingGlassImageBlock:(void (^)())endMagnifyingGlassImageBlock
{
    _endMagnifyingGlassImage = endMagnifyingGlassImageBlock;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithImageView:(UIImageView *)imageView
{
    self = [super initWithFrame:imageView.frame];
    if (self) {
        self.lineWidth = 1.0f;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        self.lineColor = [UIColor whiteColor];
        
        redoArr = [[NSMutableArray alloc]init];
        undoArr = [[NSMutableArray alloc]init];
        
        originalImage = [imageView.image copy];
        
//        self.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.2];
    }
    return self;
}
#pragma mark - My Methods -
+ (CGRect)scaleRespectAspectFromRect1:(CGRect)rect1 toRect2:(CGRect)rect2
{
    CGSize scaledSize = rect2.size;
    
    float scaleFactor = 1.0;
    
    CGFloat widthFactor  = rect2.size.width / rect1.size.width;
    CGFloat heightFactor = rect2.size.height / rect1.size.width;
    
    if (widthFactor < heightFactor)
        scaleFactor = widthFactor;
    else
        scaleFactor = heightFactor;
    
    scaledSize.height = rect1.size.height *scaleFactor;
    scaledSize.width  = rect1.size.width  *scaleFactor;
    
    if (scaledSize.height > rect2.size.height) {
        scaledSize.height = rect2.size.height;
        scaledSize.width = rect1.size.width/rect1.size.height*scaledSize.height;
    }
    else if(scaledSize.width > rect2.size.width)
    {
        scaledSize.width = rect2.size.width;
        scaledSize.height = rect1.size.height/rect1.size.width*scaledSize.width;
    }
    float y = (rect2.size.height - scaledSize.height)/2;
    float x = (rect2.size.width - scaledSize.width)/2;
    
    return CGRectMake(x, y, scaledSize.width, scaledSize.height);
}
+ (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    point1.y = rect1.height - point1.y;
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}
+ (CGPoint)convertPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    [self.lineColor setStroke];
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.lineColor.CGColor);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10);
    for (int i = 0; i<undoArr.count; i++) {
        NSDictionary *dic = [undoArr objectAtIndex:i];
        CGPoint point = [[dic objectForKey:@"Points"] CGPointValue];
        if ([[dic objectForKey:@"isBegin"] boolValue]) {
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), [[dic objectForKey:@"LineWidth"] floatValue]);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
        }
        else
        {
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
        }
    }
    CGContextStrokePath(UIGraphicsGetCurrentContext());
}

-(UIImage *)finishErase
{
    if(undoArr.count == 0)
    {
        return originalImage;
    }
    CGRect rect = CGRectZero;
    rect.size = originalImage.size;
    
    CGFloat scale = rect.size.width/self.frame.size.width;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        [originalImage drawAtPoint:CGPointZero];
        
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);

        
        for (int i = 0; i<undoArr.count; i++) {
            NSDictionary *dic = [undoArr objectAtIndex:i];
            CGPoint point = [[dic objectForKey:@"Points"] CGPointValue];
            CGPoint p = CGPointMake((point.x*rect.size.width)/self.frame.size.width, (point.y*rect.size.height)/self.frame.size.height);
            if ([[dic objectForKey:@"isBegin"] boolValue]) {
                CGContextStrokePath(UIGraphicsGetCurrentContext());
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), [[dic objectForKey:@"LineWidth"] floatValue]*scale);
                CGContextMoveToPoint(UIGraphicsGetCurrentContext(), p.x, p.y);
            }
            else
            {
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), p.x, p.y);
            }
        }
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    }
    
    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return mask;
}

#pragma mark - Touch Methods -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [redoArr removeAllObjects];
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    CGPoint point = [mytouch locationInView:self];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:point],@"Points",[NSNumber numberWithBool:YES],@"isBegin",[NSNumber numberWithFloat:_lineWidth],@"LineWidth", nil];
    [undoArr addObject:dic];
    
    if (_magnifyingGlassImage) {
        _magnifyingGlassImage([self getImageInPoint:point]);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    CGPoint point = [mytouch locationInView:self];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:point],@"Points",[NSNumber numberWithBool:NO],@"isBegin", nil];
    [undoArr addObject:dic];
    
    [self setNeedsDisplay];
    if (_magnifyingGlassImage) {
        _magnifyingGlassImage([self getImageInPoint:point]);
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_endMagnifyingGlassImage) {
        _endMagnifyingGlassImage();
    }
}

-(UIImage *)getImageInPoint:(CGPoint)point{
    UIImage* bigImage= originalImage;
    CGFloat x = point.x * bigImage.size.width/self.frame.size.width -35;
    CGFloat y = point.y * bigImage.size.height/self.frame.size.height -35;
    CGRect rect = CGRectMake(x, y, 70, 70);
    UIImage *image = [bigImage subImageWithRect:rect];
    return image;
}

-(void)unDo
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=((int)undoArr.count-1); i>0; i--) {
        NSDictionary *dic = [undoArr objectAtIndex:i];
        [arr insertObject:dic atIndex:0];
        if ([[dic objectForKey:@"isBegin"] boolValue]) {
            break;
        }
    }
    [undoArr removeObjectsInArray:arr];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[arr count])];
    [redoArr insertObjects:arr atIndexes:indexSet];
    
    [self setNeedsDisplay];
}
-(void)reDo
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (redoArr.count>0) {
        NSDictionary *dic = [redoArr objectAtIndex:0];
        [arr addObject:dic];
    }
    for (int i=1; i<redoArr.count; i++) {
        NSDictionary *dic = [redoArr objectAtIndex:i];
        if ([[dic objectForKey:@"isBegin"] boolValue]) {
            break;
        }
        [arr addObject:dic];
    }
    [undoArr addObjectsFromArray:arr];
    [redoArr removeObjectsInArray:arr];
    
    [self setNeedsDisplay];
}

-(BOOL)canUnDo
{
    return undoArr.count>0;
}

-(BOOL)canReDo
{
    return redoArr.count>0;
}

@end
