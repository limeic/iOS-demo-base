//
//  LCLemonGatewayHeader.m
//  lemon
//
//  Created by 吴文卿 on 2017/12/22.
//

#import "LCLemonBaseHeader.h"
#import "LCLemonHeader.h"

// 最小包2个字节
static NSInteger kMinBaseHeaderBytes = 2;

static uint8_t kBitMaskPackageType  = 0x80u;
static uint8_t kBitMaskBizType      = 0x70u;
static uint8_t kBitMaskPackageBytes = 0x03u;

@implementation LCLemonBaseHeader

-(void) setPackageType:(LCPackageType)packageType {
    _packageType = packageType;
    if ( _packageType == kPackageTypeHeartbeat ) {
        _isHeartbeat = true;
    }
}

// 反序列化
-(LCDecodeRetCode) decode:(LCIOBuffer *)buffer {
    
    if( buffer == NULL ) return kDecodeRetCodeIllegal;
    if( [buffer getReadableBytes] < kMinBaseHeaderBytes ) {
        return kDecodeRetCodeNotEnoughLen;
    }
    
    uint8_t firstByte = [buffer readUInt8];
    // 读取包类型
    _packageType = (firstByte & kBitMaskPackageType) == 0 ? kPackageTypeBizPack : kPackageTypeHeartbeat;
    if ( _packageType == kPackageTypeHeartbeat ) {
        _isHeartbeat = true;
    }
    
    // 读取业务类型
    _bizType = (firstByte & kBitMaskBizType) >> 4;
    
    // 读取包字节数
    uint8_t packageBytes = (firstByte & kBitMaskPackageBytes);
    
    switch (packageBytes) {
        case 0:
        {
            _packageLength = [buffer readUInt8];
            break;
        }
        case 1:
        {
            _packageLength = [buffer readUInt16];
            break;
        }
        case 2:
        {
            _packageLength = [buffer readUInt8];
            _packageLength = (_packageLength << 16);
            _packageLength |= [buffer readUInt16];
            break;
        }
        case 3:
        {
            _packageLength = [buffer readUInt32];
            break;
        }
        default:
            break;
    }
    return kDecodeRetCodeSuccess;
    
}

// 序列化
-(BOOL) encode:(LCIOBuffer *)buffer {
    
    if ( buffer == nil ) {
        return false;
    }
    
    uint8_t firstByte = 0;
    if ( _isHeartbeat && _packageType == kPackageTypeHeartbeat ) {
        firstByte |= kBitMaskPackageType;
    }
    firstByte |= (_bizType << 4) & kBitMaskBizType;
    
    uint8_t packageBytes = [LCLemonHeader calcBytes:(uint32_t)_packageLength] - 1;
    firstByte |= (packageBytes & kBitMaskPackageBytes);
    
    // 写入第一个字节
    [buffer writeInt8:firstByte];
    
    // 写入长度
    switch (packageBytes) {
        case 0: {
            [buffer writeInt8:_packageLength];
            break;
        }
        case 1: {
            [buffer writeInt16:_packageLength];
            break;
        }
        case 2: {
            [buffer writeInt8:(int)(_packageLength << 16)];
            [buffer writeInt16:(int)(_packageLength & 0xFFFF)];
            break;
        }
        case 3: {
            [buffer writeInt32:(int)_packageLength];
            break;
        }
        default:
            break;
    }
    return true;
}

@end
