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

-(void)setDeleteHide:(BOOL)hide
{
    deleteButton.hidden = hide;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setFrame:self.bounds];
        [self addSubview:imageView];
        
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPressGr.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPressGr];
        
        deleteButton = [[UIButton alloc]init];
//        [deleteButton setBackgroundImage:[UIImage imageNamed:@"ic_delet"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"ic_delet"] forState:UIControlStateNormal];
        [deleteButton setBackgroundColor:[colorWithHexString(@"#ff5252") colorWithAlphaComponent:0.8]];
        [deleteButton setFrame:self.bounds];
        [deleteButton addTarget:self action:@selector(pressDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        deleteButton.hidden = YES;
        
        self.layer.borderColor = colorWithHexString(@"#e6e6e6").CGColor;
        self.layer.borderWidth = 1;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)longPress:(UILongPressGestureRecognizer *)gesture
{
    deleteButton.hidden = NO;
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
