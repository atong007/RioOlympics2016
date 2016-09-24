//
//  ScheduleDao.h
//  PersistenceLayer
//
//  Created by 洪龙通 on 2016/9/23.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BaseDao.h"

@class Schedule;
@interface ScheduleDao : BaseDao
// 创建Schedule
- (int)create:(Schedule *)schedule;

// 查找所有Schedule
- (NSArray *)findAll;

// 指定ID查找
- (Schedule *)findById:(int)scheduleID;

// 修改Schedule
- (int)modify:(Schedule *)schedule;

// 删除Events
- (int)remove:(Schedule *)schedule;

+ (instancetype)sharedInstance;
@end
