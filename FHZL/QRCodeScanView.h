//
//  QRCodeScanView.h
//  01-QRCodeScan
//
//  Created by vera on 16/8/6.
//  Copyright © 2016年 deli. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  扫描成功的回调
 *
 *  @param value <#value description#>
 */
typedef void(^QRCodeScanDidFinishCallback)(NSString *value);

@interface QRCodeScanView : UIView

- (void)setQRCodeScanDidFinishCallback:(QRCodeScanDidFinishCallback)callback;

/**
 *  开始扫描
 */
- (void)startScan;

@end
