//
//  ScheduleBL.m
//  BusinessLayer
//
//  Created by 洪龙通 on 2016/9/25.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "ScheduleBL.h"
#import <PersistenceLayer/ScheduleDao.h>
#import <PersistenceLayer/Schedule.h>
#import <PersistenceLayer/Events.h>
#import <PersistenceLayer/EventsDao.h>

@implementation ScheduleBL

- (NSDictionary *)readData {
	
    NSArray *array = [[ScheduleDao sharedInstance] findAll];
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    
    for (Schedule *schedule in array) {
        
        NSArray *resultKeys = [resultDict allKeys];
        schedule.Event = [[EventsDao sharedInstance] findById:schedule.Event.EventID];
        if ([resultKeys containsObject:schedule.GameDate]) {
            [resultDict[schedule.GameDate] addObject:schedule];
        }else{
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:schedule];
            [resultDict setObject:array forKey:schedule.GameDate];
        }
    }
    
    return [resultDict copy];
}
@end
