//
//  HTTPMethod.m
//  TalkBar
//
//  Created by aaa on 13-8-31.
//  Copyright (c) 2013年 pengxin. All rights reserved.
//

#import "HTTPMethod.h"
#import "HTTPRequest.h"
#import "AFNetworking.h"

#import "MBProgressHUD+Add.h"

@implementation HTTPMethod

+ (void)requestURL:(NSString *)urlStr
         parameters:(NSDictionary *)parametersDic
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure
{
//    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [ serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    
    
    [manager POST:urlStr parameters:parametersDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}
+ (void)GETRequestURL:(NSString *)urlStr
                  success:(void(^)(id reponse))success
                  failure:(void(^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer = [ serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (NSString *)jsonStringFromJsonObject:(id)jsonObject;
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
//+ (NSString *)replaceUnicode:(NSString *)unicodeStr
//{
//    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
//    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
//    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
//    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
//                                                           mutabilityOption:NSPropertyListImmutable
//                                                                     format:NULL
//                                                           errorDescription:NULL];
//    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
//}

//+ (void)NET_request:(NSUInteger)HTTP_method
//             urlStr:(NSString *)urlStr
//  ServiceParameters:(NSMutableDictionary *)parametersDic
//            success:(void(^)(NSString *reponse))success
//            failure:(void(^)(NSError *error))failure
//{
//    //旧的
////    int64_t ID = arc4random();
////    NSString *keystr = [NSString stringWithFormat:@"%llu",ID];
////    NSString *method = dicforkey(parametersDic, @"Method");
////    NSString *keyDesStr=[Utility encryptStr:method andKey:keystr];
////    setDickeyobj(parametersDic, keystr, @"UID");
////    setDickeyobj(parametersDic, keyDesStr, @"Key");
////    NSError *error = nil;
////    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:parametersDic options:0 error:&error];
////    NSString *tempJsonstr = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
////    NSString *jsonstr=[tempJsonstr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//    
//    //新的
//    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
////    
////    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
////    [request setTimeoutInterval:5];
//////    NSString *methodstr = dicforkey(parametersDic, @"Method");
//////    NSLog(@"%@;Method==%@;入参:%@",urlStr,methodstr,jsonstr);
////    
////    [request setHTTPMethod:@"POST"];
////    //请求头的设置
////    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
////    [request setHTTPBody:[jsonstr dataUsingEncoding:NSUTF8StringEncoding]];
////    [request setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
////    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer.timeoutInterval = 10;
//    
//    [manager POST:urlStr parameters:jsonString progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
//    
////    operation.responseSerializer = [AFJSONResponseSerializer serializer];
////    
////    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
////        
////         NSLog(@"%@;Method==%@;返回值:%@",urlStr,methodstr,responseObject);
////        
////        success(operation.responseString);
////        
////    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        
////        NSLog(@"Error: %@", error);
////        failure(error);
////        Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
////        switch ([r currentReachabilityStatus]) {
////            case NotReachable:
////                // 没有网络连接
////            {
//////                [SVProgressHUD showImage:nil status:@"您的网络出问题了，请检查"];
////                [MBProgressHUD showError:@"您的网络出问题了，请检查" toView:nil];
////                //            return;
////            }
////                break;
////            case ReachableViaWWAN:
////                // 使用3G网络
////                break;
////            case ReachableViaWiFi:
////                // 使用WiFi网络
////                break;
////        }
////        
////    }];
////    [operation start];
//    
//}


@end
