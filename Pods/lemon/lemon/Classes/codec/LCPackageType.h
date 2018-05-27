//
//  LCPackageType.h
//  lemon
//
//  Created by 吴文卿 on 2017/12/22.
//

#ifndef LCPackageType_h
#define LCPackageType_h

typedef NS_OPTIONS(NSInteger, LCPackageType)
{
    kPackageTypeBizPack     = 0, // 业务包
    kPackageTypeHeartbeat   = 1, // 心跳包
    
    kPackageTypeMax,
};


#endif /* LCPackageType_h */
