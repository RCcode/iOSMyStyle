//
//  SelectViewController.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/28.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "SelectViewController.h"

#define CELL_IDENTIFIER @"TableViewCell"

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
    [self setReturnBtnTitle:@"取消"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    cell.textLabel.text = [_array objectAtIndex:indexPath.row];
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
