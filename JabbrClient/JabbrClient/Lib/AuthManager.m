//
//  AuthManager.m
//  JabbrClient
//
//  Created by Sean on 06/04/15.
//  Copyright (c) 2015 Colla. All rights reserved.
//

#import "AuthManager.h"

//Util
#import "Constants.h"

//Services
#import "CLAAzureHubPushNotificationService.h"

@implementation AuthManager


+ (AuthManager *)sharedInstance {
    static AuthManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    return self;
}

#pragma -
#pragma Public Methods

- (BOOL)isAuthenticated {
    return [self getCachedAuthToken] != nil;
}

- (NSString *)getCachedAuthToken {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *authDate = [defaults objectForKey:kLastAuthDate];
    
    if (!authDate){
        return nil;
    }
    else if (authDate) {
        
        NSComparisonResult result;
        result = [[NSDate date] compare:[authDate dateByAddingTimeInterval:60*60*24*7]];
        
        if (result == NSOrderedDescending){
            return nil;
        }
    }
    
    return [defaults objectForKey:kAuthToken];
}

- (void)cacheUsername:(NSString *)username {
    [self cacheObject:username forKey:kUsername];
}

- (NSString *)getUsername {
    return (NSString *)[self getCachedObjectForKey:kUsername];
}


- (NSData *)getCachedDeviceToken {
    return (NSData *)[self getCachedObjectForKey:kDeviceToken];
}

- (void)cacheAuthToken: (NSString *)authToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:authToken forKey:kAuthToken];
    [defaults setObject:[NSDate date] forKey:kLastAuthDate];
    [defaults synchronize];
}


- (void)cacheDeviceToken:(NSData *)deviceToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceToken forKey:kDeviceToken];
    [defaults synchronize];
}

- (void)signOut {
    [self clearCookie];
    [self clearCache];
}


#pragma mark -
#pragma Private Methods

- (void)clearCache {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUsername];
    [defaults removeObjectForKey:kAuthToken];
    [defaults removeObjectForKey:kLastAuthDate];
    [defaults removeObjectForKey:kTeamKey];
    [defaults removeObjectForKey:kInviteCode];
    [defaults synchronize];
    //Device Token should be not cleared
}

- (void)cacheObject: (NSObject*)object forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

- (NSObject*)getCachedObjectForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

- (void)clearCookie {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
}

@end
