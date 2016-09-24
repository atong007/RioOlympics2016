//
//  BaseDao.h
//  PersistenceLayer
//
//  Created by 洪龙通 on 2016/9/23.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "DBHelper.h"

@interface BaseDao : NSObject
{
    sqlite3 *db;
}
// 打开SQLite数据库
- (BOOL)openDB;
@end
