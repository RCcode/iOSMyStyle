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
    WardrobeSeason season;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) void(^finish)(ClothesInfo *info);
@property (weak, nonatomic) IBOutlet UITextField *txtBrand;
@property (weak, nonatomic) IBOutlet UIButton *btnType;
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
        clothesInfo.numCateId = [NSNumber numberWithInt:type];
        clothesInfo.numScateId = [NSNumber numberWithInt:category];
        clothesInfo.numSeaId = [NSNumber numberWithInt:season];
        if (_txtBrand.text) {
            clothesInfo.strBrand = _txtBrand.text;
        }
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

- (IBAction)selectType:(id)sender {
    SelectViewController *selectStyle = [[SelectViewController alloc]init];
    [selectStyle setNavagationTitle:@"选择类型"];
    selectStyle.array = getAllWardrobeType();
    __weak WriteClothesDetailsViewController *weakSelf = self;
    [selectStyle setSelectedBlock:^(int index) {
        if(index == 0)
        {
            type = 0;
        }
        else
        {
            type = index+9;
        }
        [weakSelf.btnType setTitle:getWardrobeTypeName(type) forState:UIControlStateNormal] ;
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectStyle];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)selectCategory:(id)sender {
    SelectViewController *selectCategory = [[SelectViewController alloc]init];
    [selectCategory setNavagationTitle:@"选择类别"];
    selectCategory.array = getAllWardrobeCategorye(type);
    __weak WriteClothesDetailsViewController *weakSelf = self;
    [selectCategory setSelectedBlock:^(int index) {
        switch (type) {
            case WTAll:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    if (index >0 && index<=12) {
                        category = index+1000;
                    }
                    else if(index>12 && index<=18)
                    {
                        category = index+1100-12;
                    }
                    else if(index>18 && index<=27)
                    {
                        category = index+1200-18;
                    }
                    else if(index>27 && index<=34)
                    {
                        category = index+1300-27;
                    }
                    else if(index>34 && index<=42)
                    {
                        category = index+1400-34;
                    }
                    else if(index>42 && index<=48)
                    {
                        category = index+1500-42;
                    }
                    else if(index>48)
                    {
                        category = index+1600-48;
                    }
                }
                break;
            }
            case WTUpper:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1001;
                }
                break;
            }
            case WTBottoms:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1101;
                }
                break;
            }
            case WTShoes:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1201;
                }
                break;
            }
            case WTBag:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1301;
                }
                break;
            }
            case WTAccessory:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1401;
                }
                break;
            }
            case WTJewelry:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1501;
                }
                break;
            }
            case WTUnderwear:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1601;
                }
                break;
            }
            default:
                break;
        }
        [weakSelf.btnCategory setTitle:getWardrobeCategoryeName(category) forState:UIControlStateNormal];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectCategory];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)selectSeason:(id)sender {
    SelectViewController *selectSeason = [[SelectViewController alloc]init];
    [selectSeason setNavagationTitle:@"选择季节"];
    selectSeason.array = getAllWardrobeSeason();
    __weak WriteClothesDetailsViewController *weakSelf = self;
    [selectSeason setSelectedBlock:^(int index) {
        season = index;
        [weakSelf.btnSeason setTitle:getWardrobeSeasonName(season) forState:UIControlStateNormal];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectSeason];
    [self presentViewController:nav animated:YES completion:nil];
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
