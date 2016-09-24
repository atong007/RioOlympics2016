//
//  EventsDao.m
//  PersistenceLayer
//
//  Created by 洪龙通 on 2016/9/23.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "EventsDao.h"
#import "Events.h"

@implementation EventsDao
static EventsDao *eventsDao;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventsDao = [[self alloc] init];
    });
    return eventsDao;
}

- (int)create:(Events *)events {
	
    if ([self openDB]) {
        NSString *sqlStr = @"INSERT INTO Events(EventName, EventIcon, KeyInfo, BasicsInfo, OlympicInfo) VALUES(?, ?, ?, ?, ?)";
        sqlite3_stmt *statement;
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            // 绑定参数
            sqlite3_bind_text(statement, 1, [events.EventName UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [events.EventIcon UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [events.keyInfo UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 4, [events.BasicsInfo UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 5, [events.OlympicInfo UTF8String], -1, NULL);
            
            // 执行插入
            if (sqlite3_step(statement) != SQLITE_DONE) {
                sqlite3_finalize(statement);
                sqlite3_close(db);
                NSAssert(FALSE, @"插入数据失败。");
                return -1;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return 0;
}

- (NSArray *)findAll
{
    NSMutableArray *listData = [NSMutableArray array];
    if ([self openDB]) {
        NSString *sqlStr = @"SELECT * FROM Events";
        
        sqlite3_stmt *statement;
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            // 执行查询
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                Events *events = [[Events alloc] init];
                char *cEventName = (char *)sqlite3_column_text(statement, 1);
                events.EventName = [NSString stringWithUTF8String:cEventName];
                
                char *cEventIcon = (char *)sqlite3_column_text(statement, 2);
                events.EventIcon = [NSString stringWithUTF8String:cEventIcon];
                
                char *cKeyInfo = (char *)sqlite3_column_text(statement, 3);
                events.keyInfo = [NSString stringWithUTF8String:cKeyInfo];
                
                char *cBasicsInfo = (char *)sqlite3_column_text(statement, 4);
                events.BasicsInfo = [NSString stringWithUTF8String:cBasicsInfo];
                
                char *cOlympicInfo = (char *)sqlite3_column_text(statement, 5);
                events.OlympicInfo = [NSString stringWithUTF8String:cOlympicInfo];
                
                events.EventID = sqlite3_column_int(statement, 0);
                
                [listData addObject:events];
            }
        }else {
            NSLog(@"预处理查询失败");
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return [listData copy];
}

- (Events *)findById:(int)eventID
{
    Events *events = [[Events alloc] init];
    if ([self openDB]) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM Events WHERE EventID=%i", eventID];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            // 执行查询
            if (sqlite3_step(statement) == SQLITE_ROW) {
                
                char *cEventName = (char *)sqlite3_column_text(statement, 1);
                events.EventName = [NSString stringWithUTF8String:cEventName];
                
                char *cEventIcon = (char *)sqlite3_column_text(statement, 2);
                events.EventIcon = [NSString stringWithUTF8String:cEventIcon];
                
                char *cKeyInfo = (char *)sqlite3_column_text(statement, 3);
                events.keyInfo = [NSString stringWithUTF8String:cKeyInfo];
                
                char *cBasicsInfo = (char *)sqlite3_column_text(statement, 4);
                events.BasicsInfo = [NSString stringWithUTF8String:cBasicsInfo];
                
                char *cOlympicInfo = (char *)sqlite3_column_text(statement, 5);
                events.OlympicInfo = [NSString stringWithUTF8String:cOlympicInfo];
                
                events.EventID = sqlite3_column_int(statement, 0);
            }else {
                NSLog(@"未查到数据");
                events = nil;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return events;
}

- (int)modify:(Events *)events
{
    if ([self openDB]) {
        NSString *sqlStr = @"UPDATE Events set EventName=?, EventIcon=?,KeyInfo=?,BasicsInfo=?,OlympicInfo=? where EventID =?";
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            //绑定参数开始
            sqlite3_bind_text(statement, 1, [events.EventName UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [events.EventIcon UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [events.keyInfo UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 4, [events.BasicsInfo UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 5, [events.OlympicInfo UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 6, events.EventID);
            
            //执行
            if (sqlite3_step(statement) != SQLITE_DONE) {
                sqlite3_finalize(statement);
                sqlite3_close(db);
                NSAssert(NO, @"修改数据失败。");
                return -1;
            }
        }
        sqlite3_finalize(statement);
    }else {
        NSLog(@"打开数据库失败");
    }
    sqlite3_close(db);
    return 0;
}

- (int)remove:(Events *)events
{
    int resultCode = 0;
    if ([self openDB]) {
        
        // 先删除从表（比赛日程表）相关数据
        NSString *sqlScheduleStr = [NSString stringWithFormat:@"DELETE FROM Schedule WHERE EventID=%i", events.EventID];
        
        // 开启事务，立刻提交之前事务
        sqlite3_exec(db, "BEGIN IMMEDIATE TRANSACTION", NULL, NULL, NULL);
        
        char *error;
        
        if (sqlite3_exec(db, [sqlScheduleStr UTF8String], NULL, NULL, &error) != SQLITE_OK) {
            // 回滚事务
            sqlite3_exec(db, "ROLLBACK TRANSACTION", NULL, NULL, NULL);
            NSAssert(FALSE, @"删除从表数据失败");
            resultCode = -1;
        }
        
        // 删除主表（比赛项目）数据
        NSString *sqlEventsStr = [NSString stringWithFormat:@"DELETE FROM Events WHERE EventID=%i", events.EventID];
        
        if (sqlite3_exec(db, [sqlEventsStr UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
            // 回滚事务
            sqlite3_exec(db, "ROLLBACK TRANSACTION", NULL, NULL, NULL);
            NSAssert(FALSE, @"删除主表数据失败");
            resultCode = -1;
        }
        // 提交事务
        sqlite3_exec(db, "COMMIT TRANSACTION", NULL, NULL, NULL);
        
        sqlite3_close(db);
    }
    return resultCode;
}


@end
