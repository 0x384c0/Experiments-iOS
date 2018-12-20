//
// Created by AK on 6/24/16.
// Copyright (c) 2016 AK. All rights reserved.
//


// Calendar

#define CALENDAR_WEEKDAY_TINT_COLOR [UIColor lightGrayColor]
#define CALENDAR_DAY_ENABLE_TITLE_COLOR [UIColor blackColor]
#define CALENDAR_WEEKEND_TINT_COLOR [UIColor lightGrayColor]
#define CALENDAR_DAY_SELECTED_COLOR [UIColor colorWithRed:52/256.0 green:152/256.0 blue:219/256.0 alpha:1.0]
#define CALENDAR_MONTH_TITLE_COLOR [UIColor lightGrayColor]

//#define CALENDAR_WEEKDAY_TINT_COLOR [UIColor colorWithRed:46/256.0 green:204/256.0 blue:113/256.0 alpha:1.0]
//#define CALENDAR_WEEKEND_TINT_COLOR [UIColor colorWithRed:192/256.0 green:57/256.0 blue:43/256.0 alpha:1.0]
//#define CALENDAR_DAY_SELECTED_COLOR [UIColor colorWithRed:52/256.0 green:152/256.0 blue:219/256.0 alpha:1.0]
#define CALENDAR_DAY_DISABLED_COLOR [UIColor lightGrayColor]
//#define CALENDAR_MONTH_TITLE_COLOR [UIColor colorWithRed:211/256.0 green:84/256.0 blue:0/256.0 alpha:1.0]
#define CALENDAR_TODAY_TINT_COLOR [UIColor colorWithRed:155/256.0 green:89/256.0 blue:182/256.0 alpha:1.0]

#define CALENDAR_TINT_COLOR [UIColor colorWithRed:192/256.0 green:57/256.0 blue:43/256.0 alpha:1.0]
#define CALENDAR_BAR_TINT_COLOR [UIColor whiteColor]

#define CALENDAR_HEADER_SIZE CGSizeMake(100,60)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CalendarPickerVCDelegate;

@interface CalendarPickerCVC : UICollectionViewController

@property(nonatomic, weak) id <CalendarPickerVCDelegate> calendarDelegate;
@property NSDate *startDate;
@property BOOL periodMode;

//colors
@property UIColor *dayDisabledTintColor;
@property UIColor *weekdayTintColor;
@property UIColor *weekendTintColor;
@property UIColor *todayTintColor;
@property UIColor *dateSelectedColor;
@property UIColor *monthTitleColor;
@property UIColor *dayTitleColor;

-(instancetype) initWithStartDate:(NSDate *)startDate;
-(instancetype) initWithSelectedDates:(NSArray *)dates;
-(instancetype) initWithSelectedDates:(NSArray *)dates startDate:(NSDate *)startDate;

-(void) changeMode;
-(NSMutableArray *)validationDates;

@end


@protocol CalendarPickerVCDelegate<NSObject>

-(void) didSelectDates:(NSArray *)dates;

@end
