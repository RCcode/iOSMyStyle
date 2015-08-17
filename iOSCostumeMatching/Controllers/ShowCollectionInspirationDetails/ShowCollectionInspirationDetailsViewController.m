//
//  ShowCollectionInspirationDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/23.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ShowCollectionInspirationDetailsViewController.h"
#import "LeftMenuViewController.h"

@interface ShowCollectionInspirationDetailsViewController ()<UIDocumentInteractionControllerDelegate>
{
    UIDocumentInteractionController *_documetnInteractionController;
    NSInteger like;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UILabel *lblDescription;

@end

@implementation ShowCollectionInspirationDetailsViewController

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (!userInfo) {
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        [(LeftMenuViewController *)app.sideViewController.leftViewController pressLogin:nil];
        return;
    }
    [[RC_RequestManager shareManager]ReportCollocationWithCoId:_coId success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = responseObject;
            if ([[dic objectForKey:@"stat"]integerValue] == 10000) {
                showLabelHUD(@"success");
            }
        }
    } andFailed:^(NSError *error) {
        CLog(@"%@",error);
    }];
}

-(void)setCoId:(int)coId
{
    _coId = coId;
    __weak ShowCollectionInspirationDetailsViewController *weakSelf = self;
    [[RC_RequestManager shareManager]GetCollocationDetailWithCoId:_coId success:^(id responseObject) {
        CLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = responseObject;
            if ([[dic objectForKey:@"stat"]intValue] == 10000) {
                [weakSelf upDateView:[dic objectForKey:@"list"]];
            }
        }
    } andFailed:^(NSError *error) {
        CLog(@"%@",error);
    }];
}

-(void)upDateView:(NSArray *)arr
{
    CGFloat originX = 0;
    CGFloat originY = 35;
    for (NSInteger i = 0; i<arr.count; i++) {
        NSDictionary *dic = [arr objectAtIndex:i];
        NSMutableString *str = [[NSMutableString alloc]init];
        WardrobeType type = [[dic objectForKey:@"cateId"]intValue];
        [str appendString:[NSString stringWithFormat:@"%@",getWardrobeTypeName(type)] ];
        [str appendString:@" "];
        [str appendString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"brand"]]];
        
        CGRect rect = getTextLabelRectWithContentAndFont(str, [UIFont systemFontOfSize:12]);
        UITextView *label = [[UITextView alloc]init];
        label.userInteractionEnabled = NO;
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
        [label setFont:[UIFont systemFontOfSize:12]];
        label.clipsToBounds = YES;
        [_scrollView addSubview:label];
        [label setText:str];
    }
    _scrollView.contentSize = CGSizeMake(ScreenWidth, originY+35);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:LocalizedString(@"Details", nil)];
    self.showReturn = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    self.showDone = YES;
    [self setDoneBtnTitleColor:colorWithHexString(@"#44dcca")];
    [self setDoneBtnTitle:LocalizedString(@"Report", nil)];
    
    _headImageView.layer.borderWidth = 2;
    _headImageView.layer.borderColor = colorWithHexString(@"#eeeeee").CGColor;
    _headImageView.clipsToBounds = YES;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"url"]]];
    
    _lblDescription = [[UILabel alloc]init];
    [_lblDescription setFont:[UIFont systemFontOfSize:14]];
    [_lblDescription setTextColor:colorWithHexString(@"#222222")];
    [_lblDescription setFrame:CGRectMake(20, 5, ScreenWidth-20, 20)];
    [_scrollView addSubview:_lblDescription];
    [_lblDescription setText:[_dic objectForKey:@"description"]];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"pic"]]];
    [_lblName setText:[_dic objectForKey:@"tname"]];
    
    like = [[_dic objectForKey:@"liked"]integerValue];
    if (like) {
        [_btnLike setImage:[UIImage imageNamed:@"ic_likes_h"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnLike setImage:[UIImage imageNamed:@"ic_likes"] forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)pressLike:(id)sender {
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (!userInfo) {
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        [(LeftMenuViewController *)app.sideViewController.leftViewController pressLogin:nil];
        return;
    }
    __weak ShowCollectionInspirationDetailsViewController *weakSelf = self;
    showMBProgressHUD(nil, YES);
    [[RC_RequestManager shareManager]LikeCollocation:like WithCoId:_coId success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = responseObject;
            if ([[dic objectForKey:@"stat"]integerValue] == 10000) {
//                showLabelHUD(@"success");
                if (like == 0) {
                    like = 1;
                    [weakSelf.btnLike setImage:[UIImage imageNamed:@"ic_likes_h"] forState:UIControlStateNormal];
                }
                else
                {
                    like = 0;
                    [weakSelf.btnLike setImage:[UIImage imageNamed:@"ic_likes"] forState:UIControlStateNormal];
                }
            }
            hideMBProgressHUD();
        }
    } andFailed:^(NSError *error) {
        CLog(@"%@",error);
        hideMBProgressHUD();
    }];
    
//    [[RC_RequestManager shareManager]LikeCollocationWithCoId:_coId success:^(id responseObject) {
//        CLog(@"%@",responseObject);
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = responseObject;
//            if ([[dic objectForKey:@"stat"]integerValue] == 10000) {
//                showLabelHUD(@"success");
//            }
//        }
//    } andFailed:^(NSError *error) {
//        CLog(@"%@",error);
//    }];
}

- (IBAction)pressShare:(id)sender {
    UserInfo *userInfo = [UserInfo unarchiverUserData];
    if (!userInfo) {
        AppDelegate *app = [[UIApplication sharedApplication]delegate];
        [(LeftMenuViewController *)app.sideViewController.leftViewController pressLogin:nil];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //保存本地 如果已存在，则删除
        if([[NSFileManager defaultManager] fileExistsAtPath:kToMorePath]){
            [[NSFileManager defaultManager] removeItemAtPath:kToMorePath error:nil];
        }
        NSData *imageData;
        if (_imageView.image) {
            imageData = UIImageJPEGRepresentation(_imageView.image, 0.8);
        }
        else
        {
            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_dic objectForKey:@"url"]]];
        }
        [imageData writeToFile:kToMorePath atomically:YES];
        
        NSURL *fileURL = [NSURL fileURLWithPath:kToMorePath];
        _documetnInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        _documetnInteractionController.delegate = self;
        _documetnInteractionController.UTI = @"com.instagram.photo";
        _documetnInteractionController.annotation = @{@"InstagramCaption":AppName};
        [_documetnInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
    });
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
