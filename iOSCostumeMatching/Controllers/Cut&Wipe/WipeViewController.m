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

@property (weak, nonatomic) IBOutlet PIDrawerView *drawerView;
@property (nonatomic, copy) void(^wipeImageSuccess)(UIImage *image);

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
    
    [self setNavTitle:@"擦除"];
    self.showReturn = YES;
    self.showDone = YES;
    [self setReturnBtnTitle:@"返回"];
    [self setDoneBtnTitle:@"确定"];
    
    [self.drawerView setDrawingMode:DrawingModeErase];
    
    
    self.drawerView1 = [[PIDrawerView alloc]init];
    self.drawerView1.backgroundColor = [UIColor clearColor];
    _drawerView1.originalImage = _originalImage;
    
    CGRect rect1 = CGRectMake(0, 0, _originalImage.size.width, _originalImage.size.height);
    CGRect rect2 = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight-20);
    CGRect rect = [MZCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2];

//    [self.drawerView1 setFrame:rect];
    [self.drawerView1 setFrame:CGRectMake((int)rect.origin.x, (int)rect.origin.y, (int)rect.size.width, (int)rect.size.height)];
    [self.view addSubview:self.drawerView1];
    
    [self.drawerView1 setDrawingMode:DrawingModeErase];
    
    
    
//    _scratchView = [[STScratchView alloc]init];
//    _scratchView.backgroundColor = [UIColor redColor];
//    // Set up the STScratchView
//    [_scratchView setSizeBrush:20.0];
//    [_scratchView setFrame:CGRectMake(0.0, 0.0, 320 , 320)];
//    // Create a (child) UIView
//    UIImageView *ball = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320 , 320)];
//    [ball setImage:_originalImage];
//    
//    // Define the hide view
//    [_scratchView setHideView:ball];
//    [self.view addSubview:_scratchView];
    
//    _scratchView = [[STScratchView alloc]init];
//    _scratchView.backgroundColor = [UIColor redColor];
//
//    CGRect rect1 = CGRectMake(0, 0, _originalImage.size.width, _originalImage.size.height);
//    CGRect rect2 = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight);
//    CGRect rect = [MZCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2];
//
//    [_scratchView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
//    [_scratchView setSizeBrush:20.0];
//
//    // Create a (child) UIView
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
//    [imageView setImage:_originalImage];
//
//    // Define the hide view
//    [_scratchView setHideView:imageView];
//    [self.view addSubview:_scratchView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
//    self.drawerView.originalImage = _originalImage;
//    CGRect rect1 = CGRectMake(0, 0, _originalImage.size.width, _originalImage.size.height);
//    CGRect rect2 = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight-20);
//    CGRect rect = [MZCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2];
//    [self.drawerView setFrame:CGRectMake((int)rect.origin.x, (int)rect.origin.y, (int)rect.size.width, (int)rect.size.height)];
////    [self.drawerView setFrame:CGRectMake(0, 0, 200, 150)];
//    [self.drawerView setDrawingMode:DrawingModeErase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
