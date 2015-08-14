//
//  PWSCalendarViewCell.h
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWSHelper.h"
@protocol PWSCalendarDelegate;

@interface PWSCalendarViewCell : UICollectionViewCell
{
//    UICollectionView*  m_collection_view;
}
@property (nonatomic, strong) id<PWSCalendarDelegate> delegate;
@property (nonatomic, assign) enCalendarViewType type;
@property (nonatomic, strong) NSDate*  currentDate;
@property (nonatomic, assign, getter = getCalendarHeight) CGFloat  calendarHeight;

@property (nonatomic, strong) UICollectionView*  m_collection_view;


- (void) SetWithDate:(NSDate*)pDate ShowType:(enCalendarViewType)pCalendarType;



@end
