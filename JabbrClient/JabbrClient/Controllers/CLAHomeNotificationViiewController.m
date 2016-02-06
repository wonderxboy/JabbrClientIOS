//
//  CLAHomeNotificationViiewController.m
//  Collara
//
//  Created by Sean on 03/07/15.
//  Copyright (c) 2015 Collara. All rights reserved.
//

#import "CLAHomeNotificationViiewController.h"

// Util
#import <MagicalRecord/MagicalRecord.h>
#import "Constants.h"
#import "CLAWebApiClient.h"
#import "UserDataManager.h"
#import "CLANotificationManager.h"
#import "CLASignalRMessageClient.h"

// Data Model
#import "CLAUser.h"
#import "CLATeamViewModel.h"
#import "CLANotificationMessage.h"

// Menu
#import "UIViewController+ECSlidingViewController.h"
#import "SlidingViewController.h"

// View Controllers
#import "CLACreateRoomViewController.h"
#import "CLANotificationContentViewController.h"

// Custom Controls
#import "BOZPongRefreshControl.h"
#import "CLANotifictionTableViewCell.h"
#import "CLARealmRepository.h"

@interface CLAHomeNotificationViiewController ()

@property(nonatomic, strong) BOZPongRefreshControl *pongRefreshControl;
@property(nonatomic) BOOL isRefreshing;
@property(nonatomic, strong) id<CLADataRepositoryProtocol> repository;

@end

@implementation CLAHomeNotificationViiewController

- (void)viewDidLoad {
    self.repository = [[CLARealmRepository alloc] init];
    [self addTalbeView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadNotifications];
}

- (void)addTalbeView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)loadNotifications {
    [[CLAWebApiClient sharedInstance]
     getNotificationsFor:[UserDataManager getTeam].key.stringValue
     completion:^(NSArray *result, NSString *errorMessage) {
         if (errorMessage != nil) {
             [CLANotificationManager
              showText:NSLocalizedString(@"We are terribly "
                                         @"sorry, but some "
                                         @"error happened.",
                                         nil)
              forViewController:self
              withType:CLANotificationTypeError];
             
             [self finishRefresh];
             [CLANotificationManager dismiss];
             
             return;
         }
         
         __weak __typeof(&*self) weakSelf = self;
         
         [self.repository
          addOrUpdateNotificationsWithData:result
          completion:^(void) {
              [weakSelf.tableView reloadData];
              [weakSelf finishRefresh];
              [CLANotificationManager dismiss];
          }];
     }];
}

- (void)viewDidLayoutSubviews {
    // The very first time this is called, the table view has a smaller size than
    // the screen size
    if (self.tableView.frame.size.width >=
        [UIScreen mainScreen].bounds.size.width) {
        self.pongRefreshControl =
        [BOZPongRefreshControl attachToTableView:self.tableView
                               withRefreshTarget:self
                                andRefreshAction:@selector(refreshTriggered)];
        self.pongRefreshControl.backgroundColor = [Constants highlightColor];
    }
}

#pragma mark -
#pragma mark - Pull To Resfresh

- (void)refreshTriggered {
    [UserDataManager cacheLastRefreshTime];
    self.isRefreshing = TRUE;
    [self loadNotifications];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pongRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    [self.pongRefreshControl scrollViewDidEndDragging];
}

- (void)didFinishRefresh {
    
    if (!self.isRefreshing) {
        return;
    }
    
    NSDate *lastRefreshTime = [UserDataManager getLastRefreshTime];
    NSTimeInterval remainTime = 0;
    
    if (![lastRefreshTime isEqual:[NSNull null]]) {
        remainTime = minRefreshLoadTime + [lastRefreshTime timeIntervalSinceNow];
        remainTime =
        remainTime > minRefreshLoadTime ? minRefreshLoadTime : remainTime;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:remainTime
                                     target:self
                                   selector:@selector(finishRefresh)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)finishRefresh {
    [self.pongRefreshControl finishedLoading];
    self.isRefreshing = FALSE;
}

#pragma mark - XLPagerTabStripViewControllerDelegate

- (NSString *)titleForPagerTabStripViewController:
(XLPagerTabStripViewController *)pagerTabStripViewController {
    return NSLocalizedString(@"Alerts", nil);
}

- (UIColor *)colorForPagerTabStripViewController:
(XLPagerTabStripViewController *)pagerTabStripViewController {
    return [UIColor whiteColor];
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [CLANotificationMessage allObjects].count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"NotificationCell";
    
    CLANotifictionTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CLANotifictionTableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellIdentifier];
    }
    
    cell.notification = [[[CLANotificationMessage allObjects]
                          sortedResultsUsingProperty:@"when" ascending:NO]
                         objectAtIndex:indexPath.row];
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = backgroundView;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

#pragma mark - Table Section

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showNotificationContent:
     [[[CLANotificationMessage allObjects]
       sortedResultsUsingProperty:@"when" ascending:NO]
      objectAtIndex:indexPath.row]];
}

#pragma mark -
#pragma mark Private Methods

- (void)showNotificationContent:(CLANotificationMessage *)notification {
    if (notification == nil) {
        return;
    }
    
    [[CLAWebApiClient sharedInstance]
     setRead:notification
     completion:^(NSArray *result, NSString *errorMessage) {
         [self.repository updateNotification:notification.notificationKey read:YES];
     }];
    
    UIStoryboard *storyBoard =
    [UIStoryboard storyboardWithName:kMainStoryBoard bundle:nil];
    
    CLANotificationContentViewController *notificationViewController =
    [storyBoard instantiateViewControllerWithIdentifier:
     kNotificationContentViewController];
    notificationViewController.notification = notification;
    [self presentViewController:notificationViewController
                       animated:YES
                     completion:nil];
}

@end
