//
//  WipeViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/10.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "WipeViewController.h"
#import "STScratchView.h"
#import "MZCroppableView.h"
#import "PIDrawerView.h"

@interface WipeViewController ()

@property (nonatomic, strong) STScratchView *scratchView;

@property (strong, nonatomic) PIDrawerView *drawerView1;
@property (nonatomic, strong) UIImageView *magnifyingGlassImageView;
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
    float scale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(_drawerView1.bounds.size, NO, 0);
    [_drawerView1.layer renderInContext:UIGraphicsGetCurrentContext()];
    _drawerView1.layer.contentsScale = scale;
    UIImage *finishImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
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
    
    _sizeView.hidden = YES;
    
    self.drawerView1 = [[PIDrawerView alloc]init];
    self.drawerView1.backgroundColor = [UIColor clearColor];
    __weak WipeViewController *weakSelf = self;
    [self.drawerView1 setMagnifyingGlassImageBlock:^(UIImage *image) {
        weakSelf.magnifyingGlassImageView.hidden = NO;
        [weakSelf.magnifyingGlassImageView setImage:image];
        weakSelf.sizeView.hidden = YES;
    }];
    [self.drawerView1 setEndMagnifyingGlassImageBlock:^{
        weakSelf.magnifyingGlassImageView.hidden = YES;
    }];

    _drawerView1.originalImage = _originalImage;
    
    CGRect rect1 = CGRectMake(0, 0, _originalImage.size.width, _originalImage.size.height);
    CGRect rect2 = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-130);
    CGRect rect = [MZCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2];

    [self.drawerView1 setFrame:CGRectMake((int)rect.origin.x, (int)rect.origin.y, (int)rect.size.width, (int)rect.size.height)];
//    [self.view addSubview:self.drawerView1];
    [self.view insertSubview:self.drawerView1 atIndex:0];
    
    [self.drawerView1 setDrawingMode:DrawingModeErase];
    
    self.drawerView1.eraseWidth = 14;
    _sizeView3.backgroundColor = colorWithHexString(@"#4de7d7");
    
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
    CGFloat width;
    switch (btn.tag) {
        case 0:
        {
            width = 4;
            _sizeView1.backgroundColor = colorWithHexString(@"#4de7d7");
            break;
        }
        case 1:
        {
            width = 9;
            _sizeView2.backgroundColor = colorWithHexString(@"#4de7d7");
            break;
        }
        case 2:
        {
            width = 14;
            _sizeView3.backgroundColor = colorWithHexString(@"#4de7d7");
            break;
        }
        case 3:
        {
            width = 19;
            _sizeView4.backgroundColor = colorWithHexString(@"#4de7d7");
            break;
        }
        case 4:
        {
            width = 24;
            _sizeView5.backgroundColor = colorWithHexString(@"#4de7d7");
            break;
        }
        case 5:
        {
            width = 29;
            _sizeView6.backgroundColor = colorWithHexString(@"#4de7d7");
            break;
        }
        default:
            break;
    }
    self.drawerView1.eraseWidth = width;
}

- (IBAction)pressErase:(id)sender {
    _sizeView.hidden = NO;
}

- (IBAction)pressUndo:(id)sender {
    [self.drawerView1 undo];
}

- (IBAction)pressRedo:(id)sender {
    [self.drawerView1 redo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
