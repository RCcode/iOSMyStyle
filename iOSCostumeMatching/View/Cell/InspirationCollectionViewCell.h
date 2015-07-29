//
//  InspirationCollectionViewCell.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/29.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspirationCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *collectionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end
