//
//  RC_SQLiteManager.m
//  iOSCostumeMatching
//
//  Created by TCH on 15/7/14.
//  Copyright (c) 2015年 TCH. All rights reserved.
//

#import "RC_SQLiteManager.h"
#import "FMDB.h"

#define DATABASEPATH [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]
#define dataBaseName @"CostumeMatching.db"

@interface RC_SQLiteManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation RC_SQLiteManager

static RC_SQLiteManager *sqliteManager = nil;

+ (RC_SQLiteManager *)shareManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sqliteManager = [[RC_SQLiteManager alloc]init];
        sqliteManager.db = [FMDatabase databaseWithPath:DATABASEPATH];
    });
    return sqliteManager;
}

-(void)createTable:(TableNameType)tableNameType
{
    if ([_db open]) {
        switch (tableNameType) {
            case TNTUser:
            {
                /**
                 id         平台用户唯一标识            int		N
                 uid        用户id(第三方用户标识)       String		N
                 tplat      第三方平台id                byte		N
                 (1:ig;   2:fb;   3:google;   4:twitter   5:微信    6:QQ    7:微博）
                 token      第三方token                String		N
                 tname      第三方用户名                String		N
                 plat       平台id:0.android;1.ios     byte		N
                 email      用户邮箱                    String	Y
                 ikey       ios推送key                 String	Y
                 akey       android推送key             String	Y
                 gender     性别:0.女;1.男              int		Y
                 birth      生日(yyyy-MM-dd)           datetime	Y
                 pic        头像                       String	Y
                 country	国家                       String	Y
                 */
                NSString *tableName = @"user";
                if (![_db tableExists:tableName]) {
                    NSString *strExecute = [NSString stringWithFormat:@"CREATE TABLE %@ (id INTEGER,uid text,tplat INTEGER,token text,tname text,plat INTEGER,email text, ikey text,akey text,gender INTEGER,birth text,pic data,country text)",tableName];
                    if ([_db executeUpdate:strExecute]) {
                        CLog(@"create table Wardrobe success");
                    }else{
                        CLog(@"fail to create table Wardrobe");
                    }
                }else {
                }
                break;
            }
            case TNTWardrobe:
            {
                /**
                 cateId	    一级分类id,所有为0             int		N
                 scateId	一级分类id,所有为0             int		N
                 seaId      季节id:0.所有; 1.春夏;2.秋冬	int		N
                 brand      品牌                         String	Y
                 file       图片文件                      File	N
                 clId       服饰id
                 
                 date       创建或修改日期
                 */
                
                NSString *tableName = @"Wardrobe";
                if (![_db tableExists:tableName]) {
                    NSString *strExecute = [NSString stringWithFormat:@"CREATE TABLE %@ (clId INTEGER,cateId INTEGER,scateId INTEGER,seaId INTEGER,brand text,file data,date text)",tableName];
                    if ([_db executeUpdate:strExecute]) {
                        CLog(@"create table Wardrobe success");
                    }else{
                        CLog(@"fail to create table Wardrobe");
                    }
                }else {
                }
                break;
            }
            case TNTCollocation:
            {
                /**
                 styleId        风格id                            int		N
                 occId          场合id                            int		N
                 description	描述                              String	255	Y
                 file           图片文件                           File		N
                 list           搭配服饰信息列表(传brand不为空衣服)              N
                 (
                     clId	服饰id,可为空	int		Y
                     cateId	一级分类id,所有为0	int		N
                     scateId	一级分类id,所有为0	int		N
                     seaId	季节id:0.所有; 1.春夏;2.秋冬	int		N
                     brand	品牌	String	255	N
                 )
                 */
                NSString *tableName = @"Collocation";
                if (![_db tableExists:tableName]) {
                    NSString *strExecute = [NSString stringWithFormat:@"CREATE TABLE %@ (styleId INTEGER,occId INTEGER,description text,file data,brand text,list data)",tableName];
                    if ([_db executeUpdate:strExecute]) {
                        CLog(@"create table Wardrobe success");
                    }else{
                        CLog(@"fail to create table Wardrobe");
                    }
                }else {
                }
                break;
            }
            default:
                break;
        }
        [_db close];
    }else{
        NSLog(@"fail to open");
    }
}

-(BOOL)addClothesToWardrobe:(UIImage *)image
{
    [self createTable:TNTWardrobe];
    BOOL success = [_db executeUpdate:@"insert into Wardrobe (clId,cateId,scateId,seaId,brand,file,date) values(?,?,?,?,?,?,?)",[NSNumber numberWithInt:1],[NSNumber numberWithInt:1] ,[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],@"only",UIImagePNGRepresentation(image),[NSDate date],nil];
    return success;
}

-(void)getAllClothesFromWardrobe
{
    if ([_db open]) {
        NSString *tableName = @"Wardrobe";
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:@"clId"];
            NSData *data = [rs dataForColumn:@"file"];
            UIImage *image = [UIImage imageWithData:data];
        }
        [_db close];
    }

}

@end
