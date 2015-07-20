//
//  ShowCollectionDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/20.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ShowCollectionDetailsViewController.h"

@interface ShowCollectionDetailsViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) void(^delete)(CollocationInfo *info);
@end

@implementation ShowCollectionDetailsViewController

-(void)setDeleteBlock:(void (^)(CollocationInfo *))deleteBlock
{
    _delete = deleteBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"搭配详情"];
    [self setReturnBtnTitle:@"关闭"];
    self.showReturn = YES;
    
    [_imageView setImage:_collocationInfo.file];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)showMore:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"分享", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CLog(@"删除");
        if (_delete) {
            _delete(_collocationInfo);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(buttonIndex == 1)
    {
        CLog(@"分享");
    }
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
