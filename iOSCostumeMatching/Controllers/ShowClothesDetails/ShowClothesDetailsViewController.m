//
//  ShowClothesDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/17.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ShowClothesDetailsViewController.h"
#import "CreateActivityViewController.h"
#import "CreateCollectionViewController.h"

@interface ShowClothesDetailsViewController ()<UIActionSheetDelegate,UIDocumentInteractionControllerDelegate>
{
    UIDocumentInteractionController *_documetnInteractionController;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnMatching;
@property (weak, nonatomic) IBOutlet UIButton *btnCalendar;

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
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:LocalizedString(@"Cancel", nil) destructiveButtonTitle:LocalizedString(@"Delete", nil) otherButtonTitles:LocalizedString(@"Share", nil), nil];
    [actionSheet showInView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:LocalizedString(@"Details", nil)];
    self.showReturn = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    self.showDone = YES;
    [self setDoneBtnNormalImage:[UIImage imageNamed:@"ic_more"] andHighlightedImage:nil];
    
    [_btnMatching setTitle:[NSString stringWithFormat:@" + %@",LocalizedString(@"Make_outfit", nil)] forState:UIControlStateNormal];
    [_btnCalendar setTitle:[NSString stringWithFormat:@" + %@",LocalizedString(@"Wear_it", nil)] forState:UIControlStateNormal];
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
    CGFloat originY = 15;

    for (NSInteger i = 0; i<arr.count; i++) {
        
        NSMutableString *str = [arr objectAtIndex:i];
        
        CGRect rect = getTextLabelRectWithContentAndFont(str, [UIFont systemFontOfSize:12]);
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
        [label setFont:[UIFont systemFontOfSize:12]];
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
        //保存本地 如果已存在，则删除
        if([[NSFileManager defaultManager] fileExistsAtPath:kToMorePath]){
            [[NSFileManager defaultManager] removeItemAtPath:kToMorePath error:nil];
        }
        
        NSData *imageData = UIImageJPEGRepresentation(_clothesInfo.file, 0.8);
        [imageData writeToFile:kToMorePath atomically:YES];
        
        NSURL *fileURL = [NSURL fileURLWithPath:kToMorePath];
        _documetnInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        _documetnInteractionController.delegate = self;
        _documetnInteractionController.UTI = @"com.instagram.photo";
        _documetnInteractionController.annotation = @{@"InstagramCaption":AppName};
        [_documetnInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
    }
}

- (IBAction)addCollection:(id)sender {
    CreateCollectionViewController *createCollection = [[CreateCollectionViewController alloc]init];
    createCollection.addClothesInfo = _clothesInfo;
    __weak ShowClothesDetailsViewController *weakSelf = self;
    [createCollection setCollectionFinishBlock:^(CollocationInfo *info) {
        [weakSelf addCollocation:info];
    }];
    RC_NavigationController *nav = [[RC_NavigationController alloc]initWithRootViewController:createCollection];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)addCollocation:(CollocationInfo *)info
{
    [[RC_SQLiteManager shareManager]addCollection:info];
    
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (userInfo) {
        showMBProgressHUD(nil, YES);
        [[RC_RequestManager shareManager]addCollocationWithCollocationInfo:info success:^(id responseObject) {
            CLog(@"%@",responseObject);
            hideMBProgressHUD();
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                if([[responseObject objectForKey:@"stat"] integerValue] == 10000)
                {
                    NSDictionary *dic = responseObject;
                    info.numCoId = [NSNumber numberWithInt:[[dic objectForKey:@"coId"] intValue]];
                    [[RC_SQLiteManager shareManager]addCollection:info];;
                }
            }
        } andFailed:^(NSError *error) {
            hideMBProgressHUD();
            CLog(@"%@",error);
        }];
    }
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
