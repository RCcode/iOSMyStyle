//
//  CalendarViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/13.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "CalendarViewController.h"
#import "PWSCalendarView.h"

@interface CalendarViewController ()<PWSCalendarDelegate>

@end

@implementation CalendarViewController

-(void)returnBtnPressed:(id)sender
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showReturn = YES;
    [self setNavTitle:@"我的日历"];
    [self setReturnBtnTitle:@"菜单"];
    
    PWSCalendarView* view = [[PWSCalendarView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 400) CalendarType:en_calendar_type_month];
    [view setBackgroundColor:[UIColor cyanColor]];
    [self.view addSubview:view];
    [view setDelegate:self];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - PWSCalendarDelegate

- (void) PWSCalendar:(PWSCalendarView*)_calendar didSelecteDate:(NSDate*)_date
{
    NSLog(@"select = %@", _date);
}

- (void) PWSCalendar:(PWSCalendarView*)_calendar didChangeViewHeight:(CGFloat)_height
{
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
