//
//  CustomAnimation.h
//  BirdsProject
//
//  Created by yanm1 on 16/10/14.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnimation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, assign) NSInteger imageCode;
@property (nonatomic, copy) NSDictionary *dict;
//@property (nonatomic, copy) NSString *icon;

- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict;
@end
