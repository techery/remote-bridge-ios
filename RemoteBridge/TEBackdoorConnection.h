//
//  TEBackdoorConnection.h
//  RemoteBridge
//
//  Created by Sergey Zenchenko on 6/1/16.
//  Copyright © 2016 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEBackdoorInvocation.h"

@protocol TEBackdoorConnectionDelegate <NSObject>

- (void)handleBackdoorInvocation:(TEBackdoorInvocation*)invication;

@end

@interface TEBackdoorConnection : NSObject

@property (nonatomic, strong, readonly) NSURL *bridgeServerURL;
@property (nonatomic, weak) id<TEBackdoorConnectionDelegate> delegate;

- (instancetype)initWithBridgeServerURL:(NSURL*)bridgeServerURL;

@end
