//
//  ShowCollectionInspirationDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/23.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "ShowCollectionInspirationDetailsViewController.h"

@interface ShowCollectionInspirationDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblColthes;

@end

@implementation ShowCollectionInspirationDetailsViewController

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
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
    NSMutableString *str = [[NSMutableString alloc]init];
    for (NSDictionary *dic in arr) {
        WardrobeType type = [[dic objectForKey:@"cateId"]intValue];
        [str appendString: getWardrobeTypeName(type)];
        [str appendString:@":"];
        [str appendString:[dic objectForKey:@"brand"]];
        [str appendString:@"\n"];
    }
    [_lblColthes setText:str];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"灵感详情"];
    self.showReturn = YES;
    [self setReturnBtnTitle:@"返回"];
    self.showDone = YES;
    [self setDoneBtnTitle:@"举报"];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"url"]]];
    [_lblDescription setText:[_dic objectForKey:@"description"]];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"pic"]]];
    [_lblName setText:[_dic objectForKey:@"tname"]];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)pressLike:(id)sender {
    [[RC_RequestManager shareManager]LikeCollocationWithCoId:_coId success:^(id responseObject) {
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

- (IBAction)pressShare:(id)sender {
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
