//
//  EventsBL.m
//  BusinessLayer
//
//  Created by 洪龙通 on 2016/9/25.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "EventsBL.h"
#import <PersistenceLayer/EventsDao.h>
#import <PersistenceLayer/Events.h>

@implementation EventsBL

//查询所有数据方法
-(NSArray *) readData {
    return [[EventsDao sharedInstance] findAll];
}
@end
