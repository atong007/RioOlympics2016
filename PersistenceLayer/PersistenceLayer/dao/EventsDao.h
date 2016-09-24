//
//  EventsDao.h
//  PersistenceLayer
//
//  Created by 洪龙通 on 2016/9/23.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BaseDao.h"

@class Events;
@interface EventsDao : BaseDao

// 创建Events
- (int)create:(Events *)events;

// 查找所有Events
- (NSArray *)findAll;

// 指定ID查找
- (Events *)findById:(int)eventID;

// 修改Events
- (int)modify:(Events *)events;

// 删除Events
- (int)remove:(Events *)events;

+ (instancetype)sharedInstance;
@end
