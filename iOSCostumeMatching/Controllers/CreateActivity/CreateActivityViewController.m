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

#define GAPWIDTH 10.0

@interface CreateActivityViewController ()<UITextFieldDelegate>
{
    UIScrollView *scrollView;
    UIView *addImageView;
}
@property (strong, nonatomic) IBOutlet UIView *actionView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITextField *addTitle;

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
    activityInfo.strTitle = @"lalalal";
    activityInfo.strLocation = @"bei";
    activityInfo.numIsAllDay = [NSNumber numberWithBool:YES];
    activityInfo.dateStartTime = [NSDate date];
    activityInfo.dateFinishTime = [NSDate date];
    activityInfo.dateFirstRemindTime = [NSDate date];
    activityInfo.dateSecondRemindTime = [NSDate date];
    activityInfo.numColor = [NSNumber numberWithInt:1];
    activityInfo.arrData = _dataArray;
    activityInfo.strYear = @"2015";
    activityInfo.strMonth = @"2015";
    activityInfo.strDay = @"2015";
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
    
    _addTitle.delegate = self;
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
