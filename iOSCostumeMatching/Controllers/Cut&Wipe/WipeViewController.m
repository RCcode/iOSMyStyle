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
@property (weak, nonatomic) IBOutlet UISlider *slider;

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
    
    _magnifyingGlassImageView  = [[UIImageView alloc]init];
    [_magnifyingGlassImageView setFrame:CGRectMake(0, 0, 95, 95)];
    [self.view addSubview:_magnifyingGlassImageView];
    _magnifyingGlassImageView.layer.borderColor = colorWithHexString(@"#222222").CGColor;
    _magnifyingGlassImageView.layer.borderWidth = 1.5;
    _magnifyingGlassImageView.clipsToBounds = YES;
    _magnifyingGlassImageView.hidden = YES;
    
    _slider.hidden = YES;
    
    self.drawerView1 = [[PIDrawerView alloc]init];
    self.drawerView1.backgroundColor = [UIColor clearColor];
    __weak WipeViewController *weakSelf = self;
    [self.drawerView1 setMagnifyingGlassImageBlock:^(UIImage *image) {
        weakSelf.magnifyingGlassImageView.hidden = NO;
        [weakSelf.magnifyingGlassImageView setImage:image];
        weakSelf.slider.hidden = YES;
    }];
    [self.drawerView1 setEndMagnifyingGlassImageBlock:^{
        weakSelf.magnifyingGlassImageView.hidden = YES;
    }];

    _drawerView1.originalImage = _originalImage;
    
    CGRect rect1 = CGRectMake(0, 0, _originalImage.size.width, _originalImage.size.height);
    CGRect rect2 = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight-20-90);
    CGRect rect = [MZCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2];

    [self.drawerView1 setFrame:CGRectMake((int)rect.origin.x, (int)rect.origin.y, (int)rect.size.width, (int)rect.size.height)];
//    [self.view addSubview:self.drawerView1];
    [self.view insertSubview:self.drawerView1 atIndex:0];
    
    [self.drawerView1 setDrawingMode:DrawingModeErase];
    
}

- (IBAction)changeEarseSize:(id)sender {
    CGFloat width = _slider.value*20;
    if (width<1) {
        width = 1;
    }
    self.drawerView1.eraseWidth = width;
}

- (IBAction)pressErase:(id)sender {
    _slider.hidden = NO;
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
