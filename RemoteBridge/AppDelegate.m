//
//  AppDelegate.m
//  RemoteBridge
//
//  Created by Sergey Zenchenko on 5/30/16.
//  Copyright © 2016 Techery. All rights reserved.
//

#import "AppDelegate.h"
#import "TEBackdoorService.h"

@interface AppDelegate ()

@property (nonatomic, strong) TEBackdoorService *service;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.service = [TEBackdoorService new];
    
    [self.service addBackdoorHandler:self];
    
    return YES;
}

- (NSDictionary*)getName:(NSDictionary*)params {
    return params[@"user"];
}

- (NSString*)getTime {
    return [[NSDate date] description];
}

@end
