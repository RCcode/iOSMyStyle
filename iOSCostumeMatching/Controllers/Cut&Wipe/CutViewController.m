//
//  CutViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/10.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "CutViewController.h"
#import "MZCroppableView.h"

@interface CutViewController ()
{
    MZCroppableView *mzCroppableView;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) void(^croppedImageSuccess)(UIImage *image);

@end

@implementation CutViewController

-(void)setCroppedImageSuccessBlock:(void (^)(UIImage *))croppedImageSuccessBlock
{
    _croppedImageSuccess = croppedImageSuccessBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    UIImage *croppedImage = [mzCroppableView deleteBackgroundOfImage:_imageView];
    
//    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/final.png"];
//    [UIImagePNGRepresentation(croppedImage) writeToFile:path atomically:YES];
//    
//    NSLog(@"cropped image path: %@",path);
    
    if (_croppedImageSuccess) {
        _croppedImageSuccess(croppedImage);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNavTitle:@"裁剪"];
    self.showReturn = YES;
    self.showDone = YES;
    [self setReturnBtnTitle:@"返回"];
    [self setDoneBtnTitle:@"确定"];
    
    [_imageView setImage:_originalImage];
    
    CGRect rect1 = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
    CGRect rect2 = _imageView.frame;
    [_imageView setFrame:[MZCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2]];
    
    [self setUpMZCroppableView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [_imageView setFrame:mzCroppableView.frame];
}

- (void)setUpMZCroppableView
{
    [mzCroppableView removeFromSuperview];
    mzCroppableView = [[MZCroppableView alloc] initWithImageView:_imageView];
    [self.view addSubview:mzCroppableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
