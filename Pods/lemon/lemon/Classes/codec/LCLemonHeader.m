//
//  LCLemonHeader.m
//  lemon
//
//  Created by 吴文卿 on 2017/12/22.
//

#import "LCLemonHeader.h"
#import "../exception/LCBaseException.h"

@implementation LCLemonHeader

+(int) calcBytes:(uint32_t)length {
    if ( length <= 0xFFu ) {
        return 1;
    } else if ( length <= 0xFFFFu ) {
        return 2;
    } else if ( length <= 0xFFFFFFu ) {
        return 3;
    } else {
        return 4;
    }
}

- (BOOL) isHeartbeat {
    if ( _baseHeader == nil ) return false;
    return _baseHeader.isHeartbeat;
}

- (void) setHeartbeat {
    if ( _baseHeader == nil ) {
        _baseHeader = [[LCLemonBaseHeader alloc] init];
    }
    _baseHeader.isHeartbeat = true;
    _baseHeader.bizType = kBizTypeSys;
    _baseHeader.packageType = kPackageTypeHeartbeat;
    _baseHeader.packageLength = 0;
    
}

- (void) setBizType:(LCBizType)bizType {
    if ( _baseHeader == nil ) {
        _baseHeader = [[LCLemonBaseHeader alloc] init];
    }
    [_baseHeader setBizType:bizType];
}

- (LCBizType) getBizType {
    if ( _baseHeader == nil ) {
        return kBizTypeIllegal;
    }
    return _baseHeader.bizType;
}

- (void) setPackageType:(LCPackageType)packageType {
    if ( _baseHeader == nil ) {
        _baseHeader = [[LCLemonBaseHeader alloc] init];
    }
    [_baseHeader setPackageType:packageType];
}

- (LCPackageType) getPackageType {
    if ( _baseHeader == nil ) {
        return kPackageTypeMax;
    }
    return _baseHeader.packageType;
}

- (void) setModuleId:(uint32_t)moduleId {
    if ( _bizHeader == nil ) {
        _bizHeader = [[LCLemonBizHeader alloc] init];
    }
    _bizHeader.moduleId = moduleId;
}

- (uint16_t) getModuleId {
    if ( _bizHeader == nil ) {
        return 0;
    }
    return _bizHeader.moduleId;
}

- (void) setCommandId:(uint32_t)commandId {
    if ( _bizHeader == nil ) {
        _bizHeader = [[LCLemonBizHeader alloc] init];
    }
    _bizHeader.commandId = commandId;
}

-(uint16_t) getCommandId {
    if ( _bizHeader == nil ) {
        return 0;
    }
    return _bizHeader.commandId;
}

- (BOOL) useRequest {
    if ( _bizHeader == nil ) {
        return false;
    }
    return _bizHeader.useRequestId;
}

- (void) setRequestId:(int64_t)requestId {
    if ( _bizHeader == nil ) {
        _bizHeader = [[LCLemonBizHeader alloc] init];
    }
    [_bizHeader setRequestId:requestId];
}

- (int64_t) getRequestId {
    if ( _bizHeader == nil ) {
        return 0;
    }
    return _bizHeader.requestId;
}

// 反序列化
- (LCDecodeRetCode) decode:(LCIOBuffer *)buffer {

    if ( buffer == nil ) {
        return kDecodeRetCodeIllegal;
    }
    // gateway 包头解析
    if ( _baseHeader == nil ) {
        _baseHeader = [[LCLemonBaseHeader alloc] init];
    }
    LCDecodeRetCode code = [_baseHeader decode:buffer];
    if ( code == kDecodeRetCodeNotEnoughLen ) {
        [buffer resetReadIndex];
        return code;
    }
    if ( code != kDecodeRetCodeSuccess ) {
        return code;
    }
    
    // 心跳包
    if ( _baseHeader.isHeartbeat )
        return kDecodeRetCodeSuccess;
    
    // 解析biz header包
    if ( _bizHeader == nil ) {
        _bizHeader = [[LCLemonBizHeader alloc] init];
    }
    code = [_bizHeader decode: buffer];
    if ( code == kDecodeRetCodeNotEnoughLen ) {
        [buffer resetReadIndex];
        return code;
    }
    if ( code != kDecodeRetCodeSuccess ) {
        return code;
    }
    
    // 包体长度
    _bodyLength = (uint32_t)(_baseHeader.packageLength - _bizHeader.bizHeaderLength);
    
    // 扩展包
    if ( _bizHeader.useExtend ) {
        @throw [[LCBaseException alloc] initWithName:@"业务包错误" reason:@"客户端业务包没有扩展包" userInfo:nil];
    }
    return kDecodeRetCodeSuccess;
}

// 序列化
- (BOOL) encode:(LCIOBuffer *)buffer {

    if ( buffer == nil ) {
        return false;
    }
    if ( _baseHeader == NULL ) {
        return false;
    }
    
    // 心跳包
    if ( _baseHeader.isHeartbeat ) {
        return [_baseHeader encode:buffer];
    }
    
    // 计算包体长度
    uint32_t length = 0;
    if ( _bizHeader == nil ) {
        return false;
    }
    
    // 先encode biz包. 得到实际长度
    LCIOBuffer* tempBuffer = [[LCIOBuffer alloc] init];
    if ( ![_bizHeader encode:tempBuffer] ) {
        return false;
    }
    length += _bizHeader.bizHeaderLength;
    
    if ( _bizHeader.useExtend ) {
        @throw [[LCBaseException alloc] initWithName:@"反序列化失败" reason:@"客户端反序列化不应该有extend包" userInfo:nil];
    }
    
    // 设置包长度之后对 gateway 做encode
    [_baseHeader setPackageLength:(length + _bodyLength)];
    if ( ![_baseHeader encode:buffer] ) {
        return false;
    }
    
    // 追加temp buffer
    [buffer writeData:[tempBuffer getWritedData]];
    return true;
}

@end
