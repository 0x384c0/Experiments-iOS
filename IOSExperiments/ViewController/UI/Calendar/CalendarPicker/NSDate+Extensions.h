//
//  NSDate+Extensions.h
//  BJ
//
//  Created by AK on 6/23/16.
//  Copyright © 2016 AK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extensions)

- (instancetype) initWithYear:(NSInteger) year month:(NSInteger) month day:(NSInteger) day;
- (NSDate *) firstDayOfMonth;
- (NSDate *) dateByAddingMonths:(NSInteger) month;
- (NSDate *) dateByAddingDay:(NSInteger) day;

- (NSInteger) day;
- (NSInteger) month;
- (NSInteger) year;

- (NSInteger) weekday;
- (NSInteger) numberOfDaysInMonth;
- (NSString *) monthNameFull;

- (BOOL) isSunday;
- (BOOL) isMonday;
- (BOOL) isTuesday;
- (BOOL) isWednesday;
- (BOOL) isThursday;
- (BOOL) isFriday;
- (BOOL) isSaturday;

- (NSInteger) getWeekday;
- (BOOL) isToday;
- (BOOL) isDateSameDay:(NSDate *)date;

- (BOOL) laterThan:(NSDate *)date;
- (BOOL) lessThan:(NSDate *)date;

@end
