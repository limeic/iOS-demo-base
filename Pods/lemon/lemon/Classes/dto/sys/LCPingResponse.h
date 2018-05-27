//
//  LCPingResponse.h
//  lemon
//
//  Created by allen on 2018/5/27.
//

#import <Foundation/Foundation.h>
#import <lemon/LCOkResponse.h>

@interface LCPingResponse : LCOkResponse

@property (nonatomic, assign) NSString* content;

@end
