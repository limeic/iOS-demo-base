//
//  LCLemonHeader.h
//  lemon
//
//  Created by 吴文卿 on 2017/12/22.
//

#import <Foundation/Foundation.h>
#import "LCLemonBaseHeader.h"
#import "LCLemonBizHeader.h"

@interface LCLemonHeader : NSObject

@property (nonatomic, assign) uint32_t bodyLength;
@property (nullable, nonatomic, retain, readonly) LCLemonBaseHeader *baseHeader;
@property (nullable, nonatomic, retain, readonly) LCLemonBizHeader *bizHeader;

// 计算length所占的字节数
+(int) calcBytes: (uint32_t) length;

// 是否心跳包
-(BOOL) isHeartbeat;
// 设置为心跳包
-(void) setHeartbeat;
// 设置 bizType
-(void) setBizType:(LCBizType) bizType;
// 获取 bizType
-(LCBizType) getBizType;
// 设置 packageType
-(void) setPackageType:(LCPackageType) packageType;
// 获取 packageType
-(LCPackageType) getPackageType;
// 设置 moduleId
-(void) setModuleId:(uint32_t) moduleId;
// 获取 moduleId
-(uint16_t) getModuleId;
// 设置 commandId
-(void) setCommandId:(uint32_t) commandId;
// 获取 commandId
-(uint16_t) getCommandId;
// 是否使用了request
-(BOOL) useRequest;
-(void) setRequestId:(int64_t)requestId;
-(int64_t) getRequestId;

- (LCDecodeRetCode) decode: (nonnull LCIOBuffer*) buffer;

- (BOOL) encode: (nonnull LCIOBuffer* ) buffer;

@end
