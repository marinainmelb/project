//
//  NormalVariable.h
//  BirdsProject
//
//  Created by yanm1 on 16/10/12.
//
//

#ifndef NormalVariable_h
#define NormalVariable_h


#define kkDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kkDeviceHeight [UIScreen mainScreen].bounds.size.height
//#define MainColor [UIColor colorWithRed:27/255.0 green:68/255.0 blue:255/255.0 alpha:1]
#define MainColor [UIColor colorWithRed:180/255.0 green:200/255.0 blue:255/255.0 alpha:1]
#define ButtonColor [UIColor colorWithRed:80/255.0 green:100/255.0 blue:255/255.0 alpha:1]

#define RootURL @"http://115.146.90.254:5001/"

#define LoginNotification @"LoginNotification"
#define LogoutNotification @"LogoutNotification"

UIKIT_STATIC_INLINE UIColor *toPCcolor(NSString *pcColorstr)
{
    unsigned int c;
    
    if ([pcColorstr characterAtIndex:0] == '#') {
        
        [[NSScanner scannerWithString:[pcColorstr substringFromIndex:1]] scanHexInt:&c];
        
    } else {
        
        [[NSScanner scannerWithString:pcColorstr] scanHexInt:&c];
        
    }
    
    return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0 green:((c & 0xff00) >> 8)/255.0 blue:(c & 0xff)/255.0 alpha:1.0];
}
#endif /* NormalVariable_h */
