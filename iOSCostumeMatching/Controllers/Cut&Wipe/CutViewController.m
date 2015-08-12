//
//  CutViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/10.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "CutViewController.h"
#import "MZCroppableView.h"

@interface CutViewController ()
{
    MZCroppableView *mzCroppableView;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImageView *magnifyingGlassImageView;
@property (nonatomic, strong) UIImageView *centerImageView;

@property (nonatomic, copy) void(^croppedImageSuccess)(UIImage *image);

@end

@implementation CutViewController

-(void)setCroppedImageSuccessBlock:(void (^)(UIImage *))croppedImageSuccessBlock
{
    _croppedImageSuccess = croppedImageSuccessBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneBtnPressed:(id)sender
{
    UIImage *croppedImage = [mzCroppableView deleteBackgroundOfImage:_imageView];
    
//    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/final.png"];
//    [UIImagePNGRepresentation(croppedImage) writeToFile:path atomically:YES];
//    
//    NSLog(@"cropped image path: %@",path);
    
    if (_croppedImageSuccess) {
        _croppedImageSuccess(croppedImage);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNavTitle:LocalizedString(@"Crop", nil)];
    self.showReturn = YES;
    self.showDone = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    [self setDoneBtnTitleColor:colorWithHexString(@"#44dcca")];
    [self setDoneBtnTitle:@"完成"];
    
    [_imageView setImage:_originalImage];
    
    _magnifyingGlassImageView  = [[UIImageView alloc]init];
    [_magnifyingGlassImageView setFrame:CGRectMake(0, 0, 95, 95)];
    [self.view addSubview:_magnifyingGlassImageView];
    _magnifyingGlassImageView.layer.borderColor = colorWithHexString(@"#222222").CGColor;
    _magnifyingGlassImageView.layer.borderWidth = 1.5;
    _magnifyingGlassImageView.clipsToBounds = YES;
    _magnifyingGlassImageView.hidden = YES;
    
    _centerImageView = [[UIImageView alloc]init];
    _centerImageView.frame = CGRectMake(0, 0, 4, 4);
    _centerImageView.layer.cornerRadius = 2;
    _centerImageView.clipsToBounds = YES;
    _centerImageView.backgroundColor = [UIColor redColor];
    _centerImageView.center = _magnifyingGlassImageView.center;
    [_magnifyingGlassImageView addSubview:_centerImageView];

    
    CGRect rect1 = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
    CGRect rect2 = _imageView.frame;
    [_imageView setFrame:[MZCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2]];
    
    [self setUpMZCroppableView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [_imageView setFrame:mzCroppableView.frame];
}

- (void)setUpMZCroppableView
{
    [mzCroppableView removeFromSuperview];
    mzCroppableView = [[MZCroppableView alloc] initWithImageView:_imageView];
    __weak CutViewController *weakSelf = self;
    [mzCroppableView setMagnifyingGlassImageBlock:^(UIImage *image) {
        weakSelf.magnifyingGlassImageView.hidden = NO;
        [weakSelf.magnifyingGlassImageView setImage:image];
    }];
    [mzCroppableView setEndMagnifyingGlassImageBlock:^{
        weakSelf.magnifyingGlassImageView.hidden = YES;
    }];
    [self.view addSubview:mzCroppableView];
}

- (IBAction)unDo:(id)sender {
    [mzCroppableView unDo];
}

- (IBAction)reDo:(id)sender {
    [mzCroppableView reDo];
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
