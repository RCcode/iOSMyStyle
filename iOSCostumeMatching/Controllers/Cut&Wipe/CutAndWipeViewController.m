//
//  CutAndWipeViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/10.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "CutAndWipeViewController.h"
#import "CutViewController.h"
#import "WipeViewController.h"

@interface CutAndWipeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *currentImage;

@property (nonatomic, copy) void(^finishImage)(UIImage *image);

@end

@implementation CutAndWipeViewController

-(void)setFinishImageBlock:(void (^)(UIImage *))finishImageBlock
{
    _finishImage = finishImageBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    if (_finishImage) {
        _finishImage(_currentImage);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showReturn = YES;
    [self setReturnBtnTitle:@"返回"];
    
    self.showDone = YES;
    [self setDoneBtnTitle:@"确定"];
    
    [_imageView setImage:_originalImage];
    _currentImage = _originalImage;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)cutImage:(id)sender {
    CutViewController *cutViewController = [[CutViewController alloc]init];
    cutViewController.originalImage = _currentImage;
    __weak CutAndWipeViewController *weakSelf = self;
    [cutViewController setCroppedImageSuccessBlock:^(UIImage *image) {
        [weakSelf.imageView setImage:image];
        _currentImage = image;
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:cutViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)wipeImage:(id)sender {
    WipeViewController *wipeViewController = [[WipeViewController alloc]init];
    wipeViewController.originalImage = _currentImage;
    __weak CutAndWipeViewController *weakSelf = self;
    [wipeViewController setWipeImageSuccessBlock:^(UIImage *image) {
        [weakSelf.imageView setImage:image];
        _currentImage = image;
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:wipeViewController];
    [self presentViewController:nav animated:YES completion:nil];

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