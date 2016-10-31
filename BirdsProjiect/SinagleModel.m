//
//  SinagleModel.m
//  BirdsProject
//
//  Created by yanm1 on 16/10/15.
//
//

#import "SinagleModel.h"

@implementation SinagleModel

+ (instancetype)shareInstance
{
    static SinagleModel *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[SinagleModel alloc] init];
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [df objectForKey:@"Info"];
        if (dic) {
            model.dict = dic;
        }
    });
    return model;
}
+ (NSDictionary *)sharedUserData
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"atany.archiver"];
    NSDictionary *dict =[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return dict;
}
+ (void)storeUserWithDict:(NSDictionary *)dict
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"atany.archiver"];
    BOOL success=[NSKeyedArchiver archiveRootObject:dict toFile:path];
    //    NSLog(@"%@\n:::%@", documentPath,path);
    if (success) {
        //        NSLog(@"个人信息成功存储到本地");
    }else{
        NSLog(@"个人信息存储到本地失败");
    }
}

@end
