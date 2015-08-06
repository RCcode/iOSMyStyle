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


@property (nonatomic, copy) void(^finish)(ActivityInfo *info,BOOL isNew);
@property (nonatomic, copy) void(^delete)(ActivityInfo *info);


@end

@implementation CreateActivityViewController

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    if(_dataArray.count == 0)
    {
        showLabelHUD(@"请选择服装或搭配");
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self setNavTitle:@"新建活动"];
    self.showReturn = YES;
    self.showDone = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_close"] andHighlightedImage:nil];
    [self setDoneBtnTitleColor:colorWithHexString(@"#44dcca")];
    [self setDoneBtnTitle:@"完成"];
    
    isAllDay = NO;
    _dataArray = [[NSMutableArray alloc]init];
    
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
    
    _txtLocation.textColor = colorWithHexString(@"#c7c7c7");
    _addTitle.textColor = colorWithHexString(@"#c7c7c7");
    _txtLocation.font = [UIFont systemFontOfSize:13];
    _addTitle.font = [UIFont systemFontOfSize:13];
    
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
        [self updateView];
        
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
    
    _addTitle.delegate = self;
    _txtLocation.delegate = self;
    // Do any additional setup after loading the view from its nib.
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
//        [weakSelf.btnRemind setTitle:title forState:UIControlStateNormal] ;
        [weakSelf.lblFirstRemind setText:title];
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
