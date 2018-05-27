//
//  LCEventManager.m
//  lemon
//
//  Created by 吴文卿 on 2017/12/24.
//

#import "LCEventManager.h"
#import "LCEventWrapper.h"

@interface LCEventManager()

// 存储handler
// key -> EventWrapper
@property (nonatomic, retain) NSMutableDictionary* eventPool;

@end


@implementation LCEventManager

+ (instancetype) sharedInstance {
    static LCEventManager* instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype) init {
    
    self = [super init];
    if ( !self ) return nil;
    
    self.eventPool = [[NSMutableDictionary alloc] init];
    return self;
}

//构建handler的key
- (NSString*) createKey:(LCBizType) bizType appId:(NSString*) appId moduleId:(uint16_t) moduleId commandId:(uint16_t) commandId {
    
    NSString* key = @"";
    if ( bizType == kBizTypeSys ) {
        key = @"sys|";
    } else if ( bizType == kBizTypeData ) {
        if ( appId == nil || [appId isEqualToString:@""] ) {
            return key;
        }
        key = @"biz|";
    } else if ( bizType == kBizTypeMonitor ) {
        key = @"monitor|";
    } else {
        return key;
    }
    
    if ( moduleId == 0 && commandId == 0 ) {
        return key;
    }
    uint32_t packageId = (moduleId << 16) | commandId;
    return [[NSString alloc] initWithFormat:@"%@%u", key, packageId];
}

//构建handler的key
- (NSString*) createKey:(LCBizType) bizType appId:(NSString*) appId requestId:(int64_t)requestId {
    NSString* key = [self createKey:bizType appId:appId moduleId:0 commandId:0];
    return [[NSString alloc] initWithFormat:@"%@|req|%lld", key, requestId];
}

- (BOOL)registryHandler:(LCBizType)bizType appId:(NSString *)appId moduleId:(uint16_t)moduleId commandId:(uint16_t)commandId handler:(LCBaseEventHandler *)handler {
    if ( handler == nil ) return false;
    NSString* key = [self createKey:bizType appId:appId moduleId:moduleId commandId:commandId];
    LCEventWrapper* wrapper = [[LCEventWrapper alloc] initWithHandler:handler];
    [self.eventPool setObject:wrapper forKey:key];
    return true;
}

- (BOOL)registryHandler:(LCBizType)bizType appId:(NSString *)appId requestId:(int64_t)requestId handler:(LCBaseEventHandler *)handler {
    if ( handler == nil ) return false;
    NSString* key = [self createKey:bizType appId:appId requestId:requestId];
    LCEventWrapper* wrapper = [[LCEventWrapper alloc] initWithHandler:handler];
    [self.eventPool setObject:wrapper forKey:key];
    return true;
}

- (LCBaseEventHandler *)getHandler:(LCBizType)bizType appId:(NSString *)appId moduleId:(uint16_t)moduleId commandId:(uint16_t)commandId{
    NSString* key = [self createKey:bizType appId:appId moduleId:moduleId commandId:commandId];
    LCEventWrapper* wrapper = [self.eventPool objectForKey:key];
    if ( wrapper == nil ) {
        return nil;
    }
    return wrapper.handler;
}

// 找到key
- (LCBaseEventHandler *)getHandler:(LCBizType)bizType appId:(NSString *)appId requestId:(int64_t)requestId {
    NSString* key = [self createKey:bizType appId:appId requestId:requestId];
    LCEventWrapper* wrapper = [self.eventPool objectForKey:key];
    if ( wrapper == nil ) {
        return nil;
    }
    LCBaseEventHandler* handler = wrapper.handler;
    [self.eventPool removeObjectForKey:key];
    return handler;
}

- (void) check:(int64_t)interval {

    uint64_t current = [[NSDate date] timeIntervalSince1970] * 1000;
    
    // 避免crash。需要先 retain出来对象，在retain出来的对象中做判断，在原始对象中做删除
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:self.eventPool];
    
    for ( NSString *key in dict ) {
        LCEventWrapper *wrapper = [self.eventPool objectForKey:key];
        if (wrapper == nil) continue;
        if ( wrapper.handler == nil ) continue;
        // 清理"|req|"的数据
        if ( ![key containsString:@"|req|"] ) continue;
        if ( (current - wrapper.timestamp) / 1000 > interval ) {
            //移除对象
            [self.eventPool removeObjectForKey:key];
            NSLog(@"remove handler for key: %@", key);
            continue;
        }
    }
    
}

// 清除requestHandler
- (void) clearRequestHandler {
    // 避免crash。需要先 retain出来对象，在retain出来的对象中做判断，在原始对象中做删除
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:self.eventPool];
    for ( NSString *key in dict ) {
        if ( [key containsString:@"|req|"] ) { // 清除包含req的handler
            [self.eventPool removeObjectForKey:key];
        }
    }
}

// 清除所有对象
- (void)clear {
    [self.eventPool removeAllObjects];
}

@end



















