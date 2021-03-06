//
//  Constants.h
//  JabbrClient
//
//  Created by Sean on 06/04/15.
//  Copyright (c) 2015 Colla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Constants : NSObject

FOUNDATION_EXPORT NSString *const kServerBaseUrl;
FOUNDATION_EXPORT NSString *const kApiPath;

FOUNDATION_EXPORT NSString *const kAuzreNotificationHubName;
FOUNDATION_EXPORT NSString *const kAzureNotificationHubConnectionString;

FOUNDATION_EXPORT NSTimeInterval const kMessageClientReconnectInterval;

FOUNDATION_EXPORT BOOL const kFSDocumentEnabled;

FOUNDATION_EXPORT NSString *const kMainStoryBoard;

FOUNDATION_EXPORT NSString *const kHomeNavigationController;
FOUNDATION_EXPORT NSString *const kHomeTopicViewController;
FOUNDATION_EXPORT NSString *const kHomeMemberViewController;

FOUNDATION_EXPORT NSString *const kChatNavigationController;
FOUNDATION_EXPORT NSString *const kSignInNavigationController;
FOUNDATION_EXPORT NSString *const kSignUpController;
FOUNDATION_EXPORT NSString *const kProfileNavigationController;
FOUNDATION_EXPORT NSString *const kDocumentNavigationController;

FOUNDATION_EXPORT NSString *const kLeftMenuViewController;
FOUNDATION_EXPORT NSString *const kRightMenuViewController;

FOUNDATION_EXPORT NSString *const kCreateTeamViewController;
FOUNDATION_EXPORT NSString *const kCreateRoomViewController;

FOUNDATION_EXPORT NSString *const kNotificationContentViewController;

FOUNDATION_EXPORT NSString *const kUserPrefix;
FOUNDATION_EXPORT NSString *const kRoomPrefix;
FOUNDATION_EXPORT NSString *const kDocPrefix;

FOUNDATION_EXPORT NSString *const kUsername;
FOUNDATION_EXPORT NSString *const kAuthToken;
FOUNDATION_EXPORT NSString *const kLastAuthDate;
FOUNDATION_EXPORT NSString *const kTeamKey;
FOUNDATION_EXPORT NSString *const kDeviceToken;
FOUNDATION_EXPORT NSString *const kInviteCode;

FOUNDATION_EXPORT NSString *const kMessageId;
FOUNDATION_EXPORT NSString *const kRoomName;

FOUNDATION_EXPORT NSString *const kSelectedRoomName;

FOUNDATION_EXPORT NSString *const kEventTeamUpdated;
FOUNDATION_EXPORT NSString *const kEventNoTeam;
FOUNDATION_EXPORT NSString *const kEventReceiveUnread;

FOUNDATION_EXPORT int const kTeamNameMaxLength;

FOUNDATION_EXPORT int const kMessageLoadAnimateTimeThreshold;

FOUNDATION_EXPORT float const kStatusBarHeight;

FOUNDATION_EXPORT NSTimeInterval const kMessageDisplayTimeGap;

FOUNDATION_EXPORT NSString *const kErrorDoamin;
FOUNDATION_EXPORT NSString *const kErrorDescription;

FOUNDATION_EXPORT NSString *const kNotificationAps;
FOUNDATION_EXPORT NSString *const kNotificationAlert;
FOUNDATION_EXPORT NSString *const kNotificationAppUrl;

FOUNDATION_EXPORT int const kLoadEarlierMessageCount;

FOUNDATION_EXPORT NSString *const kLastRefreshTime;
FOUNDATION_EXPORT NSTimeInterval const minRefreshLoadTime;

+ (UIImage *)menuIconImage;
+ (UIImage *)homeImage;
+ (UIImage *)settingsImage;
+ (UIImage *)chatIconImage;
+ (UIImage *)docIconImage;
+ (UIImage *)infoIconImage;
+ (UIImage *)closeIconImage;
+ (UIImage *)addIconImage;
+ (UIImage *)signOutImage;
+ (UIImage *)topicSettingIcon;
+ (UIImage *)unreadIcon;

+ (UIColor *)mainThemeColor;
+ (UIColor *)tableHeaderColor;
+ (UIColor *)highlightColor;
+ (UIColor*)mainThemeContrastColor;
+ (UIColor*)warningColor;
+ (UIColor*)backgroundColor;
@end
