//
//  WriteCollectionDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/20.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "WriteCollectionDetailsViewController.h"
#import "SelectViewController.h"
#import "LeftMenuViewController.h"

@interface WriteCollectionDetailsViewController ()<UITextFieldDelegate>
{
    int style;
    int occasion;
    BOOL pressStyle;
    BOOL pressOccasion;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) void(^finish)(CollocationInfo *info);
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnStyle;
@property (weak, nonatomic) IBOutlet UIButton *btnOccasion;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *lblStyle;
@property (weak, nonatomic) IBOutlet UILabel *lblOccasion;

@property (weak, nonatomic) IBOutlet UISwitch *upLoadSwitch;

@property (weak, nonatomic) IBOutlet UILabel *lDes;
@property (weak, nonatomic) IBOutlet UILabel *lStyle;
@property (weak, nonatomic) IBOutlet UILabel *lOccation;
@property (weak, nonatomic) IBOutlet UILabel *lUpload;


@end

@implementation WriteCollectionDetailsViewController

-(void)dealloc
{
    
}

-(void)returnBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneBtnPressed:(id)sender
{
    if (pressStyle) {
        [IS_MobAndAnalyticsManager event:@"Lookbook" label:@"lookbook_style"];
    }
    if (pressOccasion) {
        [IS_MobAndAnalyticsManager event:@"Lookbook" label:@"lookbook_occasion"];
    }
    CollocationInfo *collocationInfo = [[CollocationInfo alloc]init];
    collocationInfo.file = _image;
    collocationInfo.arrList = _arrList;
    collocationInfo.numStyleId = [NSNumber numberWithInt:style];
    collocationInfo.numOccId = [NSNumber numberWithInt:occasion];
    if (_txtDescription.text) {
        collocationInfo.strDescription = _txtDescription.text;
        [IS_MobAndAnalyticsManager event:@"Lookbook" label:@"lookbook_description"];
    }
//    collocationInfo.strDescription = @"宴会";
    collocationInfo.date = stringFromDate([NSDate date]);
    if (_finish) {
        _finish(collocationInfo);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setCollectionFinishBlock:(void (^)(CollocationInfo *))collectionfinishBlock
{
    _finish = collectionfinishBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:LocalizedString(@"Details", nil)];
    self.showDone = YES;
    self.showReturn = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    [self setDoneBtnTitleColor:colorWithHexString(@"#44dcca")];
    [self setDoneBtnTitle:LocalizedString(@"DONE", nil)];
    
    [_lDes setText:LocalizedString(@"Description", nil)];
    [_lStyle setText:LocalizedString(@"Style", nil)];
    [_lOccation setText:LocalizedString(@"Occasion", nil)];
    [_lUpload setText:LocalizedString(@"UploadClothesDes", nil)];
    
    pressStyle = NO;
    pressOccasion = NO;
    
    _imageView.image = _image;
    _txtDescription.delegate = self;
    
    [_scrollView addSubview:_contentView];
    [_contentView setFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_contentView.frame))];
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame))];
    
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

- (IBAction)selectStyle:(id)sender {
    pressStyle = YES;
    SelectViewController *selectStyle = [[SelectViewController alloc]init];
    [selectStyle setNavagationTitle:@"选择风格"];
    selectStyle.array = getAllCollocationStyle();
    __weak WriteCollectionDetailsViewController *weakSelf = self;
    [selectStyle setSelectedBlock:^(int index) {
        style = index;
        [weakSelf.lblStyle setText:getCollocationStyleName(style)];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectStyle];
    [self presentViewController:nav animated:YES completion:nil];
}


- (IBAction)selectOccasion:(id)sender {
    pressOccasion = YES;
    SelectViewController *selectOccasion = [[SelectViewController alloc]init];
    [selectOccasion setNavagationTitle:@"选择场合"];
    selectOccasion.array = getAllCollocationOccasion();
    __weak WriteCollectionDetailsViewController *weakSelf = self;
    [selectOccasion setSelectedBlock:^(int index) {
        occasion = index;
        [weakSelf.lblOccasion setText:getCollocationOccasionName(occasion)];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectOccasion];
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
