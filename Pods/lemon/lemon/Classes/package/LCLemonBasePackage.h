//
//  LCBaseLemonPackage.h
//  lemon
//  网关数据包
//  Created by 吴文卿 on 2017/11/23.
//

#import <Foundation/Foundation.h>
#import "LCLemonHeader.h"

@interface LCLemonBasePackage : NSObject

@property (nullable, nonatomic, retain, readonly) NSData* body;
@property (nullable, nonatomic, retain, readonly) LCLemonHeader* header;

-(void) copyBody:(NSData * _Nullable)body;

// 反序列化
-(LCDecodeRetCode) decode: (nonnull LCIOBuffer* ) buffer;

// 序列化
-(BOOL) encode: (nonnull LCIOBuffer* ) buffer;

@end
