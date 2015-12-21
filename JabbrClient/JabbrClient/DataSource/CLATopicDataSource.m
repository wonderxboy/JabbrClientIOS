//
//  CLATopicDataSource.m
//  Collara
//
//  Created by Sean on 20/12/15.
//  Copyright © 2015 Collara. All rights reserved.
//

#import "CLATopicDataSource.h"

#import "Constants.h"
#import "CLARoom.h"
#import "ChatViewController.h"

@interface CLATopicDataSource ()

@property(nonatomic, strong) NSArray<CLARoom *> *rooms;

@property(nonatomic, strong) NSMutableDictionary *roomDictionary;
@property(nonatomic, strong) NSMutableDictionary *filteredRoomDictionary;

@end

@implementation CLATopicDataSource

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.rooms = [NSArray array];
        self.roomDictionary = [NSMutableDictionary dictionary];
        self.filteredRoomDictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}


#pragma Public Methods
- (CLARoom *)GetSelectedRoom {
    return self.selectedRoom;
}

- (NSIndexPath *)getSelectedRoomIndexPath {
    return [self getIndexPath:self.selectedRoom];
}

- (void)updateRooms:(NSArray<CLARoom *> *)rooms {
    NSArray<CLARoom *> *localRooms = rooms.copy;
    [self.roomDictionary removeAllObjects];
    
    NSPredicate *publicRoomRredicate =
    [NSPredicate predicateWithFormat:@"(isPrivate == %@)", @NO];
    NSArray *publicRooms =
    [localRooms filteredArrayUsingPredicate:publicRoomRredicate];
    
    NSPredicate *privateRoomRredicate = [NSPredicate
                                         predicateWithFormat:@"(isPrivate == %@) AND (isDirectRoom == %@)", @YES,
                                         @NO];
    NSArray *privateRooms =
    [localRooms filteredArrayUsingPredicate:privateRoomRredicate];
    
    NSPredicate *directRoomRredicate =
    [NSPredicate predicateWithFormat:@"(isDirectRoom == %@)", @YES];
    NSArray *directRooms =
    [localRooms filteredArrayUsingPredicate:directRoomRredicate];
    
    [self.roomDictionary
     setObject:publicRooms == nil ?[NSArray array] : publicRooms
     forKey:@"0"];
    [self.roomDictionary
     setObject:privateRooms == nil ?[NSArray array] : privateRooms
     forKey:@"1"];
    [self.roomDictionary
     setObject:directRooms == nil ?[NSArray array] : directRooms
     forKey:@"2"];
    
    [self resetFilter];
    
    self.rooms = localRooms;
}

- (void)setRoom:(NSString *)roomName withUnread:(NSInteger)count {
    for (CLARoom *room in self.rooms) {
        if ([room.name isEqual:roomName]) {
            room.unread = count;
            return;
        }
    }
}

- (void)resetFilter {
    [self.filteredRoomDictionary
     setObject:[self.roomDictionary objectForKey:@"0"]
     forKey:@"0"];
    [self.filteredRoomDictionary
     setObject:[self.roomDictionary objectForKey:@"1"]
     forKey:@"1"];
    [self.filteredRoomDictionary
     setObject:[self.roomDictionary objectForKey:@"2"]
     forKey:@"2"];
}

- (void)filterContentForSearchText:(NSString *)searchText {
    NSPredicate *searchPredicate = [NSPredicate
                                    predicateWithFormat:@"displayName contains[c] %@", searchText];
    
    for (NSString *key in self.roomDictionary.allKeys) {
        NSArray *rooms = [self.roomDictionary objectForKey:key];
        NSArray *filteredRooms =
        [rooms filteredArrayUsingPredicate:searchPredicate];
        [self.filteredRoomDictionary setObject:filteredRooms forKey:key];
    }
}


#pragma DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
        case 2:
            return [self getRoomCountAtSection:section filterCount:YES];
            
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    
    CGRect frame = tableView.frame;
    
    UILabel *title = [[UILabel alloc]
                      initWithFrame:CGRectMake(15, 10, frame.size.width - 15 - 60, 30)];
    
    title.text = [self getSectionHeaderString:section];
    title.textColor = [UIColor whiteColor];
    
    UIButton *addButton = [[UIButton alloc]
                           initWithFrame:CGRectMake(frame.size.width - 60, 10, 30, 30)];
    addButton.tag = section;
    
    [addButton addTarget:self
                  action:@selector(showCreateTopicView:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [addButton setImage:[Constants addIconImage] forState:UIControlStateNormal];
    
    UIView *headerView = [[UIView alloc]
                          initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    [headerView setBackgroundColor:[Constants warningColor]];
    
    [headerView addSubview:title];
    [headerView addSubview:addButton];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLARoom *room = [self getRoom:indexPath];
    
    if (room == nil) {
        return nil;
    }
    
    BOOL unreadHidden = room.unread <= 0;
    NSString *counterText =
    room.unread > 99 ? @"99+" :[@(room.unread)stringValue];
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:self.tableCellIdentifierName];
    cell.textLabel.text = [room getHandle];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [Constants highlightColor];
    cell.selectedBackgroundView = backgroundView;
    UIView *unreadView = [cell.contentView viewWithTag:1];
    unreadView.hidden = unreadHidden;
    unreadView.backgroundColor = [Constants warningColor];
    unreadView.layer.cornerRadius = 8;
    unreadView.layer.masksToBounds = YES;
    
    UILabel *unreadLabel = (UILabel *)[cell.contentView viewWithTag:2];
    unreadLabel.text = counterText;
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self getSectionHeaderString:section];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CLARoom *room = [self getRoom:indexPath];
    if (room != nil) {
        self.selectedRoom = room;
        [self openRoom: room];
    }
}

#pragma mark -
#pragma mark - Pull To Resfresh

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pongRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    [self.pongRefreshControl scrollViewDidEndDragging];
}

#pragma -
#pragma Private Methods

- (CLARoom *)getRoom:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    NSArray *roomArray = [[self getCurrentRoomDictionary] objectForKey:key];
    return roomArray == nil ? nil :[roomArray objectAtIndex:indexPath.row];
}

- (NSDictionary *)getCurrentRoomDictionary {
    return self.filteredRoomDictionary;
}

- (NSIndexPath *)getIndexPath:(CLARoom *)room {
    NSInteger section = 0;
    if (room.isDirectRoom != NO) {
        section = 2;
    } else if (room.isPrivate != NO && room.isDirectRoom == NO) {
        section = 1;
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)section];
    NSArray *roomArray = [[self getCurrentRoomDictionary] objectForKey:key];
    
    if (roomArray == nil) {
        return nil;
    }
    
    for (NSInteger k = 0; k < roomArray.count; k++ ) {
        CLARoom *sectionRoom = [roomArray objectAtIndex:k];
        if ([sectionRoom.name isEqualToString:room.name]) {
            return [NSIndexPath indexPathForRow:k inSection:section];
        }
    }
    
    return nil;
}

- (NSUInteger)getRoomCountAtSection:(NSInteger)section filterCount:(BOOL)filtered {
    NSString *key = [NSString stringWithFormat:@"%ld", (long)section];
    NSArray *targetArray;
    
    if (filtered == NO) {
        targetArray = [self.roomDictionary objectForKey:key];
    }
    else {
        targetArray = [self.filteredRoomDictionary objectForKey:key];
    }
    
    return targetArray == nil ? 0 : targetArray.count;
}

- (NSString *)getSectionHeaderString:(NSInteger)section {
    NSString *count = [self getRoomCountStringAtSection:section];
    
    switch (section) {
        case 0:
            return [NSString
                    stringWithFormat:NSLocalizedString(@"Public Topics (%@)", nil), count];
            
        case 1:
            return [NSString
                    stringWithFormat:NSLocalizedString(@"Private Topics (%@)", nil), count];
            
        case 2:
            return [NSString
                    stringWithFormat:NSLocalizedString(@"Direct Messages (%@)", nil),
                    count];
            
        default:
            return @"";
    }
}

- (NSString *)getRoomCountStringAtSection:(NSInteger)section {
    NSInteger originalCount = [self getRoomCountAtSection:section filterCount:NO];
    
    if (self.isFiltered != NO)
    {
        NSInteger filteredCount = [self getRoomCountAtSection:section filterCount:YES];
        return [NSString stringWithFormat:@"%lu/%lu", (unsigned long)filteredCount, (unsigned long)originalCount];
    } else {
        return [NSString stringWithFormat:@"%lu", (unsigned long)originalCount];
    }
}

- (void)openRoom: (CLARoom *)room {
    
    UINavigationController *navController = nil;
    
    navController = [self.slidingViewController getNavigationControllerWithKeyIdentifier:kChatNavigationController];
    
    ChatViewController *chatViewController =
    [navController.viewControllers objectAtIndex:0];
    
    [self.slidingViewController setTopNavigationControllerWithKeyIdentifier:kChatNavigationController];
    if (chatViewController != nil) {
        [self setRoom:room.name withUnread:0];
        [chatViewController setActiveRoom:room];
    }
    
    [navController.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController resetTopViewAnimated:YES];
}

@end