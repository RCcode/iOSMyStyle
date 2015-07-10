//
//  WardrobeViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/9.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "WardrobeViewController.h"

@interface WardrobeViewController ()

@end

@implementation WardrobeViewController

-(void)returnBtnPressed:(id)sender
{
//    [[SliderViewController sharedSliderController]showLeftViewController];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showReturn = YES;
    [self setReturnBtnTitle:@"菜单"];
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
