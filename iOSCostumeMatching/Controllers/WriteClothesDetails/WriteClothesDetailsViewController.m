//
//  WriteClothesDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/17.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "WriteClothesDetailsViewController.h"
#import "SelectViewController.h"

@interface WriteClothesDetailsViewController ()<UITextFieldDelegate>
{
    WardrobeType type;
    WardrobeCategory category;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) void(^finish)(ClothesInfo *info);
@property (weak, nonatomic) IBOutlet UITextField *txtBrand;
@property (weak, nonatomic) IBOutlet UIButton *btnStyle;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnSeason;

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
    
    _txtBrand.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)selectStyle:(id)sender {
    SelectViewController *selectStyle = [[SelectViewController alloc]init];
    [selectStyle setNavagationTitle:@"选择类型"];
    selectStyle.array = getAllWardrobeType();
    __weak WriteClothesDetailsViewController *weakSelf = self;
    [selectStyle setSelectedBlock:^(int index) {
        type = index;
        [weakSelf.btnStyle setTitle:getWardrobeTypeName(type) forState:UIControlStateNormal] ;
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectStyle];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)selectCategory:(id)sender {
    SelectViewController *selectCategory = [[SelectViewController alloc]init];
    [selectCategory setNavagationTitle:@"选择类别"];
    selectCategory.array = getAllWardrobeCategorye();
    __weak WriteClothesDetailsViewController *weakSelf = self;
    [selectCategory setSelectedBlock:^(int index) {
        category = index;
        [weakSelf.btnCategory setTitle:getWardrobeCategoryeName(category) forState:UIControlStateNormal];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectCategory];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)selectSeason:(id)sender {
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
