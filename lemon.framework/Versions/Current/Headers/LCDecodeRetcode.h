
//
//  LCDecodeRetcode..h
//  lemon
//
//  Created by Allen.Wu on 2017/12/22.
//

#ifndef LCDecodeRetcode__h
#define LCDecodeRetcode__h

typedef NS_OPTIONS(NSUInteger, LCDecodeRetCode)
{
    kDecodeRetCodeSuccess       = 0,    // 解包成功
    kDecodeRetCodeIllegal       = 1,    // 解包失败
    kDecodeRetCodeNotEnoughLen  = 2,    // 包长度不够
    
    kDecodeRetCodeMax,
};


#endif /* LCDecodeRetcode__h */
