//
//  WriteCollectionDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/20.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "WriteCollectionDetailsViewController.h"
#import "SelectViewController.h"

@interface WriteCollectionDetailsViewController ()<UITextFieldDelegate>
{
    int style;
    int occasion;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) void(^finish)(CollocationInfo *info);
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnStyle;
@property (weak, nonatomic) IBOutlet UIButton *btnOccasion;

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
    CollocationInfo *collocationInfo = [[CollocationInfo alloc]init];
    collocationInfo.file = _image;
    collocationInfo.arrList = _arrList;
    collocationInfo.numStyleId = [NSNumber numberWithInt:style];
    collocationInfo.numOccId = [NSNumber numberWithInt:occasion];
    if (_txtDescription.text) {
        collocationInfo.strDescription = _txtDescription.text;
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
    
    [self setNavTitle:@"详情"];
    self.showDone = YES;
    self.showReturn = YES;
    [self setReturnBtnTitle:@"返回"];
    [self setDoneBtnTitle:@"完成"];
    
    _imageView.image = _image;
    _txtDescription.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)selectStyle:(id)sender {
    SelectViewController *selectStyle = [[SelectViewController alloc]init];
    [selectStyle setNavagationTitle:@"选择风格"];
    selectStyle.array = getAllCollocationStyle();
    __weak WriteCollectionDetailsViewController *weakSelf = self;
    [selectStyle setSelectedBlock:^(int index) {
        style = index;
        [weakSelf.btnStyle setTitle:getCollocationStyleName(style) forState:UIControlStateNormal] ;
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectStyle];
    [self presentViewController:nav animated:YES completion:nil];
}


- (IBAction)selectOccasion:(id)sender {
    SelectViewController *selectOccasion = [[SelectViewController alloc]init];
    [selectOccasion setNavagationTitle:@"选择场合"];
    selectOccasion.array = getAllCollocationOccasion();
    __weak WriteCollectionDetailsViewController *weakSelf = self;
    [selectOccasion setSelectedBlock:^(int index) {
        occasion = index;
        [weakSelf.btnOccasion setTitle:getCollocationOccasionName(occasion) forState:UIControlStateNormal] ;
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectOccasion];
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
