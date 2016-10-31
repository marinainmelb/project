//
//  MyTabBarController.m
//  BirdsProject
//
//  Created by yanm1 on 16/10/12.
//
//

#import "MyTabBarController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
#import "BirdsMapViewController.h"

@implementation MyTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildViewController:@"HomeViewController" andTitle:@"Home" image:@"tabbar_01.png"];
        [self addChildViewController:@"MyViewController" andTitle:@"My Birzam" image:@"tabbar_02.png"];
        [self addChildViewController:@"BirdsMapViewController" andTitle:@"Explore" image:@"tabbar_03.png"];
    }
    return self;
}
- (void)addChildViewController:(NSString *)className andTitle:(NSString *)title image:(NSString *)imageName
{
    Class class = NSClassFromString(className);
    UIViewController *vc = [[class alloc] init];
    
//    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.title = title;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nc];
}


@end
