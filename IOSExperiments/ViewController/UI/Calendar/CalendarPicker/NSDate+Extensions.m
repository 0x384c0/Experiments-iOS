//
//  NSDate+Extensions.m
//  BJ
//
//  Created by AK on 6/23/16.
//  Copyright © 2016 AK. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

- (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [NSDateComponents new];
    dateComponent.year = year;
    dateComponent.month = month;
    dateComponent.day = day;
    return [self initWithTimeInterval:0 sinceDate:[calendar dateFromComponents:dateComponent]];
}


- (NSDate *)firstDayOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    dateComponent.day = 1;
    return [calendar dateFromComponents:dateComponent];
}

- (NSDate *)dateByAddingMonths:(NSInteger) month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [NSDateComponents new];
    dateComponent.month = month;
    return [calendar dateByAddingComponents:dateComponent toDate:self options:NSCalendarMatchNextTime];
}

- (NSDate *)dateByAddingDay:(NSInteger) day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [NSDateComponents new];
    dateComponent.day = day;
    return [calendar dateByAddingComponents:dateComponent toDate:self options:NSCalendarMatchNextTime];
}

-(NSInteger) day{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self].day;
}

-(NSInteger) month{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self].month;
}

-(NSInteger) year{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self].year;
}

-(NSInteger) weekday{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self].weekday;
}


-(NSInteger) numberOfDaysInMonth{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

-(NSString *)monthNameFull{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MMMM YYYY";
    return [dateFormatter stringFromDate:self];
}

-(BOOL) isSunday{
    return [self getWeekday] == 1;
}

-(BOOL) isMonday{
    return [self getWeekday] == 2;
}

-(BOOL) isTuesday{
    return [self getWeekday] == 3;
}

-(BOOL) isWednesday{
    return [self getWeekday] == 4;
}

-(BOOL) isThursday{
    return [self getWeekday] == 5;
}

-(BOOL) isFriday{
    return [self getWeekday] == 6;
}

-(BOOL) isSaturday{
    return [self getWeekday] == 7;
}

-(NSInteger) getWeekday{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self].weekday;
}

-(BOOL) isToday{
    return [self isDateSameDay:[NSDate new]];
}

-(BOOL) isDateSameDay:(NSDate *)date{
    return ([self day] == date.day) && ([self month] == date.month && ([self year] == date.year));
}

- (BOOL)laterThan:(NSDate *)date {
    return [date compare:self] == NSOrderedAscending;
}

- (BOOL)lessThan:(NSDate *)date {
    return [self compare:date] == NSOrderedAscending;
}


@end
