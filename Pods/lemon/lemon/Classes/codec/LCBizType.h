//
//  LCBizType.h
//  Pods
//
//  Created by 吴文卿 on 2017/12/22.
//

#ifndef LCBizType_h
#define LCBizType_h

typedef NS_OPTIONS(NSInteger, LCBizType) {
 
    kBizTypeIllegal         = 0, // 非法业务类型
    kBizTypeData            = 1, // 数据包
    kBizTypeSys             = 2, // 系统包
    kBizTypeMonitor         = 3, // 监控包
    
    kBizTypeMax,
};

#endif /* LCBizType_h */
