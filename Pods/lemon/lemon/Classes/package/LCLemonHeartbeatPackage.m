//
//  LCLemonHeartbeatPackage.m
//  lemon
//
//  Created by 吴文卿 on 2017/11/23.
//

#import "LCLemonHeartbeatPackage.h"

@implementation LCLemonHeartbeatPackage

-(id) init {
    self = [super init];
    [self.header setBizType:kBizTypeSys];
    [self.header setPackageType:kPackageTypeHeartbeat];
    return self;
}

@end
