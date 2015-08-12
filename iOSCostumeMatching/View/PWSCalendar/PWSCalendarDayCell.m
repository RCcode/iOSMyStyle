//
//  PWSCalendarDayCell.m
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//
////////////////////////////////////////////////////////////////////////
#import "PWSCalendarDayCell.h"
#import "PWSHelper.h"
////////////////////////////////////////////////////////////////////////
const NSString* PWSCalendarDayCellId = @"PWSCalendarDayCellId";
////////////////////////////////////////////////////////////////////////
@interface PWSCalendarDayCell()
{
    UILabel* m_date;
    UIView *point1View;
    UIView *point2View;
    UIView *point3View;
}
@property (nonatomic, strong) NSDate* p_date;
@end
////////////////////////////////////////////////////////////////////////
@implementation PWSCalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self SetInitialValue];
    }
    return self;
}

- (void) SetInitialValue
{
    m_date = [[UILabel alloc] init];
    [m_date setFrame:self.bounds];
    [m_date setText:@""];
    [m_date setTextColor:colorWithHexString(@"222222")];
    [m_date setFont:[UIFont systemFontOfSize:12]];
    [m_date setTextAlignment:NSTextAlignmentCenter];
//    m_date.clipsToBounds = YES;
//    m_date.layer.cornerRadius = CGRectGetWidth(m_date.frame)/2.0;
    [self addSubview:m_date];
    self.backgroundColor = [UIColor whiteColor];
    
    point1View = [[UIView alloc]init];
    point1View.backgroundColor = [UIColor redColor];
    [point1View setFrame:CGRectMake(0, 0, 4, 4)];
    point1View.center = CGPointMake(self.bounds.size.width/2-8, CGRectGetHeight(self.frame)-10);
    point1View.layer.cornerRadius = 2;
    point1View.clipsToBounds = YES;
    [self addSubview:point1View];
    
    point2View = [[UIView alloc]init];
    point2View.backgroundColor = [UIColor redColor];
    [point2View setFrame:CGRectMake(0, 0, 4, 4)];
    point2View.center = CGPointMake(self.bounds.size.width/2, CGRectGetHeight(self.frame)-10);
    point2View.layer.cornerRadius = 2;
    point2View.clipsToBounds = YES;
    [self addSubview:point2View];
    
    point3View = [[UIView alloc]init];
    point3View.backgroundColor = [UIColor redColor];
    [point3View setFrame:CGRectMake(0, 0, 4, 4)];
    point3View.center = CGPointMake(self.bounds.size.width/2+8, CGRectGetHeight(self.frame)-10);
    point3View.layer.cornerRadius = 2;
    point3View.clipsToBounds = YES;
    [self addSubview:point3View];
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        if ([PWSHelper CheckSameDay:self.p_date AnotherDate:[NSDate date]])
        {
            [m_date setTextColor:[UIColor whiteColor]];
        }
        else
        {
            [m_date setTextColor:[UIColor whiteColor]];
        }
        [m_date setBackgroundColor:colorWithHexString(@"#45ddcb")];
    }
    else
    {
        if ([PWSHelper CheckSameDay:self.p_date AnotherDate:[NSDate date]])
        {
            [m_date setTextColor:colorWithHexString(@"#45ddcb")];
        }
        else
        {
            [m_date setTextColor:colorWithHexString(@"#222222")];
        }
        [m_date setBackgroundColor:[UIColor clearColor]];
    }
}

- (void) SetDate:(NSDate*)_date
{
    NSString* day = @"";
    self.p_date = _date;
    if (_date)
    {
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:_date];
        day = [NSString stringWithFormat:@"%@", @(dateComponents.day)];
    }
    
    if ([PWSHelper CheckSameDay:_date AnotherDate:[NSDate date]])
    {
        [m_date setTextColor:colorWithHexString(@"#45ddcb")];
    }
    else
    {
        [m_date setTextColor:colorWithHexString(@"#222222")];
    }
    
    [m_date setText:day];
    
    if (!_date) {
        point1View.backgroundColor = [UIColor clearColor];
        point2View.backgroundColor = [UIColor clearColor];
        point3View.backgroundColor = [UIColor clearColor];
        return;
    }
    NSString *_year = yearFromDate(_date);
    NSString *_month = monthFromDate(_date);
    NSString *_day = dayFromDate(_date);
    NSArray *arrActivity = [[RC_SQLiteManager shareManager]getAllActivityWithYear:_year andMonth:_month andDay:_day];
    if (arrActivity.count>=3) {
//        point1View.backgroundColor = colorWithHexString(@"#f3511d");
//        point2View.backgroundColor = colorWithHexString(@"#f5bf24");
//        point3View.backgroundColor = colorWithHexString(@"#3b5aad");
        for (int i = 0; i<3; i++) {
            ActivityInfo *info = [arrActivity objectAtIndex:i];
            switch (i) {
                case 0:
                {
                    point1View.backgroundColor = getColor((ActivityColor)[info.numColor integerValue]);
                    break;
                }
                case 1:
                {
                    point2View.backgroundColor = getColor((ActivityColor)[info.numColor integerValue]);
                    break;
                }
                case 2:
                {
                    point3View.backgroundColor = getColor((ActivityColor)[info.numColor integerValue]);
                    break;
                }
                default:
                    break;
            }
        }
    }
    else if (arrActivity.count==2)
    {
        for (int i = 0; i<2; i++) {
            ActivityInfo *info = [arrActivity objectAtIndex:i];
            switch (i) {
                case 0:
                {
                    point1View.backgroundColor = getColor((ActivityColor)[info.numColor integerValue]);
                    break;
                }
                case 1:
                {
                    point2View.backgroundColor = getColor((ActivityColor)[info.numColor integerValue]);
                    break;
                }
                default:
                    break;
            }
        }
//        point1View.backgroundColor = colorWithHexString(@"#f3511d");
//        point2View.backgroundColor = colorWithHexString(@"#f5bf24");
        point3View.backgroundColor = [UIColor clearColor];
    }
    else if (arrActivity.count==1)
    {
        ActivityInfo *info = [arrActivity objectAtIndex:0];
        point1View.backgroundColor = getColor((ActivityColor)[info.numColor integerValue]);
//        point1View.backgroundColor = colorWithHexString(@"#f3511d");
        point2View.backgroundColor = [UIColor clearColor];
        point3View.backgroundColor = [UIColor clearColor];
    }
    else
    {
        point1View.backgroundColor = [UIColor clearColor];
        point2View.backgroundColor = [UIColor clearColor];
        point3View.backgroundColor = [UIColor clearColor];
    }
}


@end
