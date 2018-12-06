//
//  ModifierPassword.m
//  FHZL
//
//  Created by hk on 17/12/15.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "ModifierPassword.h"
#import "Header.h"
@interface ModifierPassword ()
@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;
@property (weak, nonatomic) IBOutlet UITextField *NewPassWordTF;
@property (weak, nonatomic) IBOutlet UITextField *rePassWordTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

@end

@implementation ModifierPassword
- (IBAction)modifyPassWord:(id)sender {
    if (kStringIsEmpty(_oldPassWord.text) || kStringIsEmpty(_NewPassWordTF.text) || kStringIsEmpty(_rePassWordTF.text)) {
        [UIUtil showToast:L(@"EmptyPassword") inView:self.view];
    }
    else if (_oldPassWord.text.length < 6 || _NewPassWordTF.text.length < 6 || _rePassWordTF.text.length < 6) {
        [UIUtil showToast:L(@"NewPasswordTooShort") inView:self.view];
    }
    else if (![_NewPassWordTF.text isEqualToString:_rePassWordTF.text]) {
        [UIUtil showToast:L(@"NewPasswordTooShort") inView:self.view];
    }
    else{
        [self ChangeWordRequest];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topConstant.constant = kTopHeight + 10;
    [self.confirmButton setTitle:L(@"confirm") forState:UIControlStateNormal];
    [self setNavi];
}
-(void)setNavi{
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = HBackColor;
    self.title = L(@"Change Password");
    self.oldPassWord.placeholder = L(@"Please enter the old password");
    self.NewPassWordTF.placeholder = L(@"Please enter a new password");
    self.rePassWordTF.placeholder = L(@"Please confirm password");
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
}
-(void)showLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRight{}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ChangeWordRequest{
    [UIUtil showProgressHUD:L(@"Please wait a moment") inView:self.view];
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"password":[CsqStringIsEmpty(_oldPassWord.text) md5HexDigest],
                          @"newPwd":[CsqStringIsEmpty(_NewPassWordTF.text) md5HexDigest],
                          @"confirmPwd":[CsqStringIsEmpty(_rePassWordTF.text) md5HexDigest]
                          };
    [ZZXDataService HFZLRequest:@"user/pwd-modify" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil showToast:L(@"SuccessToChangePassword") inView:self.view];
             CSQ_DISPATCH_AFTER(1.5, ^{
                 [self showLeft];
             })
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
