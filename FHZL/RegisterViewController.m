//
//  RegisterViewController.m
//  FHZL
//
//  Created by hk on 17/11/8.
//  Copyright © 2017年 hk. All rights reserved.
//



#import "WXApi.h"
#import "RegisterViewController.h"
#import "Header.h"
//扫描
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "ScanViewController.h"
@interface RegisterViewController ()<ScanDele>
{
    NSTimer *_countDownTimer;
    int  _countDown;
    UIView *headView;
    int headInt;
}
typedef NS_ENUM(NSInteger,CSQRegisterStep) {
    FirstStep  = 1,
    TwoStep   = 2,
    ThreeStep = 3,
};

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

@property (weak, nonatomic) IBOutlet UIImageView *CodeImage;
@property (weak, nonatomic) IBOutlet UITextField *ImageCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *MessageTF;
@property (weak, nonatomic) IBOutlet UIButton *GetCodeButton;
@property (weak, nonatomic) IBOutlet UIImageView *twoLineLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneLineCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeigth;

@property (weak, nonatomic) IBOutlet UITextField *PhoneTF;
@property (weak, nonatomic) IBOutlet UIButton *getPhoneCode;
@property (weak, nonatomic) IBOutlet UITextField *IMEITF;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@property(nonatomic ,assign)CSQRegisterStep RegisterStep;
@property (weak, nonatomic) IBOutlet UIView *twoStepView;
@property (weak, nonatomic) IBOutlet UITextField *firstPassWordTF;
@property (weak, nonatomic) IBOutlet UITextField *TowPassWordTF;

@property (weak, nonatomic) IBOutlet UIView *threeStepView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *selectHeadButton;


@end

@implementation RegisterViewController
- (IBAction)goToFirstStep:(id)sender {
    [self setRegisterStep:FirstStep];
}
- (IBAction)goToTwoStep:(id)sender {
    [self setRegisterStep:TwoStep];
}
- (IBAction)goToThreeStep:(id)sender {
    [self setRegisterStep:ThreeStep];
}


- (IBAction)getPhoneCode:(id)sender {
    if (_GetCodeButton.selected) {
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


- (IBAction)FirstNextStep:(id)sender {
    if (kStringIsEmpty(_PhoneTF.text)) {
        [UIUtil showToast:L(@"The phone number can not be empty") inView:self.view];
    }
    else if (kStringIsEmpty(_MessageTF.text)) {
        [UIUtil showToast:L(@"Validation number can not be empty") inView:self.view];
    }
    else{
        
         [self setRegisterStep:TwoStep];
    }
  
}
- (IBAction)TwoNextStep:(id)sender {
    if (kStringIsEmpty(_firstPassWordTF.text) || kStringIsEmpty(_TowPassWordTF.text)) {
        [UIUtil showToast:L(@"EmptyPassword") inView:self.view];
    }
    else if (_firstPassWordTF.text.length < 6) {
        [UIUtil showToast:L(@"NewPasswordTooShort") inView:self.view];
    }
    else if (![_firstPassWordTF.text isEqualToString:_TowPassWordTF.text]) {
        [UIUtil showToast:L(@"NewPasswordTooShort") inView:self.view];
    }else{
        [self setRegisterStep:ThreeStep];
    }
}
- (IBAction)RestsiterButton:(id)sender {
    if (kStringIsEmpty(_PhoneTF.text)) {
        [UIUtil showToast:L(@"The phone number can not be empty") inView:self.view];
    }
    else if (kStringIsEmpty(_MessageTF.text)) {
        [UIUtil showToast:L(@"Validation number can not be empty") inView:self.view];
    }
    else if (kStringIsEmpty(_firstPassWordTF.text) || kStringIsEmpty(_TowPassWordTF.text)) {
        [UIUtil showToast:L(@"EmptyPassword") inView:self.view];
    }
    else if (_firstPassWordTF.text.length < 6) {
        [UIUtil showToast:L(@"NewPasswordTooShort") inView:self.view];
    }
    else if (![_firstPassWordTF.text isEqualToString:_TowPassWordTF.text]) {
        [UIUtil showToast:L(@"NewPasswordTooShort") inView:self.view];
    }

//    else if (!_acceptButton.selected ) {
//        [UIUtil showToast:@"请阅读并接受用户协议" inView:self.view];
//    }
    else if (kStringIsEmpty(_nickNameTF.text) ) {
        [UIUtil showToast:L(@"nickName cannot be empty") inView:self.view];
    }
    else if (_acceptButton.selected) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            //微信)
            
            SendAuthReq* req =[[SendAuthReq alloc ] init];
            req.scope = @"snsapi_userinfo,snsapi_base";
            req.state = @"app" ;
            [WXApi sendReq:req];
//                showNewAlert(nil,@"是否绑定微信头像",nil,^(UIAlertAction *action){
//
//                })
        }else{
            [UIUtil showToast:L(@"You have not installed WeChat") inView:self.view];
        }
    }
    else{
        [self RegisterRequest];
    }
}
-(void)weixinImage{
    headInt = 13;
    [self RegisterRequest];
}
-(void)WEIXINIMAGECancle{
    [self RegisterRequest];
}
-(void)WEIXINIMAGEFirst{
    [UIUtil showProgressHUD:L(@"Regist...") inView:self.view];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topConstant.constant = kTopHeight;
    self.firstLabel.text = L(@"1.Verify Cell Phone");
    self.twoLabel.text = L(@"2.Set Password");
    self.threeLabel.text = L(@"3.Device binding");
    self.PhoneTF.placeholder = L(@"Please enter your phone number");
    self.MessageTF.placeholder  = L(@"Please enter SMS verification code");
    [self.GetCodeButton setTitle:L(@"Get code") forState:UIControlStateNormal];
    [self.firstNextButton setTitle:L(@"Next") forState:UIControlStateNormal];
    self.firstPassWordTF.placeholder = L(@"Please input password");
    self.TowPassWordTF.placeholder  = L(@"Please confirm password");
    [self.twoNextButton setTitle:L(@"Next") forState:UIControlStateNormal];
    self.nickNameTF.placeholder = L(@"Please enter nickname");
    self.IMEITF.placeholder  = L(@"Please enter device number IMEI");
    self.tipLabel.text = L(@"Bind WeChat avatars before registration");
    [self.registerButton setTitle:L(@"Regist") forState:UIControlStateNormal];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinImage) name:@"WEIXINIMAGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WEIXINIMAGECancle) name:@"WEIXINIMAGECancle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WEIXINIMAGEFirst) name:@"WEIXINIMAGEFirst" object:nil];
    
    
    [self setNavi];
    [self changeView:@"TWO"];
    [self setRegisterStep:FirstStep];
    _countDown = 0;
    headInt = 0;
    _acceptButton.selected = YES;
    if ([USER_PLIST objectForKey:@"SENDCODETIME"] || [USER_PLIST objectForKey:@"SENDCODETIME"] != nil)
    {
        NSDate *leaveDate = [USER_PLIST objectForKey:@"SENDCODETIME"];
        NSTimeInterval leaveS = [leaveDate timeIntervalSince1970] * 1;
        NSDate *now2Date = [NSDate date];
        NSTimeInterval now2S = [now2Date timeIntervalSince1970] * 1;
        if (now2S - leaveS < 120)
        {
            _GetCodeButton.selected = YES;
            _countDown = 120 - now2S + leaveS;
            [_GetCodeButton setTitle:[NSString stringWithFormat:@"%@(%dS)",L(@"Remaining"),_countDown] forState:UIControlStateNormal];
            if (_countDownTimer == nil)
            {
                _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(computerTime) userInfo:nil repeats:YES];
            }
        }
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
- (IBAction)setHead:(id)sender {
    if (!headView)
    {
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
        headView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self.view addSubview:headView];
        
        UIButton *hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        hiddenButton.frame = CGRectMake(0, 0, headView.width, headView.height);
        [hiddenButton addTarget:self action:@selector(hiddenHeadView) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:hiddenButton];
        
        UIScrollView *headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 68, SCREENWIDTH, 80)];
        
            for (int i = 0; i < 12; i ++)
            {
                UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                imageButton.frame = CGRectMake(i * 80, 0, 80, 80);
                [imageButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ui2_user_icon%d",i + 1]] forState:UIControlStateNormal];
                imageButton.tag = 1001 + i;
                [imageButton addTarget:self action:@selector(selectHeadImage:) forControlEvents:UIControlEventTouchUpInside];
                [headScrollView addSubview:imageButton];
            }
        headScrollView.contentSize = CGSizeMake(80 *12, 80);
        headScrollView.bounces = NO;
        headScrollView.backgroundColor = [UIColor whiteColor];
        headScrollView.showsHorizontalScrollIndicator = NO;
        [headView addSubview:headScrollView];
    }
    else
    {
        headView.hidden = NO;
        [self.view bringSubviewToFront:headView];
    }
}
-(void)hiddenHeadView{
     headView.hidden = YES;
}
-(void)selectHeadImage:(UIButton *)but{
    headInt = but.tag -1000;
    [_selectHeadButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ui2_user_icon%d.png",headInt]] forState:UIControlStateNormal];
    [self hiddenHeadView];
}
- (IBAction)scan:(id)sender {
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    scanVC.delegate = self;
    [self.navigationController pushViewController:scanVC animated:NO];
}
-(void)changeCode:(NSString *)code{
    _IMEITF.text = code;
}
- (IBAction)setReceive:(id)sender {
    UIButton *but = sender;
    but.selected = !but.selected;
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
    self.title = L(@"Registered Account");

//    [self.navigationItem setLeftBarButtonItem:({
//        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:({
//            UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
//            [button setBackgroundImage:[UIImage imageNamed:BackImageNormal] forState:UIControlStateNormal];
//            [button setBackgroundImage:[UIImage imageNamed:BackImageP] forState:UIControlStateHighlighted];
//            [button addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
//            button.frame = CGRectMake(0, 0, 25, 25);
//            button;
//        })];
//        barButton;//APP_登录确定1_返回.png
//    })];
//    [self.navigationItem setRightBarButtonItem:({
//        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:({
//            UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
//            [button setBackgroundImage:[UIImage imageNamed:@"MAIN2_位置_状态栏_轨迹_N.png"] forState:UIControlStateNormal];
//            [button setBackgroundImage:[UIImage imageNamed:@"MAIN2_位置_状态栏_轨迹_N.png"] forState:UIControlStateHighlighted];
//            [button addTarget:self action:@selector(showReft) forControlEvents:UIControlEventTouchUpInside];
//            button.frame = CGRectMake(0, 0, 25, 25);
//            button;
//        })];
//        barButton;//APP_登录确定1_返回.png
//    })];
}
-(void)showLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)codeRequest{
    [UIUtil showProgressHUD:L(@"Get SMS verification code") inView:self.view]; //登录..
    
    NSDictionary *dic = @{@"mobilePhone":_PhoneTF.text,@"smsType":@"0"};
    
    [ZZXDataService HFZLRequest:@"sms/verify-code" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         LOGDATA(dic)
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil showToast:L(@"SentSMS") inView:self.view];
             _GetCodeButton.selected = YES;
             _countDown = 120;
             NSDate *date = [NSDate date];
             [USER_PLIST setObject:date forKey:@"SENDCODETIME"]; //保存发送验证码成功时的当前时间
             _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(computerTime) userInfo:nil repeats:YES];
         }else{
             switch ([data[@"code"]integerValue]) {
                 case 203001:
                 {
                     [UIUtil showToast:L(@"You cannot send text messages repeatedly within a minute") inView:self.view];
                 }
                     break;
                 case 203002:
                 {
                     [UIUtil showToast:L(@"Too many text messages in an hour") inView:self.view];
                 }
                     break;
                 case 203003:
                 {
                     [UIUtil showToast:L(@"Text messages are all used up today") inView:self.view];
                 }
                     break;
                 case 101014:
                 {
                     [UIUtil showToast:L(@"The phone number has been registered") inView:self.view];
                 }
                     break;
                 default:
                     [UIUtil showToast:L(@"Request failed") inView:self.view];
                     break;
             }
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
        [_GetCodeButton setTitle:[NSString stringWithFormat:@"%@(%dS)",L(@"Remaining"),_countDown] forState:UIControlStateNormal];
//        [USER_PLIST setObject:[NSString stringWithFormat:@"%d",_countDown] forKey:@"COMPUTERTIME"];
    }
    else
    {
        _GetCodeButton.selected = NO;
        [_GetCodeButton setTitle:L(@"Get code") forState:UIControlStateNormal];
//        [USER_PLIST setObject:[NSString stringWithFormat:@"%d",_countDown] forKey:@"COMPUTERTIME"];
        if (_countDownTimer != nil)
        {
            [_countDownTimer invalidate];
            _countDownTimer = nil;
        }
    }
}
-(void)RegisterRequest{
    [UIUtil showProgressHUD:L(@"Regist...") inView:self.view];
    NSDictionary *dic = @{@"mobilePhone":CsqStringIsEmpty(_PhoneTF.text),
                          @"password":[CsqStringIsEmpty(_firstPassWordTF.text) md5HexDigest],
                          @"confirmPwd":[CsqStringIsEmpty(_TowPassWordTF.text) md5HexDigest],
                          @"phoneVeriCode":CsqStringIsEmpty(_MessageTF.text),
//                          @"isAccepteSrv":_acceptButton.selected?@"1":@"0",
                          @"isAccepteSrv":@"1",
                    @"nickName":CsqStringIsEmpty(_nickNameTF.text),
                          @"macId":CsqStringIsEmpty(_IMEITF.text),
                          @"iconId":[NSString stringWithFormat:@"%d",headInt],
                      @"wxHead":CsqStringIsEmpty(USERMANAGER.user.headPicPath)
                          };
    [ZZXDataService HFZLRequest:@"user/register" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil showToast:L(@"RegistRequestSuccess") inView:self.view];
             CSQ_DISPATCH_AFTER(1.5, ^{
                 [self showLeft];
             })
         }else{
             switch ([data[@"code"]integerValue]) {
                 case 101013:
                     {
                         [UIUtil showToast:L(@"User protocol is not uniform") inView:self.view];
                     }
                     break;
                 case 101014:
                 {
                     [UIUtil showToast:L(@"The phone number has been registered") inView:self.view];
                 }
                     break;
                 case 101031:
                 {
                     [UIUtil showToast:L(@"The device number is bound") inView:self.view];
                 }
                     break;
                 case 101012:
                 {
                     [UIUtil showToast:L(@"Verification code error") inView:self.view];
                 }
                     break;
                     
                 default:
                     [UIUtil showToast:L(@"Registration failed") inView:self.view];
                     break;
             }
             
             
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
