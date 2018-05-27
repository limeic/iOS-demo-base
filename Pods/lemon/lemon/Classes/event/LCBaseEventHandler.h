//
//  LCBaseEventHandler.h
//  lemon
//
//  Created by 吴文卿 on 2017/12/24.
//

#import <Foundation/Foundation.h>
#import "LCLemonBasePackage.h"

// 回调函数，收到数据包
typedef LCLemonBasePackage* _Nullable(^OnResponse)(LCLemonBasePackage* _Nullable package);

@interface LCBaseEventHandler : NSObject

@property (nonatomic, copy) OnResponse _Nullable onResponse;

-(id _Nonnull ) initWithCallback: (nonnull OnResponse) onResponse;

@end
