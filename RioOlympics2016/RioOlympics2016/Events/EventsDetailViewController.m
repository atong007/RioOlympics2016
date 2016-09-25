//
//  EventsDetailViewController.m
//  RioOlympics2016
//
//  Created by 洪龙通 on 2016/9/25.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "EventsDetailViewController.h"
#import <PersistenceLayer/Events.h>

@interface EventsDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblEventName;
@property (weak, nonatomic) IBOutlet UIImageView *imgEventIcon;
@property (weak, nonatomic) IBOutlet UITextView *txtViewKeyInfo;
@property (weak, nonatomic) IBOutlet UITextView *txtViewBasicsInfo;
@property (weak, nonatomic) IBOutlet UITextView *txtViewOlympicInfo;
@end

@implementation EventsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lblEventName.text = self.event.EventName;
    self.imgEventIcon.image = [UIImage imageNamed:self.event.EventIcon];
    self.txtViewKeyInfo.text = self.event.keyInfo;
    self.txtViewBasicsInfo.text = self.event.BasicsInfo;
    self.txtViewOlympicInfo.text = self.event.OlympicInfo;
}

@end
