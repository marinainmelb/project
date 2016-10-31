//
//  SinagleModel.h
//  BirdsProject
//
//  Created by yanm1 on 16/10/15.
//
//

#import <Foundation/Foundation.h>

@interface SinagleModel : NSObject
@property (nonatomic, copy) NSDictionary *dict;
+ (void)storeUserWithDict:(NSDictionary *)dict;
+ (instancetype)shareInstance;
@end
