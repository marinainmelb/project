//
//  BirdsMapViewController.m
//  BirdsProject
//
//  Created by yanm1 on 16/10/12.
//
//

#import "BirdsMapViewController.h"
#import <MapKit/MapKit.h>
#import "CustomPinAnnotation.h"
#import "CustomAnimation.h"
#import "BirdsDetailView.h"

@interface BirdsMapViewController()<MKMapViewDelegate>
@property (nonatomic, strong) BirdsDetailView *birdView;
@end

@implementation BirdsMapViewController
{
    MKMapView *_mapView;
    CLLocationManager *_locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight - 64 - 49)];
    [self.view addSubview:_mapView];
    
    _mapView.delegate = self;
    
    
    _locationManager = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.mapType = MKMapTypeStandard;
    
    [self downloadData];
}

- (void)downloadData
{
    NSString *url = [NSString stringWithFormat:@"%@?view=all", RootURL];
    [SVProgressHUD show];
    [HTTPMethod GETRequestURL:url success:^(id reponse) {
        NSLog(@"%@", reponse);
        [SVProgressHUD dismiss];
        
        NSMutableArray *tempArr= [[NSMutableArray alloc] init];
        if ([reponse isKindOfClass:[NSDictionary class]]) {
            if ([reponse[@"record_list"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in reponse[@"record_list"]) {
                    if ([dic[@"latitude"] isKindOfClass:[NSNull class]] || [dic[@"longitude"] isKindOfClass:[NSNull class]]) {
                        continue;
                    }
                    
                    CustomAnimation *animation = [[CustomAnimation alloc] initWithAnnotationModelWithDict:dic];
                    
                    [tempArr addObject:animation];
                }
                
                [_mapView addAnnotations:tempArr];
            }
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
    }];
};
- (BirdsDetailView *)birdView
{
    if (!_birdView) {
        _birdView = [[BirdsDetailView alloc] init];
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        [window addSubview:_birdView];
    }
    return _birdView;
}

#pragma mark - annotation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *IDString = @"annoView";
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] init];
        
        return annotationView;
    }
    
    CustomPinAnnotation *annotationView = (CustomPinAnnotation *)[mapView dequeueReusableAnnotationViewWithIdentifier:IDString];
    if (!annotationView) {
        annotationView = [[CustomPinAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:IDString];

    }
    CustomAnimation *customAnnotation = (CustomAnimation *)annotation;
    annotationView.imageCode = customAnnotation.imageCode;
    annotationView.title = customAnnotation.title;
    annotationView.dict = customAnnotation.dict;
    return annotationView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    CustomPinAnnotation *annotationView = (CustomPinAnnotation *)view;
    self.birdView.hidden = NO;
    self.birdView.dict = annotationView.dict;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}
- (void)dealloc
{
    [_birdView removeFromSuperview];
    _birdView = nil;
}
@end
