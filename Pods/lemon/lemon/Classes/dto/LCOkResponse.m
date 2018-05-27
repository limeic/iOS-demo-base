//
//  LCOkResponse.m
//  lemon
//
//  Created by allen on 2018/5/27.
//

#import "LCOkResponse.h"
#import "LCResponseStatus.h"

@implementation LCOkResponse

-(id) init {
    if ( self = [super init] ) {
        self.status = [NSString stringWithFormat:@"%@", kReplyOk];
        self.message = nil;
    }
    return self;
}

-(id) initWithMessage:(NSString *)message {
    if ( self = [super init] ) {
        self.status = [NSString stringWithFormat:@"%@", kReplyOk];;
        self.message = message;
    }
    return self;
}

@end
