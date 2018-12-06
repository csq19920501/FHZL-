//
//  APNSetingViewController.m
//  GT
//
//  Created by hk on 17/11/29.
//  Copyright © 2017年 hk. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "APNSetingViewController.h"
#import "Header.h"
@interface APNSetingViewController ()<MFMessageComposeViewControllerDelegate,UITextFieldDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *apnLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *simLabel;
@property (weak, nonatomic) IBOutlet UITextField *apnTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UITextField *simTF;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

@end

@implementation APNSetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topConstant.constant = kTopHeight;
    [self setNavi];
    _apnLabel.text = L(@"APN:");
    _userNameLabel.text = L(@"UserName:");
    _passwordLabel.text = L(@"PassWord:");
    _simLabel.text = L(@"SIM:");
    [_sureButton setTitle:L(@"OK") forState:UIControlStateNormal];
    
    _simTF.text = CsqStringIsEmpty([UserManager sharedInstance].device.devicePhone);
    if (IOS_VERSION >= 10.0) {
        _apnLabel.adjustsFontSizeToFitWidth = YES;
        _userNameLabel.adjustsFontSizeToFitWidth = YES;
        _passwordLabel.adjustsFontSizeToFitWidth = YES;
        _simLabel.adjustsFontSizeToFitWidth = YES;
    }
}
-(void)setNavi{
    self.view.backgroundColor = HBackColor;
    self.title = L(@"APN Set");
    UIFont *font = [UIFont systemFontOfSize:16];
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes =dic;

}
-(void)showLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OkClick:(id)sender {
    if ([[_apnTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        [UIUtil showToast:L(@"APN can not be empty") inView:self.view];
        return;
    }
    
    if ([[_simTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        [UIUtil showToast:L(@"SIM can not be empty") inView:self.view];
        return;
    }
    
//    if ([_simTF.text rangeOfString:@" "].location != NSNotFound) {
//        [UIUtil showToast:L(@"SIM can't include Spaces") inView:self.view];
//        return;
//    }
    
    NSString *str = [NSString  stringWithFormat:@"APN=%@,%@,%@",_apnTF.text,_userNameTF.text,_passWordTF.text];
    if ([MFMessageComposeViewController canSendText]) {
                MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
        // 设置短信内容
        vc.body = str;
        // 设置收件人列表
        vc.recipients = @[_simTF.text];  // 号码数组
        // 设置代理
        vc.messageComposeDelegate = self;
        // 显示控制器
        [self presentViewController:vc animated:YES completion:nil];
//        [self.navigationController pushViewController:vc animated:YES];
    }else{
        showNewAlert(nil,L(@"The device does not support SMS"),nil,nil);
    }
    
//    NSString *urlStr = [NSString stringWithFormat:@"sms:%@&body=%@", _simTF.text, str];
////    NSString *urlStr = [NSString stringWithFormat:@"sms://%@&body=%@", _simTF.text, str];
////    NSString *urlStr = [NSString stringWithFormat:@"sms://%@", _simTF.text];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    [[UIApplication sharedApplication] openURL:url];
    
   
 
    
//    UIWebView *smsWebview =[[UIWebView alloc] init];
//    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@&body=%@",_simTF.text, str]];
//    [smsWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//    [self.view addSubview:smsWebview];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ( _apnTF == textField)
    {
        if (string.length > 0 && textField.text.length > 39)
        {
            [UIUtil showToast:[NSString stringWithFormat:L(@"cannot exceed"),40] inView:self.view];
            return NO;
        }
    }
    if ( _userNameTF == textField)
    {
        if (string.length > 0 && textField.text.length > 29)
        {
            [UIUtil showToast:[NSString stringWithFormat:L(@"cannot exceed"),30] inView:self.view];
            return NO;
        }
    }

    if ( _passWordTF == textField)
    {
        if (string.length > 0 && textField.text.length > 29)
        {
            [UIUtil showToast:[NSString stringWithFormat:L(@"cannot exceed"),30] inView:self.view];
            return NO;
        }
    }
    if ( _simTF == textField)
    {
        if (string.length > 0 && textField.text.length > 15)
        {
            [UIUtil showToast:[NSString stringWithFormat:L(@"cannot exceed"),16] inView:self.view];
            return NO;
        }
    }
    return YES;
}
- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    // 关闭短信界面
    [controller dismissViewControllerAnimated:NO completion:nil];
    if(result == MessageComposeResultCancelled) {
        NSLog(@"取消发送");
    } else if(result == MessageComposeResultSent) {
        [UIUtil showToast:@"Sent successfully" inView:self.view];
        NSLog(@"已经发出");
    } else {
        NSLog(@"发送失败");
        [UIUtil showToast:@"Send failed" inView:self.view];
    }
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
