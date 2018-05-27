//
//  LCOkResponse.h
//  lemon
//
//  Created by allen on 2018/5/27.
//

#import <Foundation/Foundation.h>
#import "LCBaseResponse.h"

@interface LCOkResponse : LCBaseResponse

/**
 * 初始化
 */
-(id) init;

/**
 * 使用message进行初始化
 */
-(id) initWithMessage: (nonnull NSString*)message;

@end
