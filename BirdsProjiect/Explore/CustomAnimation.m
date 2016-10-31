//
//  CustomAnimation.m
//  BirdsProject
//
//  Created by yanm1 on 16/10/14.
//
//

#import "CustomAnimation.h"

@implementation CustomAnimation
- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.coordinate = CLLocationCoordinate2DMake([dict[@"latitude"] doubleValue], [dict[@"longitude"] doubleValue]);
        self.imageCode = [dict[@"top_estimation_code"] integerValue];
        self.title = dict[@"location"];
        
        _dict = dict;
    }
    return self;
}
@end
