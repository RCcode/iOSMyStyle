//
//  WipeViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/10.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "WipeViewController.h"
#import "MZCroppableView.h"
#import "RCDrawerView.h"

@interface WipeViewController ()
{
    CGFloat scale;
    RCDrawerView *rcdrawerView;
}
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *magnifyingGlassImageView;
@property (nonatomic, strong) UIView *paintingSizeView;
@property (nonatomic, copy) void(^wipeImageSuccess)(UIImage *image);
@property (weak, nonatomic) IBOutlet UIView *sizeView1;
@property (weak, nonatomic) IBOutlet UIView *sizeView2;
@property (weak, nonatomic) IBOutlet UIView *sizeView3;
@property (weak, nonatomic) IBOutlet UIView *sizeView4;
@property (weak, nonatomic) IBOutlet UIView *sizeView5;
@property (weak, nonatomic) IBOutlet UIView *sizeView6;
@property (weak, nonatomic) IBOutlet UIView *sizeView;

@end

@implementation WipeViewController

-(void)setWipeImageSuccessBlock:(void (^)(UIImage *))wipeImageSuccessBlock
{
    _wipeImageSuccess = wipeImageSuccessBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    UIImage *finishImage = [rcdrawerView finishErase];
    if (_wipeImageSuccess) {
        _wipeImageSuccess(finishImage);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:LocalizedString(@"Erase", nil)];
    self.showReturn = YES;
    self.showDone = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    [self setDoneBtnTitleColor:colorWithHexString(@"#44dcca")];
    [self setDoneBtnTitle:@"完成"];
    
    _sizeView1.layer.cornerRadius = CGRectGetWidth(_sizeView1.frame)/2;
    _sizeView2.layer.cornerRadius = CGRectGetWidth(_sizeView2.frame)/2;
    _sizeView3.layer.cornerRadius = CGRectGetWidth(_sizeView3.frame)/2;
    _sizeView4.layer.cornerRadius = CGRectGetWidth(_sizeView4.frame)/2;
    _sizeView5.layer.cornerRadius = CGRectGetWidth(_sizeView5.frame)/2;
    _sizeView6.layer.cornerRadius = CGRectGetWidth(_sizeView6.frame)/2;
    
    
    _magnifyingGlassImageView  = [[UIImageView alloc]init];
    [_magnifyingGlassImageView setFrame:CGRectMake(0, 0, 95, 95)];
    [self.view addSubview:_magnifyingGlassImageView];
    _magnifyingGlassImageView.layer.borderColor = colorWithHexString(@"#222222").CGColor;
    _magnifyingGlassImageView.layer.borderWidth = 1.5;
    _magnifyingGlassImageView.clipsToBounds = YES;
    _magnifyingGlassImageView.hidden = YES;
    _paintingSizeView = [[UIView alloc]init];
    [_magnifyingGlassImageView addSubview:_paintingSizeView];
    _paintingSizeView.layer.borderColor = [UIColor redColor].CGColor;
    _paintingSizeView.layer.borderWidth = 1;
    
    _sizeView.hidden = NO;
    
    CGRect rect1 = CGRectMake(0, 0, _originalImage.size.width, _originalImage.size.height);
    CGRect rect2 = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-75);
    CGRect rect = [MZCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2];

    if (rect.size.width == ScreenWidth) {
        scale = _originalImage.size.width/rect.size.width;
    }
    else
    {
        scale = _originalImage.size.height/rect.size.height;
    }

    _paintingSizeView.frame = CGRectMake(0, 0, 14*scale, 14*scale);
    _paintingSizeView.center = _magnifyingGlassImageView.center;
    _paintingSizeView.layer.cornerRadius = 14*scale/2;

    _imageView = [[UIImageView alloc]initWithFrame:rect];
    [_imageView setImage:_originalImage];
    [self.view addSubview:_imageView];
    [self setUpMZCroppableView];

    _sizeView3.backgroundColor = colorWithHexString(@"#4de7d7");
    
}

- (void)setUpMZCroppableView
{
    [rcdrawerView removeFromSuperview];
    rcdrawerView = [[RCDrawerView alloc] initWithImageView:_imageView];
    rcdrawerView.lineWidth = 14;
    __weak WipeViewController *weakSelf = self;
    [rcdrawerView setMagnifyingGlassImageBlock:^(UIImage *image) {
        weakSelf.magnifyingGlassImageView.hidden = NO;
        [weakSelf.magnifyingGlassImageView setImage:image];
        weakSelf.sizeView.hidden = YES;
    }];
    [rcdrawerView setEndMagnifyingGlassImageBlock:^{
        weakSelf.magnifyingGlassImageView.hidden = YES;
    }];
    [self.view addSubview:rcdrawerView];
    [self.view bringSubviewToFront:_magnifyingGlassImageView];
    [self.view bringSubviewToFront:_sizeView];
}


-(void)setAllViewCustomColor
{
    _sizeView1.backgroundColor = colorWithHexString(@"#5f5f5f");
    _sizeView2.backgroundColor = colorWithHexString(@"#5f5f5f");
    _sizeView3.backgroundColor = colorWithHexString(@"#5f5f5f");
    _sizeView4.backgroundColor = colorWithHexString(@"#5f5f5f");
    _sizeView5.backgroundColor = colorWithHexString(@"#5f5f5f");
    _sizeView6.backgroundColor = colorWithHexString(@"#5f5f5f");
}

- (IBAction)changeEarseSize:(id)sender {
    [self setAllViewCustomColor];
    UIButton *btn = sender;
    CGFloat width = 14;
    switch (btn.tag) {
        case 0:
        {
            width = 4;
            _sizeView1.backgroundColor = colorWithHexString(@"#4de7d7");
            _paintingSizeView.frame = CGRectMake(0, 0, width*scale, width*scale);
            _paintingSizeView.center = _magnifyingGlassImageView.center;
            _paintingSizeView.layer.cornerRadius = width*scale/2;
            break;
        }
        case 1:
        {
            width = 9;
            _sizeView2.backgroundColor = colorWithHexString(@"#4de7d7");
            _paintingSizeView.frame = CGRectMake(0, 0, width*scale, width*scale);
            _paintingSizeView.center = _magnifyingGlassImageView.center;
            _paintingSizeView.layer.cornerRadius = width*scale/2;
            break;
        }
        case 2:
        {
            width = 14;
            _sizeView3.backgroundColor = colorWithHexString(@"#4de7d7");
            _paintingSizeView.frame = CGRectMake(0, 0, width*scale, width*scale);
            _paintingSizeView.center = _magnifyingGlassImageView.center;
            _paintingSizeView.layer.cornerRadius = width*scale/2;
            break;
        }
        case 3:
        {
            width = 19;
            _sizeView4.backgroundColor = colorWithHexString(@"#4de7d7");
            _paintingSizeView.frame = CGRectMake(0, 0, width*scale, width*scale);
            _paintingSizeView.center = _magnifyingGlassImageView.center;
            _paintingSizeView.layer.cornerRadius = width*scale/2;
            break;
        }
        case 4:
        {
            width = 24;
            _sizeView5.backgroundColor = colorWithHexString(@"#4de7d7");
            _paintingSizeView.frame = CGRectMake(0, 0, width*scale, width*scale);
            _paintingSizeView.center = _magnifyingGlassImageView.center;
            _paintingSizeView.layer.cornerRadius = width*scale/2;
            break;
        }
        case 5:
        {
            width = 29;
            _sizeView6.backgroundColor = colorWithHexString(@"#4de7d7");
            _paintingSizeView.frame = CGRectMake(0, 0, width*scale, width*scale);
            _paintingSizeView.center = _magnifyingGlassImageView.center;
            _paintingSizeView.layer.cornerRadius = width*scale/2;
            break;
        }
        default:
            break;
    }
    rcdrawerView.lineWidth = width;
}

- (IBAction)pressErase:(id)sender {
    _sizeView.hidden = !_sizeView.hidden;
}

- (IBAction)pressUndo:(id)sender {
    [rcdrawerView unDo];
}

- (IBAction)pressRedo:(id)sender {
    [rcdrawerView reDo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
