//
//  TrackCourtVC.h
//  FHZL
//
//  Created by hk on 2018/5/28.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "RootViewController.h"

@interface TrackCourtVC : RootViewController
@property(nonatomic ,strong)NSArray * trackCourtArray;
@property (nonatomic,copy)void(^cellClick)(NSArray *railArray);
@end
