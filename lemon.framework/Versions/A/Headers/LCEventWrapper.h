//
//  LCEventWrapper.h
//  lemon
//
//  Created by 吴文卿 on 2017/12/24.
//

#import <Foundation/Foundation.h>
#import "LCBaseEventHandler.h"

@interface LCEventWrapper : NSObject

@property (nonatomic, assign, readonly) uint64_t timestamp;
@property (nonatomic, retain) LCBaseEventHandler* _Nullable handler;

-(id _Nonnull ) initWithHandler:(nonnull LCBaseEventHandler*) handler;

@end
