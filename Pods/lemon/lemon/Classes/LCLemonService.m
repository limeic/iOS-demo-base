//
//  LCLemonService.m
//  lemon SDK 统一入口
//  Created by Allen.Wu on 2017/11/23.

#import "LCLemonService.h"
#import "exception/LCBaseException.h"
#import "event/LCEventManager.h"
#import "network/LCTcpClient.h"
#import "util/LCLbUtil.h"
#import "package/LCLemonHeartbeatPackage.h"
#import "dto/sys/LCRegistryRequest.h"
#import "dto/sys/LCRegistryResponse.h"
#import "dto/sys/LCBindUserRequest.h"
#import "dto/sys/LCBinduserResponse.h"
#import "dto/sys/LCHttpDeliverRequest.h"
#import "dto/sys/LCHttpDeliverResponse.h"
#import "dto/sys/LCPingRequest.h"
#import "dto/sys/LCPingResponse.h"
#import "dto/sys/LCNotify.h"
#import "dto/sys/LCNotifyAck.h"

static uint64_t g_req_id = 1;  // 包序号

static const NSInteger kHeartbeatInterval   = 30; // 心跳时间间隔
static const NSInteger kReconnInterval      = 3;  // 重连间隔时间
static const NSInteger kEventCheckInterval  = 10; // 事件超时检测timer
static const NSInteger KEventTimeout        = 30; // 事件30秒超时

@interface LCLemonService()

// 回调给调用方
@property (nonatomic, nullable, copy) OnRegistry onRegistry;
@property (nonatomic, nullable, copy) OnClosed onClosed;
@property (nonatomic, nullable, copy) OnStopped onStopped;

// 连接属性
@property (nonatomic, nullable, retain) LCTcpClient *client;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) BOOL openReconnect;

// 定义定时器
@property (nonatomic, strong) NSTimer* heartbeatTimer;
@property (nonatomic, strong) NSTimer* reconnTimer;
@property (nonatomic, strong) NSTimer* eventCheckTimer;

@end

@implementation LCLemonService

// 启动心跳保活机制
- (void) startKeepAlive {
    if ( _heartbeatTimer == nil ) {
        _heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:kHeartbeatInterval target:self selector:@selector(doHeartbeat) userInfo:nil repeats:YES];
    }
}

- (void) doHeartbeat {
    if ( _client != nil ) {
        LCLemonHeartbeatPackage *heartbeat = [[LCLemonHeartbeatPackage alloc] init];
        [_client send:heartbeat];
    }
}

// 停止心跳包发送
- (void) stopKeepAlive {
    if ( _heartbeatTimer != nil ) {
        [_heartbeatTimer invalidate];
        _heartbeatTimer = nil;
    }
}

// 启动重连定时器
- (void) startReconnTimer {
    if ( _reconnTimer == nil ) {
        _reconnTimer = [NSTimer scheduledTimerWithTimeInterval:kReconnInterval target:self selector:@selector(doReconn) userInfo:nil repeats:YES];
    }
}

// 执行重连
- (void) doReconn {
    [self start];
}

// 停止重连定时器
- (void) stopReconnTimer {
    if ( _reconnTimer != nil ) {
        [_reconnTimer invalidate];
        _reconnTimer = nil;
    }
}

// 启动事件监测定时器
- (void) startEventCheckTimer {
    if ( _eventCheckTimer == nil ) {
        _eventCheckTimer = [NSTimer scheduledTimerWithTimeInterval:kEventCheckInterval target:self selector:@selector(doEventCheck) userInfo:nil repeats:YES];
    }
}

- (void) doEventCheck {
    [[LCEventManager sharedInstance] check: KEventTimeout];
}

// 停止事件监测定时器
- (void) stopEventCheckTimer {
    if ( _eventCheckTimer != nil ) {
        [_eventCheckTimer invalidate];
        _eventCheckTimer = nil;
    }
}

// 获取单实例
+ (instancetype) sharedInstance {
    static LCLemonService* instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype) init {
    self = [super init];
    if ( !self ) return nil;

    self.url = @"https://api.limeic.com/api/connectors/allocation";
    self.appId = @"";
    self.onRegistry = nil;
    self.onClosed = nil;
    self.onStopped = nil;
    
    self.isRunning = false;
    self.openReconnect = true; // 默认开启重连
    self.client = nil;
    
    return self;
}

// 更改url
- (void) changeUrl:(NSString *)url {
    self.url = url;
}

// 设置配置参数
- (void) initWithAppId:(NSString *)appId onRegistry:(OnRegistry)onRegistry onClosed:(OnClosed)onClosed onStopped:(OnStopped)onStopped {
    
    if ( self.url == nil || self.appId == nil ) {
        @throw [[LCBaseException alloc]initWithName:@"参数异常" reason:@"传入的url或appId为空" userInfo:nil];
    }
    self.appId      = appId;
    self.onRegistry = onRegistry;
    self.onClosed   = onClosed;
    self.onStopped  = onStopped;
    
    self.isRunning  = false;
    self.client     = nil;
}

// 启动服务
- (void) start {
    
    if ( _isRunning ) {
        NSLog(@"lemoncloud service is already running");
        return ;
    }
    
    if ( self.client == nil ) {
        self.client = [[LCTcpClient alloc] init];
    }
    
    // 连接到connect
    @try {
        LCNodeAddress* address = [[LCLbUtil sharedInstance] getNodeAddress:self.url appId:self.appId];
        NSLog(@"node address==> ipv4:%@, ipv6:%@ port:%ld", address.ipv4, address.ipv6, (long)address.port);
        
        NSString* ip = nil ;
        if ( address.ipv4 != nil ) {
            ip = address.ipv4;
        } else if ( address.ipv6 != nil ) {
            ip = address.ipv6;
        }
        
        [self.client connect:ip port:(int)address.port onActive:^{
            NSLog(@"connected!");
            
            self.isRunning = true;
            self.openReconnect = true;
            
            // 启动定时器
            [self startKeepAlive];
            [self startEventCheckTimer];
            [self stopReconnTimer];

            // 向GW注册appId
            [self registryAppId];
        } onClosed:^{
            NSLog(@"closed!!");
            [self onClose];
        } onHeartbeat:^{
            NSLog(@"heartbeat!");
        }];
    }
    @catch (LCBaseException *e) {
        NSLog(@"exception: %@", e);
        [self startReconnTimer];
    }
}

//停止服务
- (void) stop {
    
    self.openReconnect = false; // 主动停止，关闭重连定时器
    [self.client disconnect];   // 断开链接
    [[LCEventManager sharedInstance] clearRequestHandler]; // 清除所有request事件
    // 回调给业务方
    if ( self.onStopped != nil ) {
        self.onStopped();
    }
}

// 处理连接断开资源清理事件
- (void) onClose {
    
    self.isRunning = false;
    [self stopKeepAlive];
    [self stopEventCheckTimer];

    if ( self.openReconnect ) { // 如果开启重连，则启动重连定时器
        [self startReconnTimer];
    }
    // 回调给业务方
    if ( self.onClosed != nil ) {
        self.onClosed();
    }
    
}

// 注册AppId
- (void) registryAppId {
    
    NSString* appId = [LCLemonService sharedInstance].appId;
    NSLog(@"registry appId: %@ to server", appId);
    
    LCRegistryRequest* request = [[LCRegistryRequest alloc] init];
    request.appKey = appId;
    request.moduleId = kModuleUnknown;
    
    LCLemonBasePackage* package = [[LCLemonBasePackage alloc] init];
    [package.header setModuleId:kModuleConnector];
    [package.header setCommandId:kCommandRegisterReq];
    [package copyBody: [request toJSONData]];
    
    // 定义回调函数处理
    LCBaseEventHandler* handler = [[LCBaseEventHandler alloc] initWithCallback:^LCLemonBasePackage * _Nullable(LCLemonBasePackage * _Nullable package) {

        NSLog(@"received registry appId resp");
        if ( package == nil ) {
            return nil;
        }
        NSError* err = nil;
        LCRegistryResponse* response = [[LCRegistryResponse alloc] initWithData:package.body error:&err];
        if ( err != nil ) {
            NSLog(@"registry appId failed for appId: %@, err; %@", appId, err);
            return nil;
        }
        NSLog(@"registry appId resp: %@", response);
        // 回调给业务方
        if ( self.onRegistry != nil ) {
            self.onRegistry();
        }
        return nil;
    }];

    // 发送数据
    [self send:kBizTypeSys packageType:kPackageTypeBizPack package:package handler:handler];
}

// 绑定用户ID
- (void) bindUserId:(NSString *)userId handler:(LCBaseEventHandler *)handler {
    
    if ( userId == nil ) {
        @throw [[LCBaseException alloc] initWithName:@"参数异常" reason:@"传入的userId为空" userInfo:nil];
    }
    
    LCBindUserRequest* request = [[LCBindUserRequest alloc] init];
    request.userId = userId;
    
    LCLemonBasePackage* package = [[LCLemonBasePackage alloc] init];
    [package.header setModuleId:kModuleConnector];
    [package.header setCommandId:kCommandBindUserReq];
    [package copyBody: [request toJSONData]];
    
    // 发送数据
    [self send:kBizTypeSys packageType:kPackageTypeBizPack package:package handler:handler];
}

// 发送ping消息
- (void) ping:(LCBaseEventHandler *)handler {
    
    LCPingRequest* request = [[LCPingRequest alloc] init];
    request.content = @"Ping Test From iOS!";
    
    LCLemonBasePackage* package = [[LCLemonBasePackage alloc] init];
    [package.header setModuleId:kModuleConnector];
    [package.header setCommandId:kCommandPingReq];
    [package copyBody: [request toJSONData]];

    // 发送数据
    [self send:kBizTypeSys packageType:kPackageTypeBizPack package:package handler:handler];
}

// 内部方法。
// 封装send
- (void) send: (LCBizType) bizType packageType:(LCPackageType) packageType package:(LCLemonBasePackage*)package handler:(LCBaseEventHandler*) handler {
    
    if ( !self.isRunning ) return;
    if ( package == nil ) return ;
    if ( self.client == nil ) return ;
    
    [package.header setBizType:bizType];
    [package.header setPackageType:packageType];
    
    if ( handler != nil ) {
        [package.header setRequestId:g_req_id];
        g_req_id++;

        [[LCEventManager sharedInstance]
            registryHandler:[package.header getBizType]
            appId:_appId
            requestId: [package.header getRequestId]
            handler:handler];
    }
    
    if ( ![self.client send:package] ) {
        NSLog(@"send package failed for reqId: %llu", g_req_id - 1);
        return ;
    }
}

// 发送消息
// TCP suitable
- (void) send:(NSInteger)moduleId commandId:(NSInteger)commandId data:(LCLemonBasePackage *)data handler:(LCBaseEventHandler *)handler {
    // 发送tcp消息到业务服务
    [self send:kBizTypeData packageType:kPackageTypeBizPack package:data handler:handler];
}

// 注册moduleId, commandId对应的handler到eventmanager
- (void) onNotify:(NSInteger)moduleId commandId:(NSInteger)commandId handler:(LCBaseEventHandler *)handler {
    [[LCEventManager sharedInstance] registryHandler:kBizTypeData appId:_appId moduleId:moduleId commandId:commandId handler:handler];
}

// 发送消息
// HTTP suitable
- (void) send:(NSString *)url data:(NSString *)data method:(NSString *)method headers:(NSMutableDictionary *)headers handler:(LCBaseEventHandler *)handler {
    
    // 发送http消息到业务服务
    LCHttpDeliverRequest* request = [[LCHttpDeliverRequest alloc] init];
    request.url = url;
    request.data = data;
    request.method = method;
    request.headers = headers;
    
    LCLemonBasePackage* package = [[LCLemonBasePackage alloc] init];
    [package.header setModuleId:kModuleConnector];
    [package.header setCommandId:kCommandHttpDeliverReq];
    [package copyBody: [request toJSONData]];
    
    // 发送数据包
    [self send:kBizTypeSys packageType:kPackageTypeBizPack package:package handler:handler];
}

// 接收文本消息广播
- (void) onNotify:(OnTextNotifyHandler)handler {
    
    if ( handler == nil ) {
        return ;
    }

    LCBaseEventHandler* notifyHandler = [[LCBaseEventHandler alloc] initWithCallback:^LCLemonBasePackage * _Nullable(LCLemonBasePackage * _Nullable package) {

        if ( package == nil ) {
            NSLog(@"wrong notify");
            return nil;
        }

        if ( package.body == nil ) {
            NSLog(@"wrong notify body");
            return nil;
        }

        
        NSError* err = nil;
        LCNotify* notify = [[LCNotify alloc] initWithData:package.body error:&err];
        if ( err != nil ) {
            NSLog(@"notify msg err: %@", err);
            return nil;
        }
        if ( handler != nil ) {
            handler(notify.data);
        }
        return nil;
    }];

    [[LCEventManager sharedInstance]
     registryHandler:kBizTypeData
     appId:_appId
     moduleId:kModuleConnector
     commandId:kCommandNotify
     handler:notifyHandler];
}

@end
