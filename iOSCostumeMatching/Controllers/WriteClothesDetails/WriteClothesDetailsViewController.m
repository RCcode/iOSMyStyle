//
//  WriteClothesDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/17.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "WriteClothesDetailsViewController.h"

@interface WriteClothesDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) void(^finish)(ClothesInfo *info);

@end

@implementation WriteClothesDetailsViewController

#pragma mark - setter

-(void)setFinishImageBlock:(void (^)(ClothesInfo *))finishBlock
{
    _finish = finishBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneBtnPressed:(id)sender
{
    if (_finish) {
        ClothesInfo *clothesInfo = [[ClothesInfo alloc]init];
//        clothesInfo.numClId = [NSNumber numberWithInt:(int)(_arrClothes.count+1)];
        clothesInfo.numCateId = [NSNumber numberWithInt:0];
        clothesInfo.numScateId = [NSNumber numberWithInt:0];
        clothesInfo.numSeaId = [NSNumber numberWithInt:0];
        clothesInfo.strBrand = @"hhhh";
        clothesInfo.file = _image;
        clothesInfo.date = stringFromDate([NSDate date]);
        _finish(clothesInfo);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"详情"];
    self.showReturn = YES;
    [self setReturnBtnTitle:@"返回"];
    self.showDone = YES;
    [self setDoneBtnTitle:@"完成"];
    
    _imageView.image = _image;
    // Do any additional setup after loading the view from its nib.
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
