//
//  LCLemonService.h
//  lemon SDK 统一入口
//  Created by Allen.Wu on 2017/11/23.


#import <Foundation/Foundation.h>
#import "LCLemonBasePackage.h"
#import "LCBaseEventHandler.h"
#import "LemonCommandTypes.pbobjc.h"

/**
 * 定义服务建立并注册appId成功之后的回调
 */
typedef void(^OnRegistry)(void);

/**
 * 定义服务断开的回调
 */
typedef void(^OnClosed)(void);

/**
 * 定义服务停止之后的回调
 */
typedef void(^OnStopped)(void);

/**
 * 文本消息广播处理
 */
typedef void(^OnTextNotifyHandler)(NSString* data);

@interface LCLemonService : NSObject

@property (nonatomic, assign) NSString * _Nonnull url;
@property (nonatomic, assign) NSString * _Nonnull appId;

/**
 * 获取对象实例
 */
+(instancetype _Nonnull ) sharedInstance;

/**
 * 初始化服务连接参数配置
 * @param url      服务连接地址
 * @param appId    申请到的AppId
 */
-(void) initWithUrl: (nonnull NSString*) url appId:(nonnull NSString*) appId onRegistry:(nullable OnRegistry) onRegistry onClosed:(nullable OnClosed) onClosed onStopped:(nullable OnStopped) onStopped;

/**
 * 启动服务
 */
-(void) start;

/**
 * 停止服务
 */
-(void) stop;

/**
 * 向Gateway注册userId
 * Tips: 只有注册了userId的App才能接收到服务端主动发送的消息
 */
-(void) bindUserId: (nonnull NSString*) userId handler:(nullable LCBaseEventHandler *) handler;

/**
 * 发送ping消息到Gateway集群，测试Gateway可用性
 */
-(void) ping: (nullable LCBaseEventHandler* ) handler;

/**
 * 发送数据到Gateway集群
 * 适用于业务服务的通信协议为tcp的
 */
-(void) send: (NSInteger) moduleId commandId:(NSInteger) commandId data:(nullable LCLemonBasePackage* )data handler:(nullable LCBaseEventHandler *) handler;

/**
 * 注册广播消息处理
 * 适用于业务服务的通信协议为tcp的
 */
-(void) onNotify: (NSInteger) moduleId commandId:(NSInteger) commandId handler:(nullable LCBaseEventHandler* )handler;

/**
 * 发送数据到Gatewat集群
 * 适用于业务服务的通信协议为http的
 */
-(void) send: (nonnull NSString*) url data:(NSString*) data method:(HttpMethod) method headers:(NSMutableDictionary*) headers handler:(nullable LCBaseEventHandler*) handler;

/**
 * 接收广播消息
 * 适用于业务服务的通信协议为tcp的
 */
-(void) onNotify:(OnTextNotifyHandler)handler;


@end
