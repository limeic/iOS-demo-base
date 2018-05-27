//
//  LCIOBuffer.m
//  lemon
//
//  Created by Allen.Wu on 2017/12/22.
//

#import "LCIOBuffer.h"

@implementation LCIOBuffer : NSObject

-(int) getReadableBytes {
    return writeIndex - readIndex;
}

-(nullable NSData*) getWritedData {
    // 已经读完，则没有数据
    if (readIndex >= writeIndex ) return nil;
    NSData* buffer = [data subdataWithRange:NSMakeRange(readIndex, writeIndex)];
    // 返回拷贝的副本
    return [[NSData alloc] initWithData:buffer];
}

-(void) discardReadBytes {
    
    if ( readIndex <= 0 ) return ;
    NSData* buffer = [[NSData alloc] initWithData:[data subdataWithRange:NSMakeRange(readIndex, [data length] - readIndex)]];
    
    // 重新初始化data
    data = [[NSMutableData alloc] initWithData:buffer];
    
    writeIndex -= readIndex;
    markReadIndex -= readIndex;
    if ( markReadIndex < 0 ) {
        markReadIndex = readIndex;
    }
    
    markWriteIndex -= readIndex;
    if ( markWriteIndex < 0 ||
        markWriteIndex < readIndex ||
        markWriteIndex < markReadIndex ) {
        markWriteIndex = writeIndex;
    }
    readIndex = 0;
}

-(void) clear {
    data = nil;
    readIndex = 0;
    writeIndex = 0;
    markReadIndex = 0;
    markWriteIndex = 0;
}

-(int) FixLength: (int)len {
    int n = 2;
    int b = 2;
    while (b < len)
    {
        b = 2 << n;
        n++;
    }
    return b;
}

-(int) FixSizeAndReset:(int)currentLen futureLen:(int)futureLen {
    if ( futureLen > currentLen ) {
        int size = [self FixLength:currentLen] * 2;
        if ( futureLen > size ) {
            size = [self FixLength:futureLen] * 2;
        }
        
        NSData* buffer = [[NSData alloc] initWithData:[data subdataWithRange:NSMakeRange(0, currentLen)]];
        data = [[NSMutableData alloc ] initWithData:buffer];
    }
    return futureLen;
}

-(void) setReadIndex:(int)index {
    readIndex = index;
}

-(void) setWriteIndex:(int)index {
    writeIndex = index;
}

-(void) markReadIndex {
    markReadIndex = readIndex;
}

-(void) markWriteIndex {
    markWriteIndex = writeIndex;
}

-(void) resetReadIndex {
    readIndex = markReadIndex;
}

-(void) resetWriteIndex {
    writeIndex = markWriteIndex;
}

-(int8_t) readInt8 {
    
    int8_t v;
    @try {
        [data getBytes:&v range:NSMakeRange(readIndex, 1)];
        readIndex++;
    }
    @catch (NSException *exception) {
        NSLog(@"readChar error: %@", exception.description);
    }
    @finally {
        return (v & 0xFFu);
    }
}

-(uint8_t) readUInt8 {
    return (uint8_t)[self readInt8];
}

-(int16_t) readInt16 {
    int32_t ch1 = [self readInt8];
    int32_t ch2 = [self readInt8];
    return (int16_t)((ch1 << 8) + (ch2 << 0));
}

-(uint16_t) readUInt16 {
    uint32_t ch1 = [self readUInt8];
    uint32_t ch2 = [self readUInt8];
    return (uint32_t)((ch1 << 8) + (ch2 << 0));
}

-(int32_t) readInt32 {
    int32_t ch1 = [self readInt8];
    int32_t ch2 = [self readInt8];
    int32_t ch3 = [self readInt8];
    int32_t ch4 = [self readInt8];
    return ((ch1 << 24) + (ch2 << 16) + (ch3 << 8) + (ch4 << 0));
}

-(uint32_t) readUInt32 {
    uint32_t ch1 = [self readUInt8];
    uint32_t ch2 = [self readUInt8];
    uint32_t ch3 = [self readUInt8];
    uint32_t ch4 = [self readUInt8];
    return ((ch1 << 24) + (ch2 << 16) + (ch3 << 8) + (ch4 << 0));
}

-(int64_t) readInt64 {
    int64_t ch1 = [self readInt8];
    int64_t ch2 = [self readInt8];
    int64_t ch3 = [self readInt8];
    int64_t ch4 = [self readInt8];
    int64_t ch5 = [self readInt8];
    int64_t ch6 = [self readInt8];
    int64_t ch7 = [self readInt8];
    int64_t ch8 = [self readInt8];
    return ((ch1 << 8*7) + (ch2 << 8*6) + (ch3 << 8*5) + (ch4 << 8*4) + (ch5 << 8*3) + (ch6 << 8*2) + (ch7 << 8*1) + (ch8 << 8*0));
}

-(uint64_t) readUInt64 {
    uint64_t ch1 = [self readUInt8];
    uint64_t ch2 = [self readUInt8];
    uint64_t ch3 = [self readUInt8];
    uint64_t ch4 = [self readUInt8];
    uint64_t ch5 = [self readUInt8];
    uint64_t ch6 = [self readUInt8];
    uint64_t ch7 = [self readUInt8];
    uint64_t ch8 = [self readUInt8];
    return ((ch1 << 8*7) + (ch2 << 8*6) + (ch3 << 8*5) + (ch4 << 8*4) + (ch5 << 8*3) + (ch6 << 8*2) + (ch7 << 8*1) + (ch8 << 8*0));
}

-(nullable NSData*) readData:(int)len {
    int dataLen = (int)[data length];
    if ( readIndex + len >= dataLen ) {
        len = dataLen - readIndex;
    }
    
    NSData* buffer = [[NSData alloc] initWithData:[data subdataWithRange:NSMakeRange(readIndex, len)]];
    ;
    readIndex += len;
    return buffer;
}

-(void) writeInt8: (int8_t) value {
    [self FixSizeAndReset:writeIndex futureLen:writeIndex+1];
    NSData* valueBytes = [[NSData alloc] initWithBytes:&value length:1];
    [data appendData:valueBytes];
    writeIndex++;
}

-(void) writeInt16:(int16_t)value {
    [self FixSizeAndReset:writeIndex futureLen:writeIndex+2];
    value = NSSwapHostShortToBig(value);
    [data appendData:[[NSData alloc] initWithBytes:&value length:2]];
    writeIndex += 2;
}

-(void) writeInt32:(int32_t)value {
    [self FixSizeAndReset:writeIndex futureLen:writeIndex+4];
    value = NSSwapHostIntToBig(value);
    [data appendData:[[NSData alloc] initWithBytes:&value length:4]];
    writeIndex += 4;
}

-(void) writeInt64:(int64_t)value {
    [self FixSizeAndReset:writeIndex futureLen:writeIndex+8];
    value = NSSwapHostLongLongToBig(value);
    [data appendData:[[NSData alloc] initWithBytes:&value length:8]];
    writeIndex += 8;
}

-(void) writeData:(nonnull NSData *)buffer {
    if ( buffer == nil ) return ;
    int len = (int)[buffer length];
    if ( len <= 0 ) return ;
    
    [self FixSizeAndReset:writeIndex futureLen:writeIndex + len];
    [data appendData:buffer];
    writeIndex += len;
}

@end
