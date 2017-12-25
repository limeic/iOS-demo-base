//
//  LCLemonBizHeader.h
//  lemon
//
//  Created by 吴文卿 on 2017/12/22.
//

#import <Foundation/Foundation.h>
#import "LCDecodeRetcode.h"
#import "LCIOBuffer.h"

@interface LCLemonBizHeader : NSObject

@property (nonatomic, assign) uint32_t version;
@property (nonatomic, assign) uint32_t moduleId;
@property (nonatomic, assign) uint32_t commandId;
@property (nonatomic, assign, readonly) int64_t requestId;
@property (nonatomic, assign, readonly) int64_t reserved;
@property (nonatomic, assign, readonly) int64_t extendBytes;
@property (nonatomic, assign, readonly) uint32_t bizHeaderLength;

@property (nonatomic, assign) BOOL isRetry;
@property (nonatomic, assign) BOOL isZip;
@property (nonatomic, assign) BOOL isCrypt;
@property (nonatomic, assign, readonly) BOOL useRequestId;
@property (nonatomic, assign, readonly) BOOL useReserved;
@property (nonatomic, assign, readonly) BOOL useExtend;

-(void) setRequestId:(int64_t)requestId;

-(void) setReserved:(int64_t)reserved;

-(void) calcExtendBytes:(uint32_t) extendLength;

-(LCDecodeRetCode) decode: (LCIOBuffer *) buffer;

-(BOOL) encode: (LCIOBuffer *) buffer;

@end
