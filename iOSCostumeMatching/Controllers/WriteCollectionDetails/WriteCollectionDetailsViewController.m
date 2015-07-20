//
//  WriteCollectionDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/20.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "WriteCollectionDetailsViewController.h"

@interface WriteCollectionDetailsViewController ()

@end

@implementation WriteCollectionDetailsViewController

-(void)returnBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneBtnPressed:(id)sender
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"详情"];
    self.showDone = YES;
    self.showReturn = YES;
    [self setReturnBtnTitle:@"返回"];
    [self setDoneBtnTitle:@"完成"];
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
