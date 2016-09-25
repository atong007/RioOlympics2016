//
//  EventsDaoTests.m
//  PersistenceLayer
//
//  Created by 洪龙通 on 2016/9/23.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EventsDao.h"
#import "Events.h"

@interface EventsDaoTests : XCTestCase
@property (nonatomic, strong) Events *theEvents;
@property (nonatomic, strong) EventsDao *dao;
@end

@implementation EventsDaoTests

- (void)setUp {
    [super setUp];
    self.dao = [EventsDao sharedInstance];
    
    self.theEvents = [[Events alloc] init];
    self.theEvents.EventName = @"test EventName";
    self.theEvents.EventIcon = @"test EventIcon";
    self.theEvents.keyInfo = @"test KeyInfo";
    self.theEvents.BasicsInfo = @"test BasicsInfo";
    self.theEvents.OlympicInfo = @"test OlympicInfo";
}

- (void)tearDown {
    [super tearDown];
    self.dao = nil;
}

- (void)test_1_Create {
    
    int res = [self.dao create:self.theEvents];
    XCTAssertEqual(res, 0);
}

- (void)test_2_FindById {
    self.theEvents.EventID = 41;
    Events *resultEvents = [self.dao findById:41];
    XCTAssertNotNil(resultEvents, @"查询记录为nil");

    XCTAssertEqualObjects(resultEvents.EventName, self.theEvents.EventName);
    XCTAssertEqualObjects(resultEvents.EventIcon, self.theEvents.EventIcon);
    XCTAssertEqualObjects(resultEvents.keyInfo, self.theEvents.keyInfo);
    XCTAssertEqualObjects(resultEvents.BasicsInfo, self.theEvents.BasicsInfo);
    XCTAssertEqualObjects(resultEvents.OlympicInfo, self.theEvents.OlympicInfo);
}

- (void)test_3_FindAll{
    
    NSArray *resultArray = [self.dao findAll];
    XCTAssertEqual([resultArray count], 41);
    
    Events *lastEvents = [resultArray lastObject];
    
    XCTAssertEqualObjects(lastEvents.EventName, self.theEvents.EventName);
    XCTAssertEqualObjects(lastEvents.EventIcon, self.theEvents.EventIcon);
    XCTAssertEqualObjects(lastEvents.keyInfo, self.theEvents.keyInfo);
    XCTAssertEqualObjects(lastEvents.BasicsInfo, self.theEvents.BasicsInfo);
    XCTAssertEqualObjects(lastEvents.OlympicInfo, self.theEvents.OlympicInfo);
}

- (void)test_4_Modify{
    self.theEvents.EventID = 41;
    self.theEvents.EventName = @"test modify EventName";
    
    int result = [self.dao modify:self.theEvents];
    XCTAssertEqual(result, 0);
    
    Events *resultEvents = [self.dao findById:41];
    
    XCTAssertNotNil(resultEvents, @"查询记录为nil");
    
    XCTAssertEqualObjects(resultEvents.EventName, self.theEvents.EventName);
    XCTAssertEqualObjects(resultEvents.EventIcon, self.theEvents.EventIcon);
    XCTAssertEqualObjects(resultEvents.keyInfo, self.theEvents.keyInfo);
    XCTAssertEqualObjects(resultEvents.BasicsInfo, self.theEvents.BasicsInfo);
    XCTAssertEqualObjects(resultEvents.OlympicInfo, self.theEvents.OlympicInfo);
    
}

- (void)test_5_remove{
    self.theEvents.EventID = 41;
    int result = [self.dao remove:self.theEvents];
    
    XCTAssertEqual(result, 0);
    NSLog(@"id:%d", self.theEvents.EventID);
    Events *resultEvents = [self.dao findById:self.theEvents.EventID];
    XCTAssertNil(resultEvents, @"记录删除失败");
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
