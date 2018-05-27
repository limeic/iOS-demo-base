//
//  LCModule.h
//  lemon
//
//  Created by allen on 2018/5/27.
//

#ifndef LCModule_h
#define LCModule_h

typedef NS_OPTIONS(NSInteger, LCModule)
{
    kModuleUnknown          = 0, // 无效moduleId
    kModuleConnector        = 1, // 链接器关联业务
    
    kModuleMax,
};


#endif /* LCModule_h */
