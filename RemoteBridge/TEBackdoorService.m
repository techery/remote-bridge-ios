//
//  TEBackdoorService.m
//  RemoteBridge
//
//  Created by Sergey Zenchenko on 6/1/16.
//  Copyright © 2016 Techery. All rights reserved.
//

#import "TEBackdoorService.h"
#import "TEBackdoorConnection.h"

@interface TEBackdoorService () <TEBackdoorConnectionDelegate>

@property (nonatomic, strong) TEBackdoorConnection *connection;

@property (nonatomic, strong) NSMutableArray *backdoorHandlers;

@end

@implementation TEBackdoorService

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backdoorHandlers = [NSMutableArray new];
        
        NSURL *bridgeServerURL = [NSURL URLWithString:@"ws://0.0.0.0:8080/create?id=123"];
        
        self.connection = [[TEBackdoorConnection alloc] initWithBridgeServerURL:bridgeServerURL];
        self.connection.delegate = self;
    }
    
    return self;
}

- (void)handleBackdoorInvocation:(TEBackdoorInvocation*)backdoorInvication
{
    NSString *backdoorMethodName = [NSString stringWithFormat:@"%@", backdoorInvication.name];
    NSString *backdoorMethodNameWithArgument = [NSString stringWithFormat:@"%@:", backdoorInvication.name];

    NSArray *selectorNames = @[backdoorMethodName, backdoorMethodNameWithArgument];
    
    backdoorInvication.response = [NSString stringWithFormat:@"Unknown backdoor method:%@", backdoorInvication.name];
    
    for (NSObject *handler in self.backdoorHandlers) {
        for (NSString *selectorName in selectorNames) {
            SEL backdoorSelector = NSSelectorFromString(selectorName);
            
            if ([handler respondsToSelector:backdoorSelector]) {
                NSMethodSignature *methodSignature = [[handler class] instanceMethodSignatureForSelector:backdoorSelector];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
                
                id argument = nil;
                
                if (methodSignature.numberOfArguments > 2) {
                    argument = backdoorInvication.params;
                    [invocation setArgument:&argument
                                    atIndex:2];
                }
                
                [invocation setSelector:backdoorSelector];
                [invocation setTarget:handler];
                [invocation invoke];
                id result;
                [invocation getReturnValue:&result];
                
                backdoorInvication.response = result;
            }
        }
    }
}

- (void)addBackdoorHandler:(NSObject*)backdoorHandler
{
    [self.backdoorHandlers addObject:backdoorHandler];
}

@end
