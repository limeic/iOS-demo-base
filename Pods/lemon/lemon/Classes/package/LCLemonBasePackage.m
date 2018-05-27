//
//  LCBaseLemonPackage.m
//  lemon
//
//  Created by 吴文卿 on 2017/11/23.
//

#import "LCLemonBasePackage.h"

@implementation LCLemonBasePackage

// 初始化时创建header对象
-(id) init {
    self = [super init];
    _header = [[LCLemonHeader alloc] init];
    return self;
}

// 设置包体长度
- (void) copyBody:(NSData *)body {
    uint32_t bodyLength = 0;
    _body = body;
    if ( body != nil ) {
        bodyLength = (uint32_t)self.body.length;
    }
    if ( _header == nil ) {
        _header = [[LCLemonHeader alloc] init];
    }
    _header.bodyLength = bodyLength;
}

// 反序列化
- (LCDecodeRetCode)decode:(LCIOBuffer *)buffer {
    
    if ( buffer == nil ) {
        return kDecodeRetCodeIllegal;
    }
    
    _header = [[LCLemonHeader alloc] init];
    LCDecodeRetCode code = [_header decode:buffer];
    if ( code != kDecodeRetCodeSuccess ) {
        return code;
    }
    
    // 读取包体
    uint32_t bodyLength = _header.bodyLength;
    if ( bodyLength > [buffer getReadableBytes] ) {
        [buffer resetReadIndex];
        return kDecodeRetCodeNotEnoughLen;
    }
    _body = [buffer readData:bodyLength];
    return kDecodeRetCodeSuccess;
}


// 序列化
- (BOOL)encode:(LCIOBuffer *)buffer {

    if ( buffer == nil ) {
        return false;
    }
    
    if ( _header == nil ) {
        return false;
    }
    
    if ( ![_header encode: buffer] ) {
        return false;
    }
    
    if ( _body != nil ) {
        [buffer writeData:_body];
    }
    return true;
}

@end
