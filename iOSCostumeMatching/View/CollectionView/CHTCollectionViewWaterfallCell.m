//
//  UICollectionViewWaterfallCell.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "CHTCollectionViewWaterfallCell.h"

@interface CHTCollectionViewWaterfallCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CHTCollectionViewWaterfallCell

-(void)dealloc
{
    [_imageView removeFromSuperview];
    _imageView = nil;
    _image = nil;
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    [_imageView setImage:image];
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _imageView = [[UIImageView alloc] init];
    // Scale with fill for contents when we resize.
    _imageView.contentMode = UIViewContentModeScaleAspectFill;

    // Scale the imageview to fit inside the contentView with the image centered:
    CGRect imageViewFrame = CGRectMake(0.f, 0.f, CGRectGetMaxX(self.contentView.bounds), CGRectGetMaxY(self.contentView.bounds));
    _imageView.frame = imageViewFrame;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
  }
  return self;
}

@end
