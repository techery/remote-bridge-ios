//
//  TEBackdoorInvocation.h
//  RemoteBridge
//
//  Created by Sergey Zenchenko on 6/1/16.
//  Copyright © 2016 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEBackdoorInvocation : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSDictionary *params;
@property(nonatomic, strong) id response;

@end
