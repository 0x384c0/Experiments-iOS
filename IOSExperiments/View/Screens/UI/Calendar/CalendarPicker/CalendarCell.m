//
//  CalendarCell.m
//  BJ
//
//  Created by AK on 6/23/16.
//  Copyright © 2016 AK. All rights reserved.
//

#import "CalendarCell.h"

#define DELAY 0.5

@implementation CalendarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)selectDay {

}

- (void)deselectDay {

}

- (void)setAsToday {

}

- (void)selectDayWithColor:(UIColor *)color {

    [UIView animateWithDuration:DELAY animations:^{
        self.lblDay.layer.cornerRadius = self.lblDay.frame.size.width / 2;
        self.lblDay.layer.backgroundColor = color.CGColor;
        self.lblDay.textColor = [UIColor whiteColor];
    } completion:nil];
}

- (void)deselectDayWithColor:(UIColor *)color {

    [UIView animateWithDuration:DELAY animations:^{
        self.lblDay.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.lblDay.textColor = color;
    } completion:nil];

}

- (void)selectAsTodayWithColor:(UIColor *)color {

    [UIView animateWithDuration:DELAY animations:^{
        self.lblDay.layer.cornerRadius = self.lblDay.frame.size.width / 2;
        self.lblDay.layer.backgroundColor = color.CGColor;
        self.lblDay.textColor  = [UIColor whiteColor];
    } completion:nil];

}

- (void)setAsSelectedDayColor:(UIColor *)color {
    self.lblDay.layer.cornerRadius = self.lblDay.frame.size.width / 2;
    self.lblDay.layer.backgroundColor = color.CGColor;
    self.lblDay.textColor = [UIColor whiteColor];
}

- (void)setAsDeselectedDayWithColor:(UIColor *)color {
    self.lblDay.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.lblDay.textColor = color;
}

- (void)setAsTodayWithColor:(UIColor *)color {
    self.lblDay.layer.cornerRadius = self.lblDay.frame.size.width / 2;
    self.lblDay.layer.backgroundColor = color.CGColor;
    self.lblDay.textColor  = [UIColor whiteColor];
}


@end
