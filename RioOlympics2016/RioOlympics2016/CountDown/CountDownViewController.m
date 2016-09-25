//
//  CountDownViewController.m
//  RioOlympics2016
//
//  Created by 洪龙通 on 2016/9/26.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "CountDownViewController.h"

@interface CountDownViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger countDownDay = [self getCountDownDate];
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%li 天", countDownDay]];
    [strAttr addAttribute:NSFontAttributeName
                                          value:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]
                                          range:NSMakeRange([strAttr length] -1 , 1)];
    
    self.timeLabel.attributedText = strAttr;
    [self.view bringSubviewToFront:self.timeLabel];
}

- (NSInteger)getCountDownDate
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = 5;
    dateComponents.month = 8;
    dateComponents.year = 2016;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorianCalendar dateFromComponents:dateComponents];
    
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:NSCalendarWrapComponents];
    return [components day];
}

@end
