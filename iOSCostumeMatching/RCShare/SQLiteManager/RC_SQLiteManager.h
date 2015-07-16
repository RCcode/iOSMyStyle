//
//  RC_SQLiteManager.h
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/14.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TableNameType TableNameType;

enum TableNameType
{
    TNTUser,
    TNTWardrobe,
    TNTCollocation
};

@interface RC_SQLiteManager : NSObject

+ (RC_SQLiteManager *)shareManager;

-(BOOL)addClothesToWardrobe:(ClothesInfo *)clothesInfo;

-(NSArray *)getAllClothesFromWardrobe;

@end
