//
//  LCLemonGatewayHeader.h
//  lemon
//
//  Created by 吴文卿 on 2017/12/22.
//

#import <Foundation/Foundation.h>
#import "LCBizType.h"
#import "LCPackageType.h"
#import "LCDecodeRetcode.h"
#import "LCIOBuffer.h"

@interface LCLemonBaseHeader : NSObject

// 是否心跳包
@property (nonatomic, assign) BOOL isHeartbeat;
// 业务类型
@property (nonatomic, assign) LCBizType bizType;
// 包类型
@property (nonatomic, assign, readonly) LCPackageType packageType;
// 包整体长度(去除 GatewayHeader 之后的长度) -- 字节数
@property (nonatomic, assign) NSInteger packageLength;

- (void) setPackageType:(LCPackageType)packageType;

- (LCDecodeRetCode) decode: (LCIOBuffer *) buffer;
- (BOOL) encode: (LCIOBuffer *) buffer;

@end
