//
//  InstagramLoginViewController.h
//  Instagram
//
//  Created by TCH on 15/5/25.
//  Copyright (c) 2015年 zhao liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramLoginViewController : RC_BaseViewController

-(void)setSuccessLoginBlock:(void(^)(NSString *code))successLoginBlock;

@end
