//
//  DIOSocketManager.h
//  Dioresta
//
//  Created by Brian Gilham on 2014-04-12.
//  Copyright (c) 2014 Space Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DIOActionDrill = @"drill";
static NSString *const DIOActionLeft =  @"left";
static NSString *const DIOActionRight = @"right";
static NSString *const DIOActionClientRegistered = @"clientRegistered";

@interface DIOSocketManager : NSObject

#pragma mark - Shared Manager
+ (id)sharedManager;

#pragma mark - Communication
- (void)sendAction:(NSString *)action andData:(NSDictionary *)data;

#pragma mark - Device ID
- (NSString *)deviceID;

@end
