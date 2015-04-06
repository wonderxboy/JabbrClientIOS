//
//  AuthManager.h
//  JabbrClient
//
//  Created by Sean on 06/04/15.
//  Copyright (c) 2015 Colla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthManager : NSObject

//TODO: remove
@property (strong, nonatomic, readonly) NSString *server_url;
@property (nonatomic, readonly) BOOL *isAuthenticated;

+ (AuthManager *)sharedInstance;

- (void)signInWithUsername:(NSString *)username password: (NSString *)password completion:(void (^)(NSError *error))completionBlock;
@end
