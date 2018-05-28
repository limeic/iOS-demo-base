//
//  ViewController.m
//  LemonDemo
//
//  Created by 吴文卿 on 2017/12/25.
//  Copyright © 2017年 吴文卿. All rights reserved.
//

#import "ViewController.h"
#import <lemon/LCLemonService.h>
#import <lemon/LCPingRequest.h>
#import <lemon/LCPingResponse.h>
#import <lemon/LCBindUserRequest.h>
#import <lemon/LCBinduserResponse.h>
#import <lemon/LCHttpDeliverRequest.h>
#import <lemon/LCHttpDeliverResponse.h>

@interface ViewController ()

@property (nonatomic, retain) LCLemonService* service;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString* url = @"http://test.api.limeic.com/api/connectors/allocation";
    //NSString* url = @"http:///192.168.2.207/api/connectors/allocation";
    NSString* appId = @"307acc4411343315889eefe56e277f6e";
    
    // 初始化service
    _service = [LCLemonService sharedInstance];
    
    // 测试service
    [_service changeUrl:url];
    
    [_service initWithAppId:appId onRegistry:^{
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
    
    NSString* userId = @"123456789";
    
    LCBaseEventHandler* handler = [[LCBaseEventHandler alloc] initWithCallback:^LCLemonBasePackage * _Nullable(LCLemonBasePackage * _Nullable package) {
        if ( package == nil ) {
            NSLog(@"bind user resp error");
            return nil;
        }
        NSError* err = nil;
        LCBinduserResponse* response = [[LCBinduserResponse alloc] initWithData:package.body error:&err];
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
        LCPingResponse* response = [[LCPingResponse alloc] initWithData: package.body error: &err];
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
        LCHttpDeliverResponse* response = [[LCHttpDeliverResponse alloc] initWithData:package.body error:&err];
        if ( err != nil ) {
            NSLog(@"receive http get resp failed. err: %@", err);
            return nil;
        }
        NSLog(@"http get resp: %@", response);
        return nil;
    }];
    
    NSString* url = @"http://demo.http.lemoncloud.tech/ping?data=helloworld";
    [[LCLemonService sharedInstance] send:url data:nil method:@"GET" headers:NULL handler:handler];
    
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
        LCHttpDeliverResponse* response = [[LCHttpDeliverResponse alloc] initWithData:package.body error:&err];
        if ( err != nil ) {
            NSLog(@"receive http post resp failed. err: %@", err);
            return nil;
        }
        NSLog(@"http post resp: %@", response);
        return nil;
    }];
    
    NSString* url = @"http://demo.http.lemoncloud.tech/ping";
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers setObject:@"application/json;charset=UTF-8" forKey:@"Content-Type"];
    [[LCLemonService sharedInstance] send:url data:@"{\"hello\":\"world\", \"age\":10}" method:@"POST" headers:headers handler:handler];
}

@end
