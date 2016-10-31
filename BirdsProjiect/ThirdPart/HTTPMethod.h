//
//  HTTPMethod.h
//  TalkBar
//
//  Created by aaa on 13-8-31.
//  Copyright (c) 2013年 pengxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HTTPMethod : NSObject


//+ (NSString *)replaceUnicode:(NSString *)unicodeStr;
//
//+ (void)NET_request:(NSUInteger)HTTP_method
//                urlStr:(NSString *)urlStr
//             ServiceParameters:(NSMutableDictionary *)parametersDic
//                          success:(void(^)(NSString *reponse))success
//                          failure:(void(^)(NSError *error))failure;
+ (void)requestURL:(NSString *)urlStr
         parameters:(NSDictionary *)parametersDic
            success:(void(^)(id reponse))success
            failure:(void(^)(NSError *error))failure;

+ (void)GETRequestURL:(NSString *)urlStr
               success:(void(^)(id reponse))success
               failure:(void(^)(NSError *error))failure;


@end
