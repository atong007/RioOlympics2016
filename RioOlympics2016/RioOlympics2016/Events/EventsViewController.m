//
//  EventsViewController.m
//  RioOlympics2016
//
//  Created by 洪龙通 on 2016/9/25.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "EventsViewController.h"
#import "EventsViewCell.h"
#import <BusinessLogicLayer/EventsBL.h>
#import <PersistenceLayer/Events.h>
#import "EventsDetailViewController.h"


@interface EventsViewController ()
@property (nonatomic, copy) NSArray *eventsArray;
@end

@implementation EventsViewController
{
    NSUInteger columnCount;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes 使用storyboard获取时不需要注册
//    [self.collectionView registerClass:[EventsViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // 如果是iPhone设备，列数为2
        columnCount = 2;
    }else {
        // 如果是iPad设备，列数为5
        columnCount = 5;
    }
}

- (NSArray *)eventsArray
{
    if (!_eventsArray) {
//        _eventsArray = [NSArray array];
        EventsBL *eventBL = [[EventsBL alloc] init];
        _eventsArray = [eventBL readData];
    }
    return _eventsArray;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        
        Events *event = self.eventsArray[indexPath.section * columnCount + indexPath.row];
        EventsDetailViewController *detailVC = [segue destinationViewController];
        detailVC.event = event;
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return ([self.eventsArray count] + 1) / columnCount;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return columnCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    EventsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    // 设置cell
    Events *events = self.eventsArray[indexPath.section * columnCount + indexPath.row];
    cell.imageView.image = [UIImage imageNamed:events.EventIcon];
    
    // 返回cell
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
