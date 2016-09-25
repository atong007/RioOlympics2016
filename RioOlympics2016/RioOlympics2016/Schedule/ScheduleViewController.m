//
//  ScheduleViewController.m
//  RioOlympics2016
//
//  Created by 洪龙通 on 2016/9/25.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "ScheduleViewController.h"
#import <BusinessLogicLayer/ScheduleBL.h>
#import <PersistenceLayer/Schedule.h>
#import <PersistenceLayer/Events.h>


@interface ScheduleViewController ()

@property (nonatomic, copy) NSDictionary *schedulesDict;
// 比赛日期
@property (nonatomic, copy) NSArray *dateArray;
@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (NSArray *)dateArray
{
    if (!_dateArray) {
        ScheduleBL *scheduleBL = [[ScheduleBL alloc] init];
        _schedulesDict = [scheduleBL readData];
        _dateArray = [[_schedulesDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
    return _dateArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dateArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.schedulesDict objectForKey:self.dateArray[section]] count];
}

/**
 *  tableView cell的设置
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    static NSString *reuseID = @"schedule";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    //2.传递数据模型来设置cell属性
    Schedule *schedule = [self.schedulesDict objectForKey:self.dateArray[indexPath.section]][indexPath.row];
    cell.textLabel.text = schedule.GameTime;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@", schedule.GameInfo, schedule.Event.EventName];
    
    //3.返回cell
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle = [self.dateArray[section] substringFromIndex:5];
    return headerTitle;
}

@end
