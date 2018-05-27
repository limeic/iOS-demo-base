//
//  LCFailResponse.m
//  lemon
//
//  Created by allen on 2018/5/27.
//

#import "LCFailResponse.h"
#import "LCResponseStatus.h"

@implementation LCFailResponse

-(id) init {
    if ( self = [super init] ) {
        self.status = [NSString stringWithFormat:@"%@", kReplyFail];
        self.message = nil;
    }
    return self;
}

-(id) initWithMessage:(NSString *)message {
    if ( self = [super init] ) {
        self.status = [NSString stringWithFormat:@"%@", kReplyFail];;
        self.message = message;
    }
    return self;
}

@end
