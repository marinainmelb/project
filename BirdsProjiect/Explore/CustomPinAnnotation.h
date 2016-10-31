//
//  CustomPinAnnotation.h
//  BirdsProject
//
//  Created by yanm1 on 16/10/14.
//
//

#import <MapKit/MapKit.h>

@interface CustomPinAnnotation : MKAnnotationView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger imageCode;
@property (nonatomic, copy) NSDictionary *dict;
@end
