//
//  WriteCollectionDetailsViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/20.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "WriteCollectionDetailsViewController.h"

@interface WriteCollectionDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) void(^finish)(CollocationInfo *info);

@end

@implementation WriteCollectionDetailsViewController

-(void)dealloc
{
    
}

-(void)returnBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneBtnPressed:(id)sender
{
    CollocationInfo *collocationInfo = [[CollocationInfo alloc]init];
    collocationInfo.file = _image;
    collocationInfo.arrList = _arrList;
    collocationInfo.numStyleId = [NSNumber numberWithInt:1];
    collocationInfo.numOccId = [NSNumber numberWithInt:1];
    collocationInfo.strDescription = @"宴会";
    collocationInfo.date = stringFromDate([NSDate date]);
    if (_finish) {
        _finish(collocationInfo);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setCollectionFinishBlock:(void (^)(CollocationInfo *))collectionfinishBlock
{
    _finish = collectionfinishBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"详情"];
    self.showDone = YES;
    self.showReturn = YES;
    [self setReturnBtnTitle:@"返回"];
    [self setDoneBtnTitle:@"完成"];
    
    _imageView.image = _image;
    // Do any additional setup after loading the view from its nib.
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
