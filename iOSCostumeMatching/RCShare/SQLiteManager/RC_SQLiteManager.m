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

-(BOOL)deleteTable:(TableNameType)tableNameType
{
    if ([_db open]) {
        NSString *tableName;
        switch (tableNameType) {
            case TNTUser:
            {
                tableName = @"user";
                break;
            }
            case TNTWardrobe:
            {
                tableName = @"Wardrobe";
                break;
            }
            case TNTCollocation:
            {
                tableName = @"Collocation";
                break;
            }
            case TNTActivity:
            {
                tableName = @"Activity";
                break;
            }
            default:
                break;
        }
        BOOL success = [_db executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@",tableName]];
        [_db close];
        return success;
    }
    return NO;
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
                 picURL        头像                       String	Y
                 country	国家                       String	Y
                 localId    本地自增标识
                 */
                NSString *tableName = @"User";
                if (![_db tableExists:tableName]) {
                    NSString *strExecute = [NSString stringWithFormat:@"CREATE TABLE %@ (localId INTEGER PRIMARY KEY AUTOINCREMENT,id INTEGER,uid text,tplat INTEGER,token text(100),tname text,plat INTEGER,email text, ikey text,akey text,gender INTEGER,birth text,picURL text,country text)",tableName];
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
                    NSString *strExecute = [NSString stringWithFormat:@"CREATE TABLE %@ (localId INTEGER PRIMARY KEY AUTOINCREMENT,clId INTEGER,cateId INTEGER,scateId INTEGER,seaId INTEGER,brand text,file data,date text)",tableName];
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
                 
                 coId	搭配id	int		N
                 */
                NSString *tableName = @"Collocation";
                if (![_db tableExists:tableName]) {
                    NSString *strExecute = [NSString stringWithFormat:@"CREATE TABLE %@ (localId INTEGER PRIMARY KEY AUTOINCREMENT,coId INTEGER,styleId INTEGER,occId INTEGER,description text,file data,list data,date text)",tableName];
                    if ([_db executeUpdate:strExecute]) {
                        CLog(@"create table Collocation success");
                    }else{
                        CLog(@"fail to create table Collocation");
                    }
                }else {
                }
                break;
            }
            case TNTActivity:
            {
                /**
                 title           标题
                 location        位置
                 isAllDay        全天
                 startTime       开始时间
                 finishTime      结束时间
                 firstRemindTime     第一次提醒时间
                 secondRemindTime    第二次提醒时间
                 color           颜色
                 arrData        衣服或搭配数组
                 year            年
                 month           月
                 day             日
                 
                 id              活动标识
                 */
                
                NSString *tableName = @"Activity";
                if (![_db tableExists:tableName]) {
                    NSString *strExecute = [NSString stringWithFormat:@"CREATE TABLE %@ (id INTEGER PRIMARY KEY AUTOINCREMENT,title text,location text,isAllDay bool,startTime date,finishTime date,firstRemindTime INTEGER,secondRemindTime INTEGER,color INTEGER,arrData data,year INTEGER,month INTEGER,day INTEGER)",tableName];
                    if ([_db executeUpdate:strExecute]) {
                        CLog(@"create table Activity success");
                    }else{
                        CLog(@"fail to create table Activity");
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

-(BOOL)addUser:(UserInfo *)userInfo
{
    [self createTable:TNTUser];
    if([_db open])
    {
        BOOL isExit = NO;
        NSString * sql = [NSString stringWithFormat:@"select * from User where uid = %@",userInfo.strUid];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            isExit = YES;
        }
        BOOL success;
        if (isExit) {
            NSString *updateSql = [[NSString alloc] initWithFormat:@"UPDATE User SET id = %@ ,token = '%@' ,tname = '%@', picURL = '%@' where uid = %@",userInfo.numId,userInfo.strToken,userInfo.strTname,userInfo.strPicURL,userInfo.strUid];
            success = [_db executeUpdate:updateSql];
        }
        else
        {
            success = [_db executeUpdate:@"insert into User (id ,uid ,tplat ,token ,tname ,plat ,picURL) values(?,?,?,?,?,?,?)",userInfo.numId, userInfo.strUid, userInfo.numTplat, userInfo.strToken, userInfo.strTname,userInfo.numPlat,userInfo.strPicURL,nil];
        }
        
        [_db close];
        return success;
    }
    return NO;
}

-(BOOL)deleteUser:(UserInfo *)userInfo
{
    [self createTable:TNTUser];
    if([_db open])
    {
        BOOL success = [_db executeUpdate:@"delete from User where uid = ?",userInfo.strUid,nil];
        [_db close];
        return success;
    }
    return NO;
}

#pragma mark -

-(BOOL)addClothesToWardrobe:(ClothesInfo *)clothesInfo
{
    [self createTable:TNTWardrobe];
    if([_db open])
    {
        BOOL success = [_db executeUpdate:@"insert into Wardrobe (clId,cateId,scateId,seaId,brand,file,date) values(?,?,?,?,?,?,?)",clothesInfo.numClId, clothesInfo.numCateId, clothesInfo.numScateId, clothesInfo.numSeaId, clothesInfo.strBrand,UIImagePNGRepresentation(clothesInfo.file),clothesInfo.date,nil];
        [_db close];
        return success;
    }
    return NO;
}

-(BOOL)deleteClotheFromWardrobe:(ClothesInfo *)clothesInfo
{
    [self createTable:TNTWardrobe];
    if([_db open])
    {
        BOOL success = [_db executeUpdate:@"delete from Wardrobe where date = ?",clothesInfo.date,nil];
        [_db close];
        return success;
    }
    return NO;
}

-(NSMutableArray *)getAllClothesFromWardrobe
{
    [self createTable:TNTWardrobe];
    if ([_db open]) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        NSString *tableName = @"Wardrobe";
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ order by date desc",tableName];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            ClothesInfo *clothesInfo = [[ClothesInfo alloc]init];
            
            clothesInfo.numLocalId = [NSNumber numberWithInt:[rs intForColumn:@"localId"]];
            clothesInfo.numClId = [NSNumber numberWithInt:[rs intForColumn:@"clId"]];
            clothesInfo.numCateId = [NSNumber numberWithInt:[rs intForColumn:@"cateId"]];
            clothesInfo.numScateId = [NSNumber numberWithInt:[rs intForColumn:@"scateId"]];
            clothesInfo.numSeaId = [NSNumber numberWithInt:[rs intForColumn:@"seaId"]];
            clothesInfo.strBrand = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"brand"]];
            clothesInfo.file = [UIImage imageWithData:[rs dataForColumn:@"file"]];
            clothesInfo.date = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"date"]];
            
            [arr addObject:clothesInfo];
        }
        [_db close];
        return arr;
    }
    return nil;
}

-(NSMutableArray *)getClothesFromWardrobeWithSeason:(int)season Type:(int)type Category:(int)category
{
    [self createTable:TNTWardrobe];
    if ([_db open]) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        NSString *tableName = @"Wardrobe";
        NSString * sql;
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ where cateId = %d and scateId = %d and seaId = %d order by date desc",tableName,type,category,season];
        
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            ClothesInfo *clothesInfo = [[ClothesInfo alloc]init];
            
            clothesInfo.numLocalId = [NSNumber numberWithInt:[rs intForColumn:@"localId"]];
            clothesInfo.numClId = [NSNumber numberWithInt:[rs intForColumn:@"clId"]];
            clothesInfo.numCateId = [NSNumber numberWithInt:[rs intForColumn:@"cateId"]];
            clothesInfo.numScateId = [NSNumber numberWithInt:[rs intForColumn:@"scateId"]];
            clothesInfo.numSeaId = [NSNumber numberWithInt:[rs intForColumn:@"seaId"]];
            clothesInfo.strBrand = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"brand"]];
            clothesInfo.file = [UIImage imageWithData:[rs dataForColumn:@"file"]];
            clothesInfo.date = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"date"]];
            
            [arr addObject:clothesInfo];
        }
        [_db close];
        return arr;
    }
    return nil;
}

#pragma mark -

-(BOOL)addCollection:(CollocationInfo *)collocationInfo
{
    [self createTable:TNTCollocation];
    if([_db open])
    {
        BOOL success = [_db executeUpdate:@"insert into Collocation (coId ,styleId ,occId ,description ,file ,date) values(?,?,?,?,?,?)",collocationInfo.numCoId,collocationInfo.numStyleId, collocationInfo.numOccId, collocationInfo.strDescription,UIImagePNGRepresentation(collocationInfo.file),collocationInfo.date,nil];
        [_db close];
        return success;
    }
    return NO;
}

-(BOOL)deleteCollection:(CollocationInfo *)collocationInfo
{
    [self createTable:TNTCollocation];
    if([_db open])
    {
        BOOL success = [_db executeUpdate:@"delete from Collocation where date = ?",collocationInfo.date,nil];
        [_db close];
        return success;
    }
    return NO;
}

-(NSMutableArray *)getCollectionWithStyle:(int)style occasion:(int)occasion
{
    [self createTable:TNTCollocation];
    if ([_db open]) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSString *tableName = @"Collocation";
        NSString * sql;
        if (style == 0 && occasion == 0) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ order by date desc",tableName];
        }
        else if(style == 0)
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ where occId= %d order by date desc",tableName,occasion];
        }
        else if(occasion == 0)
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ where styleId= %d order by date desc",tableName,style];
        }
        else
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ where styleId= %d and occId= %d order by date desc",tableName,style,occasion];
        }
        
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            CollocationInfo *clothesInfo = [[CollocationInfo alloc]init];
            
            clothesInfo.numCoId = [NSNumber numberWithInt:[rs intForColumn:@"coId"]];
            clothesInfo.numStyleId = [NSNumber numberWithInt:[rs intForColumn:@"styleId"]];
            clothesInfo.numOccId = [NSNumber numberWithInt:[rs intForColumn:@"occId"]];
            clothesInfo.strDescription = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"description"]];
            clothesInfo.file = [UIImage imageWithData:[rs dataForColumn:@"file"]];
            clothesInfo.date = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"date"]];
            
            [arr addObject:clothesInfo];
        }
        [_db close];
        return arr;
    }
    return nil;
}

-(NSMutableArray *)getAllCollection
{
    [self createTable:TNTCollocation];
    if ([_db open]) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSString *tableName = @"Collocation";
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ order by date desc",tableName];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            CollocationInfo *clothesInfo = [[CollocationInfo alloc]init];
            
            clothesInfo.numCoId = [NSNumber numberWithInt:[rs intForColumn:@"coId"]];
            clothesInfo.numStyleId = [NSNumber numberWithInt:[rs intForColumn:@"styleId"]];
            clothesInfo.numOccId = [NSNumber numberWithInt:[rs intForColumn:@"occId"]];
            clothesInfo.strDescription = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"description"]];
            clothesInfo.file = [UIImage imageWithData:[rs dataForColumn:@"file"]];
            clothesInfo.date = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"date"]];
            
            [arr addObject:clothesInfo];
        }
        [_db close];
        return arr;
    }
    return nil;
}

#pragma mark -

-(BOOL)addActivityInfo:(ActivityInfo *)activityInfo
{
    [self createTable:TNTActivity];
    if([_db open])
    {
        NSMutableData *mData = [[NSMutableData alloc] init];
        NSKeyedArchiver *myKeyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
        [myKeyedArchiver encodeObject:activityInfo.arrData];
        [myKeyedArchiver finishEncoding];
        
        BOOL success = [_db executeUpdate:@"insert into Activity (title ,location ,isAllDay ,startTime ,finishTime ,firstRemindTime ,secondRemindTime ,color ,arrData ,year ,month ,day) values(?,?,?,?,?,?,?,?,?,?,?,?)",activityInfo.strTitle,activityInfo.strLocation, activityInfo.numIsAllDay, activityInfo.dateStartTime,activityInfo.dateFinishTime,activityInfo.firstRemindTime,activityInfo.secondRemindTime,activityInfo.numColor,mData,activityInfo.numYear,activityInfo.numMonth,activityInfo.numDay,nil];
        [_db close];
        return success;
    }
    return NO;
}

-(BOOL)updateActivityInfo:(ActivityInfo *)activityInfo
{
    [self createTable:TNTActivity];
    if([_db open])
    {
        NSMutableData *mData = [[NSMutableData alloc] init];
        NSKeyedArchiver *myKeyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
        [myKeyedArchiver encodeObject:activityInfo.arrData];
        [myKeyedArchiver finishEncoding];
        BOOL success = [_db executeUpdate:@"update Activity SET title = ?,location = ?,isAllDay = ?,startTime = ?,finishTime = ?,firstRemindTime = ?,secondRemindTime = ?,color = ?,arrData = ?,year = ?,month = ?,day= ? where id = ?",activityInfo.strTitle,activityInfo.strLocation, activityInfo.numIsAllDay, activityInfo.dateStartTime,activityInfo.dateFinishTime,activityInfo.firstRemindTime,activityInfo.secondRemindTime,activityInfo.numColor,mData,activityInfo.numYear,activityInfo.numMonth,activityInfo.numDay,activityInfo.numId,nil];
        [_db close];
        return success;
    }
    return NO;
}

-(NSMutableArray *)getAllActivity
{
    [self createTable:TNTActivity];
    if ([_db open]) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSString *tableName = @"Activity";
//        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ order by startTime desc",tableName];
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            ActivityInfo *activityInfo = [[ActivityInfo alloc]init];
            
            activityInfo.numId = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            activityInfo.numColor = [NSNumber numberWithInt:[rs intForColumn:@"color"]];
            activityInfo.numIsAllDay = [NSNumber numberWithInt:[rs intForColumn:@"isAllDay"]];
            activityInfo.numDay = [NSNumber numberWithInt:[rs intForColumn:@"day"]];
            activityInfo.strLocation = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"location"]];
            activityInfo.numMonth = [NSNumber numberWithInt:[rs intForColumn:@"month"]];
            activityInfo.strTitle = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"title"]];
            activityInfo.numYear = [NSNumber numberWithInt:[rs intForColumn:@"year"]];
            activityInfo.dateFinishTime = [rs dateForColumn:@"finishTime"];
            activityInfo.firstRemindTime = [NSNumber numberWithInt:[rs intForColumn:@"firstRemindTime"]];
            activityInfo.secondRemindTime = [NSNumber numberWithInt:[rs intForColumn:@"secondRemindTime"]];
            activityInfo.dateStartTime = [rs dateForColumn:@"startTime"];
            
            NSKeyedUnarchiver *myKeyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:[rs dataForColumn:@"arrData"]];
            NSArray *arrData = [myKeyedUnarchiver decodeObject];
            activityInfo.arrData = arrData;
            
            [arr addObject:activityInfo];
        }
        [_db close];
        return arr;
    }
    return nil;
}

-(NSMutableArray *)getAllActivityWithYear:(NSString *)year andMonth:(NSString *)month andDay:(NSString *)day
{
    [self createTable:TNTActivity];
    if ([_db open]) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSString *tableName = @"Activity";
        NSString * sql;
        if(year && month && day)
        {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ where year = %d and month = %d and day = %d",tableName,[year intValue],[month intValue],[day intValue]];
        }
        else if (year && month) {
            sql = [NSString stringWithFormat:@"SELECT * FROM %@ where year = %d and month = %d order by day",tableName,[year intValue],[month intValue]];
        }
        CLog(@"%@",sql);
        FMResultSet * rs = [_db executeQuery:sql];
        while ([rs next]) {
            ActivityInfo *activityInfo = [[ActivityInfo alloc]init];
            
            activityInfo.numId = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            activityInfo.numColor = [NSNumber numberWithInt:[rs intForColumn:@"color"]];
            activityInfo.numIsAllDay = [NSNumber numberWithInt:[rs intForColumn:@"isAllDay"]];
            activityInfo.numDay = [NSNumber numberWithInt:[rs intForColumn:@"day"]];
            activityInfo.strLocation = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"location"]];
            activityInfo.numMonth = [NSNumber numberWithInt:[rs intForColumn:@"month"]];
            activityInfo.strTitle = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"title"]];
            activityInfo.numYear = [NSNumber numberWithInt:[rs intForColumn:@"year"]];
            activityInfo.dateFinishTime = [rs dateForColumn:@"finishTime"];
            activityInfo.firstRemindTime = [NSNumber numberWithInt:[rs intForColumn:@"firstRemindTime"]];
            activityInfo.secondRemindTime = [NSNumber numberWithInt:[rs intForColumn:@"secondRemindTime"]];
            activityInfo.dateStartTime = [rs dateForColumn:@"startTime"];
            
            NSKeyedUnarchiver *myKeyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:[rs dataForColumn:@"arrData"]];
            NSArray *arrData = [myKeyedUnarchiver decodeObject];
            activityInfo.arrData = arrData;
            
            [arr addObject:activityInfo];
        }
        [_db close];
        return arr;
    }
    return nil;
}

-(BOOL)deleteActivityInfo:(ActivityInfo *)activityInfo
{
    [self createTable:TNTActivity];
    if([_db open])
    {
        BOOL success = [_db executeUpdate:@"delete from Activity where id = ?",activityInfo.numId,nil];
        [_db close];
        return success;
    }
    return NO;
}























@end
