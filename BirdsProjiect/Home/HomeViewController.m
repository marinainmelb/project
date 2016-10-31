//
//  HomeViewController.m
//  BirdsProject
//
//  Created by yanm1 on 16/10/12.
//
//

#import "HomeViewController.h"
#import "UIButton+BackgroundColor.h"
#import <AVFoundation/AVFoundation.h>
#import "EMCDDeviceManager+Media.h"

#import <CoreLocation/CoreLocation.h>
#import "ProgressView.h"

static CGFloat buttonHeight = 200;
@interface HomeViewController() <CLLocationManagerDelegate>
@property (nonatomic, strong) ProgressView *progressView;
@end

@implementation HomeViewController
{
    UILabel *_tipsLabel;
    UIButton *_button;
    
    CLLocationManager *_locationManager; //定位
    CLLocationCoordinate2D _locationCoordinate;
    NSString *_address;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = MainColor;
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_button setTitle:@"hold down to talk" forState:UIControlStateNormal];
//    [_button setTitle:@"loosen to send" forState:UIControlStateHighlighted];
    
    _button.frame = CGRectMake(kkDeviceWidth/2 - buttonHeight/2, (kkDeviceHeight - 49)/2 - buttonHeight/2, buttonHeight, buttonHeight);
    _button.layer.cornerRadius = buttonHeight/2;
//    _button.layer.borderWidth = 1;
//    _button.layer.borderColor = [UIColor blackColor].CGColor;
    _button.layer.masksToBounds = YES;
    _button.titleLabel.numberOfLines = 0;
    _button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button setBackgroundColor:toPCcolor(@"eeeeee") forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"bird.png"] forState:UIControlStateNormal];
    _button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_button];
    
    
    [_button addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [_button addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _button.mj_y - 40, kkDeviceWidth - 40, 30)];
//    _tipsLabel.hidden = NO;
    _tipsLabel.text = @"Tap to Birzam";
    _tipsLabel.textColor = [UIColor blackColor];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.numberOfLines = 0;
    [self.view addSubview:_tipsLabel];
    
    [self locationAddress];
}
- (ProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[ProgressView alloc] init];
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        [window addSubview:_progressView];
    }
    
    return _progressView;
}

- (void)recordButtonTouchDown
{
    _tipsLabel.text = @"Loosen to send";
    _tipsLabel.textColor = [UIColor redColor];
    
    if (![self canRecord]) {
        UIAlertController *al = [[UIAlertController alloc] init];
        al.title = @"Tips";
//        al.message = @"BirdsApp ...";
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [al addAction:action];
        [self presentViewController:al animated:YES completion:nil];
        return;
    }
    
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error)
     {
         if (error) {
             NSLog(@"%@",@"failure to start recording");
         }
     }];
}
- (void)recordButtonTouchUpInside
{
    _tipsLabel.text = @"Tap to Birzam";
    _tipsLabel.textColor = [UIColor blackColor];
    
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            UIAlertController *al = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Are you sure to send the audio?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf sendVoiceMessageWithLocalPath:recordPath duration:aDuration];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [al addAction:action];
            [al addAction:action2];
            
            [self presentViewController:al animated:YES completion:nil];
            
        }
        else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}
- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if (![df boolForKey:@"Login"]) {
        [SVProgressHUD showErrorWithStatus:@"Please login first"];
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *date = [dateStr componentsSeparatedByString:@" "][0];
    NSString *time = [dateStr componentsSeparatedByString:@" "][1];
    
    NSString *url = [NSString stringWithFormat:@"%@upload_audio", RootURL];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@"" forKey:@"user_comment"];
    [parameters setValue:date forKey:@"date"];
    [parameters setValue:[df valueForKey:@"email"] forKey:@"submitted_by"];
    [parameters setValue:[NSString stringWithFormat:@"%@", @(_locationCoordinate.longitude)] forKey:@"longitude"];
    [parameters setValue:[NSString stringWithFormat:@"%@", @(_locationCoordinate.latitude)] forKey:@"latitude"];
    [parameters setValue:time forKey:@"time"];
    [parameters setValue:@"iOS" forKey:@"client"];
    [parameters setValue:_address.length == 0 ? @"2+La+Trobe+Street+Melbourne+VIC+3004" : _address forKey:@"location"];
    [parameters setValue:@"0" forKey:@"evaluation"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *fileName = [NSString stringWithFormat:@"%@.amr",[self stringWithUUID]];
        NSData *data = [NSData dataWithContentsOfFile:localPath];
        
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"amr"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"progress = %f", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        dispatch_async(dispatch_get_main_queue(), ^{
           self.progressView.progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.progressView.hidden = YES;
        
        NSLog(@"%@",data);
        NSLog(@"%@", str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.progressView.hidden = YES;
        [SVProgressHUD showErrorWithStatus:@"Upload failed"];
        NSLog(@"%@", error);
    
    }];
    
}
- (NSString *)stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}
- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}
#pragma mark - location
- (void)locationAddress
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _locationManager.distanceFilter = 50; // in meters
    _locationManager.delegate = self;
    
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
//    if([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0){
//        [_locationManager requestWhenInUseAuthorization];
//    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *newLocation=locations[0];
    _locationCoordinate=newLocation.coordinate;
    
    NSLog(@"%f,%f",_locationCoordinate.longitude,_locationCoordinate.latitude);
    
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for(CLPlacemark *place in placemarks){
            NSLog(@"%@", place.subLocality);
            NSString *state = place.administrativeArea.length != 0 ? place.administrativeArea: @"";
            
            NSString *city = place.locality.length != 0 ? place.locality: @"";
            NSString *street = place.subLocality.length != 0 ? place.subLocality: @"";
            
            _address = [NSString stringWithFormat:@"%@%@%@", state, city, street];
        }
        
        [_locationManager stopUpdatingLocation];
    }];

}
- (void)getAddress
{
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"Location failure"];
    NSLog(@"%@", error);
}
- (void)jiangzao
{
    
}
@end
