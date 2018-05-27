//
//  LCRegistryRequest.h
//  lemon
//
//  Created by allen on 2018/5/27.
//

#import <Foundation/Foundation.h>
#import <lemon/LCModule.h>
#import <lemon/LCCommand.h>
#import <JSONModel/JSONModel.h>

@interface LCRegistryRequest : JSONModel

@property (nonatomic, assign) NSString * _Nonnull appKey;
@property (nonatomic, assign) NSInteger moduleId;

@end
