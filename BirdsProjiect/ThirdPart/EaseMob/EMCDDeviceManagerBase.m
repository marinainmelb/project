/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <UIKit/UIKit.h>
#import "EMCDDeviceManagerBase.h"

static EMCDDeviceManager *emCDDeviceManager;
@interface EMCDDeviceManager (){

}

@end

@implementation EMCDDeviceManager
+(EMCDDeviceManager *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emCDDeviceManager = [[EMCDDeviceManager alloc] init];
    });
    
    return emCDDeviceManager;
}


@end
