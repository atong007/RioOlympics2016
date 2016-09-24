//
//  Events.h
//  PersistenceLayer
//
//  Created by 洪龙通 on 2016/9/23.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Events : NSObject

// 编号
@property (nonatomic, assign) int EventID;

// 项目名
@property (nonatomic, copy) NSString *EventName;

// 项目图标
@property (nonatomic, copy) NSString *EventIcon;

// 项目关键信息
@property (nonatomic, copy) NSString *keyInfo;

// 项目基本信息
@property (nonatomic, copy) NSString *BasicsInfo;

// 项目奥运会历史信息
@property (nonatomic, copy) NSString *OlympicInfo;

@end
