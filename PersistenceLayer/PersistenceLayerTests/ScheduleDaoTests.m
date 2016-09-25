//
//  ScheduleDaoTests.m
//  PersistenceLayer
//
//  Created by 洪龙通 on 2016/9/23.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ScheduleDao.h"
#import "Schedule.h"
#import "Events.h"

@interface ScheduleDaoTests : XCTestCase
@property (nonatomic, strong) ScheduleDao *dao;
@property (nonatomic, strong) Schedule *theSchedule;
@end

@implementation ScheduleDaoTests

- (void)setUp {
    [super setUp];
    self.dao = [ScheduleDao sharedInstance];
    Events *Event = [[Events alloc] init];
    Event.EventID = 1;
    self.theSchedule = [[Schedule alloc] init];
    self.theSchedule.Event = Event;
    self.theSchedule.GameDate = @"test GameDate";
    self.theSchedule.GameTime = @"test GameTime";
    self.theSchedule.GameInfo = @"test GameInfo";
}

- (void)tearDown {
    [super tearDown];
    self.dao = nil;
}

- (void)test_1_Create {
    
    int res = [self.dao create:self.theSchedule];
    XCTAssertEqual(res, 0);
}

- (void)test_2_FindById {
    self.theSchedule.ScheduleID = 502;
    Schedule *resultSchedule = [self.dao findById:502];
    XCTAssertNotNil(resultSchedule, @"查询记录为nil");
    
    XCTAssertEqualObjects(resultSchedule.GameDate, self.theSchedule.GameDate);
    XCTAssertEqualObjects(resultSchedule.GameTime, self.theSchedule.GameTime);
    XCTAssertEqualObjects(resultSchedule.GameInfo, self.theSchedule.GameInfo);
    XCTAssertEqual(resultSchedule.Event.EventID, self.theSchedule.Event.EventID);
}

- (void)test_3_FindAll{
    
    NSArray *resultArray = [self.dao findAll];
    XCTAssertEqual([resultArray count], 502);
    
    Schedule *lastSchedule = [resultArray lastObject];
    
    XCTAssertEqualObjects(lastSchedule.GameDate, self.theSchedule.GameDate);
    XCTAssertEqualObjects(lastSchedule.GameTime, self.theSchedule.GameTime);
    XCTAssertEqualObjects(lastSchedule.GameInfo, self.theSchedule.GameInfo);
    XCTAssertEqual(lastSchedule.Event.EventID, self.theSchedule.Event.EventID);
}

- (void)test_4_Modify{
    self.theSchedule.ScheduleID = 502;
    self.theSchedule.GameDate = @"test modify GameDate";
    
    int result = [self.dao modify:self.theSchedule];
    XCTAssertEqual(result, 0);
    
    Schedule *resultSchedule = [self.dao findById:502];
    
    XCTAssertNotNil(resultSchedule, @"查询记录为nil");
    
    XCTAssertEqualObjects(resultSchedule.GameDate, self.theSchedule.GameDate);
    XCTAssertEqualObjects(resultSchedule.GameTime, self.theSchedule.GameTime);
    XCTAssertEqualObjects(resultSchedule.GameInfo, self.theSchedule.GameInfo);
    XCTAssertEqual(resultSchedule.Event.EventID, self.theSchedule.Event.EventID);
    
}

- (void)test_5_remove{
    self.theSchedule.ScheduleID = 502;
    int result = [self.dao remove:self.theSchedule];
    
    XCTAssertEqual(result, 0);
    Schedule *resultSchedule = [self.dao findById:self.theSchedule.ScheduleID];
    XCTAssertNil(resultSchedule, @"记录删除失败");
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
