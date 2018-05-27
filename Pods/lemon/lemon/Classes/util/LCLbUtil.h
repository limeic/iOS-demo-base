//
//  LCLbUtil.h
//  lemon
//
//  Created by 吴文卿 on 2017/12/23.
//

#import <Foundation/Foundation.h>
#import "LCNodeAddress.h"

@interface LCLbUtil : NSObject

+(instancetype) sharedInstance;

// 获取GatewayAddress
-(LCNodeAddress*) getNodeAddress: (NSString*) url appId: (NSString*) appId;

@end
