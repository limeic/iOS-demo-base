//
//  ViewController.m
//  LemonDemo
//
//  Created by 吴文卿 on 2017/12/25.
//  Copyright © 2017年 吴文卿. All rights reserved.
//

#import "ViewController.h"
#import <lemon/LCLemonService.h>
#import <lemon/LemonCommandTypes.pbobjc.h>
#import <lemon/LemonGateway.pbobjc.h>

@interface ViewController ()

@property (nonatomic, retain) LCLemonService* service;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString* url = @"http://lb.lemoncloud.tech/route";
    //NSString* url = @"http://192.168.199.136:3101/route";
    NSString* appId = @"54927e37f4a053b8c6de537ab7cdd479";
    
    // 初始化service
    _service = [LCLemonService sharedInstance];
    [_service initWithUrl:url appId:appId onRegistry:^{
        NSLog(@"registry!!");
    } onClosed:^{
        NSLog(@"service closed!!");
    } onStopped:^{
        NSLog(@"service stopped!!");
    }];
    
    // 注册handler
    [_service onNotify:^(NSString *data) {
        NSLog(@"received broadcast data: %@", data);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnStart:(id)sender {
    // 启动服务
    NSLog(@"start lemon service");
    [_service start];
}


- (IBAction)onBtnStop:(id)sender {
    // 停止服务
    NSLog(@"stop lemon service");
    [_service stop];
}

- (IBAction)onBtnBindUser:(id)sender {
    
    NSString* userId = @"123456";
    
    LCBaseEventHandler* handler = [[LCBaseEventHandler alloc] initWithCallback:^LCLemonBasePackage * _Nullable(LCLemonBasePackage * _Nullable package) {
        if ( package == nil ) {
            NSLog(@"bind user resp error");
            return nil;
        }
        NSError* err = nil;
        LemonPduBindUserResp* response = [LemonPduBindUserResp parseFromData:package.body error:&err];
        if ( err != nil ) {
            NSLog(@"bind userId failed for userId: %@, err; %@", userId, err);
            return nil;
        }
        NSLog(@"bind userId resp: %@", response);
        return nil;
    }];
    
    [[LCLemonService sharedInstance] bindUserId:userId handler:handler];
}


- (IBAction)onBtnTestPing:(id)sender {
    LCBaseEventHandler* handler = [[LCBaseEventHandler alloc] initWithCallback:^LCLemonBasePackage * _Nullable(LCLemonBasePackage * _Nullable package) {
        if ( package == nil ) {
            NSLog(@"ping resp error");
            return nil;
        }
        NSError* err = nil;
        LemonPduPingResp* response = [LemonPduPingResp parseFromData:package.body error:&err];
        if ( err != nil ) {
            NSLog(@"ping resp err; %@", err);
            return nil;
        }
        NSLog(@"ping resp: %@", response);
        return nil;
    }];
    
    [[LCLemonService sharedInstance] ping:handler];
}

- (IBAction)onBtnSendHttpGet:(id)sender {
    
    LCBaseEventHandler* handler = [[LCBaseEventHandler alloc] initWithCallback:^LCLemonBasePackage * _Nullable(LCLemonBasePackage * _Nullable package) {
        NSLog(@"received http get resp");
        
        if ( package == nil ) {
            return nil;
        }
        if ( package.body == nil ) {
            return nil;
        }
        
        NSError* err = nil;
        LemonPduTransitHttpMsgResp* resp = [LemonPduTransitHttpMsgResp parseFromData:package.body error:&err];
        if ( err != nil ) {
            NSLog(@"receive http get resp failed. err: %@", err);
            return nil;
        }
        NSLog(@"http get resp: %@", resp);
        return nil;
    }];
    
    NSString* url = @"http://demo.http.lemoncloud.tech/ping?data=helloworld";
    [[LCLemonService sharedInstance] send:url data:nil method:HttpMethod_HTTPMethodGet headers:NULL handler:handler];
}

- (IBAction)onBtnSendHttpPost:(id)sender {
    
    LCBaseEventHandler* handler = [[LCBaseEventHandler alloc] initWithCallback:^LCLemonBasePackage * _Nullable(LCLemonBasePackage * _Nullable package) {
        NSLog(@"received http post resp");
        
        if ( package == nil ) {
            return nil;
        }
        if ( package.body == nil ) {
            return nil;
        }
        
        NSError* err = nil;
        LemonPduTransitHttpMsgResp* resp = [LemonPduTransitHttpMsgResp parseFromData:package.body error:&err];
        if ( err != nil ) {
            NSLog(@"receive http post resp failed. err: %@", err);
            return nil;
        }
        NSLog(@"http post resp: %@", resp);
        return nil;
    }];
    
    NSString* url = @"http://demo.http.lemoncloud.tech/ping";
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers setObject:@"application/json;charset=UTF-8" forKey:@"Content-Type"];
    [[LCLemonService sharedInstance] send:url data:@"{\"hello\":\"world\", \"age\":10}" method:HttpMethod_HTTPMethodPost headers:headers handler:handler];
}

@end
