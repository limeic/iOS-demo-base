// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: Lemon.Gateway.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30001
#error This file was generated by a different version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class LemonHttpHeader;
GPB_ENUM_FWD_DECLARE(HttpMethod);
GPB_ENUM_FWD_DECLARE(LemonServerErrorCode);

NS_ASSUME_NONNULL_BEGIN

#pragma mark - LemonGatewayRoot

/// Exposes the extension registry for this file.
///
/// The base class provides:
/// @code
///   + (GPBExtensionRegistry *)extensionRegistry;
/// @endcode
/// which is a @c GPBExtensionRegistry that includes all the extensions defined by
/// this file and all files that it depends on.
@interface LemonGatewayRoot : GPBRootObject
@end

#pragma mark - LemonPduRegistryReq

typedef GPB_ENUM(LemonPduRegistryReq_FieldNumber) {
  LemonPduRegistryReq_FieldNumber_AppId = 1,
};

///*
/// 客户端注册AppId 请求
/// MID: LEMON_MID_GATEWAY
/// CID: LEMON_CID_GATEWAY_REGISTRY_REQ
@interface LemonPduRegistryReq : GPBMessage

/// appId
@property(nonatomic, readwrite, copy, null_resettable) NSString *appId;

@end

#pragma mark - LemonPduRegistryResp

typedef GPB_ENUM(LemonPduRegistryResp_FieldNumber) {
  LemonPduRegistryResp_FieldNumber_Result = 1,
};

///*
/// 客户端注册AppId 响应
/// MID: LEMON_MID_GATEWAY
/// CID: LEMON_CID_GATEWAY_REGISTRY_RESP
@interface LemonPduRegistryResp : GPBMessage

/// 结果码
@property(nonatomic, readwrite) enum LemonServerErrorCode result;

@end

/// Fetches the raw value of a @c LemonPduRegistryResp's @c result property, even
/// if the value was not defined by the enum at the time the code was generated.
int32_t LemonPduRegistryResp_Result_RawValue(LemonPduRegistryResp *message);
/// Sets the raw value of an @c LemonPduRegistryResp's @c result property, allowing
/// it to be set to a value that was not defined by the enum at the time the code
/// was generated.
void SetLemonPduRegistryResp_Result_RawValue(LemonPduRegistryResp *message, int32_t value);

#pragma mark - LemonPduBindUserReq

typedef GPB_ENUM(LemonPduBindUserReq_FieldNumber) {
  LemonPduBindUserReq_FieldNumber_UserId = 1,
};

///*
/// 客户端绑定用户ID 响应
/// MID: LEMON_MID_GATEWAY
/// CID: LEMON_CID_GATEWAY_BIND_USER_REQ
@interface LemonPduBindUserReq : GPBMessage

/// 用户ID
@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

@end

#pragma mark - LemonPduBindUserResp

typedef GPB_ENUM(LemonPduBindUserResp_FieldNumber) {
  LemonPduBindUserResp_FieldNumber_Result = 1,
};

///*
/// 客户端绑定用户ID 响应
/// MID: LEMON_MID_GATEWAY
/// CID: LEMON_CID_GATEWAY_BIND_USER_RESP
@interface LemonPduBindUserResp : GPBMessage

/// 结果码
@property(nonatomic, readwrite) enum LemonServerErrorCode result;

@end

/// Fetches the raw value of a @c LemonPduBindUserResp's @c result property, even
/// if the value was not defined by the enum at the time the code was generated.
int32_t LemonPduBindUserResp_Result_RawValue(LemonPduBindUserResp *message);
/// Sets the raw value of an @c LemonPduBindUserResp's @c result property, allowing
/// it to be set to a value that was not defined by the enum at the time the code
/// was generated.
void SetLemonPduBindUserResp_Result_RawValue(LemonPduBindUserResp *message, int32_t value);

#pragma mark - LemonPduTransitHttpMsgReq

typedef GPB_ENUM(LemonPduTransitHttpMsgReq_FieldNumber) {
  LemonPduTransitHttpMsgReq_FieldNumber_URL = 1,
  LemonPduTransitHttpMsgReq_FieldNumber_Method = 2,
  LemonPduTransitHttpMsgReq_FieldNumber_Data_p = 3,
  LemonPduTransitHttpMsgReq_FieldNumber_HeadersArray = 4,
};

///*
/// 转发请求 transit http msg
/// MID: LEMON_MID_GATEWAY
/// CID: LEMON_CID_GATEWAY_TRANSIT_HTTP_MSG_REQ
@interface LemonPduTransitHttpMsgReq : GPBMessage

/// 请求的url地址
@property(nonatomic, readwrite, copy, null_resettable) NSString *URL;

/// 请求的方法
@property(nonatomic, readwrite) enum HttpMethod method;

/// json数据（若是GET，则可以带在url中）
@property(nonatomic, readwrite, copy, null_resettable) NSString *data_p;

/// 需要添加的http头信息
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<LemonHttpHeader*> *headersArray;
/// The number of items in @c headersArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger headersArray_Count;

@end

/// Fetches the raw value of a @c LemonPduTransitHttpMsgReq's @c method property, even
/// if the value was not defined by the enum at the time the code was generated.
int32_t LemonPduTransitHttpMsgReq_Method_RawValue(LemonPduTransitHttpMsgReq *message);
/// Sets the raw value of an @c LemonPduTransitHttpMsgReq's @c method property, allowing
/// it to be set to a value that was not defined by the enum at the time the code
/// was generated.
void SetLemonPduTransitHttpMsgReq_Method_RawValue(LemonPduTransitHttpMsgReq *message, int32_t value);

#pragma mark - LemonPduTransitHttpMsgResp

typedef GPB_ENUM(LemonPduTransitHttpMsgResp_FieldNumber) {
  LemonPduTransitHttpMsgResp_FieldNumber_Result = 1,
  LemonPduTransitHttpMsgResp_FieldNumber_Data_p = 2,
};

///*
/// 返回 transit http msg的返回数据
/// MID: LEMON_MID_GATEWAY
/// CID: LEMON_CID_GATEWAY_TRANSIT_HTTP_MSG_RESP
@interface LemonPduTransitHttpMsgResp : GPBMessage

/// 结果码
@property(nonatomic, readwrite) enum LemonServerErrorCode result;

/// 返回的数据
@property(nonatomic, readwrite, copy, null_resettable) NSString *data_p;

@end

/// Fetches the raw value of a @c LemonPduTransitHttpMsgResp's @c result property, even
/// if the value was not defined by the enum at the time the code was generated.
int32_t LemonPduTransitHttpMsgResp_Result_RawValue(LemonPduTransitHttpMsgResp *message);
/// Sets the raw value of an @c LemonPduTransitHttpMsgResp's @c result property, allowing
/// it to be set to a value that was not defined by the enum at the time the code
/// was generated.
void SetLemonPduTransitHttpMsgResp_Result_RawValue(LemonPduTransitHttpMsgResp *message, int32_t value);

#pragma mark - LemonPduPingReq

typedef GPB_ENUM(LemonPduPingReq_FieldNumber) {
  LemonPduPingReq_FieldNumber_Data_p = 1,
};

///*
/// Gateway Ping测试
/// MID: LEMON_MID_GATEWAY
/// CID: LEMON_CID_GATEWAY_PING_REQ
@interface LemonPduPingReq : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *data_p;

@end

#pragma mark - LemonPduPingResp

typedef GPB_ENUM(LemonPduPingResp_FieldNumber) {
  LemonPduPingResp_FieldNumber_Result = 1,
  LemonPduPingResp_FieldNumber_Data_p = 2,
};

///*
/// Gateway Ping测试
/// MID: LEMON_MID_GATEWAY
/// CID: LEMON_CID_GATEWAY_PING_RESP
@interface LemonPduPingResp : GPBMessage

/// 结果码 
@property(nonatomic, readwrite) enum LemonServerErrorCode result;

/// 返回的数据
@property(nonatomic, readwrite, copy, null_resettable) NSString *data_p;

@end

/// Fetches the raw value of a @c LemonPduPingResp's @c result property, even
/// if the value was not defined by the enum at the time the code was generated.
int32_t LemonPduPingResp_Result_RawValue(LemonPduPingResp *message);
/// Sets the raw value of an @c LemonPduPingResp's @c result property, allowing
/// it to be set to a value that was not defined by the enum at the time the code
/// was generated.
void SetLemonPduPingResp_Result_RawValue(LemonPduPingResp *message, int32_t value);

#pragma mark - LemonPduMsgNotify

typedef GPB_ENUM(LemonPduMsgNotify_FieldNumber) {
  LemonPduMsgNotify_FieldNumber_Data_p = 1,
};

///*
/// Gateway 广播数据
/// MID: LEMON_MID_GATEWAY
/// CID: LEMON_CID_GATEWAY_MSG_NOTIFY
@interface LemonPduMsgNotify : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *data_p;

@end

#pragma mark - LemonPduMsgNotifyAck

typedef GPB_ENUM(LemonPduMsgNotifyAck_FieldNumber) {
  LemonPduMsgNotifyAck_FieldNumber_Result = 1,
};

///*
/// Gateway 广播数据
/// MID: LEMON_MID_GATEWAY
/// CID: LEMON_CID_GATEWAY_MSG_NOTIFY_ACK
@interface LemonPduMsgNotifyAck : GPBMessage

/// 结果码
@property(nonatomic, readwrite) enum LemonServerErrorCode result;

@end

/// Fetches the raw value of a @c LemonPduMsgNotifyAck's @c result property, even
/// if the value was not defined by the enum at the time the code was generated.
int32_t LemonPduMsgNotifyAck_Result_RawValue(LemonPduMsgNotifyAck *message);
/// Sets the raw value of an @c LemonPduMsgNotifyAck's @c result property, allowing
/// it to be set to a value that was not defined by the enum at the time the code
/// was generated.
void SetLemonPduMsgNotifyAck_Result_RawValue(LemonPduMsgNotifyAck *message, int32_t value);

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
