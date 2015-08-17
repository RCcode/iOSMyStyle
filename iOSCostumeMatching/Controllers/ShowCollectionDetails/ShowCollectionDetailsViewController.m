//
//  ShowCollectionDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/20.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ShowCollectionDetailsViewController.h"
#import "CreateActivityViewController.h"
#import "IBActionSheet.h"

@interface ShowCollectionDetailsViewController ()<UIActionSheetDelegate,UIDocumentInteractionControllerDelegate,IBActionSheetDelegate>
{
    UIDocumentInteractionController *_documetnInteractionController;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnCalendar;

@property (nonatomic, copy) void(^delete)(CollocationInfo *info);
@end

@implementation ShowCollectionDetailsViewController

-(void)setDeleteBlock:(void (^)(CollocationInfo *))deleteBlock
{
    _delete = deleteBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    IBActionSheet *standardIBAS = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizedString(@"Cancel", nil) destructiveButtonTitle:LocalizedString(@"Delete", nil)  otherButtonTitlesArray:@[LocalizedString(@"Share", nil)]];
    
    [standardIBAS setButtonTextColor:colorWithHexString(@"#ff4b4b") forButtonAtIndex:0];
    [standardIBAS setButtonBackgroundColor:[UIColor whiteColor] forButtonAtIndex:0];
    [standardIBAS setFont:[UIFont systemFontOfSize:15] forButtonAtIndex:0];
    
    [standardIBAS setButtonTextColor:colorWithHexString(@"#222222") forButtonAtIndex:1];
    [standardIBAS setButtonBackgroundColor:[UIColor whiteColor] forButtonAtIndex:1];
    [standardIBAS setFont:[UIFont systemFontOfSize:15] forButtonAtIndex:1];
    
    [standardIBAS setButtonTextColor:colorWithHexString(@"#3a62d5") forButtonAtIndex:2];
    [standardIBAS setButtonBackgroundColor:[UIColor whiteColor] forButtonAtIndex:2];
    [standardIBAS setFont:[UIFont systemFontOfSize:15] forButtonAtIndex:2];
    
    [standardIBAS showInView:self.view];

//    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:LocalizedString(@"Cancel", nil) destructiveButtonTitle:LocalizedString(@"Delete", nil) otherButtonTitles:LocalizedString(@"Share", nil), nil];
//    [actionSheet showInView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:LocalizedString(@"Details", nil)];
    self.showReturn = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    self.showDone = YES;
    [self setDoneBtnNormalImage:[UIImage imageNamed:@"ic_more"] andHighlightedImage:nil];
    
    [_btnCalendar setTitle:[NSString stringWithFormat:@" + %@",LocalizedString(@"Wear_it", nil)] forState:UIControlStateNormal];
    
    [_imageView setImage:_collocationInfo.file];
    
    _lblDescription = [[UILabel alloc]init];
    [_lblDescription setFont:[UIFont systemFontOfSize:13]];
    [_lblDescription setTextColor:colorWithHexString(@"#222222")];
    [_lblDescription setFrame:CGRectMake(20, 5, ScreenWidth-20, 20)];
    [_scrollView addSubview:_lblDescription];
    [_lblDescription setText:(_collocationInfo.strDescription)];
        
    CGFloat originX = 0;
    CGFloat originY = 30;
    for (NSInteger i = 0; i<_collocationInfo.arrList.count; i++) {
        ClothesInfo *info = [_collocationInfo.arrList objectAtIndex:i];
        
        NSMutableString *str = [[NSMutableString alloc]init];
        WardrobeType type = (WardrobeType)[info.numCateId integerValue];
        [str appendString: getWardrobeTypeName(type)];
        [str appendString:@" "];
        [str appendString:info.strBrand];
        
        CGRect rect = getTextLabelRectWithContentAndFont(str, [UIFont systemFontOfSize:11]);
        UITextView *label = [[UITextView alloc]init];
        CGFloat width = rect.size.width+20;
        if ((originX +width) > (ScreenWidth-20)) {
            originX = 0;
            originY = originY+35;
        }
        [label setFrame:CGRectMake(originX+20, originY, width, 30)];
        
        originX = originX+20+width;
        
        [label setTextAlignment:NSTextAlignmentCenter];
        label.backgroundColor = colorWithHexString(@"#c0e1d9");
        [label setTextColor:colorWithHexString(@"#ffffff")];
        [label setFont:[UIFont systemFontOfSize:11]];
        [_scrollView addSubview:label];
        [label setText:str];
    }
    _scrollView.contentSize = CGSizeMake(ScreenWidth, originY+35);
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CLog(@"删除");
        if (_delete) {
            _delete(_collocationInfo);
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
        
        NSData *imageData = UIImageJPEGRepresentation(_collocationInfo.file, 0.8);
        [imageData writeToFile:kToMorePath atomically:YES];
        
        NSURL *fileURL = [NSURL fileURLWithPath:kToMorePath];
        _documetnInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        _documetnInteractionController.delegate = self;
        _documetnInteractionController.UTI = @"com.instagram.photo";
        _documetnInteractionController.annotation = @{@"InstagramCaption":AppName};
        [_documetnInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
    }
}

- (IBAction)addCalendar:(id)sender {
    CreateActivityViewController *createActivity = [[CreateActivityViewController alloc]init];
    [createActivity addClothesOrCollection:_collocationInfo];
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
