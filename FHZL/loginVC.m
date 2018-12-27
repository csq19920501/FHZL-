//
//  loginVC.m
//  FHZL
//
//  Created by hk on 17/12/6.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "loginVC.h"

#import "RegisterViewController.h"
#import "ForgetPassWord.h"
#import "Header.h"
#import "loginAccountCell.h"
#import "Masonry.h"
@interface loginVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSMutableArray *accountArray;
}
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;

@property(nonatomic,strong)UITableView *accountTableView;
@end

@implementation loginVC
- (IBAction)accountSelect:(id)sender {
    if ([_accountTF isFirstResponder] || [_passwordTF isFirstResponder]) {
        SDLog(@"键盘弹出状态不允许操作此功能");
        return;
    }
    if (!self.accountButton.selected) {
        [UIView animateWithDuration:0.2 animations:^(void){
            if (accountArray.count != 0) {
                CGRect rect = self.accountView.frame;
                if (accountArray.count <= 4) {
                    rect.size.height = 30 * accountArray.count;
                }else{
                    rect.size.height = 30 * 4;
                }
                self.accountView.frame = rect;
                self.accountTableView.frame = self.accountView.bounds;
                
                
                self.accountView.hidden = NO;
                _passwordTF.enabled = NO;
                _accountButton.selected = !_accountButton.selected;
            }
        }];
    }else{
        [self hiddenAccountView];
    }
}
-(void)hiddenAccountView{
    if (!self.accountView.hidden) {
        [UIView animateWithDuration:0.2 animations:^(void){
            _passwordTF.enabled = YES;
            _accountView.hidden = YES;
            _accountButton.selected = !_accountButton.selected;
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.loginButton setTitle:L(@"Login") forState:UIControlStateNormal];
    [self.forgetButton setTitle:L(@"ForgotPassword") forState:UIControlStateNormal];
    [self.registButton setTitle:L(@"New User Registration") forState:UIControlStateNormal];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:18]; // 设置font
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor]; // 设置颜色
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:L(@"Account") attributes:attrs]; // 初始化富文本占位字符串
    _accountTF.attributedPlaceholder = attStr;
    NSAttributedString *attStr2 = [[NSAttributedString alloc] initWithString:L(@"PassWord") attributes:attrs]; // 初始化富文本占位字符串
    _passwordTF.attributedPlaceholder = attStr2;
    
    _accountTF.text = USERMANAGER.user.accoundID;
//    _passwordTF.text = USERMANAGER.user.password;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAccountView)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    accountArray = [NSMutableArray array];
    [accountArray addObjectsFromArray:[USER_PLIST objectForKey:@"ACCOUNDARRAY"]];

    DISPATCH_ON_MAIN_THREAD(^{
        //更新UI
        CGRect rect = self.accountView.frame;
        if (accountArray.count <= 4) {
            rect.size.height = 30 * accountArray.count;
            self.accountView.frame = rect;
        }else{
            rect.size.height = 30 * 4;
            self.accountView.frame = rect;
        }
        self.accountTableView = [[UITableView alloc]initWithFrame:self.accountView.bounds style:UITableViewStylePlain];
        self.accountTableView.delegate = self;
        self.accountTableView.dataSource = self;
        [self.accountTableView registerNib:[UINib nibWithNibName:@"loginAccountCell" bundle:nil] forCellReuseIdentifier:@"loginAccountCell"];
//        [self.accountTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.right.top.equalTo(self.accountView);
//
//        }];
        [self.accountView addSubview:self.accountTableView];
    })
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (IBAction)loginClick:(id)sender {
    if (kStringIsEmpty(_accountTF.text)) {
        [UIUtil showToast:L(@"EmptyUsername") inView:self.view];
    }
    else if (![AppData deptNumInputShouldNumber:_accountTF.text]) {
        [UIUtil showToast:L(@"The account does not conform to the specification") inView:self.view];
    }
    else if (kStringIsEmpty(_passwordTF.text)) {
        [UIUtil showToast:L(@"EmptyPassword") inView:self.view];
    }
    else{
        [self LoginRequest];
    }
}
- (IBAction)Register:(id)sender {
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
}
- (IBAction)ForgetPassword:(id)sender {
    [self.navigationController pushViewController:[ForgetPassWord new] animated:YES];
}
-(void)LoginRequest{
    [UIUtil showProgressHUD:L(@"HintLogin") inView:self.view];
    NSDictionary *dic = @{@"loginName":CsqStringIsEmpty(_accountTF.text),
                          @"password":[CsqStringIsEmpty(_passwordTF.text) md5HexDigest],
                          };
    
    [ZZXDataService HFZLRequest:@"user/login" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil showToast:L(@"HintRequestSuccess") inView:self.view];
             UserManager *userManager = [UserManager sharedInstance];
             userManager.user.isLogined = YES;
             userManager.user.password = _passwordTF.text;
             userManager.user.accoundID = _accountTF.text;
             
             NSDictionary *userDict = data[@"data"][@"userInfo"];
             if (!kDictIsEmpty(userDict)) {
                 userManager.user.nickname = GetData(userDict, @"nickName");
                 userManager.user.userID = GetData(userDict, @"id") ;
                 userManager.user.macID = GetData(userDict, @"macId");
                 userManager.user.iconId = GetData(userDict, @"iconId");
                 userManager.user.mobilePhone = GetData(userDict, @"mobilePhone");
                 userManager.user.appCookie = GetData(userDict, @"appCookie");
                 NSString *str = GetData(userDict, @"headPicPath");
                 if (!kStringIsEmpty(str)) {
                     if ([str hasPrefix:@"http://thirdwx"]) {
                         userManager.user.headPicPath = GetData(userDict, @"headPicPath");
                     }else{
                         userManager.user.upPicPath = GetData(userDict, @"headPicPath");
                     }
                 }
                 
                 userManager.user.mobilePhone = GetData(userDict, @"phone");
             }
             
             //记录登录账号
             
             NSArray *accountArray1 = [accountArray copy];
             BOOL isExit = NO;
             for (NSDictionary *accountDict in accountArray1) {
                 if ([accountDict[@"userAccount"] isEqualToString:_accountTF.text]) {
                     [accountArray removeObject:accountDict];
                     [accountArray addObject:@{@"userAccount":_accountTF.text,@"passWord":_passwordTF.text}];
                     [self.accountTableView reloadData];
                     [USER_PLIST setObject:accountArray forKey:@"ACCOUNDARRAY"];
                     isExit = YES;
                     break;
                 }
             }
             if (!isExit) {
                 [accountArray addObject:@{@"userAccount":_accountTF.text,@"passWord":_passwordTF.text}];
                 [USER_PLIST setObject:accountArray forKey:@"ACCOUNDARRAY"];
             }
             
             
             NSString *token = data[@"data"][@"token"];
             if (!kStringIsEmpty(token)) {
                  userManager.user.token = token;
             }
             NSString *loginType = data[@"data"][@"type"];
             if (!kStringIsEmpty(loginType)) {
                 userManager.user.loginType = loginType;
             }
 
//             NSDictionary *dictMusic = @{TYPE:MUSIC};
//             NSDictionary *dictGT10 = @{TYPE:GT10,GT10:_device,GT10ARRAY:_deviceArray};
//             [_AllDeviceArray addObjectsFromArray:@[dictMusic,dictGT10]];
             
             NSArray *cardVeiwArr = data[@"data"][@"cardVeiws"];
             [userManager.AllDeviceArray removeAllObjects];
             if (!kArrayIsEmpty(cardVeiwArr)) {
                 for (NSDictionary *cardDict in cardVeiwArr) {
                     NSLog(@"desc = %@",cardDict[@"desc"]);
                     NSDictionary *cardD;
                     if ([cardDict[@"viewId"] isEqualToString:@"101"]) {
                         NSLog(@"添加101");
                        cardD  = @{TYPE:GT10,orderNum:cardDict[@"orderNum"]};
                         [userManager.AllDeviceArray addObject:cardD];
                     }else if([cardDict[@"viewId"] isEqualToString:@"102"]){
                         NSLog(@"添加102");
//                        cardD = @{TYPE:MUSIC,orderNum:cardDict[@"orderNum"]};
                     }else if([cardDict[@"viewId"] isEqualToString:@"103"]){
                         NSLog(@"添加103");
                         cardD = @{TYPE:SUIPAI,orderNum:cardDict[@"orderNum"]};
                         [userManager.AllDeviceArray addObject:cardD];
                     }                     
                 }
             }
             [[UserManager sharedInstance] save];             
//             [self.navigationController pushViewController:[HomeVC new] animated:YES];
             [APPDELEGATE setRootMainVC];
         }else{
             switch ([data[@"code"]integerValue]) {
                 case 101016:
                     {
                         [UIUtil showToast:L(@"Wrong account or password") inView:self.view];
                     }
                     break;
                 case 101017:
                 {
                     [UIUtil showToast:L(@"Account not registered") inView:self.view];
                 }
                     break;
                 case 101021:
                 {
                     [UIUtil showToast:L(@"No account or password error") inView:self.view];
                 }
                     break;
                 default:
                     [UIUtil showToast:L(@"Login failed") inView:self.view];
                     break;
             }
         }
     } fail:^(NSError *error)
     {
         
//         [UIUtil showToast:@"网络异常" inView:self.view];
         
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TFdelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _accountTF) {
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
    }else{
        if (string.length > 0 && textField.text.length >= TFLength)
        {
            showLimit(TFLength)
            return NO;
        }
    }
    return YES;
}
#pragma mark tableviewDele
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return accountArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"loginAccountCell";
    loginAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.accoundLabel.text = accountArray[indexPath.row][@"userAccount"];
    cell.deleAccoundButton.tag = 100 + indexPath.row;
    [cell.deleAccoundButton addTarget:self action:@selector(deleAccount:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击 %ld",indexPath.row);
    _accountTF.text = accountArray[indexPath.row][@"userAccount"];
    _passwordTF.text = accountArray[indexPath.row][@"passWord"];
    DISPATCH_ON_MAIN_THREAD(^{
        //更新UI
        CGRect rect = self.accountView.frame;
        if (accountArray.count <= 4) {
            rect.size.height = 30 * accountArray.count;
        }else{
            rect.size.height = 30 * 4;
        }
        self.accountView.frame = rect;
        self.accountTableView.frame = self.accountView.bounds;
    })
    [self hiddenAccountView];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.accountView]) {
        
        return NO;
    }
    return YES;
}
-(void)deleAccount:(UIButton*)but{
    int tag = (int)but.tag - 100;
    [accountArray removeObjectAtIndex:tag];
    [self.accountTableView reloadData];
    [USER_PLIST setObject:accountArray forKey:@"ACCOUNDARRAY"];
    [USER_PLIST synchronize ];
    
    CGRect rect = self.accountView.frame;
    if (accountArray.count <= 4) {
        rect.size.height = 30 * accountArray.count;
    }else{
        rect.size.height = 30 * 4;
    }

    self.accountView.frame = rect;
    self.accountTableView.frame = self.accountView.bounds;
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
