//
//  DBHelper.m
//  PersistenceLayer
//
//  Created by 洪龙通 on 2016/9/23.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBHelper.h"

@class PersistenceLayer;
@implementation DBHelper

+ (const char *)applicationDocumentsDirectoryFile:(NSString *)fileName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return [filePath UTF8String];
}

+ (void)initDB
{
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[DBHelper class]];
    NSLog(@"bundle:%@", frameworkBundle.bundlePath);
    NSString *configFilePath = [frameworkBundle pathForResource:@"DBconfig" ofType:@"plist"];
    
    NSDictionary *configTable = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
    // 从配置文件中取出数据库版本号
    NSNumber *dbConfigVersion = [configTable objectForKey:@"DB_VERSION"];
    if (dbConfigVersion == nil) {
        dbConfigVersion = 0;
    }
    
    // 从数据库的DBVersion表记录返回的数据库版本号
    int versionNumber = [DBHelper dbVersionNumber];
    
    if ([dbConfigVersion intValue] != versionNumber) {
        const char *dbFilePath = [self applicationDocumentsDirectoryFile:DB_FILE_NAME];
        if (sqlite3_open(dbFilePath, &db) == SQLITE_OK) {
            // 加载数据到业务表中
            NSLog(@"数据库升级...");
            NSString *createtablePath = [frameworkBundle pathForResource:@"create_load" ofType:@"sql"];
            NSLog(@"createtablePath:%@", createtablePath);
            NSString *sql = [NSString stringWithContentsOfFile:createtablePath encoding:NSUTF8StringEncoding error:nil];
            
            int result = sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL);
            NSLog(@"Initial result Code:%d", result);
            
            // 把当前版本号写回到文件中
            NSString *usql = [NSString stringWithFormat:@"UPDATE DBVersionInfo SET version_number = %i", [dbConfigVersion intValue]];
            sqlite3_exec(db, [usql UTF8String], NULL, NULL, NULL);
        }else{
            NSLog(@"数据库打开失败");
        }
        sqlite3_close(db);
    }
}

+ (int)dbVersionNumber
{
    int versionNumber = -1;
    
    const char *dbFilePath = [DBHelper applicationDocumentsDirectoryFile:DB_FILE_NAME];
    if (sqlite3_open(dbFilePath, &db) == SQLITE_OK) {
        // 创建DBVersionInfo表来存储版本号
        NSString *sql = @"Create table if not exists DBVersionInfo(version_number int)";
        sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL);
        
        NSString *qsql = @"select version_number from DBVersionInfo";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            // 执行查询
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSLog(@"有数据情况");
                versionNumber = sqlite3_column_int(statement, 0);
            }else {
                NSLog(@"无数据情况");
                NSString *insertSql = @"insert into DBVersionInfo(version_number) values(-1)";
                sqlite3_exec(db, [insertSql UTF8String], NULL, NULL, NULL);
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }else {
        sqlite3_close(db);
    }
    
    return versionNumber;
}
@end
