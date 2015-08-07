//
//  ShowClothesDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/17.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ShowClothesDetailsViewController.h"
#import "CreateActivityViewController.h"

@interface ShowClothesDetailsViewController ()<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, copy) void(^delete)(ClothesInfo *info);

@end

@implementation ShowClothesDetailsViewController

-(void)setDeleteBlock:(void (^)(ClothesInfo *))deleteBlock
{
    _delete = deleteBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"分享", nil];
    [actionSheet showInView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"详情"];
    self.showReturn = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    self.showDone = YES;
    [self setDoneBtnNormalImage:[UIImage imageNamed:@"ic_more"] andHighlightedImage:nil];
    
    [_imageView setImage:_clothesInfo.file];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (_clothesInfo.strBrand && ![_clothesInfo.strBrand isEqualToString:@""]) {
        [arr addObject:_clothesInfo.strBrand];
    }
    if (_clothesInfo.numCateId && [_clothesInfo.numCateId integerValue] != 0) {
        NSString *s = getWardrobeTypeName((WardrobeType)([_clothesInfo.numCateId integerValue]));
        if (s) {
            [arr addObject:s];
        }
    }
    if (_clothesInfo.numScateId && [_clothesInfo.numScateId integerValue] != 0) {
        NSString *s = getWardrobeCategoryeName((WardrobeCategory)([_clothesInfo.numScateId integerValue]));
        if (s) {
            [arr addObject:s];
        }
    }
    
    CGFloat originX = 0;
    CGFloat originY = 10;

    for (NSInteger i = 0; i<arr.count; i++) {
        
        NSMutableString *str = [arr objectAtIndex:i];
        
        CGRect rect = getTextLabelRectWithContentAndFont(str, [UIFont systemFontOfSize:11]);
        UILabel *label = [[UILabel alloc]init];
        CGFloat width = rect.size.width+20;
        if ((originX +width) > (ScreenWidth-20)) {
            originX = 0;
            originY = originY+30;
        }
        [label setFrame:CGRectMake(originX+20, originY, width, 25)];
        
        originX = originX+20+width;
        
        [label setTextAlignment:NSTextAlignmentCenter];
        label.backgroundColor = colorWithHexString(@"#c0e1d9");
        [label setTextColor:colorWithHexString(@"#ffffff")];
        [label setFont:[UIFont systemFontOfSize:11]];
        [_scrollView addSubview:label];
        [label setText:str];
    }
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CLog(@"删除");
        if (_delete) {
            _delete(_clothesInfo);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(buttonIndex == 1)
    {
        CLog(@"分享");
    }
}

- (IBAction)addCollection:(id)sender {
}

- (IBAction)addCalendar:(id)sender {
    CreateActivityViewController *createActivity = [[CreateActivityViewController alloc]init];
    [createActivity addClothesOrCollection:_clothesInfo];
    [createActivity setActivityFinishBlock:^(ActivityInfo *info,BOOL isNew) {
        [[RC_SQLiteManager shareManager]addActivityInfo:info];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:createActivity];
    [self presentViewController:nav animated:YES completion:nil];
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
