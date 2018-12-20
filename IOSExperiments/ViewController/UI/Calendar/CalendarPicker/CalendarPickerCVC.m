//
// Created by AK on 6/24/16.
// Copyright (c) 2016 AK. All rights reserved.
//

#import "CalendarPickerCVC.h"
#import "NSDate+Extensions.h"
#import "CalendarCell.h"
#import "CalendarHeaderView.h"
#import "UICollectionView+Extensions.h"

#define CALENDAR_CELL_ID @"Cell"
#define CALENDAR_HEADER_ID @"Header"


@interface CalendarPickerCVC() <UICollectionViewDelegateFlowLayout>

@property NSMutableArray *selectedDates;
@property NSInteger startYear;
@property NSInteger endYear;

@end

@implementation CalendarPickerCVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup collectionview
    self.collectionView.delegate = self;
//    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.directionalLockEnabled = YES;

    [self.collectionView registerNib:[UINib nibWithNibName:@"CalendarCell" bundle:nil] forCellWithReuseIdentifier:CALENDAR_CELL_ID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CalendarHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CALENDAR_HEADER_ID];

    [self performSelector:@selector(scrollToToday) withObject:nil afterDelay:0];
}

- (void)changeMode {
    self.selectedDates = [NSMutableArray new];
    [self.collectionView reloadData];
}


- (void)scrollToToday {
    NSDate *date = [NSDate date];
    NSInteger section = (([date year] - self.startYear) * 12) + [date month];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:section-1];

    @try {
        [self.collectionView scrollToIndexpathByShowingHeader:indexPath];
    }
    @catch (NSException *e){
        NSLog(@"%@",e);
    }
}

- (instancetype)init {
    return [self initWithStartYear:[[NSDate date] year] endYear:[[NSDate date] year] + 1 selectedDates:nil];
}

-(instancetype) initWithStartYear:(NSInteger) startYear endYear:(NSInteger)endYear selectedDates:(NSArray *)selectedDates{

    self.startDate = [NSDate date];
    self.startYear = startYear;
    self.endYear = endYear;

    self.dayDisabledTintColor = CALENDAR_DAY_DISABLED_COLOR;
    self.weekdayTintColor = CALENDAR_WEEKDAY_TINT_COLOR;
    self.weekendTintColor = CALENDAR_WEEKEND_TINT_COLOR;
    self.dateSelectedColor = CALENDAR_DAY_SELECTED_COLOR;
    self.monthTitleColor = CALENDAR_MONTH_TITLE_COLOR;
    self.todayTintColor = CALENDAR_TODAY_TINT_COLOR;
    self.dayTitleColor = CALENDAR_DAY_ENABLE_TITLE_COLOR;

    self.selectedDates = selectedDates ? [selectedDates mutableCopy] : [NSMutableArray new];

    //Layout creation
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//    layout.sectionHeadersPinToVisibleBounds = YES;  // If you want make a floating header enable this property(Avaialble after iOS9)
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    layout.headerReferenceSize = CALENDAR_HEADER_SIZE;

    return (CalendarPickerCVC *) [super initWithCollectionViewLayout:layout];
}

- (instancetype)initWithStartDate:(NSDate *)startDate {
    self = [self initWithStartYear:[[NSDate date] year] endYear:[[NSDate date] year] + 1 selectedDates:nil];
    self.startDate = startDate;

    return self;
}


- (instancetype)initWithSelectedDates:(NSArray *)dates startDate:(NSDate *)startDate {
    self = [self initWithStartYear:[[NSDate date] year] endYear:[[NSDate date] year] + 1 selectedDates:dates];
    self.startDate = startDate;

    return self;
}


- (instancetype)initWithSelectedDates:(NSArray *)dates {
    self = [self initWithStartYear:[[NSDate date] year] endYear:[[NSDate date] year] + 1 selectedDates:dates];
    self.startDate = [NSDate date];

    return self;
}

-(NSInteger)countOfSameDateInSelectedDates:(NSDate *)date{
    NSInteger count = 0;
    for(NSDate *date1 in self.selectedDates)
        if([date1 isDateSameDay:date]) count ++;

    return count;
}


// MARK: UICollectionViewDataSource



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.startYear > self.endYear)
        return 0;

    return 12 * (self.endYear - self.startYear) + 12;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDate *startDate = [[NSDate alloc] initWithYear:self.startYear month:1 day:1];
    NSDate *firstDayOfMonth = [startDate dateByAddingMonths:section];
    NSInteger addingPrefixDaysWithMonthDyas = ( [firstDayOfMonth numberOfDaysInMonth] + [firstDayOfMonth weekday] - [[NSCalendar currentCalendar] firstWeekday]);
    NSInteger addingSuffixDays = addingPrefixDaysWithMonthDyas % 7;
    NSInteger totalNumber  = addingPrefixDaysWithMonthDyas;
    if (addingSuffixDays != 0) {
        totalNumber = totalNumber + (7 - addingSuffixDays);
    }

    return totalNumber;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CALENDAR_CELL_ID forIndexPath:indexPath];

    NSDate *calendarStartDate = [[NSDate alloc] initWithYear:self.startYear month:1 day:1];
    NSDate *firstDayOfThisMonth = [calendarStartDate dateByAddingMonths:indexPath.section];
    NSInteger prefixDays = ([firstDayOfThisMonth weekday] - [[NSCalendar currentCalendar] firstWeekday]);

    if (indexPath.row >= prefixDays) {
        cell.isCellSelectable = YES;
        NSDate *currentDate = [firstDayOfThisMonth dateByAddingDay:(indexPath.row - prefixDays)];
        NSDate *nextMonthFirstDay = [firstDayOfThisMonth dateByAddingDay:[firstDayOfThisMonth numberOfDaysInMonth] - 1];

        cell.currentDate = currentDate;
        cell.lblDay.text = [NSString stringWithFormat:@"%li", (long)[currentDate day]];

        if ([self countOfSameDateInSelectedDates:currentDate] > 0 && ([firstDayOfThisMonth month] == [currentDate month])) {
            [cell setAsSelectedDayColor:self.dateSelectedColor];
        }
        else{
            [cell setAsDeselectedDayWithColor:self.dayTitleColor];

            if (currentDate > nextMonthFirstDay) {
                cell.isCellSelectable = NO;
                cell.lblDay.textColor = [UIColor clearColor];
            }
            if ([currentDate isToday]) {
                [cell setAsTodayWithColor:self.todayTintColor];
            }
            
            if (self.startDate) {
                if ([[NSCalendar currentCalendar] startOfDayForDate:cell.currentDate] < [[NSCalendar currentCalendar] startOfDayForDate:self.startDate]) {
                    cell.isCellSelectable = NO;
                    cell.lblDay.textColor = self.dayDisabledTintColor;
                }
            }
        }
    }
    else {
        [cell setAsDeselectedDayWithColor:self.dayTitleColor];
        cell.isCellSelectable = NO;
        NSDate *previousDay = [firstDayOfThisMonth dateByAddingDay:(-(prefixDays - indexPath.row))];
        cell.currentDate = previousDay;
        cell.lblDay.text = [NSString stringWithFormat:@"%li", (long)[previousDay day]];
        cell.lblDay.textColor = [UIColor clearColor];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width - 7;
    return CGSizeMake(screenWidth/7, screenWidth/7);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 0, 5, 0);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        CalendarHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CALENDAR_HEADER_ID forIndexPath:indexPath];

        NSDate *startDate = [[NSDate alloc] initWithYear:self.startYear month:1 day:1];
        NSDate *firstDayOfMonth = [startDate dateByAddingMonths:indexPath.section];

        header.lblTitle.text = [firstDayOfMonth monthNameFull];
        header.lblTitle.textColor = self.monthTitleColor;
        [header updateWeekdaysLabelColor:self.weekdayTintColor];
        [header updateWeekendLabelColor:self.weekendTintColor];
        header.backgroundColor = [UIColor clearColor];

        return header;
    }
    
    return [CalendarHeaderView new];
}


// MARK: UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CalendarCell *cell = (CalendarCell *) [collectionView cellForItemAtIndexPath:indexPath];

    if (cell.isCellSelectable) {
        if(self.periodMode){
            if([self countOfSameDateInSelectedDates:cell.currentDate] == 0){
                [self.selectedDates addObject:cell.currentDate];
                [cell selectDayWithColor:self.dateSelectedColor];

                if([cell.currentDate isToday])
                    [cell selectAsTodayWithColor:self.dateSelectedColor];

                if([self.selectedDates count] > 2){
                    self.selectedDates = [NSMutableArray new];
                    [self.selectedDates addObject:cell.currentDate];
                    [self.collectionView reloadData];
                }

                if([self.selectedDates count] == 2){
                    self.selectedDates = [self periodDates];
                    [self.collectionView reloadData];
                }
            }else{
                self.selectedDates = [NSMutableArray new];
                [self.selectedDates addObject:cell.currentDate];
                [self.collectionView reloadData];
            }
        }else{
            if ([self countOfSameDateInSelectedDates:cell.currentDate] == 0){
                [self.selectedDates addObject:cell.currentDate];
                [cell selectDayWithColor:self.dateSelectedColor];

                if([cell.currentDate isToday])
                    [cell selectAsTodayWithColor:self.dateSelectedColor];
            }
            else {
                [self.selectedDates removeObject:cell.currentDate] ;

                [cell deselectDayWithColor:self.dayTitleColor];

                if ([cell.currentDate isToday])
                    [cell selectAsTodayWithColor:self.todayTintColor];
            }
        }
    }

    id <CalendarPickerVCDelegate> strongDelegate = self.calendarDelegate;

    if ([strongDelegate respondsToSelector:@selector(didSelectDates:)]) {
        [strongDelegate didSelectDates:[self validationDates]];
    }
}

-(NSMutableArray *)periodDates{

    NSDate *firstDate = self.selectedDates[0];
    NSDate *secondDate = self.selectedDates[1];

    if([firstDate laterThan:secondDate]){
        NSDate *date = firstDate;
        firstDate = secondDate;
        secondDate = date;
    }

    NSMutableArray *dates = [NSMutableArray array];
    while([firstDate timeIntervalSince1970] <= [secondDate timeIntervalSince1970])
    {
        [dates addObject:firstDate];
        firstDate = [NSDate dateWithTimeInterval:86400 sinceDate:firstDate];
    }

    return dates;
}

-(NSMutableArray *) validationDates{

    NSMutableArray *dates = [NSMutableArray new];
    for(NSDate *date in self.selectedDates){

        NSInteger seconds = [[NSTimeZone localTimeZone] secondsFromGMTForDate: date];
        NSDate *localeDate = [NSDate dateWithTimeInterval: seconds sinceDate: date];

        [dates addObject:localeDate];
    }

    return dates;
}


@end
