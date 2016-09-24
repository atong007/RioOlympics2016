//
//  ScheduleDao.m
//  PersistenceLayer
//
//  Created by 洪龙通 on 2016/9/23.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "ScheduleDao.h"
#import "Schedule.h"
#import "Events.h"

@implementation ScheduleDao

static ScheduleDao *scheduleDao;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scheduleDao = [[self alloc] init];
    });
    return scheduleDao;
}

- (int)create:(Schedule *)schedule {
    
    NSLog(@"eventID:%d", schedule.Event.EventID);
    if ([self openDB]) {
        NSString *sqlStr = @"INSERT INTO Schedule(GameDate, GameTime, GameInfo, EventID) VALUES(?, ?, ?, ?)";
        sqlite3_stmt *statement;
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            // 绑定参数
            sqlite3_bind_text(statement, 1, [schedule.GameDate UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [schedule.GameTime UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [schedule.GameInfo UTF8String], -1, NULL);
            sqlite3_bind_int(statement,  4, schedule.Event.EventID);
            
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
        NSString *sqlStr = @"SELECT * FROM Schedule";
        
        sqlite3_stmt *statement;
        // 预处理过程
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            // 执行查询
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                Schedule *schedule = [[Schedule alloc] init];
                Events *Event = [[Events alloc] init];
                schedule.Event = Event;
                
                schedule.ScheduleID = sqlite3_column_int(statement, 0);

                char *cGameDate = (char *)sqlite3_column_text(statement, 1);
                schedule.GameDate = [NSString stringWithUTF8String:cGameDate];
                
                char *cGameTime = (char *)sqlite3_column_text(statement, 2);
                schedule.GameTime = [NSString stringWithUTF8String:cGameTime];
                
                char *cGameInfo = (char *)sqlite3_column_text(statement, 3);
                schedule.GameInfo = [NSString stringWithUTF8String:cGameInfo];
                
                schedule.Event.EventID = sqlite3_column_int(statement, 4);
                
                [listData addObject:schedule];
            }
        }else {
            NSLog(@"预处理查询失败");
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return [listData copy];
}

- (Schedule *)findById:(int)scheduleID
{
    Schedule *schedule = [[Schedule alloc] init];
    if ([self openDB]) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM Schedule WHERE ScheduleID=%i", scheduleID];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            // 执行查询
            if (sqlite3_step(statement) == SQLITE_ROW) {
                
                Events *Event = [[Events alloc] init];
                schedule.Event = Event;
                
                schedule.ScheduleID = sqlite3_column_int(statement, 0);
                
                char *cGameDate = (char *)sqlite3_column_text(statement, 1);
                schedule.GameDate = [NSString stringWithUTF8String:cGameDate];
                
                char *cGameTime = (char *)sqlite3_column_text(statement, 2);
                schedule.GameTime = [NSString stringWithUTF8String:cGameTime];
                
                char *cGameInfo = (char *)sqlite3_column_text(statement, 3);
                schedule.GameInfo = [NSString stringWithUTF8String:cGameInfo];
                
                schedule.Event.EventID = sqlite3_column_int(statement, 4);
            }else {
                NSLog(@"未查到数据");
                schedule = nil;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return schedule;
}

- (int)modify:(Schedule *)schedule
{
    if ([self openDB]) {
        NSString *sqlStr = @"UPDATE Schedule SET GameDate=?, GameTime=?, GameInfo=?, EventID=? WHERE ScheduleID=?";
        
        sqlite3_stmt *statement;
        //预处理过程
        if (sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            //绑定参数开始
            sqlite3_bind_text(statement, 1, [schedule.GameDate UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [schedule.GameTime UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [schedule.GameInfo UTF8String], -1, NULL);
            sqlite3_bind_int(statement,  4, schedule.Event.EventID);
            sqlite3_bind_int(statement, 5, schedule.ScheduleID);
            
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

- (int)remove:(Schedule *)schedule
{
    int resultCode = 0;
    if ([self openDB]) {
        
        // 删除比赛日程表相关数据
        NSString *sqlScheduleStr = [NSString stringWithFormat:@"DELETE FROM Schedule WHERE ScheduleID=%i", schedule.ScheduleID];
        
        // 开启事务，立刻提交之前事务
        sqlite3_exec(db, "BEGIN IMMEDIATE TRANSACTION", NULL, NULL, NULL);
        
        if (sqlite3_exec(db, [sqlScheduleStr UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
            // 回滚事务
            sqlite3_exec(db, "ROLLBACK TRANSACTION", NULL, NULL, NULL);
            NSAssert(FALSE, @"删除表数据失败");
            resultCode = -1;
        }
        // 提交事务
        sqlite3_exec(db, "COMMIT TRANSACTION", NULL, NULL, NULL);
        
        sqlite3_close(db);
    }
    return resultCode;
}

@end
