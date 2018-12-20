//
//  CalendarCell.h
//  BJ
//
//  Created by AK on 6/23/16.
//  Copyright © 2016 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDay;


@property NSDate *currentDate;
@property BOOL isCellSelectable;

-(void) selectDayWithColor:(UIColor *)color;
-(void) deselectDayWithColor:(UIColor *)color;
-(void) selectAsTodayWithColor:(UIColor *)color;

-(void) setAsSelectedDayColor:(UIColor *)color;
-(void) setAsDeselectedDayWithColor:(UIColor *)color;
-(void) setAsTodayWithColor:(UIColor *)color;

@end
