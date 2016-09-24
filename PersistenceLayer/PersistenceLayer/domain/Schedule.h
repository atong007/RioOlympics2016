//
//  Schedule.h
//  PersistenceLayer
//
//  Created by 洪龙通 on 2016/9/23.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Events;
@interface Schedule : NSObject

// 编号
@property (nonatomic, assign) int ScheduleID;

// 比赛日期
@property (nonatomic, copy) NSString *GameDate;

// 比赛时间
@property (nonatomic, copy) NSString *GameTime;

// 比赛描述
@property (nonatomic, copy) NSString *GameInfo;

// 比赛项目
@property (nonatomic, strong) Events *Event;

@end
