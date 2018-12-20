//
//  CalendarHeaderView.m
//  BJ
//
//  Created by AK on 6/23/16.
//  Copyright © 2016 AK. All rights reserved.
//

#import "CalendarHeaderView.h"

@implementation CalendarHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

    NSArray *weeksDayList = [[NSCalendar currentCalendar] shortWeekdaySymbols];


    if ([NSCalendar currentCalendar].firstWeekday == 2) {
        self.lblFirst.text = weeksDayList[1];
        self.lblSecond.text = weeksDayList[2];
        self.lblThird.text = weeksDayList[3];
        self.lblFourth.text = weeksDayList[4];
        self.lblFifth.text = weeksDayList[5];
        self.lblSixth.text = weeksDayList[6];
        self.lblSeventh.text = weeksDayList[0];
    } else {
        self.lblFirst.text = weeksDayList[0];
        self.lblSecond.text = weeksDayList[1];
        self.lblThird.text = weeksDayList[2];
        self.lblFourth.text = weeksDayList[3];
        self.lblFifth.text = weeksDayList[4];
        self.lblSixth.text = weeksDayList[5];
        self.lblSeventh.text = weeksDayList[6];
    }
}

- (void)updateWeekdaysLabelColor:(UIColor *)color {
    self.lblFirst.textColor = color;
    self.lblSecond.textColor = color;
    self.lblThird.textColor = color;
    self.lblFourth.textColor = color;
    self.lblFifth.textColor = color;
}

- (void)updateWeekendLabelColor:(UIColor *)color {
    self.lblSixth.textColor = color;
    self.lblSeventh.textColor = color;
}


@end
