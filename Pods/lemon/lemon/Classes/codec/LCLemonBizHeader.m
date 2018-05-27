//
//  LCLemonBizHeader.m
//  lemon
//
//  Created by 吴文卿 on 2017/12/22.
//

#import "LCLemonBizHeader.h"
#import "LCLemonHeader.h"

static uint8_t kMinBizHeaderBytes = 8;
static uint8_t kRequestIdBytes    = 8;
static uint8_t kReservedBytes     = 8;

static uint8_t kBizMaskRetry        = 0x80u;
static uint8_t kBizMaskZip          = 0x40u;
static uint8_t kBizMaskCrypt        = 0x20u;
static uint8_t kBizMaskUseRequestId = 0x10u;
static uint8_t kBizMaskUseReserved  = 0x08u;
static uint8_t kBizMaskUseExtend    = 0x04u;

@implementation LCLemonBizHeader

- (void) setRequestId:(int64_t)requestId {
    _useRequestId = true;
    _requestId = requestId;
}

- (void) setReserved:(int64_t)reserved {
    _useReserved = true;
    _reserved = reserved;
}

- (void) calcExtendBytes:(uint32_t)extendLength {
    if ( extendLength <= 0 ) {
        _useExtend = false;
        _extendBytes = 0;
        return ;
    }
    _useExtend = true;
    _extendBytes = (uint32_t)[LCLemonHeader calcBytes:extendLength] - 1;
}

// 反序列化
-(LCDecodeRetCode) decode:(LCIOBuffer *)buffer {
    
    if ( buffer == nil ) {
        return kDecodeRetCodeIllegal;
    }

    _bizHeaderLength = kMinBizHeaderBytes;
    if ( [buffer getReadableBytes] < _bizHeaderLength )  {
        return kDecodeRetCodeNotEnoughLen;
    }
    
    uint8_t firstByte = [buffer readUInt8];
    _isRetry        = (firstByte & kBizMaskRetry)           != 0;
    _isZip          = (firstByte & kBizMaskZip)             != 0;
    _isCrypt        = (firstByte & kBizMaskCrypt)           != 0;
    _useRequestId   = (firstByte & kBizMaskUseRequestId)    != 0;
    _useReserved    = (firstByte & kBizMaskUseReserved)     != 0;
    _useExtend      = (firstByte & kBizMaskUseExtend)       != 0;
    
    // 获取版本号
    _version = [buffer readUInt16];
    
    // 读取命令号
    _moduleId = [buffer readUInt16];
    _commandId = [buffer readUInt16];
    
    // 获取requestId
    if ( _useRequestId ) {
        _bizHeaderLength += kRequestIdBytes;
        if ( [buffer getReadableBytes] < kRequestIdBytes ) {
            return kDecodeRetCodeNotEnoughLen;
        }
        _requestId = [buffer readUInt64];
    }
    
    // 获取reserved
    if ( _useReserved ) {
        _bizHeaderLength += kReservedBytes;
        if ([buffer getReadableBytes] < kReservedBytes) {
            return kDecodeRetCodeNotEnoughLen;
        }
        _reserved = [buffer readUInt64];
    }
    
    // 获取扩展包的字节数的值所占的字节数 - 1
    if ( _useExtend ) {
        _bizHeaderLength += 1;
        if ([buffer getReadableBytes] < 1) {
            return kDecodeRetCodeNotEnoughLen;
        }
        _extendBytes = [buffer readUInt8];
    }

    return kDecodeRetCodeSuccess;
}

// 序列化
-(BOOL) encode:(LCIOBuffer *)buffer {

    if ( buffer == nil ) {
        return false;
    }
    
    _bizHeaderLength = kMinBizHeaderBytes;
    
    uint8_t firstByte = 0;
    firstByte |= (_isRetry) ? kBizMaskRetry : 0;
    firstByte |= (_isZip) ? kBizMaskZip : 0;
    firstByte |= (_isCrypt) ? kBizMaskCrypt : 0;
    firstByte |= (_useRequestId) ? kBizMaskUseRequestId : 0;
    firstByte |= (_useReserved) ? kBizMaskUseReserved : 0;
    firstByte |= (_useExtend) ? kBizMaskUseExtend : 0;
    [buffer writeInt8:firstByte];
    
    // 写入版本号
    [buffer writeInt16:_version];
    
    // 写入命令号
    [buffer writeInt16:_moduleId];
    [buffer writeInt16:_commandId];
    
    // 写入requestId
    if ( _useRequestId ) {
        _bizHeaderLength += kRequestIdBytes;
        [buffer writeInt64:_requestId];
    }
    
    // 写入Reserved
    if ( _useReserved ) {
        _bizHeaderLength += kReservedBytes;
        [buffer writeInt64:_reserved];
    }
    
    if ( _useExtend ) {
        _bizHeaderLength += 1;
        [buffer writeInt8:_extendBytes];
    }

    return true;
}

@end
