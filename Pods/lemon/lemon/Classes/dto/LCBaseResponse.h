//
//  LCBaseResponse.h
//  lemon
//
//  Created by allen on 2018/5/27.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface LCBaseResponse : JSONModel

@property (nonatomic, assign) NSString * _Nonnull status;
@property (nonatomic, assign) NSString<Optional>* message;

@end
