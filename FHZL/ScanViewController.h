//
//  ScanViewController.h
//  01-QRCodeScan
//
//  Created by vera on 16/8/6.
//  Copyright © 2016年 deli. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "RootViewController.h"
@protocol ScanDele <NSObject>

-(void)changeCode:(NSString*)str;

@end

@interface ScanViewController : RootViewController

@property(weak ,nonatomic)id<ScanDele>delegate;

@end
