//
//  LCTcpClient.m
//  lemon
//
//  Created by 吴文卿 on 2017/12/23.
//

#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "LCTcpClient.h"
#import "LCLemonService.h"
#import "../package/LCLemonBasePackage.h"
#import "../exception/LCBaseException.h"
#import "../codec/LCIOBuffer.h"
#import "../event/LCEventManager.h"

static const NSInteger kSocketConnectTimeout                = 30; // 30秒连接超时
static const NSInteger kSendTimeout                         = 30; // 发送超时

@interface LCTcpClient()

// 连接属性
@property (nonatomic, strong) GCDAsyncSocket* socket;
@property (nonatomic, assign) NSString* host;
@property (nonatomic, assign) int port;

// 回调
@property (nonatomic, nullable, copy) OnActive onActive;
@property (nonatomic, nullable, copy) OnClosed onClosed;
@property (nonatomic, nullable, copy) OnHeartbeat onHeartbeat;

// 数据缓冲区
@property (nonatomic, nullable, retain) LCIOBuffer* buffer;

@end

@implementation LCTcpClient

// 连接
-(void) connect:(NSString *)host port:(int)port onActive:(OnActive)onActive onClosed:(OnClosed)onClosed onHeartbeat:(OnHeartbeat)onHeartbeat {
    
    if ( self.socket != nil && [self.socket isConnected] ) {
        [self.socket disconnect];
        self.socket = nil;
    }
    
    self.host = host;
    self.port = port;
    self.onActive = onActive;
    self.onClosed = onClosed;
    self.onHeartbeat = onHeartbeat;
    
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError* err = nil;
    if ( ![self.socket connectToHost:host onPort:port withTimeout:kSocketConnectTimeout error:&err] ) {
        @throw [[LCBaseException alloc] initWithName:@"socket异常" reason:@"连接失败" userInfo:nil];
    }
    return ;
}

// 断开连接
-(void) disconnect {
    if ( self.socket != nil && [self.socket isConnected] ) {
        [self.socket disconnect];
        self.socket = nil;
    }
}

// 发送数据
-(BOOL) send:(LCLemonBasePackage *)package {
    if ( package == nil ) {
        return false;
    }
    if ( self.socket == nil || !self.socket.isConnected ) {
        return false;
    }
    LCIOBuffer* buff = [[LCIOBuffer alloc] init];
    if ( ![package encode: buff] )  {
        return false;
    }
    // 发送数据
    NSData* data = [buff getWritedData];
    NSLog(@"send package: %@", data);
    [self.socket writeData:data withTimeout:kSendTimeout tag:1];
    return true;
}

// 处理连接断开事件
-(void) onClose {
    [self.buffer clear];
    if ( self.onClosed != nil ) {
        self.onClosed();
    }
}

///---> socket 回调 <----- begin
// 连接建立回调
-(void)socket:(GCDAsyncSocket *)socket didConnectToHost:(nonnull NSString *)host port:(uint16_t)port {
    
    // 通知Service连接建立
    if ( self.onActive != nil ) {
        self.onActive();
    }
    
    // 开始读取数据
    [socket readDataWithTimeout:-1 tag:0];
}

// 连接断开回调
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    [self onClose];
}

// 收到数据回调
-(void)socket:(GCDAsyncSocket *)socket didReadData:(nonnull NSData *)data withTag:(long)tag {
    
    if ( data == nil ) {
        return ;
    }
    
    // 写入数据
    if ( _buffer == nil ) {
        _buffer = [[LCIOBuffer alloc] init];
    }
    [_buffer writeData:data];
    
    // 循环反序列化
    while ( [_buffer getReadableBytes] > 1 ) {
        
        LCLemonBasePackage* request = [[LCLemonBasePackage alloc] init];
        LCDecodeRetCode code = [request decode:_buffer];
        
        // 长度不够
        if ( code == kDecodeRetCodeNotEnoughLen ) {
            break;
        }
        
        // 解包失败
        if ( code != kDecodeRetCodeSuccess ) {
            continue;
        }
        
        // 收到心跳包
        if ( [request.header isHeartbeat] ) {
            if ( self.onHeartbeat != nil ) {
                self.onHeartbeat();
            }
            continue;
        }
        
        // 收到非法业务类型数据包
        LCBizType bizType = request.header.baseHeader.bizType;
        if ( bizType == kBizTypeIllegal ) {
            continue;
        }
        
        LCBaseEventHandler* handler = nil;
        if ( request.header.useRequest ) {
            int64_t requestId = [request.header getRequestId];
            handler = [[LCEventManager sharedInstance]
                       getHandler:[request.header getBizType]
                       appId:[LCLemonService sharedInstance].appId
                       requestId:requestId];
        } else {
            uint16_t moduleId = [request.header getModuleId];
            uint16_t commandId = [request.header getCommandId];
            handler =[[LCEventManager sharedInstance]
                        getHandler:[request.header getBizType]
                        appId:[LCLemonService sharedInstance].appId
                        moduleId:moduleId
                        commandId:commandId];
        }
        
        if ( handler == nil ) {
            continue;
        }
        
        if ( handler.onResponse != nil ) {
            LCLemonBasePackage* response = handler.onResponse(request);
            [self send:response];
        }
        
    }
    [_buffer discardReadBytes];
    
    // 继续读取数据
    [socket readDataWithTimeout:-1 tag:0];
}

///---> socket 回调 <----- end
@end




















