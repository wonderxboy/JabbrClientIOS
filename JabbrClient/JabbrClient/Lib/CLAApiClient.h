//
//  CLAApiClient.h
//  Collara
//
//  Created by Sean on 07/05/15.
//  Copyright (c) 2015 Collara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLAUserRegistrationViewModel.h"
#import "CLANotificationMessage.h"

@protocol CLAApiClient;

@protocol CLAApiClient <NSObject>

- (void)createAccount:(CLAUserRegistrationViewModel *)userRegistrationModel completionHandler:(void (^)(NSString *errorMessage))completion;
- (void)signInWith: (NSString *)username password:(NSString *)password completionHandler:(void (^)(NSString *errorMessage))completion;
- (void)createTeam:(NSString *)name completionHandler:(void(^)(NSString *errorMessage))completion;
- (void)joinTeam:(NSString *)invitationCode completionHandler:(void(^)(NSString *errorMessage))completion;
- (void)getInviteCodeForTeam:(NSNumber *)team completion:(void(^)(NSString *invitationCode, NSString *errorMessage))completion;
- (void)sendInviteFor:(NSString *)team to:(NSString *)email completion:(void(^)(NSString *token, NSString *errorMessage))completion;
- (void)getNotificationsFor:(NSString *)team completion:(void(^)(NSArray *result, NSString *errorMessage))completion;
- (void)setRead:(CLANotificationMessage *)notification completion:(void(^)(NSArray *result, NSString *errorMessage))completion;
- (void)setBadge:(NSNumber *)count forTeam:(NSNumber *)teamKey;
@end
