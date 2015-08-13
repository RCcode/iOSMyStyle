//
//  SelectViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/28.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "SelectViewController.h"
#import "ColorCell.h"
#import "CustumalCell.h"

#define CELL_IDENTIFIER @"TableViewCell"
#define COLOR_CELL_IDENTIFIER @"ColorCell"

@interface SelectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic, copy) void(^select)(int index);

@end

@implementation SelectViewController

-(void)setSelectedBlock:(void (^)(int))selectedBlock
{
    _select = selectedBlock;
}

-(void)returnBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:_navagationTitle];
    self.showReturn = YES;
    [self setReturnBtnNormalImage:[UIImage imageNamed:@"ic_back"] andHighlightedImage:nil];
    self.view.backgroundColor = colorWithHexString(@"#eeeeee");
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 15, ScreenWidth-20, ScreenHeight-64-15)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = colorWithHexString(@"#eeeeee");
    [_tableView registerNib:[UINib nibWithNibName:@"CustumalCell" bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
    [_tableView registerNib:[UINib nibWithNibName:@"ColorCell" bundle:nil] forCellReuseIdentifier:COLOR_CELL_IDENTIFIER];
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 1) {
        ColorCell *cell = [tableView dequeueReusableCellWithIdentifier:COLOR_CELL_IDENTIFIER];
        cell.lblColor.text = [_array objectAtIndex:indexPath.row];
        cell.colorView.backgroundColor = getColor(indexPath.row);
        return cell;
    }
    CustumalCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    cell.lblTitle.text = [_array objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_select) {
        _select(indexPath.row);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == 1) {
        return 49;
    }
    else
    {
        if (indexPath.row == 0) {
            return 59;
        }
        else
        {
            return 49;
        }
    }
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
