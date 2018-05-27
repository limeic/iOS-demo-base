//
//  LCEventManager.h
//  lemon
//
//  Created by 吴文卿 on 2017/12/24.
//

#import <Foundation/Foundation.h>
#import "LCBizType.h"
#import "LCBaseEventHandler.h"

@interface LCEventManager : NSObject

// 获取单例对象
+(instancetype) sharedInstance;

// 注册handler事件
// 此方法用于注册广播事件响应
-(BOOL) registryHandler:(LCBizType) bizType appId:(NSString*) appId moduleId:(uint16_t)moduleId commandId:(uint16_t) commandId handler:(LCBaseEventHandler *) handler;

// 注册handler事件
// 此方法用于request => response 事件响应
-(BOOL) registryHandler:(LCBizType) bizType appId:(NSString*) appId requestId:(int64_t)requestId handler:(LCBaseEventHandler *) handler;

// 获取handler
-(LCBaseEventHandler*) getHandler: (LCBizType) bizType appId:(NSString* ) appId moduleId:(uint16_t)moduleId commandId:(uint16_t) commandId;

// 获取handler
-(LCBaseEventHandler*) getHandler:(LCBizType)bizType appId:(NSString *)appId requestId:(int64_t) requestId;

// 定时清理timestamp超过interval的事件handler
// interval单位：秒
- (void) check: (int64_t) interval;

// 清除requestHandler
- (void) clearRequestHandler;

// 清除所有handler
- (void) clear;

@end
