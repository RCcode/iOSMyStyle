//
//  RC_NavigationController.m
//  iOSIdeagram
//
//  Created by TCH on 15/3/18.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "RC_NavigationController.h"

@interface RC_NavigationController ()

@end

@implementation RC_NavigationController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:colorWithHexString(@"#ffffff")];
    self.navigationBar.shadowImage = [[UIImage alloc]init];
    self.navigationBar.translucent = NO;
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
