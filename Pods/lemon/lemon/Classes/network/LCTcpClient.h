//
//  LCTcpClient.h
//  lemon
//
//  Created by 吴文卿 on 2017/12/23.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "LCLemonBasePackage.h"

/**
 * 连接建立之后的回调
 */
typedef void(^OnActive)(void);

/**
 * 收到心跳包之后的回调
 */
typedef void(^OnHeartbeat)(void);

/**
 * 连接关闭之后的回调
 */
typedef void(^OnClosed)(void);

@interface LCTcpClient : NSObject <GCDAsyncSocketDelegate>

// 建立连接
-(void) connect:(nonnull NSString*)host port:(int)port onActive:(nullable OnActive) onActive onClosed:(nullable OnClosed) onClosed onHeartbeat:(nullable OnHeartbeat) onHeartbeat;

// 断开连接
-(void) disconnect;

// 发送数据
-(BOOL) send: (nullable LCLemonBasePackage*) package;

@end
