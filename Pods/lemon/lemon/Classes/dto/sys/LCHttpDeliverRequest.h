//
//  LCHttpDeliverRequest.h
//  lemon
//
//  Created by allen on 2018/5/27.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface LCHttpDeliverRequest : JSONModel

@property (nonatomic, assign) NSString* url;

@property (nonatomic, assign) NSString* method;

@property (nonatomic, copy) NSDictionary<Optional>* headers;

@property (nonatomic, copy) NSString<Optional>* data;

@end
