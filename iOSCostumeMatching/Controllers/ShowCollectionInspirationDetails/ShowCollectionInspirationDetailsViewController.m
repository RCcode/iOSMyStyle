//
//  ShowCollectionInspirationDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/23.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ShowCollectionInspirationDetailsViewController.h"

@interface ShowCollectionInspirationDetailsViewController ()

@end

@implementation ShowCollectionInspirationDetailsViewController

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setCoId:(int)coId
{
    _coId = coId;
    [[RC_RequestManager shareManager]GetCollocationDetailWithCoId:_coId success:^(id responseObject) {
        CLog(@"%@",responseObject);
    } andFailed:^(NSError *error) {
        CLog(@"%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"灵感详情"];
    self.showReturn = YES;
    [self setReturnBtnTitle:@"返回"];
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
