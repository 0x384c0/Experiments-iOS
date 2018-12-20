//
//  CalendarHeaderView.h
//  BJ
//
//  Created by AK on 6/23/16.
//  Copyright © 2016 AK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblThird;
@property (weak, nonatomic) IBOutlet UILabel *lblFourth;
@property (weak, nonatomic) IBOutlet UILabel *lblFifth;
@property (weak, nonatomic) IBOutlet UILabel *lblSixth;
@property (weak, nonatomic) IBOutlet UILabel *lblSeventh;

-(void) updateWeekdaysLabelColor:(UIColor *)color;
-(void) updateWeekendLabelColor:(UIColor *)color;


@end
