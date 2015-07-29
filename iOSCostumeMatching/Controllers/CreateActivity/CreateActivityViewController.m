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

#define GAPWIDTH 10.0

@interface CreateActivityViewController ()<UITextFieldDelegate>
{
    UIScrollView *scrollView;
    UIView *addImageView;
    BOOL isAllDay;
    NSDate *startTime;
    NSDate *endTime;
    int firstRemind;
    int secondRemind;
    ActivityColor color;
    
    BOOL setStartTime;
}
@property (strong, nonatomic) IBOutlet UIView *actionView;

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


@property (nonatomic, copy) void(^finish)(ActivityInfo *info);



@end

@implementation CreateActivityViewController

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    ActivityInfo *activityInfo = [[ActivityInfo alloc]init];
    activityInfo.numId = [NSNumber numberWithInt:1];
    activityInfo.strTitle = _addTitle.text;
    activityInfo.strLocation = _txtLocation.text;
    activityInfo.numIsAllDay = [NSNumber numberWithBool:isAllDay];
    activityInfo.dateStartTime = startTime;
    activityInfo.dateFinishTime = endTime;
    activityInfo.dateFirstRemindTime = [NSDate date];
    activityInfo.dateSecondRemindTime = [NSDate date];
    activityInfo.numColor = [NSNumber numberWithInt:color];
    activityInfo.arrData = _dataArray;
    activityInfo.strYear = yearFromDate(startTime);
    activityInfo.strMonth = monthFromDate(startTime);
    activityInfo.strDay = dayFromDate(startTime);
    if (_finish) {
        _finish(activityInfo);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setActivityFinishBlock:(void (^)(ActivityInfo *))activityfinishBlock
{
    _finish = activityfinishBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"新建活动"];
    self.showReturn = YES;
    [self setReturnBtnTitle:@"取消"];
    self.showDone = YES;
    [self setDoneBtnTitle:@"保存"];
    
    isAllDay = NO;
    _dataArray = [[NSMutableArray alloc]init];
    
    addImageView = [[UIView alloc]init];
    [addImageView setFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    [addImageView setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:addImageView];
    
    scrollView = [[UIScrollView alloc]init];
    [scrollView setFrame:CGRectMake(0, CGRectGetHeight(addImageView.frame), ScreenWidth, ScreenHeight-NavBarHeight-20)];
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = self.actionView.frame.size;
    [scrollView addSubview:_actionView];
    
    [_dateView setFrame:CGRectMake(0, ScreenHeight-64, ScreenWidth, CGRectGetHeight(_dateView.frame))];
    [_dateAndTimeView setFrame:CGRectMake(0, ScreenHeight-64, ScreenWidth, CGRectGetHeight(_dateAndTimeView.frame))];
    [self.view addSubview:_dateView];
    [self.view addSubview:_dateAndTimeView];
    
    
    _addTitle.delegate = self;
    _txtLocation.delegate = self;
    // Do any additional setup after loading the view from its nib.
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
    for (id view in addImageView.subviews) {
        [view removeFromSuperview];
    }
    if (_dataArray.count>0) {
        __weak CreateActivityViewController *weakSelf = self;
        CGFloat itemWidth = (ScreenWidth-40.0) / 3.0;
        for (int i=0; i<_dataArray.count; i++) {
            id data = [_dataArray objectAtIndex:i];
            ItemView *itemView = [[ItemView alloc]initWithFrame:CGRectMake(i%3*(itemWidth+GAPWIDTH)+GAPWIDTH, GAPWIDTH+(i/3)*(itemWidth+GAPWIDTH), itemWidth, itemWidth)];
            itemView.info = data;
            [itemView setDeleteBlock:^(id info,id item) {
                [weakSelf removeItem:item andInfo:info];
            }];
            [addImageView addSubview:itemView];
        }
        [addImageView setFrame:CGRectMake(0, 0, ScreenWidth, ceilf(_dataArray.count/3.0)*(itemWidth+GAPWIDTH))];
        [scrollView setFrame:CGRectMake(0, CGRectGetHeight(addImageView.frame), ScreenWidth, ScreenHeight-NavBarHeight-20-CGRectGetHeight(addImageView.frame))];
    }
    else
    {
        [addImageView setFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        [scrollView setFrame:CGRectMake(0, CGRectGetHeight(addImageView.frame), ScreenWidth, ScreenHeight-NavBarHeight-20)];
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
    [_dataArray addObject:object];
    [self updateView];
}

- (IBAction)isAllDay:(id)sender {
    UISwitch *s = sender;
    isAllDay = s.on;
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
    [selectFirstRemind setNavagationTitle:@"选择时间"];
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
        [weakSelf.btnRemind setTitle:title forState:UIControlStateNormal] ;
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectFirstRemind];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)setSecondRemind:(id)sender {
    SelectViewController *selectFirstRemind = [[SelectViewController alloc]init];
    [selectFirstRemind setNavagationTitle:@"选择时间"];
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
        [weakSelf.btnSecondRemind setTitle:title forState:UIControlStateNormal] ;
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectFirstRemind];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)setColor:(id)sender {
    SelectViewController *selectColor = [[SelectViewController alloc]init];
    [selectColor setNavagationTitle:@"选择颜色"];
    selectColor.array = getAllColor();
    
    __weak CreateActivityViewController *weakSelf = self;
    [selectColor setSelectedBlock:^(int index) {
        color = index;
        [weakSelf.btnColor setTitle:getColorName(color) forState:UIControlStateNormal] ;
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:selectColor];
    [self presentViewController:nav animated:YES completion:nil];
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
