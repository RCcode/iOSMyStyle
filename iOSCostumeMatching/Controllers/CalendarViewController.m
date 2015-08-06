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

#define SHOWHELPKEY @"showCalendarViewHelp"

@interface CalendarViewController ()<PWSCalendarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    PWSCalendarView *calendarView;
    UITableView *activityTableView;
    NSString *year;
    NSString *month;
}

@property (nonatomic, strong) NSMutableArray *arrActivity;

@property (strong, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UILabel *lblHelp1;
@property (weak, nonatomic) IBOutlet UILabel *lblHelp2;

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
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_sideslip"] andHighlightedImage:nil];
    self.showDone = YES;
    [self setDoneBtnTitleColor:colorWithHexString(@"#44dcca")];
    [self setDoneBtnTitle:@"今天"];
    
    NSString *showHelp = [[NSUserDefaults standardUserDefaults]objectForKey:SHOWHELPKEY];
    if (showHelp) {
        
    }
    else
    {
        [self.view addSubview:_helpView];
    }
    
//    [[RC_SQLiteManager shareManager]deleteTable:TNTActivity];
    
    calendarView = [[PWSCalendarView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 320) CalendarType:en_calendar_type_month];
    __weak CalendarViewController *weakSelf = self;
    [calendarView setChangeMonthBlock:^(NSDate *date) {
        [weakSelf setTitleDate:date];
    }];
    [calendarView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:calendarView];
    [calendarView setDelegate:self];
        
    activityTableView = [[UITableView alloc]init];
    [activityTableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
    activityTableView.delegate = self;
    activityTableView.dataSource = self;
    [activityTableView setFrame:CGRectMake(0, CGRectGetHeight(calendarView.frame), ScreenWidth, ScreenHeight-20-CGRectGetHeight(calendarView.frame))];
    [self.view insertSubview:activityTableView atIndex:0];
    activityTableView.backgroundColor = colorWithHexString(@"#eeeeee");
    [self setTitleDate:[NSDate date]];
}

- (IBAction)closeHelp:(id)sender {
    [_helpView removeFromSuperview];
    [activityTableView setFrame:CGRectMake(0, CGRectGetHeight(calendarView.frame), ScreenWidth, ScreenHeight-64-CGRectGetHeight(calendarView.frame))];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:SHOWHELPKEY];
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
    _arrActivity = [[RC_SQLiteManager shareManager]getAllActivityWithYear:year andMonth:month andDay:nil];
    [activityTableView reloadData];
}

-(void)setTitleDate:(NSDate *)date
{
    NSDateFormatter* ff = [[NSDateFormatter alloc] init];
//    [ff setDateFormat:@"yyyy-MM-dd"];
    [ff setDateFormat:@"yyyy-MM"];
    NSString* strDate = [ff stringFromDate:date];
    [self setNavTitle:strDate];
    NSString *year = yearFromDate(date);
    NSString *month = monthFromDate(date);
    _arrActivity = [[RC_SQLiteManager shareManager]getAllActivityWithYear:year andMonth:month andDay:nil];
    [activityTableView reloadData];
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
    if(info.arrData.count>0)
    {
        id object = [info.arrData objectAtIndex:0];
        UIImage *image;
        if ([object isKindOfClass:[ClothesInfo class]]) {
            image = ((ClothesInfo *)object).file;
        }
        else
        {
            image = ((CollocationInfo *)object).file;
        }
        [cell.clothesOrCollectionImageView setImage:image];
    }
    cell.lblTitle.text = [NSString stringWithFormat:@"%@",info.strTitle];
    [cell.lblTitle setBackgroundColor:[getColor([info.numColor intValue]) colorWithAlphaComponent:0.7]];
    [cell.leftView setBackgroundColor:getColor([info.numColor intValue])];
    [cell.lblTime setText:dayFromDate(info.dateStartTime)];
    
    return cell;
}

#pragma mark - PWSCalendarDelegate

- (void) PWSCalendar:(PWSCalendarView*)_calendar didSelecteDate:(NSDate*)_date
{
    NSLog(@"select = %@", _date);
    NSString *_year = yearFromDate(_date);
    NSString *_month = monthFromDate(_date);
    NSString *_day = dayFromDate(_date);
    _arrActivity = [[RC_SQLiteManager shareManager]getAllActivityWithYear:_year andMonth:_month andDay:_day];
    [activityTableView reloadData];
}

- (void) PWSCalendar:(PWSCalendarView*)_calendar didChangeViewHeight:(CGFloat)_height
{
    NSString *showHelp = [[NSUserDefaults standardUserDefaults]objectForKey:SHOWHELPKEY];
    if (showHelp) {
        _helpView.hidden = YES;
        [activityTableView setFrame:CGRectMake(0, CGRectGetHeight(calendarView.frame), ScreenWidth, ScreenHeight-64-CGRectGetHeight(calendarView.frame))];
    }
    else
    {
        _helpView.hidden = NO;
        [_helpView setFrame:CGRectMake(5, CGRectGetHeight(calendarView.frame), CGRectGetWidth(_helpView.frame), CGRectGetHeight(_helpView.frame))];
        [activityTableView setFrame:CGRectMake(0, CGRectGetMaxY(_helpView.frame)+5, ScreenWidth, ScreenHeight-64-CGRectGetMaxY(_helpView.frame)-5)];
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
