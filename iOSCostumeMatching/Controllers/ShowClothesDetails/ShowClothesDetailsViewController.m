//
//  ShowClothesDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/17.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ShowClothesDetailsViewController.h"

@interface ShowClothesDetailsViewController ()<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, copy) void(^delete)(ClothesInfo *info);

@end

@implementation ShowClothesDetailsViewController

-(void)setDeleteBlock:(void (^)(ClothesInfo *))deleteBlock
{
    _delete = deleteBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"分享", nil];
    [actionSheet showInView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"详情"];
    self.showReturn = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    self.showDone = YES;
    [self setDoneBtnNormalImage:[UIImage imageNamed:@"ic_more"] andHighlightedImage:nil];
    
    [_imageView setImage:_clothesInfo.file];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CLog(@"删除");
        if (_delete) {
            _delete(_clothesInfo);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(buttonIndex == 1)
    {
        CLog(@"分享");
    }
}

- (IBAction)addCollection:(id)sender {
}

- (IBAction)addCalendar:(id)sender {
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
