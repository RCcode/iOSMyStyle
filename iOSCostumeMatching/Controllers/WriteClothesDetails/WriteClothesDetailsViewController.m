//
//  WriteClothesDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/17.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "WriteClothesDetailsViewController.h"
#import "SelectViewController.h"
#import "LeftMenuViewController.h"

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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblSeason;

@property (weak, nonatomic) IBOutlet UILabel *lblBrand;
@property (weak, nonatomic) IBOutlet UILabel *lCategory;
@property (weak, nonatomic) IBOutlet UILabel *lsubCategory;
@property (weak, nonatomic) IBOutlet UILabel *lseason;
@property (weak, nonatomic) IBOutlet UILabel *lDesUploadClothes;


@property (weak, nonatomic) IBOutlet UISwitch *upLoadSwitch;

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
    [self setNavTitle:LocalizedString(@"Details", nil)];
    self.showReturn = YES;
    self.showDone = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    [self setDoneBtnTitleColor:colorWithHexString(@"#44dcca")];
    [self setDoneBtnTitle:LocalizedString(@"DONE", nil)];

    [_lblBrand setText:LocalizedString(@"Brand", nil)];
    [_lCategory setText:LocalizedString(@"Season", nil)];
    [_lsubCategory setText:LocalizedString(@"Category", nil)];
    [_lseason setText:LocalizedString(@"Subcategory", nil)];
    [_lDesUploadClothes setText:LocalizedString(@"UploadClothesDes", nil)];
    
    [_scrollView addSubview:_contentView];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame));
    
    _imageView.image = _image;
    
    _txtBrand.delegate = self;
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (userInfo) {
        _upLoadSwitch.on = YES;
    }
    else
    {
        _upLoadSwitch.on = NO;
    }
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)selectType:(id)sender {
    SelectViewController *selectStyle = [[SelectViewController alloc]init];
    [selectStyle setNavagationTitle:LocalizedString(@"Category", nil)];
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
//        [weakSelf.btnType setTitle:getWardrobeTypeName(type) forState:UIControlStateNormal] ;
        [weakSelf.lblType setText:getWardrobeTypeName(type)];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectStyle];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)selectCategory:(id)sender {
    SelectViewController *selectCategory = [[SelectViewController alloc]init];
    [selectCategory setNavagationTitle:LocalizedString(@"Subcategory", nil)];
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
                    category = index+1000;
                }
                break;
            }
            case WTBottoms:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1100;
                }
                break;
            }
            case WTShoes:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1200;
                }
                break;
            }
            case WTBag:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1300;
                }
                break;
            }
            case WTAccessory:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1400;
                }
                break;
            }
            case WTJewelry:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1500;
                }
                break;
            }
            case WTUnderwear:{
                if (index == 0) {
                    category = 0;
                }
                else
                {
                    category = index+1600;
                }
                break;
            }
            default:
                break;
        }
//        [weakSelf.btnCategory setTitle:getWardrobeCategoryeName(category) forState:UIControlStateNormal];
        [weakSelf.lblCategory setText:getWardrobeCategoryeName(category)];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectCategory];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)selectSeason:(id)sender {
    SelectViewController *selectSeason = [[SelectViewController alloc]init];
    [selectSeason setNavagationTitle:LocalizedString(@"Season", nil)];
    selectSeason.array = getAllWardrobeSeason();
    __weak WriteClothesDetailsViewController *weakSelf = self;
    [selectSeason setSelectedBlock:^(int index) {
        season = index;
//        [weakSelf.btnSeason setTitle:getWardrobeSeasonName(season) forState:UIControlStateNormal];
        [weakSelf.lblSeason setText:getWardrobeSeasonName(season)];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectSeason];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)upLoadValueChange:(id)sender {
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (userInfo) {
    }
    else
    {
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        [(LeftMenuViewController *)app.sideViewController.leftViewController pressLogin:nil];
        _upLoadSwitch.on = NO;
    }
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
