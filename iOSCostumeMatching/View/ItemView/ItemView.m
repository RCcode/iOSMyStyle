//
//  ItemView.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/22.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ItemView.h"

#define DELETEBUTTONWIDTH 50

@interface ItemView ()
{
    UIImageView *imageView;
    UIButton *deleteButton;
}

@property (nonatomic, copy) void(^delete)(id info,id item);

@end

@implementation ItemView

-(void)setInfo:(id)info
{
    _info = info;
    if ([info isKindOfClass:[ClothesInfo class]]) {
        ClothesInfo *_data = info;
        [imageView setImage:_data.file];
    }
    else
    {
        CollocationInfo *_data = info;
        [imageView setImage:_data.file];
    }
}

-(void)setDeleteBlock:(void (^)(id info,id item))deleteBlock
{
    _delete = deleteBlock;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setFrame:self.bounds];
        [self addSubview:imageView];
        deleteButton = [[UIButton alloc]init];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"ball"] forState:UIControlStateNormal];
        [deleteButton setFrame:CGRectMake(CGRectGetWidth(frame)-DELETEBUTTONWIDTH, 0, DELETEBUTTONWIDTH, DELETEBUTTONWIDTH)];
        [deleteButton addTarget:self action:@selector(pressDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
    }
    return self;
}

-(void)pressDelete:(id)sender
{
    if (_delete) {
        _delete(_info,self);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
