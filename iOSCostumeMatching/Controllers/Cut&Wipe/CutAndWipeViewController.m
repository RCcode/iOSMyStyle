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
#import "WriteClothesDetailsViewController.h"

@interface CutAndWipeViewController ()
{
    WriteClothesDetailsViewController *writeClothesDetailsViewController;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *currentImage;

@property (nonatomic, copy) void(^finish)(ClothesInfo *info);

@end

@implementation CutAndWipeViewController

-(void)setFinishImageBlock:(void (^)(ClothesInfo *))finishBlock
{
    _finish = finishBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    writeClothesDetailsViewController.image = _currentImage;
    __weak CutAndWipeViewController *weakSelf = self;
    [writeClothesDetailsViewController setFinishImageBlock:^(ClothesInfo *info) {
        weakSelf.finish(info);
    }];
    [self.navigationController pushViewController:writeClothesDetailsViewController animated:YES];
//    if (_finishImage) {
//        _finishImage(_currentImage);
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showReturn = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    
    self.showDone = YES;
    [self setDoneBtnTitleColor:colorWithHexString(@"#44dcca")];
    [self setDoneBtnTitle:@"下一步"];
    
    [self setNavTitle:LocalizedString(@"Crop", nil)];
    
    [_imageView setImage:_originalImage];
    _currentImage = _originalImage;
    
    writeClothesDetailsViewController = [[WriteClothesDetailsViewController alloc]init];
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
