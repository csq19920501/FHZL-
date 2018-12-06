//
//  BindDeviceVC.m
//  FHZL
//
//  Created by hk on 2018/1/19.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "BindDeviceVC.h"
#import "Header.h"
//扫描
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "ScanViewController.h"
@interface BindDeviceVC ()<ScanDele>
@property (weak, nonatomic) IBOutlet UITextField *IMEI_tf;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

@end

@implementation BindDeviceVC
- (IBAction)BindClick:(id)sender {
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    scanVC.delegate = self;
    [self.navigationController pushViewController:scanVC animated:NO];
}
-(void)changeCode:(NSString *)code{
    _IMEI_tf.text = code;
}
- (IBAction)confirmClick:(id)sender {
    if (!kStringIsEmpty(_IMEI_tf.text)) {
        [self bindNewDevice];
    }else{
        [UIUtil showToast:L(@"Can not be empty") inView:self.view];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = L(@"Device binding");
    self.topConstant.constant = kTopHeight + 30;
    self.titleLabel.text = L(@"Please enter device IMEI for binding");
    [self.bindButton setTitle:L(@"Determine binding") forState:UIControlStateNormal] ;
}


-(void)bindNewDevice{
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(_IMEI_tf.text)
                          };
    [ZZXDataService HFZLRequest:@"user/dev-bind" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil showToast:L(@"Bind successfully") inView:self.view];
             CSQ_DISPATCH_AFTER(1.5, ^{
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"UnBindSuccess" object:nil];
                 [self showLeft];
             })
             
             
         }else{
             switch ([data[@"code"]integerValue]) {
                 case 102011:
                     {
                         [UIUtil showToast:L(@"Equipment not found") inView:self.view];
                     }
                     break;
                 case 101031:
                 {
                     [UIUtil showToast:L(@"The device has been bound") inView:self.view];
                 }
                     break;
                 default:
                     break;
             }
             
         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
     }];
}


-(void)showLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _IMEI_tf) {
        if (!([string isEqualToString:@"0"]
              || [string isEqualToString:@"1"]
              || [string isEqualToString:@"2"]
              || [string isEqualToString:@"3"]
              || [string isEqualToString:@"4"]
              || [string isEqualToString:@"5"]
              || [string isEqualToString:@"6"]
              || [string isEqualToString:@"7"]
              || [string isEqualToString:@"8"]
              || [string isEqualToString:@"9"]) && string.length > 0) {
            return NO;
        }
        
        if (string.length > 0 && textField.text.length >= 15)
        {
            showLimit(15)
            return NO;
        }
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
