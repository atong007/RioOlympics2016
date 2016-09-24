//
//  BaseDao.m
//  PersistenceLayer
//
//  Created by 洪龙通 on 2016/9/23.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BaseDao.h"

@implementation BaseDao

- (instancetype)init{
    if (self = [super init]) {
        // 初始化数据库
        [DBHelper initDB];
    }
    return self;
}

- (BOOL)openDB {
    
    const char *dbFilePath = [DBHelper applicationDocumentsDirectoryFile:DB_FILE_NAME];
    
    NSLog(@"DBFilePath =%s", dbFilePath);
    
    if (sqlite3_open(dbFilePath, &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
        return FALSE;
    }
    return TRUE;
}
@end
