//
//  EventsBLTests.m
//  BusinessLayer
//
//  Created by 洪龙通 on 2016/9/25.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EventsBL.h"
#import <PersistenceLayer/EventsDao.h>
#import <PersistenceLayer/Events.h>

@interface EventsBLTests : XCTestCase

@property (nonatomic, strong) EventsBL *eventsBL;
@property (nonatomic, strong) Events *theEvents;
@end

@implementation EventsBLTests

- (void)setUp {
    [super setUp];
    
    self.eventsBL = [[EventsBL alloc] init];
    self.theEvents = [[Events alloc] init];
    self.theEvents.EventName = @"test BL EventName";
    self.theEvents.EventIcon = @"test BL EventIcon";
    self.theEvents.keyInfo = @"test BL KeyInfo";
    self.theEvents.BasicsInfo = @"test BL BasicsInfo";
    self.theEvents.OlympicInfo = @"test BL OlympicInfo";
    EventsDao *dao = [EventsDao sharedInstance];
    [dao create:self.theEvents];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.theEvents.EventID = 41;
    [[EventsDao sharedInstance] remove:self.theEvents];
    self.eventsBL = nil;
}

- (void)test_1_readData {
    
    NSArray *list = [self.eventsBL readData];
    
    XCTAssertEqual([list count], 41);
    
    Events *lastEvents = [list lastObject];
    
    XCTAssertEqualObjects(lastEvents.EventName, self.theEvents.EventName, @"比赛项目名测试失败");
    XCTAssertEqualObjects(lastEvents.EventIcon, self.theEvents.EventIcon, @"比赛项目图标测试失败");
    XCTAssertEqualObjects(lastEvents.keyInfo, self.theEvents.keyInfo, @"项目关键信息测试失败");
    XCTAssertEqualObjects(lastEvents.BasicsInfo, self.theEvents.BasicsInfo, @"项目基本信息测试失败");
    XCTAssertEqualObjects(lastEvents.OlympicInfo, self.theEvents.OlympicInfo, @"项目奥运会历史信息测试失败");
}

// 开启这个方法会运行上述测试用例两次
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
