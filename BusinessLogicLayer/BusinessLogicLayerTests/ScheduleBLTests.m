//
//  ScheduleBLTests.m
//  BusinessLayer
//
//  Created by 洪龙通 on 2016/9/25.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ScheduleBL.h"
#import <PersistenceLayer/ScheduleDao.h>
#import <PersistenceLayer/Schedule.h>
#import <PersistenceLayer/Events.h>

@interface ScheduleBLTests : XCTestCase

@property (nonatomic, strong) ScheduleBL *scheduleBL;
@property (nonatomic, strong) Schedule *theSchedule;
@end

@implementation ScheduleBLTests

- (void)setUp {
    [super setUp];

    self.scheduleBL = [[ScheduleBL alloc] init];
    
    self.theSchedule = [[Schedule alloc] init];
    Events *Event = [[Events alloc] init];
    Event.EventID = 10;
    Event.EventName = @"Cycling Mountain Bike";
    self.theSchedule = [[Schedule alloc] init];
    self.theSchedule.Event = Event;
    self.theSchedule.GameDate = @"test BL GameDate";
    self.theSchedule.GameTime = @"test BL GameTime";
    self.theSchedule.GameInfo = @"test BL GameInfo";
    [[ScheduleDao sharedInstance] create:self.theSchedule];
}

- (void)tearDown {
    [super tearDown];
    self.theSchedule.ScheduleID = 502;
    [[ScheduleDao sharedInstance] remove:self.theSchedule];

    self.scheduleBL = nil;
}

- (void)test_1_readData {
    
    NSDictionary *resultDict = [self.scheduleBL readData];
    
    NSArray *keysArray = [resultDict allKeys];
    XCTAssertEqual([keysArray count], 18);// 总共17天 + 测试添加的一个
    
    Schedule *resultSchedule = resultDict[self.theSchedule.GameDate][0];
    
    XCTAssertEqualObjects(resultSchedule.GameDate, self.theSchedule.GameDate);
    XCTAssertEqualObjects(resultSchedule.GameTime, self.theSchedule.GameTime);
    XCTAssertEqualObjects(resultSchedule.GameInfo, self.theSchedule.GameInfo);
    XCTAssertEqual(resultSchedule.Event.EventID, self.theSchedule.Event.EventID);
    XCTAssertEqualObjects(resultSchedule.Event.EventName, self.theSchedule.Event.EventName);

}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
