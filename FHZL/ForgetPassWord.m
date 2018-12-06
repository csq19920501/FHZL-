//
//  RegisterViewController.m
//  FHZL
//
//  Created by hk on 17/11/8.
//  Copyright © 2017年 hk. All rights reserved.
//




#import "ForgetPassWord.h"
#import "Header.h"

@interface ForgetPassWord ()
{
    NSTimer *_countDownTimer;
    int  _countDown;
    int  showRightInt;
}
typedef NS_ENUM(NSInteger,CSQRegisterStep) {
    FirstStep  = 1,
    TwoStep   = 2,
    ThreeStep = 3,
};


@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UITextField *PhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UITextField *rePassWordTF;
@property (weak, nonatomic) IBOutlet UITextField *ImageCodeTF;
@property (weak, nonatomic) IBOutlet UIImageView *CodeImage;
@property (weak, nonatomic) IBOutlet UIImageView *twoLineLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneLineCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeigth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;


@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@property(nonatomic ,assign)CSQRegisterStep RegisterStep;
@property (weak, nonatomic) IBOutlet UIView *twoStepView;

@property (weak, nonatomic) IBOutlet UIView *threeStepView;
@end

@implementation ForgetPassWord
- (IBAction)FirstNextStep:(id)sender {
    if (kStringIsEmpty(_PhoneTF.text)) {
        [UIUtil showToast:L(@"The phone number can not be empty") inView:self.view];
    }
    else if (kStringIsEmpty(_messageTF.text)) {
        [UIUtil showToast:L(@"Validation number can not be empty") inView:self.view];
    }
    else{
        [self setRegisterStep:TwoStep];
    }

}
- (IBAction)TwoNextStep:(id)sender {
//    [self setRegisterStep:ThreeStep];
    if (kStringIsEmpty(_PhoneTF.text)) {
        [UIUtil showToast:L(@"The phone number can not be empty") inView:self.view];
    }
    else if (![AppData valiMobile:_PhoneTF.text]) {
        [UIUtil showToast:L(@"Incorrect phone number format") inView:self.view];
    }
    else if (kStringIsEmpty(_passWordTF.text) || kStringIsEmpty(_rePassWordTF.text)) {
        [UIUtil showToast:L(@"EmptyPassword") inView:self.view];
    }
    else if (_passWordTF.text.length < 6) {
        [UIUtil showToast:L(@"NewPasswordTooShort") inView:self.view];
    }
    else if (![_passWordTF.text isEqualToString:_rePassWordTF.text]) {
        [UIUtil showToast:L(@"NewPasswordTooShort") inView:self.view];
    }
    else{
        [self ForgetPassWordRequest];
    }


}
- (IBAction)RestsiterButton:(id)sender {
}
- (IBAction)getMessage:(id)sender {
    if (_messageButton.selected) {
        return;
    }
    else if (kStringIsEmpty(_PhoneTF.text)) {
        [UIUtil showToast:L(@"The phone number can not be empty") inView:self.view];
    }
    else if (![AppData valiMobile:_PhoneTF.text]) {
        [UIUtil showToast:L(@"Incorrect phone number format") inView:self.view];
    }
    else{
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]; //取消第一响应者状态
        
        [self codeRequest];
    }

}
-(void)changeView:(NSString*)str{
    if ([str isEqualToString:@"TWO"]) {
        _twoLineLabel.hidden = YES;
        _CodeImage.hidden = YES;
        _ImageCodeTF.hidden = YES;
        _oneLineCenterY.constant = 0;
        _backViewHeigth.constant = 108;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topConstant.constant = kTopHeight;
    self.firstLabel.text = L(@"1.Verify Cell Phone");
    self.twoLabel.text = L(@"2.Set Password");
    self.threeLabel.text = L(@"3.Device binding");
    self.PhoneTF.placeholder = L(@"Please enter your phone number");
    self.messageTF.placeholder  = L(@"Please enter SMS verification code");
    [self.messageButton setTitle:L(@"Get code") forState:UIControlStateNormal];
    [self.firstNextButton setTitle:L(@"Next") forState:UIControlStateNormal];
    self.passWordTF.placeholder = L(@"Please input password");
    self.rePassWordTF.placeholder  = L(@"Please confirm password");
    [self.changePassWord setTitle:L(@"Next") forState:UIControlStateNormal];
    
    
    [self setNavi];
    [self changeView:@"TWO"];
    [self setRegisterStep:FirstStep];
    _countDown = 0;
    if ([USER_PLIST objectForKey:@"SENDCODETIME"] || [USER_PLIST objectForKey:@"SENDCODETIME"] != nil)
    {
        NSDate *leaveDate = [USER_PLIST objectForKey:@"SENDCODETIME"];
        NSTimeInterval leaveS = [leaveDate timeIntervalSince1970] * 1;
        NSDate *now2Date = [NSDate date];
        NSTimeInterval now2S = [now2Date timeIntervalSince1970] * 1;
        if (now2S - leaveS < 120)
        {
            _messageButton.selected = YES;
            _countDown = 120 - now2S + leaveS;
            [_messageButton setTitle:[NSString stringWithFormat:@"%@(%dS)",L(@"Remaining"),_countDown] forState:UIControlStateNormal];
            if (_countDownTimer == nil)
            {
                _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(computerTime) userInfo:nil repeats:YES];
            }
        }
    }

}
-(void)setRegisterStep:(CSQRegisterStep)RegisterStep{
    switch (RegisterStep) {
        case FirstStep:
        {
            _firstLabel.textColor = HTextColor;
            _twoLabel.textColor = [UIColor darkGrayColor];
            _threeLabel.textColor = [UIColor darkGrayColor];
            
            _twoStepView.hidden = YES;
            _threeStepView.hidden = YES;
        }
            break;
        case TwoStep:
        {
            _firstLabel.textColor = [UIColor darkGrayColor];
            _twoLabel.textColor = HTextColor;
            _threeLabel.textColor = [UIColor darkGrayColor];
            
            _twoStepView.hidden = NO;
            [self.view bringSubviewToFront:_twoStepView];
            _threeStepView.hidden = YES;
        }
            break;
        case ThreeStep:
        {
            _firstLabel.textColor = [UIColor darkGrayColor];
            _twoLabel.textColor = [UIColor darkGrayColor];
            _threeLabel.textColor = HTextColor;
            
            _twoStepView.hidden = YES;
            _threeStepView.hidden = NO;
            [self.view bringSubviewToFront:_threeStepView];
        }
            break;
        default:
            break;
    }
    
}
-(void)setNavi{
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = HBackColor;
    self.title = L(@"ForgotPassword");
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationItem setLeftBarButtonItem:({
//        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:({
//            UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
//            [button setBackgroundImage:[UIImage imageNamed:@"标题栏_返回_N.png"] forState:UIControlStateNormal];
//            [button setBackgroundImage:[UIImage imageNamed:@"标题栏_返回_P.png"] forState:UIControlStateHighlighted];
//            [button addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
//            button.frame = CGRectMake(0, 0, 25, 25);
//            button;
//        })];
//        barButton;//APP_登录确定1_返回.png
//    })];
    [self.navigationItem setRightBarButtonItem:({
        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, 25, 25);
            button;
        })];
        barButton;
    })];
    showRightInt = 0;
}
-(void)showLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRight{
    showRightInt ++;
    if (showRightInt == 5) {
        showRightInt = 0;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:L(@"Switch server") preferredStyle:  UIAlertControllerStyleActionSheet];
        
        UIAlertAction *wai;
        UIAlertAction *nei;
        if ([[AppData httpServerUrl] isEqualToString:APPURLRELEASE]) {
            
            wai = [UIAlertAction actionWithTitle:[NSString  stringWithFormat:@"%@(%@)",@"正式服",L(@"Now")] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [AppData setHttpServerUrl:APPURLRELEASE];
//                [AppData setAppType:APPWAITYPE];
            }];
            nei = [UIAlertAction actionWithTitle:@"测试服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [AppData setHttpServerUrl:APPURLDEBUG];
//                [AppData setAppType:APPNEITYPE];
            }];
            
            
           
            [wai setValue:[UIColor redColor] forKey:@"_titleTextColor"];
 
            [nei setValue:[UIColor grayColor] forKey:@"_titleTextColor"];

        }else{
            wai = [UIAlertAction actionWithTitle:@"正式服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [AppData setHttpServerUrl:APPURLRELEASE];
//                [AppData setAppType:APPWAITYPE];
            }];
            nei = [UIAlertAction actionWithTitle:[NSString  stringWithFormat:@"%@(%@)",@"测试服",L(@"Now")]  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [AppData setHttpServerUrl:APPURLDEBUG];
//                [AppData setAppType:APPNEITYPE];
            }];
            [wai setValue:[UIColor grayColor] forKey:@"_titleTextColor"];
            [nei setValue:[UIColor redColor] forKey:@"_titleTextColor"];
        }
        
        UIAlertAction*cancel =  [UIAlertAction actionWithTitle:L(@"Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [cancel setValue:[UIColor grayColor] forKey:@"_titleTextColor"];
        [alert addAction:wai];
        [alert addAction:nei];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)codeRequest{
    [UIUtil showProgressHUD:L(@"Get SMS verification code") inView:self.view]; //登录..
    
    NSDictionary *dic = @{@"mobilePhone":_PhoneTF.text,@"smsType":@"1"};
    
    [ZZXDataService HFZLRequest:@"sms/verify-code" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         LOGDATA(dic)
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil showToast:L(@"SentSMS") inView:self.view];
             _messageButton.selected = YES;
             _countDown = 120;
             NSDate *date = [NSDate date];
             [USER_PLIST setObject:date forKey:@"SENDCODETIME"]; //保存发送验证码成功时的当前时间
             
             _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(computerTime) userInfo:nil repeats:YES];
         }else{
             [UIUtil showToast:L(@"Send failed") inView:self.view];
         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
     }];
}
-(void)computerTime
{
    _countDown--;
    
    if (_countDown >= 1)
    {
        [_messageButton setTitle:[NSString stringWithFormat:@"%@(%dS)",L(@"Remaining"),_countDown] forState:UIControlStateNormal];
        [USER_PLIST setObject:[NSString stringWithFormat:@"%d",_countDown] forKey:@"COMPUTERTIME"];
    }
    else
    {
        _messageButton.selected = NO;
        [_messageButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [USER_PLIST setObject:[NSString stringWithFormat:@"%d",_countDown] forKey:@"COMPUTERTIME"];
        if (_countDownTimer != nil)
        {
            [_countDownTimer invalidate];
            _countDownTimer = nil;
        }
    }
}
-(void)ForgetPassWordRequest{
    [UIUtil showProgressHUD:@"请稍候..." inView:self.view];
    NSDictionary *dic = @{@"mobilePhone":CsqStringIsEmpty(_PhoneTF.text),
                          @"newPwd":[CsqStringIsEmpty(_passWordTF.text) md5HexDigest],
                          @"confirmPwd":[CsqStringIsEmpty(_rePassWordTF.text) md5HexDigest],
                          @"veriCode":CsqStringIsEmpty(_messageTF.text)
                        };
    [ZZXDataService HFZLRequest:@"user/pwd-reset" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
       
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil showToast:L(@"SuccessToChangePassword") inView:self.view];
             
         }else{
             [UIUtil showToast:L(@"Modify failed") inView:self.view];
             
         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
     }];
}
#pragma mark TFdelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(_PhoneTF == textField) {
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
        if (string.length > 0 && textField.text.length >= 11)
        {
            showLimit(11)
            return NO;
        }
    }
    if (string.length > 0 && textField.text.length >= TFLength)
    {
        showLimit(TFLength)
        return NO;
    }
    return YES;
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
