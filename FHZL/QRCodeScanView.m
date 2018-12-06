//
//  QRCodeScanView.m
//  01-QRCodeScan
//
//  Created by vera on 16/8/6.
//  Copyright © 2016年 deli. All rights reserved.
//

#define kInsertSpace 0

#import "QRCodeScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeScanView ()<AVCaptureMetadataOutputObjectsDelegate>
{
    QRCodeScanDidFinishCallback _codeScanDidFinishCallback;
    
    NSTimer *_timer;
    
    //是否向上
    BOOL _isUp;
    
    //线移动的最小值
    CGFloat min;
    
    //线移动的最大值
    CGFloat max;
}

//输入与输出设备的桥梁
@property (nonatomic, strong) AVCaptureSession *session;

//显示视频流的图层
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *videoLayer;

@property (nonatomic, strong) AVCaptureMetadataOutput *output;

/**
 *  二维码框
 */
@property (nonatomic, weak) UIImageView *remarkImageView;

/**
 *  扫描线
 */
@property (nonatomic, weak) UIImageView *lineImageView;

@end

@implementation QRCodeScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    //暂停定时器
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)update
{
    CGRect frame = self.lineImageView.frame;
    
    if (frame.origin.y <= min)
    {
        //向下移动
        _isUp = NO;
    }
    else if (frame.origin.y >= max)
    {
        //向上移动
        _isUp = YES;
    }
    
    //y坐标改变
    if (_isUp)
    {
        frame.origin.y--;
    }
    else
    {
        frame.origin.y++;
    }
    
    //重新设置frame
    self.lineImageView.frame = frame;
}

- (UIImageView *)lineImageView
{
    if (!_lineImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qr_scan_line"]];
        [self addSubview:imageView];
        _lineImageView = imageView;
    }
    
    return _lineImageView;
}

- (UIImageView *)remarkImageView
{
    if (!_remarkImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];//smk
        [self addSubview:imageView];
        _remarkImageView = imageView;
    }
    
    return _remarkImageView;
}

- (AVCaptureSession *)session
{
    if (!_session)
    {
        //1.创建一个摄像头对象(AVMediaTypeVideo：采集类型是视频)
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        //2.创建一个输入对象
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        
        //3.创建一个输出对象
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        self.output = output;
        
        //设置代理方法
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //4.创建输入设备和输出设备的桥梁
        _session = [[AVCaptureSession alloc] init];
        
        //5.添加输入设备和输出设备
        //(1).添加输入设备
        if ([_session canAddInput:input])
        {
            [_session addInput:input];
        }
        
        //(2).添加输出设备
        if ([_session canAddOutput:output])
        {
            [_session addOutput:output];
        }
        
        //6.设置扫描类型：必须写到addInput，addOutput之后
        /*
         AVMetadataObjectTypeQRCode -> 二维码
         
         AVMetadataObjectTypeEAN13Code,
         AVMetadataObjectTypeEAN8Code,
         AVMetadataObjectTypeCode128Code -> 条形码
         */
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
        
        //所有扫描类型
//        output.metadataObjectTypes = output.availableMetadataObjectTypes;
    }
    
    return _session;
}

- (AVCaptureVideoPreviewLayer *)videoLayer
{
    if (!_videoLayer)
    {
        AVCaptureVideoPreviewLayer *videoLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        [self.layer insertSublayer:videoLayer atIndex:0];
    
        _videoLayer = videoLayer;
    }
    
    return _videoLayer;
}

- (void)setQRCodeScanDidFinishCallback:(QRCodeScanDidFinishCallback)callback
{
    _codeScanDidFinishCallback = callback;
}

/**
 *  开始扫描
 */
- (void)startScan
{
    [self.session startRunning];
    
    //开启定时器
    [_timer setFireDate:[NSDate distantPast]];
}

#pragma mark --- AVCaptureMetadataOutputObjectsDelegate(已经扫描到结果时会自动触发)

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //已经扫描到了
    if (metadataObjects.count > 0)
    {
        //停止扫描
        [self.session stopRunning];
        
        //暂停定时器
        [_timer setFireDate:[NSDate distantFuture]];
        
        //保存二维码或者条形码的数据
        AVMetadataMachineReadableCodeObject *codeObject = [metadataObjects firstObject];
        NSString *value = codeObject.stringValue;
        
        if (_codeScanDidFinishCallback)
        {
            _codeScanDidFinishCallback(value);
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.videoLayer.frame = self.bounds;
//    self.videoLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    
    
    
    CGFloat width = 250;
    CGFloat height = 85;
    
    self.remarkImageView.frame = CGRectMake(self.frame.size.width / 2 - width / 2, self.frame.size.height / 2 - height / 2 - 70, width, height);
    
    self.lineImageView.frame = CGRectMake(CGRectGetMinX(self.remarkImageView.frame) + kInsertSpace, CGRectGetMinY(self.remarkImageView.frame) + kInsertSpace, CGRectGetWidth(self.remarkImageView.frame) - 2 * kInsertSpace, 1);
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.remarkImageView.frame.origin.x, self.frame.size.height)];
    backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:backView];
    
    UIView *backView2 = [[UIView alloc]initWithFrame:CGRectMake(self.remarkImageView.frame.origin.x, 0,self.frame.size.width - 2 * self.remarkImageView.frame.origin.x, self.remarkImageView.frame.origin.y)];
    backView2.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:backView2];
    
    UIView *backView3 = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width - self.remarkImageView.frame.origin.x, 0, self.remarkImageView.frame.origin.x, self.frame.size.height)];
    backView3.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:backView3];
    
    UIView *backView4 = [[UIView alloc]initWithFrame:CGRectMake(self.remarkImageView.frame.origin.x, self.remarkImageView.frame.origin.y + self.remarkImageView.frame.size.height,self.frame.size.width - 2 * self.remarkImageView.frame.origin.x,self.frame.size.height - (self.remarkImageView.frame.origin.y + self.remarkImageView.frame.size.height))];
    backView4.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:backView4];
    
    
    CGFloat wigthJIAO = 30;
    CGFloat heigthJIAO = 2;
    CGFloat remarkImageWidth = self.remarkImageView.frame.size.width;
    CGFloat remarkImageHeigth = self.remarkImageView.frame.size.height;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, wigthJIAO, heigthJIAO)];
    label.backgroundColor = [UIColor whiteColor];
    [self.remarkImageView addSubview:label];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, heigthJIAO, wigthJIAO)];
    label2.backgroundColor = [UIColor whiteColor];
    [self.remarkImageView addSubview:label2];
    UILabel *labe3 = [[UILabel alloc]initWithFrame:CGRectMake(remarkImageWidth - wigthJIAO, 0, wigthJIAO, heigthJIAO)];
    labe3.backgroundColor = [UIColor whiteColor];
    [self.remarkImageView addSubview:labe3];
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(remarkImageWidth - heigthJIAO, 0, heigthJIAO, wigthJIAO)];
    label4.backgroundColor = [UIColor whiteColor];
    [self.remarkImageView addSubview:label4];
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, remarkImageHeigth - heigthJIAO, wigthJIAO, heigthJIAO)];
    label5.backgroundColor = [UIColor whiteColor];
    [self.remarkImageView addSubview:label5];
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(0, remarkImageHeigth - wigthJIAO, heigthJIAO, wigthJIAO)];
    label6.backgroundColor = [UIColor whiteColor];
    [self.remarkImageView addSubview:label6];
    
    UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(remarkImageWidth - wigthJIAO, remarkImageHeigth - heigthJIAO, wigthJIAO, heigthJIAO)];
    label7.backgroundColor = [UIColor whiteColor];
    [self.remarkImageView addSubview:label7];
    UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(remarkImageWidth - heigthJIAO, remarkImageHeigth - wigthJIAO, heigthJIAO, wigthJIAO)];
    label8.backgroundColor = [UIColor whiteColor];
    [self.remarkImageView addSubview:label8];
    
    
    min = CGRectGetMinY(self.lineImageView.frame);
    max = CGRectGetMaxY(self.remarkImageView.frame) - kInsertSpace;
    
    //扫描区域：CGRectMake(y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽)
    self.output.rectOfInterest = CGRectMake(min / self.frame.size.height, CGRectGetMinX(self.lineImageView.frame) / self.frame.size.width, (CGRectGetHeight(self.remarkImageView.frame) - 2 * kInsertSpace) / self.frame.size.height, (CGRectGetWidth(self.remarkImageView.frame) - 2 * kInsertSpace) / self.frame.size.width);
}
@end
