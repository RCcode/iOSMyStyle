//
//  CreateCollectionViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/20.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "CreateCollectionViewController.h"
#import "WriteCollectionDetailsViewController.h"

@interface CreateCollectionViewController ()

@end

@implementation CreateCollectionViewController

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    WriteCollectionDetailsViewController *writeCollection = [[WriteCollectionDetailsViewController alloc]init];
    [self.navigationController pushViewController:writeCollection animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"衣服搭配"];
    self.showReturn = YES;
    self.showDone = YES;
    [self setReturnBtnTitle:@"取消"];
    [self setDoneBtnTitle:@"继续"];
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
