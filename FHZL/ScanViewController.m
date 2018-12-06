//
//  ScanViewController.m
//  01-QRCodeScan
//
//  Created by vera on 16/8/6.
//  Copyright © 2016年 deli. All rights reserved.
//

#import "ScanViewController.h"
#import "QRCodeScanView.h"
#import "Header.h"
#import "LocalizedStringTool.h"
#define NAVCOLOR [UIColor colorWithRed:21/255. green:22/255. blue:24/255. alpha:1]
@interface ScanViewController ()
{
    QRCodeScanView *_qrCodeScanView;
}

@end

@implementation ScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    //    iOS 判断应用是否有使用相机的权限
#ifdef DEBUG
#else
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        CSQ_DISPATCH_AFTER(0.5, ^{
            [UIUtil showToast:L(@"APP camera permissions are not open, please go to phone system Settings to open the phoenix zhilian camera permissions") inView:[AppData theTopView]];
        })
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
#endif
    
    
    
    
    QRCodeScanView *qrCodeScanView = [[QRCodeScanView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:qrCodeScanView];
    _qrCodeScanView = qrCodeScanView;
    
    [self setStatusViewAndNavView];
    
    
    
    
    
    //开始扫描
    [qrCodeScanView startScan];
    
    [qrCodeScanView setQRCodeScanDidFinishCallback:^(NSString *value)
    {

        if (_delegate && [_delegate respondsToSelector:@selector(changeCode:)]) {
            [_delegate changeCode:value];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)setStatusViewAndNavView
{
//    self.navigationController.navigationBar.hidden = YES;
//    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    statusView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:statusView];
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
//    navView.backgroundColor = NAVCOLOR;
//    [self.view addSubview:navView];
//    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(0, 0, 58, 44);
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [navView addSubview:backButton];
//    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image = [UIImage imageNamed:@"title_return_n.png"];
//    imageView.frame = CGRectMake(0, 0, 16, 23);
//    imageView.center = backButton.center;
//    [backButton addSubview:imageView];
//    
//    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - 50, 0, 100, 44)];
//    nameLable.text  = @"扫一扫";
//    nameLable.textAlignment = NSTextAlignmentCenter;
//    nameLable.font = [UIFont systemFontOfSize:18];
//    nameLable.textColor = [UIColor whiteColor];
//    [navView addSubview:nameLable];
    self.title = L(@"Barcode scanning");
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
