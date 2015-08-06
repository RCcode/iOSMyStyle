//
//  ActivityCell.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/23.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblWeek;
@property (weak, nonatomic) IBOutlet UIView *leftView;


@property (weak, nonatomic) IBOutlet UIImageView *clothesOrCollectionImageView;

@end
