//
//  LCCommand.h
//  lemon
//
//  Created by allen on 2018/5/27.
//

#ifndef LCCommand_h
#define LCCommand_h

typedef NS_OPTIONS(NSInteger, LCCommand)
{
    kCommandUNKNOWN          = 0, // 无效命令
    
    kCommandRegisterReq         = 1,
    kCommandRegisterResp        = 2,
    
    kCommandBindUserReq                = 3,
    kCommandBindUserResp               = 4,
    
    kCommandPingReq                    = 5,
    kCommandPingResp                   = 6,
    
    kCommandHttpDeliverReq             = 7,
    kCommandHttpDeliverResp            = 8,
    
    kCommandNotify                     = 9,
    kCommandNotifyAck                  = 10,
    
    kCommandMax,
};


#endif /* LCCommand_h */
