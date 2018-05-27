//
//  LCLbUtil.m
//  lemon
//
//  Created by 吴文卿 on 2017/12/23.
//

#import "LCLbUtil.h"
#import "../exception/LCBaseException.h"

@interface LCLbUtil()

@property (nonatomic, retain) NSMutableArray* addressArray;

@end

@implementation LCLbUtil

+ (instancetype)sharedInstance {
    
    static LCLbUtil *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
    
}

- (id) init {
    self = [super init];
    self.addressArray = [[NSMutableArray alloc] init];
    return self;
}

// 获取getNodeAddress
- (LCNodeAddress *)getNodeAddress:(NSString *)urlstr appId:(NSString *)appId {
    
    NSString* uri = [NSString stringWithFormat:@"%@?appKey=%@", urlstr, appId];
    NSURL *url = [NSURL URLWithString:uri];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response = [[NSURLResponse alloc]init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if ( response == nil || str == nil ) {
        NSLog(@"appId: %@, str: %@", appId, str);
        @throw [[LCBaseException alloc] initWithName:@"参数问题" reason:@"lb返回参数异常" userInfo:nil];
    }

    // 解析json
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData                                                        options:NSJSONReadingMutableContainers error:&err];
    if ( err != nil ) {
        @throw [[LCBaseException alloc]
                initWithName:@"参数问题"
                reason: [NSString stringWithFormat:@"lb返回参数异常.err: %@. jsonData: %@", err, jsonData]
                userInfo:nil];
        return nil;
    }

    NSString *status = [dic objectForKey:@"status"];
    if ( ![status isEqualToString:@"ok"] ) {
        NSLog(@"response status is not ok. dic: %@", dic);
        return nil;
    }
    
    LCNodeAddress* address = [[LCNodeAddress alloc] init];
    address.ipv4 = [dic objectForKey:@"ipv4"];
    address.ipv6 = [dic objectForKey:@"ipv6"];
    address.port = [[dic objectForKey:@"port"] integerValue];
    return address;
}

@end
