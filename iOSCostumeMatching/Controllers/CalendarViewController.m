//
//  CalendarViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/13.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "CalendarViewController.h"
#import "PWSCalendarView.h"
#import "CreateActivityViewController.h"
#import "ActivityCell.h"
#import "ShowActivityViewController.h"

@interface CalendarViewController ()<PWSCalendarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    PWSCalendarView *calendarView;
    UITableView *activityTableView;
}

@property (nonatomic, strong) NSMutableArray *arrActivity;

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
    
//    [[RC_SQLiteManager shareManager]deleteTable:TNTActivity];
    self.arrActivity = [[RC_SQLiteManager shareManager]getAllActivity];
    
    activityTableView = [[UITableView alloc]init];
    [activityTableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
    activityTableView.delegate = self;
    activityTableView.dataSource = self;
    [activityTableView setFrame:CGRectMake(0, CGRectGetHeight(calendarView.frame), ScreenWidth, ScreenHeight-20-CGRectGetHeight(calendarView.frame))];
    [self.view insertSubview:activityTableView atIndex:0];
}

- (IBAction)addActivity:(id)sender {
    CreateActivityViewController *createActivity = [[CreateActivityViewController alloc]init];
    __weak CalendarViewController *weakSelf = self;
    [createActivity setActivityFinishBlock:^(ActivityInfo *info) {
        [weakSelf addNewActivity:info];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:createActivity];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)addNewActivity:(ActivityInfo *)info
{
    [[RC_SQLiteManager shareManager]addActivityInfo:info];
    _arrActivity = [[RC_SQLiteManager shareManager]getAllActivity];
    [activityTableView reloadData];
}

-(void)setTitleDate:(NSDate *)date
{
    NSDateFormatter* ff = [[NSDateFormatter alloc] init];
    [ff setDateFormat:@"yyyy-MM-dd"];
    NSString* strDate = [ff stringFromDate:date];
    [self setNavTitle:strDate];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowActivityViewController *showActivity = [[ShowActivityViewController alloc]init];
    showActivity.activityInfo = [_arrActivity objectAtIndex:indexPath.row];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:showActivity];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrActivity.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    ActivityInfo *info = [_arrActivity objectAtIndex:[indexPath row]];
    id object = [info.arrData objectAtIndex:0];
    UIImage *image;
    if ([object isKindOfClass:[ClothesInfo class]]) {
        image = ((ClothesInfo *)object).file;
    }
    else
    {
        image = ((CollocationInfo *)object).file;
    }
    cell.lblTitle.text = [NSString stringWithFormat:@"%@",info.strTitle];
    [cell.lblTitle setBackgroundColor:getColor([info.numColor intValue])];
    [cell.lblTime setText:dayFromDate(info.dateStartTime)];
    [cell.clothesOrCollectionImageView setImage:image];
    return cell;
}

#pragma mark - PWSCalendarDelegate

- (void) PWSCalendar:(PWSCalendarView*)_calendar didSelecteDate:(NSDate*)_date
{
    NSLog(@"select = %@", _date);
}

- (void) PWSCalendar:(PWSCalendarView*)_calendar didChangeViewHeight:(CGFloat)_height
{
    [activityTableView setFrame:CGRectMake(0, CGRectGetHeight(calendarView.frame), ScreenWidth, ScreenHeight-64-CGRectGetHeight(calendarView.frame))];
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
