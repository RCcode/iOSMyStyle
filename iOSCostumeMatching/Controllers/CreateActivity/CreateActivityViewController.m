//
//  CreateActivityViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/21.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "CreateActivityViewController.h"
#import "MyWardrobeViewController.h"
#import "MyCollectionViewController.h"
#import "ItemView.h"
#import "SelectViewController.h"

#define GAPWIDTH 8.0

@interface CreateActivityViewController ()<UITextFieldDelegate>
{
    UIScrollView *scrollView;
    UIScrollView *addImageScrollView;
    BOOL isAllDay;
    NSDate *startTime;
    NSDate *endTime;
    NSInteger firstRemind;
    NSInteger secondRemind;
    ActivityColor color;
    
    BOOL setStartTime;
}
@property (strong, nonatomic) IBOutlet UIView *actionView;
@property (strong, nonatomic) IBOutlet UIView *addClotheOrCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;



@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITextField *addTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;


@property (weak, nonatomic) IBOutlet UISwitch *switchAllDay;
@property (weak, nonatomic) IBOutlet UIButton *btnStartTime;
@property (weak, nonatomic) IBOutlet UIButton *btnEndTime;
@property (weak, nonatomic) IBOutlet UIButton *btnRemind;
@property (weak, nonatomic) IBOutlet UIButton *btnSecondRemind;
@property (weak, nonatomic) IBOutlet UIButton *btnColor;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateAndTimePicker;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UIView *dateAndTimeView;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstRemind;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondRemind;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (weak, nonatomic) IBOutlet UIButton *btnClothes;
@property (weak, nonatomic) IBOutlet UIButton *btnMacthing;

@property (nonatomic, copy) void(^finish)(ActivityInfo *info,BOOL isNew);
@property (nonatomic, copy) void(^delete)(ActivityInfo *info);

@property (weak, nonatomic) IBOutlet UILabel *lblAllDay;
@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lblFinish;
@property (weak, nonatomic) IBOutlet UILabel *lblRemind;
@property (weak, nonatomic) IBOutlet UILabel *lbl2Remind;
@property (weak, nonatomic) IBOutlet UILabel *lblColor;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnDone2;


@end

@implementation CreateActivityViewController

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    [IS_MobAndAnalyticsManager event:@"Calendar" label:@"calendar_addnew_save"];
    if(_dataArray.count == 0)
    {
        showLabelHUD(LocalizedString(@"SelectAlert", nil));
        return;
    }
    
    ActivityInfo *activityInfo = [[ActivityInfo alloc]init];
    activityInfo.numId = [NSNumber numberWithInt:1];
    activityInfo.strTitle = _addTitle.text;
    activityInfo.strLocation = _txtLocation.text;
    activityInfo.numIsAllDay = [NSNumber numberWithBool:isAllDay];
    activityInfo.dateStartTime = startTime;
    activityInfo.dateFinishTime = endTime;
    activityInfo.firstRemindTime = [NSNumber numberWithInteger:firstRemind];
    activityInfo.secondRemindTime = [NSNumber numberWithInteger:secondRemind];
    activityInfo.numColor = [NSNumber numberWithInt:color];
    activityInfo.arrData = _dataArray;
    activityInfo.numYear = [NSNumber numberWithInt:[yearFromDate(startTime) intValue]];
    activityInfo.numMonth = [NSNumber numberWithInt:[monthFromDate(startTime) intValue]];
    activityInfo.numDay = [NSNumber numberWithInt:[dayFromDate(startTime) intValue]];
    if (_finish) {
        if (_type == 1) {
            _finish(activityInfo,NO);
        }
        else
        {
            _finish(activityInfo,YES);
        }
    }
    if (_type == 1) {
        [self isAddRemind:NO andRemindTime:_activityInfo.dateStartTime andFirstRemind:[_activityInfo.firstRemindTime integerValue] andSecondRemind:[_activityInfo.secondRemindTime integerValue] isAllDay:[_activityInfo.numIsAllDay boolValue] andContent:[NSString stringWithFormat:@"%@,%@",_activityInfo.strTitle,_activityInfo.strLocation]];
    }
    [self isAddRemind:YES andRemindTime:startTime andFirstRemind:firstRemind andSecondRemind:secondRemind isAllDay:isAllDay andContent:[NSString stringWithFormat:@"%@,%@",_addTitle.text,_txtLocation.text]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)isAddRemind:(BOOL)isAdd andRemindTime:(NSDate *)_startTime andFirstRemind:(NSInteger)_firstRemind andSecondRemind:(NSInteger)_secondRemind isAllDay:(BOOL)_isAllDay andContent:(NSString *)content
{
    if (_isAllDay) {
        NSDate *firstReminddate;
        switch ((AllDayRemind)_firstRemind) {
            case ADR_none:
            {
                break;
            }
            case ADR_intraday:
            {
                firstReminddate = _startTime;
                break;
            }
            case ADR_before1day:
            {
                firstReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60 sinceDate:_startTime];
                break;
            }
            case ADR_before2day:
            {
                firstReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60*2 sinceDate:_startTime];
                break;
            }
            case ADR_before3day:
            {
                firstReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60*3 sinceDate:_startTime];
                break;
            }
            case ADR_before1week:
            {
                firstReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60*7 sinceDate:_startTime];
                break;
            }
            default:
                break;
        }
        NSDate *secondReminddate;
        switch ((AllDayRemind)_secondRemind) {
            case ADR_none:
            {
                break;
            }
            case ADR_intraday:
            {
                secondReminddate = _startTime;
                break;
            }
            case ADR_before1day:
            {
                secondReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60 sinceDate:_startTime];
                break;
            }
            case ADR_before2day:
            {
                secondReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60*2 sinceDate:_startTime];
                break;
            }
            case ADR_before3day:
            {
                secondReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60*3 sinceDate:_startTime];
                break;
            }
            case ADR_before1week:
            {
                secondReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60*7 sinceDate:_startTime];
                break;
            }
            default:
                break;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        if (firstReminddate) {
            NSString *firstDateString = [dateFormatter stringFromDate:firstReminddate];
            NSString *finalString = [NSString stringWithFormat:@"%@-09",firstDateString];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd-HH"];
            NSDate *date=[formatter dateFromString:finalString];
            [self addPushWithStartTime:date andContent:content];
        }
        if (secondReminddate)
        {
            NSString *secondDateString = [dateFormatter stringFromDate:secondReminddate];
            NSString *finalString = [NSString stringWithFormat:@"%@-09",secondDateString];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd-HH"];
            NSDate *date=[formatter dateFromString:finalString];
            [self addPushWithStartTime:date andContent:content];
        }
        
    }
    else
    {
        NSDate *firstReminddate;
        switch ((NotAllDayRemind)_firstRemind) {
            case NADR_none:
            {
                break;
            }
            case NADR_before1hour:
            {
                firstReminddate = [[NSDate alloc]initWithTimeInterval:-60*60 sinceDate:_startTime];
                break;
            }
            case NADR_before2hour:
            {
                firstReminddate = [[NSDate alloc]initWithTimeInterval:-60*60*2 sinceDate:_startTime];
                break;
            }
            case NADR_before3hour:
            {
                firstReminddate = [[NSDate alloc]initWithTimeInterval:-60*60*3 sinceDate:_startTime];
                break;
            }
            case NADR_before5hour:
            {
                firstReminddate = [[NSDate alloc]initWithTimeInterval:-60*60*5 sinceDate:_startTime];
                break;
            }
            case NADR_before1day:
            {
                firstReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60 sinceDate:_startTime];
                break;
            }
            case NADR_before2day:
            {
                firstReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60*2 sinceDate:_startTime];
                break;
            }
            case NADR_before1week:
            {
                firstReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60*7 sinceDate:_startTime];
                break;
            }
            default:
                break;
        }
        NSDate *secondReminddate;
        switch ((NotAllDayRemind)_secondRemind) {
            case NADR_none:
            {
                break;
            }
            case NADR_before1hour:
            {
                secondReminddate = [[NSDate alloc]initWithTimeInterval:-60*60 sinceDate:_startTime];
                break;
            }
            case NADR_before2hour:
            {
                secondReminddate = [[NSDate alloc]initWithTimeInterval:-60*60*2 sinceDate:_startTime];
                break;
            }
            case NADR_before3hour:
            {
                secondReminddate = [[NSDate alloc]initWithTimeInterval:-60*60*3 sinceDate:_startTime];
                break;
            }
            case NADR_before5hour:
            {
                secondReminddate = [[NSDate alloc]initWithTimeInterval:-60*60*5 sinceDate:_startTime];
                break;
            }
            case NADR_before1day:
            {
                secondReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60 sinceDate:_startTime];
                break;
            }
            case NADR_before2day:
            {
                secondReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60*2 sinceDate:_startTime];
                break;
            }
            case NADR_before1week:
            {
                secondReminddate = [[NSDate alloc]initWithTimeInterval:-24*60*60*7 sinceDate:_startTime];
                break;
            }
            default:
                break;
        }
        
        if (firstReminddate) {
            if (isAdd) {
                [self addPushWithStartTime:firstReminddate andContent:content];
            }
            else
            {
                [self removePushWithStartTime:firstReminddate andContent:content];
            }
        }
        if (secondReminddate) {
            if (isAdd) {
                [self addPushWithStartTime:secondReminddate andContent:content];
            }
            else
            {
                [self removePushWithStartTime:secondReminddate andContent:content];
            }
        }
    }
}

-(void)removePushWithStartTime:(NSDate *)date andContent:(NSString *)content
{
    NSArray *arr = [[UIApplication sharedApplication]scheduledLocalNotifications];
    for (UILocalNotification *localNotification in arr) {
        if ([localNotification.fireDate isEqualToDate:date] && [localNotification.alertBody isEqualToString:content]) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            break;
        }
    }
}

-(void)addPushWithStartTime:(NSDate *)date andContent:(NSString *)content
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    
    notification.repeatInterval = kCFCalendarUnitEra;
    
    notification.timeZone=[NSTimeZone defaultTimeZone];
    
    notification.applicationIconBadgeNumber = 1;
    
    notification.fireDate = date;
    
    notification.alertBody=content;
    
    notification.alertAction = @"打开";
    
    // 通知提示音 使用默认的
    
    notification.soundName= UILocalNotificationDefaultSoundName;
    
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)setActivityFinishBlock:(void (^)(ActivityInfo *,BOOL isNew))activityfinishBlock
{
    _finish = activityfinishBlock;
}

-(void)setDeleteBlock:(void (^)(ActivityInfo *))deleteBlock
{
    _delete = deleteBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:LocalizedString(@"New_Event", nil)];
    self.showReturn = YES;
    self.showDone = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_close"] andHighlightedImage:nil];
    [self setDoneBtnTitleColor:colorWithHexString(@"#44dcca")];
    [self setDoneBtnTitle:LocalizedString(@"Save", nil)];
    
    [_btnClothes setTitle:[NSString stringWithFormat:@" + %@",LocalizedString(@"Closet", nil)] forState:UIControlStateNormal];
    [_btnMacthing setTitle:[NSString stringWithFormat:@" + %@",LocalizedString(@"Outfits", nil)] forState:UIControlStateNormal];
    
    [_lblAllDay setText:LocalizedString(@"All_day", nil)];
    [_txtLocation setPlaceholder:LocalizedString(@"Location", nil)];
    [_addTitle setPlaceholder:LocalizedString(@"Title", nil)];
    [_lblStartTime setText:LocalizedString(@"Starts", nil)];
    [_lblFinish setText:LocalizedString(@"Ends", nil)];
    [_lblRemind setText:LocalizedString(@"Alert", nil)];
    [_lbl2Remind setText:LocalizedString(@"Second_Alert", nil)];
    [_lblColor setText:LocalizedString(@"Color", nil)];
    
    [_btnDone setTitle:LocalizedString(@"DONE", nil) forState:UIControlStateNormal];
    [_btnDone2 setTitle:LocalizedString(@"DONE", nil) forState:UIControlStateNormal];
    
    isAllDay = NO;
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    addImageScrollView = [[UIScrollView alloc]init];
    [addImageScrollView setFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    [addImageScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:addImageScrollView];
    
    [self.view addSubview:_addClotheOrCollectionView];
    
    scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = self.actionView.frame.size;
    scrollView.backgroundColor = colorWithHexString(@"#eeeeee");
    [scrollView addSubview:_actionView];
    
    [_dateView setFrame:CGRectMake(0, ScreenHeight-64, ScreenWidth, CGRectGetHeight(_dateView.frame))];
    [_dateAndTimeView setFrame:CGRectMake(0, ScreenHeight-64, ScreenWidth, CGRectGetHeight(_dateAndTimeView.frame))];
    [self.view addSubview:_dateView];
    [self.view addSubview:_dateAndTimeView];
    
    _txtLocation.textColor = colorWithHexString(@"#aeaeae");
    _addTitle.textColor = colorWithHexString(@"#aeaeae");
    _txtLocation.font = [UIFont systemFontOfSize:13];
    _addTitle.font = [UIFont systemFontOfSize:13];
    
    _switchAllDay.onTintColor = colorWithHexString(@"#44dcca");
    
    startTime = [NSDate date];
    endTime = [NSDate date];
    [_btnStartTime setTitle:stringNotAllDayFromDate(startTime) forState:UIControlStateNormal];
    [_btnEndTime setTitle:stringNotAllDayFromDate(endTime) forState:UIControlStateNormal];
    
    [_lblFirstRemind setText:getNotAllDayRemindName((NotAllDayRemind)firstRemind)];
    [_lblSecondRemind setText:getNotAllDayRemindName((NotAllDayRemind)secondRemind)];
    
    _colorView.layer.cornerRadius = CGRectGetWidth(_colorView.frame)/2;
    [_colorView setBackgroundColor:getColor(color)];
    
    if (_type == 1) {
        _btnDelete.hidden = NO;
        [_dataArray addObjectsFromArray:_activityInfo.arrData];
        
        _addTitle.text = _activityInfo.strTitle;
        _txtLocation.text = _activityInfo.strLocation;
        isAllDay = [_activityInfo.numIsAllDay boolValue];
        [_switchAllDay setOn:isAllDay];
        startTime = _activityInfo.dateStartTime;
        endTime = _activityInfo.dateFinishTime;
        
        firstRemind = [_activityInfo.firstRemindTime integerValue];
        secondRemind = [_activityInfo.secondRemindTime integerValue];
        
        if (isAllDay) {
            [_btnStartTime setTitle:stringAllDayFromDate(startTime) forState:UIControlStateNormal];
            [_btnEndTime setTitle:stringAllDayFromDate(endTime) forState:UIControlStateNormal];
            [_lblFirstRemind setText:getAllDayRemindName((AllDayRemind)firstRemind)];
            [_lblSecondRemind setText:getAllDayRemindName((AllDayRemind)secondRemind)];
        }
        else
        {
            [_btnStartTime setTitle:stringNotAllDayFromDate(startTime) forState:UIControlStateNormal];
            [_btnEndTime setTitle:stringNotAllDayFromDate(endTime) forState:UIControlStateNormal];
            [_lblFirstRemind setText:getNotAllDayRemindName((NotAllDayRemind)firstRemind)];
            [_lblSecondRemind setText:getNotAllDayRemindName((NotAllDayRemind)secondRemind)];
        }
        color = (ActivityColor)[_activityInfo.numColor integerValue];
        [_colorView setBackgroundColor:getColor(color)];
    }
    else
    {
        _btnDelete.hidden = YES;
    }
    [self updateView];
    
    _addTitle.delegate = self;
    _txtLocation.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDelete)];
    _addClotheOrCollectionView.userInteractionEnabled = YES;
    [_addClotheOrCollectionView addGestureRecognizer:tap];
    
    [addImageScrollView addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}

-(void)hideDelete
{
    for (id v in addImageScrollView.subviews) {
        if ([v isKindOfClass:[ItemView class]]) {
            ItemView *item = v;
            [item setDeleteHide:YES];
        }
    }
}

- (void)viewDidLayoutSubviews
{
    [_addClotheOrCollectionView setFrame:CGRectMake(0, CGRectGetHeight(addImageScrollView.frame), ScreenWidth, CGRectGetHeight(_addClotheOrCollectionView.frame))];
    [scrollView setFrame:CGRectMake(0, CGRectGetMaxY(_addClotheOrCollectionView.frame), ScreenWidth, ScreenHeight-64-CGRectGetMaxY(_addClotheOrCollectionView.frame))];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)removeItem:(id)item andInfo:(id)info
{
    UIView *v = item;
    [v removeFromSuperview];
    [_dataArray removeObject:info];
    [self updateView];
}

-(void)updateView
{
    for (id view in addImageScrollView.subviews) {
        [view removeFromSuperview];
    }
    if (_dataArray.count>0) {
        __weak CreateActivityViewController *weakSelf = self;
        CGFloat itemWidth = 77;
        for (int i=0; i<_dataArray.count; i++) {
            id data = [_dataArray objectAtIndex:i];
            ItemView *itemView = [[ItemView alloc]initWithFrame:CGRectMake(i*(itemWidth+GAPWIDTH)+GAPWIDTH, GAPWIDTH, itemWidth, itemWidth)];
            itemView.info = data;
            [itemView setDeleteBlock:^(id info,id item) {
                [weakSelf removeItem:item andInfo:info];
            }];
            [addImageScrollView addSubview:itemView];
        }
        [addImageScrollView setFrame:CGRectMake(0, 0, ScreenWidth, 93)];
        [addImageScrollView setContentSize:CGSizeMake(_dataArray.count*(itemWidth+GAPWIDTH)+GAPWIDTH, CGRectGetHeight(addImageScrollView.frame))];
    }
    else
    {
        [addImageScrollView setFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        [addImageScrollView setContentSize:CGSizeMake(0, CGRectGetHeight(addImageScrollView.frame))];
    }
}

- (IBAction)addClothes:(id)sender {
    MyWardrobeViewController *myWardrobe = [[MyWardrobeViewController alloc]init];
    __weak CreateActivityViewController *weakSelf = self;
    [myWardrobe setSelectBlock:^(ClothesInfo *info) {
        [weakSelf addClothesOrCollection:info];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:myWardrobe];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)addColloction:(id)sender {
    MyCollectionViewController *myCollection = [[MyCollectionViewController alloc]init];
    __weak CreateActivityViewController *weakSelf = self;
    [myCollection setSelectBlock:^(CollocationInfo *info) {
        [weakSelf addClothesOrCollection:info];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:myCollection];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)addClothesOrCollection:(id)object
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    [_dataArray addObject:object];
    [self updateView];
}

- (IBAction)isAllDay:(id)sender {
    UISwitch *s = sender;
    isAllDay = s.on;
    if (isAllDay) {
        [_btnStartTime setTitle:stringAllDayFromDate(startTime) forState:UIControlStateNormal];
        [_btnEndTime setTitle:stringAllDayFromDate(endTime) forState:UIControlStateNormal];
    }
    else
    {
        [_btnStartTime setTitle:stringNotAllDayFromDate(startTime) forState:UIControlStateNormal];
        [_btnEndTime setTitle:stringNotAllDayFromDate(endTime) forState:UIControlStateNormal];
    }
}

- (IBAction)setStartTime:(id)sender {
    setStartTime = YES;
    if (isAllDay) {
        ViewAnimation(_dateView, CGRectMake(0, ScreenHeight-64-CGRectGetHeight(_dateView.frame), ScreenWidth, CGRectGetHeight(_dateView.frame)));
    }
    else
    {
        ViewAnimation(_dateAndTimeView, CGRectMake(0, ScreenHeight-64-CGRectGetHeight(_dateView.frame), ScreenWidth, CGRectGetHeight(_dateAndTimeView.frame)));
    }
}

- (IBAction)setEndTime:(id)sender {
    setStartTime = NO;
    if (isAllDay) {
        ViewAnimation(_dateView, CGRectMake(0, ScreenHeight-64-CGRectGetHeight(_dateView.frame), ScreenWidth, CGRectGetHeight(_dateView.frame)));
    }
    else
    {
        ViewAnimation(_dateAndTimeView, CGRectMake(0, ScreenHeight-64-CGRectGetHeight(_dateView.frame), ScreenWidth, CGRectGetHeight(_dateAndTimeView.frame)));
    }
}

- (IBAction)setFirstRemind:(id)sender {
    SelectViewController *selectFirstRemind = [[SelectViewController alloc]init];
    [selectFirstRemind setNavagationTitle:LocalizedString(@"Notification", nil)];
    if (isAllDay) {
        selectFirstRemind.array = getAllDayRemind();
    }
    else
    {
        selectFirstRemind.array = getNotAllDayRemind();
    }
    
    __weak CreateActivityViewController *weakSelf = self;
    [selectFirstRemind setSelectedBlock:^(int index) {
        firstRemind = index;
        NSString *title;
        if (isAllDay) {
            title = getAllDayRemindName(index);
        }
        else
        {
            title = getNotAllDayRemindName(index);
        }
//        [weakSelf.btnRemind setTitle:title forState:UIControlStateNormal] ;
        [weakSelf.lblFirstRemind setText:title];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectFirstRemind];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)setSecondRemind:(id)sender {
    SelectViewController *selectFirstRemind = [[SelectViewController alloc]init];
    [selectFirstRemind setNavagationTitle:LocalizedString(@"Notification", nil)];
    if (isAllDay) {
        selectFirstRemind.array = getAllDayRemind();
    }
    else
    {
        selectFirstRemind.array = getNotAllDayRemind();
    }
    
    __weak CreateActivityViewController *weakSelf = self;
    [selectFirstRemind setSelectedBlock:^(int index) {
        secondRemind = index;
        NSString *title;
        if (isAllDay) {
            title = getAllDayRemindName(index);
        }
        else
        {
            title = getNotAllDayRemindName(index);
        }
//        [weakSelf.btnSecondRemind setTitle:title forState:UIControlStateNormal] ;
        [weakSelf.lblSecondRemind setText:title];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectFirstRemind];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)setColor:(id)sender {
    SelectViewController *selectColor = [[SelectViewController alloc]init];
    selectColor.type = 1;
    [selectColor setNavagationTitle:@"选择颜色"];
    selectColor.array = getAllColor();
    
    __weak CreateActivityViewController *weakSelf = self;
    [selectColor setSelectedBlock:^(int index) {
        color = index;
        [weakSelf.colorView setBackgroundColor:getColor(index)];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectColor];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)pressDelete:(id)sender {
    if (_delete) {
        _delete(_activityInfo);
    }
    [self isAddRemind:NO andRemindTime:_activityInfo.dateStartTime andFirstRemind:[_activityInfo.firstRemindTime integerValue] andSecondRemind:[_activityInfo.secondRemindTime integerValue] isAllDay:[_activityInfo.numIsAllDay boolValue] andContent:[NSString stringWithFormat:@"%@,%@",_activityInfo.strTitle,_activityInfo.strLocation]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressDateDone:(id)sender {
    if (setStartTime) {
        startTime = _datePicker.date;
        [_btnStartTime setTitle:stringAllDayFromDate(startTime) forState:UIControlStateNormal];
    }
    else
    {
        endTime = _datePicker.date;
        [_btnEndTime setTitle:stringAllDayFromDate(endTime) forState:UIControlStateNormal];
    }
    ViewAnimation(_dateView, CGRectMake(0, ScreenHeight-64, ScreenWidth, CGRectGetHeight(_dateView.frame)));
}

- (IBAction)pressDateAndTimeDone:(id)sender {
    if (setStartTime) {
        startTime = _dateAndTimePicker.date;
        [_btnStartTime setTitle:stringNotAllDayFromDate(startTime) forState:UIControlStateNormal];
    }
    else
    {
        endTime = _dateAndTimePicker.date;
        [_btnEndTime setTitle:stringNotAllDayFromDate(endTime) forState:UIControlStateNormal];
    }
    ViewAnimation(_dateAndTimeView, CGRectMake(0, ScreenHeight-64, ScreenWidth, CGRectGetHeight(_dateAndTimeView.frame)));
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
