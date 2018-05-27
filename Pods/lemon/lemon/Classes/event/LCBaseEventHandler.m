//
//  LCBaseEventHandler.m
//  lemon
//
//  Created by 吴文卿 on 2017/12/24.
//

#import "LCBaseEventHandler.h"
#import "../exception/LCBaseException.h"

@implementation LCBaseEventHandler

-(id) initWithCallback:(OnResponse)onResponse {
    if ( onResponse == nil ) {
        @throw [[LCBaseException alloc] initWithName:@"handler异常" reason:@"onResponse不能为nil" userInfo:nil];
        return self;
    }
    self.onResponse = onResponse;
    return self;
}

@end
