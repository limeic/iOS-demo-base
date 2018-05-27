//
//  LCIOBuffer.h
//  lemon
//
//  Created by 吴文卿 on 2017/12/22.
//

#import <Foundation/Foundation.h>

@interface LCIOBuffer : NSObject {
    
@private
    NSMutableData* data;    // 缓冲区数据
    int readIndex;          // 当前下标
    int writeIndex;
    int markReadIndex;      // 标记下标
    int markWriteIndex;
    
}
// 获取可读字节数
-(int) getReadableBytes;
// 获取写入的数据
-(nullable NSData*) getWritedData;

// 清除已读字节数
-(void) discardReadBytes;
// 清除数据
-(void) clear;

// 设置下标
-(void) setReadIndex: (int) index;
-(void) setWriteIndex: (int) index;
-(void) markReadIndex;
-(void) markWriteIndex;
-(void) resetReadIndex;
-(void) resetWriteIndex;

// 读取数据
-(int8_t) readInt8;
-(uint8_t) readUInt8;
-(int16_t) readInt16;
-(uint16_t) readUInt16;
-(int32_t) readInt32;
-(uint32_t) readUInt32;
-(int64_t) readInt64;
-(uint64_t) readUInt64;
-(nullable NSData*) readData: (int)len;

// 写入数据
-(void) writeInt8: (int8_t) value;
-(void) writeInt16: (int16_t) value;
-(void) writeInt32: (int32_t) value;
-(void) writeInt64: (int64_t) value;
-(void) writeData: (nonnull NSData*) buffer;

@end

