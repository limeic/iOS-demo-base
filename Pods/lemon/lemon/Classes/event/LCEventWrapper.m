//
//  LCEventWrapper.m
//  lemon
//
//  Created by 吴文卿 on 2017/12/24.
//

#import "LCEventWrapper.h"
#import "../exception/LCBaseException.h"

@implementation LCEventWrapper

-(id) initWithHandler:(LCBaseEventHandler *)handler {
    if ( handler == nil ) {
        @throw [[LCBaseException alloc] initWithName:@"handler异常" reason:@"handler为空" userInfo:nil];
    }
    self.handler = handler;
    _timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    return self;
}

@end
