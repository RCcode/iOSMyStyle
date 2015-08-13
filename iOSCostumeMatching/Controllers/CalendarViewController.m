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
    int _lastPosition;
}

@property (nonatomic, strong) NSMutableArray *arrActivity;

@property (strong, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UILabel *lblHelp1;
@property (weak, nonatomic) IBOutlet UILabel *lblHelp2;

@property (weak, nonatomic) IBOutlet UIButton *btnAddActivity;
@property (nonatomic, strong) UIButton *btnUpOrDown;
@property (nonatomic, strong) UIView *bottomView;

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

-(void)updateView{
    _arrActivity = [[RC_SQLiteManager shareManager]getAllActivityWithYear:year andMonth:month andDay:nil];
    [activityTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showReturn = YES;
//    [self setNavTitle:LocalizedString(@"Calendar", nil)];
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_sideslip"] andHighlightedImage:nil];
    self.showDone = YES;
    [self setDoneBtnTitleColor:colorWithHexString(@"#44dcca")];
    [self setDoneBtnTitle:LocalizedString(@"Toady", nil)];
    
    [_lblHelp1 setText:LocalizedString(@"helpCalendar1", nil)];
    [_lblHelp2 setText:LocalizedString(@"helpCalendar2", nil)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateView) name:NOTIFICATION_UPDATEVIEW object:nil];
    
//    [[RC_SQLiteManager shareManager]deleteTable:TNTActivity];
    
    calendarView = [[PWSCalendarView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 320) CalendarType:en_calendar_type_month];
    __weak CalendarViewController *weakSelf = self;
    [calendarView setChangeMonthBlock:^(NSDate *date) {
        [weakSelf setTitleDate:date];
    }];
    [calendarView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:calendarView];
    [calendarView setDelegate:self];
    
    _bottomView = [[UIView alloc]init];
    _bottomView.userInteractionEnabled = YES;
    [_bottomView setBackgroundColor:colorWithHexString(@"#eeeeee")];
    [_bottomView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    [self.view addSubview:_bottomView];
    
    _btnUpOrDown = [[UIButton alloc]init];
    [_btnUpOrDown setFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [_btnUpOrDown setImage:[UIImage imageNamed:@"ic_pull"] forState:UIControlStateNormal];
    [_btnUpOrDown setBackgroundColor:colorWithHexString(@"#f9f9f9")];
    [_btnUpOrDown addTarget:self action:@selector(pressUpOrDown:) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(followFinger:)];
    [_btnUpOrDown addGestureRecognizer:panGesture];
    //    [self.view addSubview:_btnUpOrDown];
    [_bottomView addSubview:_btnUpOrDown];
    
    NSString *showHelp = [[NSUserDefaults standardUserDefaults]objectForKey:SHOWHELPKEY];
    if (showHelp) {
        
    }
    else
    {
        [_helpView setFrame:CGRectMake(5, CGRectGetMaxY(_btnUpOrDown.frame)+5, CGRectGetWidth(_helpView.frame), CGRectGetHeight(_helpView.frame))];
        [_bottomView addSubview:_helpView];
    }
    
    
    
    activityTableView = [[UITableView alloc]init];
    [activityTableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
    activityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    activityTableView.delegate = self;
    activityTableView.dataSource = self;
    [activityTableView setFrame:CGRectMake(0, CGRectGetHeight(calendarView.frame), ScreenWidth, ScreenHeight-20-CGRectGetHeight(calendarView.frame))];
    //    [self.view insertSubview:activityTableView atIndex:0];
//    [self.view addSubview:activityTableView];
    activityTableView.backgroundColor = colorWithHexString(@"#eeeeee");
    [self setTitleDate:[NSDate date]];
    [_bottomView addSubview:activityTableView];
    
//    [self.view bringSubviewToFront:_helpView];
    [self.view bringSubviewToFront:_btnAddActivity];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateView];
}

- (IBAction)closeHelp:(id)sender {
    [_helpView removeFromSuperview];
    [activityTableView setFrame:CGRectMake(0, CGRectGetMaxY(_btnUpOrDown.frame)+5, ScreenWidth, CGRectGetHeight(_bottomView.frame)-25)];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:SHOWHELPKEY];
}

- (IBAction)addActivity:(id)sender {
    [IS_MobAndAnalyticsManager event:@"Calendar" label:@"calendar_addnew"];
    CreateActivityViewController *createActivity = [[CreateActivityViewController alloc]init];
    __weak CalendarViewController *weakSelf = self;
    [createActivity setActivityFinishBlock:^(ActivityInfo *info,BOOL isNew) {
        if (isNew) {
            [weakSelf addNewActivity:info];
        }
        else
        {
            [weakSelf updateActivity:info];
        }
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

-(void)updateActivity:(ActivityInfo *)info
{
    [[RC_SQLiteManager shareManager]updateActivityInfo:info];
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
    year = yearFromDate(date);
    month = monthFromDate(date);
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShowActivityViewController *showActivity = [[ShowActivityViewController alloc]init];
    showActivity.activityInfo = [_arrActivity objectAtIndex:indexPath.row];
    __weak CalendarViewController *weakSelf = self;
    [showActivity setDeleteBlock:^(ActivityInfo *info) {
        [weakSelf deleteCollection:info];
    }];
    [showActivity setActivityFinishBlock:^(ActivityInfo *info,BOOL isNew) {
        if (isNew) {
            [weakSelf addNewActivity:info];
        }
        else
        {
            [weakSelf updateActivity:info];
        }
    }];

    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:showActivity];
    [self presentViewController:nav animated:YES completion:nil];
    
//    CreateActivityViewController *createActivity = [[CreateActivityViewController alloc]init];
//    createActivity.activityInfo = [_arrActivity objectAtIndex:indexPath.row];
//    createActivity.type = 1;
//    __weak CalendarViewController *weakSelf = self;
//    [createActivity setDeleteBlock:^(ActivityInfo *info) {
//        [weakSelf deleteCollection:info];
//    }];
//    [createActivity setActivityFinishBlock:^(ActivityInfo *info,BOOL isNew) {
//        if (isNew) {
//            [weakSelf addNewActivity:info];
//        }
//        else
//        {
//            [weakSelf updateActivity:info];
//        }
//    }];
//    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:createActivity];
//    [self presentViewController:nav animated:YES completion:nil];
}

-(void)deleteCollection:(ActivityInfo *)info
{
    [[RC_SQLiteManager shareManager]deleteActivityInfo:info];
    _arrActivity = [[RC_SQLiteManager shareManager]getAllActivityWithYear:year andMonth:month andDay:nil];
    [activityTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrActivity.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [cell.lblWeek setText:weekdayStringFromDate(info.dateStartTime)];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    
    if (currentPostion - _lastPosition > 20  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可）
        
        _lastPosition = currentPostion;
        
        NSLog(@"ScrollUp now");
        [self moveUp:YES];
    }
//    else if (currentPostion == CGRectGetHeight(scrollView.frame))
//    {
//        [self moveUp:NO];
//    }
//
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
        [_bottomView setFrame:CGRectMake(0, CGRectGetHeight(calendarView.frame)-5, ScreenWidth, ScreenHeight-(CGRectGetHeight(calendarView.frame)-5)-64)];
        [activityTableView setFrame:CGRectMake(0, CGRectGetMaxY(_btnUpOrDown.frame)+5, ScreenWidth, CGRectGetHeight(_bottomView.frame)-25)];
    }
    else
    {
        _helpView.hidden = NO;
        [_bottomView setFrame:CGRectMake(0, CGRectGetHeight(calendarView.frame)-5, ScreenWidth, ScreenHeight-(CGRectGetHeight(calendarView.frame)-5)-64)];
        [activityTableView setFrame:CGRectMake(0, CGRectGetMaxY(_helpView.frame)+5, ScreenWidth, CGRectGetHeight(_bottomView.frame)-CGRectGetMaxY(_helpView.frame)-5)];
    }
}

-(void)followFinger:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state]== UIGestureRecognizerStateBegan)
    {
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [recognizer locationInView:self.view];
        if ((0 < point.y) && (point.y < (CGRectGetMaxY(calendarView.frame)-5))) {
            
            NSString *showHelp = [[NSUserDefaults standardUserDefaults]objectForKey:SHOWHELPKEY];
            if (showHelp) {
                _helpView.hidden = YES;
                [_bottomView setFrame:CGRectMake(0, point.y, ScreenWidth, ScreenHeight-64-point.y)];
                [activityTableView setFrame:CGRectMake(0, CGRectGetMaxY(_btnUpOrDown.frame)+5, ScreenWidth, CGRectGetHeight(_bottomView.frame)-25)];
            }
            else
            {
                _helpView.hidden = NO;
                [_bottomView setFrame:CGRectMake(0, point.y, ScreenWidth, ScreenHeight-64-point.y)];
                [activityTableView setFrame:CGRectMake(0, CGRectGetMaxY(_helpView.frame)+5, ScreenWidth, CGRectGetHeight(_bottomView.frame)-CGRectGetMaxY(_helpView.frame)-5)];
            }
        }
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
    }
}

-(void)moveUp:(BOOL)up
{
    if (up)
    {
        [UIView animateWithDuration:0.5f animations:^{
            NSString *showHelp = [[NSUserDefaults standardUserDefaults]objectForKey:SHOWHELPKEY];
            if (showHelp) {
                _helpView.hidden = YES;
                [_bottomView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
                [activityTableView setFrame:CGRectMake(0, CGRectGetMaxY(_btnUpOrDown.frame)+5, ScreenWidth, CGRectGetHeight(_bottomView.frame)-25)];
            }
            else
            {
                _helpView.hidden = NO;
                [_bottomView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
                [activityTableView setFrame:CGRectMake(0, CGRectGetMaxY(_helpView.frame)+5, ScreenWidth, CGRectGetHeight(_bottomView.frame)-CGRectGetMaxY(_helpView.frame)-5)];
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            NSString *showHelp = [[NSUserDefaults standardUserDefaults]objectForKey:SHOWHELPKEY];
            if (showHelp) {
                _helpView.hidden = YES;
                [_bottomView setFrame:CGRectMake(0, CGRectGetHeight(calendarView.frame)-5, ScreenWidth, ScreenHeight-(CGRectGetHeight(calendarView.frame)-5)-64)];
                [activityTableView setFrame:CGRectMake(0, CGRectGetMaxY(_btnUpOrDown.frame)+5, ScreenWidth, CGRectGetHeight(_bottomView.frame)-25)];
            }
            else
            {
                _helpView.hidden = NO;
                [_bottomView setFrame:CGRectMake(0, CGRectGetHeight(calendarView.frame)-5, ScreenWidth, ScreenHeight-(CGRectGetHeight(calendarView.frame)-5)-64)];
                [activityTableView setFrame:CGRectMake(0, CGRectGetMaxY(_helpView.frame)+5, ScreenWidth, CGRectGetHeight(_bottomView.frame)-CGRectGetMaxY(_helpView.frame)-5)];
            }
        }];
    }
}

- (IBAction)pressUpOrDown:(id)sender {
    if (_bottomView.frame.origin.y == 0) {
        [self moveUp:NO];
    }
    else
    {
        [self moveUp:YES];
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
