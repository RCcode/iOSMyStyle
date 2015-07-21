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
{
    PWSCalendarView *calendarView;
}
@end

@implementation CalendarViewController

-(void)returnBtnPressed:(id)sender
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:true];
}

-(void)doneBtnPressed:(id)sender
{
    [calendarView ScrollToToday];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showReturn = YES;
    [self setNavTitle:@"我的日历"];
    [self setReturnBtnTitle:@"菜单"];
    self.showDone = YES;
    [self setDoneBtnTitle:@"今天"];
    
    [self setTitleDate:[NSDate date]];
    calendarView = [[PWSCalendarView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 320) CalendarType:en_calendar_type_month];
    __weak CalendarViewController *weakSelf = self;
    [calendarView setChangeMonthBlock:^(NSDate *date) {
        [weakSelf setTitleDate:date];
    }];
    [calendarView setBackgroundColor:[UIColor cyanColor]];
    [self.view addSubview:calendarView];
    [calendarView setDelegate:self];
    // Do any additional setup after loading the view from its nib.
}

-(void)setTitleDate:(NSDate *)date
{
    NSDateFormatter* ff = [[NSDateFormatter alloc] init];
    [ff setDateFormat:@"yyyy-MM-dd"];
    NSString* strDate = [ff stringFromDate:date];
    [self setNavTitle:strDate];
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
