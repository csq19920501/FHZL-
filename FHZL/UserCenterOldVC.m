//
//  UserCenterVC.m
//  FHZL
//
//  Created by hk on 17/12/14.
//  Copyright © 2017年 hk. All rights reserved.
//
#import "WXApi.h"
#import "UserCenterOldVC.h"
#import "Header.h"
#import "UserCenterItemCell.h"

#import "ModifierPassword.h"

#import "MapSettingViewController.h"
#import "NaviCenterViewController.h"
#import "AboutUsViewController.h"
#import "UIViewController+HeadFunction.h"
@interface UserCenterOldVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIAlertView *nameAlertView;
    UITextField *nameTF;
    UIView *headView;
    int headViewInt;
    UIButton *testButton;
    BOOL isNotFirst; //是否第一次更改账号frame
}
@property (weak, nonatomic) IBOutlet UITableView *MyTablewView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;


@end

@implementation UserCenterOldVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstant.constant = kTopHeight;
    ifIphoneX(self.bottomConstant.constant = 34)
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinImage) name:@"WEIXINIMAGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WEIXINIMAGEFirst) name:@"WEIXINIMAGEFirst" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadView) name:gotoHeadImageOrWeiXinNoti object:nil];
    
    headViewInt = [[UserManager sharedInstance].user.iconId intValue];
    
    [_MyTablewView registerNib:[UINib nibWithNibName:@"UserCenterItemCell" bundle:nil] forCellReuseIdentifier:@"UserCenterItemCell"];
    [self setNavi];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    // 判断沙盒里是否有图片文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@HeadImage.png",[userdefaults stringForKey:@"123"]]];   // 保存文件的名称
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    if (result) {

        [self changeHeadWithPhone:[UIImage imageWithContentsOfFile:filePath]];
//        [testButton setBackgroundImage:[UIImage imageWithContentsOfFile:filePath] forState:UIControlStateNormal];
        [fileManager removeItemAtPath:filePath error:nil];
    }
    else {
    }
}

-(void)WEIXINIMAGEFirst{
    [UIUtil showProgressHUD:L(@"Changing heads") inView:self.view];
}
-(void)weixinImage{
    headViewInt = 13;
    [self setHeadImage];
    [UIUtil showProgressHUD:L(@"Changing heads") inView:self.view];
}
-(void)setNavi{
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = HBackColor;
    _MyTablewView.backgroundColor = HBackColor;
    self.title = L(@"Personal center");
    
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
}
-(void)showLeft{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - uitableviewDele
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 10;
            break;
        default:
            return 1;
            break;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 9;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
       return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        switch (section) {
            case 0:
                return 5;
                break;
            case 1:
                return 3;
                break;
            case 2:
                return 1;
                break;
//            case 3:
//                return 1;
//                break;
            
            default:
                return 0;
                break;
        }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *indentifierID2 = @"UserCenterItemCell";
        UserCenterItemCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifierID2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) //姓名
        {
            cell.titleLabel.text = L(@"name");
            cell.valueLabel.text = [UserManager sharedInstance].user.nickname;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.headButton setBackgroundImage:[UIImage imageNamed:@"1jiepin.png"] forState:UIControlStateNormal];
            cell.headButton.hidden = NO;
            if (cell.valueLabel.text.length >= 14) {
                cell.valueLabel.font = [UIFont systemFontOfSize:13];
            }
            testButton = cell.headButton;
            
        }
        else if (indexPath.row == 1) //头像
        {
            cell.titleLabel.text = L(@"Head portrait");
            cell.valueLabel.text = @"";
            cell.headButton.hidden = NO;
//            [cell.headButton addTarget:self action:@selector(changeHeadView) forControlEvents:UIControlEventTouchUpInside];
            cell.headButton.tag = 100;
            

            
            if ([[UserManager sharedInstance].user.iconId integerValue] >= 1 && [[UserManager sharedInstance].user.iconId integerValue] <= 12) {
                cell.headButton.layer.cornerRadius =  15;
                [cell.headButton.layer setMasksToBounds:YES];
                [cell.headButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ui2_user_icon%@",[UserManager sharedInstance].user.iconId]] forState:UIControlStateNormal];
            }else if([[UserManager sharedInstance].user.iconId integerValue] == 13 ){
                if (!headImageIsEmpty(USERMANAGER.user.headPicPath) ) {
                    cell.headButton.layer.cornerRadius =  15;
                    [cell.headButton.layer setMasksToBounds:YES];
                    [cell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:USERMANAGER.user.headPicPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"微众世界_头像0"]];
                }
            }else if( [[UserManager sharedInstance].user.iconId integerValue] == 14){
            
                    cell.headButton.layer.cornerRadius =  15;
                    [cell.headButton.layer setMasksToBounds:YES];
                    [cell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:USERMANAGER.user.upPicPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"微众世界_头像0"]];
            }
            else
            {
                [cell.headButton setBackgroundImage:[UIImage imageNamed:@"微众世界_头像0"] forState:UIControlStateNormal];
            }
            
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        else if (indexPath.row == 2) //账号
        {
            cell.titleLabel.text = L(@"Account");
            cell.valueLabel.text = [NSString stringWithFormat:@"%@%@",[UserManager sharedInstance].user.accoundID,@""];
            
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.headButton setBackgroundImage:[UIImage imageNamed:@"2jieping.png"] forState:UIControlStateNormal];
            cell.headButton.hidden = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!isNotFirst) {
                    CGRect rect = cell.valueLabel.frame;
                    rect.size.width =  rect.size.width - 18;
                    cell.valueLabel.frame = rect;
                    isNotFirst = YES;
                }
            });

        }
        else if (indexPath.row == 3) //
        {
            cell.titleLabel.text = L(@"Modify password");
            
            [cell.headButton setBackgroundImage:[UIImage imageNamed:@"4.jiepin.png"] forState:UIControlStateNormal];
            cell.headButton.hidden = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        else if (indexPath.row == 4) //
        {
            cell.titleLabel.text = L(@"WeiXin");
            
            [cell.headButton setBackgroundImage:[UIImage imageNamed:@"个人中心_绑定微信.png"] forState:UIControlStateNormal];
            cell.headButton.hidden = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    }
//    else if (indexPath.section == 1)
//    {
//        cell.valueLabel.text = @"";

//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        if (indexPath.row == 0)
//        {
//            cell.titleLabel.text = @"FM发射";
//            [cell.headButton setBackgroundImage:[UIImage imageNamed:@"5jiepin.png"] forState:UIControlStateNormal];
//            cell.headButton.hidden = NO;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.titleLabel.text = L(@"MapSetting");
            [cell.headButton setBackgroundImage:[UIImage imageNamed:@"3jiepin.png"] forState:UIControlStateNormal];
            cell.headButton.hidden = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 1)
        {
            cell.titleLabel.text = L(@"Message center");//好友分享
            [cell.headButton setBackgroundImage:[UIImage imageNamed:@"6jiepin.png"] forState:UIControlStateNormal];
            cell.headButton.hidden = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 2)
        {
            cell.titleLabel.text = L(@"About us");
            [cell.headButton setBackgroundImage:[UIImage imageNamed:@"7jiepin.png"] forState:UIControlStateNormal];
            cell.headButton.hidden = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            cell.titleLabel.text = L(@"Logout");
            cell.valueLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.headButton setBackgroundImage:[UIImage imageNamed:@"9jiepin.png"] forState:UIControlStateNormal];
            cell.headButton.hidden = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            nameAlertView  = [[UIAlertView alloc] initWithTitle:nil message:L(@"Enter the name you want") delegate:self cancelButtonTitle:L(@"Cancel") otherButtonTitles:L(@"OK"), nil];
            nameAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            nameTF = [nameAlertView textFieldAtIndex:0];
            nameAlertView.tag = 52;
            nameTF.delegate = self;
            nameAlertView.delegate = self;
            [nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [nameAlertView show];
        }
        if (indexPath.row == 1) {
//            MPWeakSelf(self)
//            [self setHeadBlock:^(){
//                 [weakself changeHeadView];
//             }];
            [self csqPhoneClick];
        }
        if (indexPath.row == 3) {
            [self.navigationController pushViewController:[ModifierPassword new] animated:YES];
        }
        if (indexPath.row == 4) {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                //微信) {
                
                if (headImageIsEmpty(USERMANAGER.user.headPicPath) ) {
                    showNewAlert(nil,L(@"Whether to bind WeChat heads"),nil,^(UIAlertAction *action){
                        SendAuthReq* req =[[SendAuthReq alloc ] init];
                        req.scope = @"snsapi_userinfo,snsapi_base";
                        req.state = @"app" ;
                        [WXApi sendReq:req];
                    })
                }else{
                    
                    showNewAlert(nil,L(@"Whether to unbind WeChat head"),nil,(^(UIAlertAction *action){
                        [UIUtil showProgressHUD:L(@"unbundling") inView:self.view];
                        [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
                        
                        NSDictionary * dic = nil;
                        headViewInt = 1;
                        dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                                @"iconId":[NSString stringWithFormat:@"%d",headViewInt],
                                @"wxHead":@"0"
                                };
//                        if (headImageIsEmpty(USERMANAGER.user.upPicPath)) {
//                            if (headViewInt == 13 || headViewInt == 14) {
//                                headViewInt = 1;
//                            }
//                            dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
//                                    @"iconId":[NSString stringWithFormat:@"%d",headViewInt],
//                                    @"wxHead":@"0"
//                                    };
//                        }else{
//                            if (headViewInt == 13) {
//                                headViewInt = 14;
//                            }
//
//                            dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
//                                    @"iconId":[NSString stringWithFormat:@"%d",headViewInt],
//                                    @"wxHead":CsqStringIsEmpty(USERMANAGER.user.upPicPath)
//                                    };
//                        }
                        
                        
                        [ZZXDataService HFZLRequest:@"user/modify-user" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
                         {
                             if ([data[@"code"]integerValue] == 0) {
                                 [UIUtil showToast:L(@"UnBindSuccess") inView:self.view];
                                 USERMANAGER.user.iconId = [NSString stringWithFormat:@"%d",headViewInt];
                                 USERMANAGER.user.headPicPath = @"0";
                                 if (headViewInt == 14) {
//                                     USERMANAGER.user.upPicPath = GetData();
                                 }
                                 [USERMANAGER save];
                                 [_MyTablewView reloadData];
                             }else{
                                 [UIUtil showToast:L(@"Failed") inView:self.view];
                             }
                         } fail:^(NSError *error)
                         {
//                             [UIUtil showToast:@"网络异常" inView:self.view];
                         }];
                        
                    }))
                    
                    
                }
            }else{
                [UIUtil showToast:L(@"You have not installed WeChat") inView:self.view];
            }

        }
    }

//    if (indexPath.section == 1) {
//        if (indexPath.row == 0) {
//            [self.navigationController pushViewController:[FMLaunchViewController new] animated:YES];
//        }
//    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[MapSettingViewController new] animated:YES];
        }
        if (indexPath.row == 1) {
            [self.navigationController pushViewController:[NaviCenterViewController new] animated:YES];
        }
        if (indexPath.row == 2) {
            [self.navigationController pushViewController:[AboutUsViewController new] animated:YES];
        }
    }
    if (indexPath.section == 2) {
        showNewAlert(nil,L(@"Are you sure to quit"),nil,^(UIAlertAction *action){
            [UIUtil showProgressHUD:L(@"Exiting...") inView:self.view];
            NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID)};
            [ZZXDataService HFZLRequest:@"user/logout" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
             {
                 if ([data[@"code"]integerValue] == 0) {
                 }else{
                 }
                 [UIUtil hideProgressHUD];
                 USERMANAGER.user.isLogined = NO;
                 USERMANAGER.user.token = @"";
                 USERMANAGER.seleCar = nil;
                 [USERMANAGER.GT10CarArray removeAllObjects];
                 [USERMANAGER save];
                 [APPDELEGATE setRootLoginVC];
             } fail:^(NSError *error)
             {
                 [UIUtil hideProgressHUD];
                 USERMANAGER.user.isLogined = NO;
                 USERMANAGER.user.token = @"";
                 USERMANAGER.seleCar = nil;
                 [USERMANAGER.GT10CarArray removeAllObjects];
                 [USERMANAGER save];
                 [APPDELEGATE setRootLoginVC];
             }];
        })
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidChange:(UITextField *)textField
{
    CGFloat kMaxLength = 16;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                [UIUtil showToast:L(@"Length must not exceed 16 digits") inView:self.view];
                //                [nameTF resignFirstResponder];
                double delayInSeconds = 0.5f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                               {
                                   textField.text = [toBeString substringToIndex:kMaxLength];
                               });
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
}
-(void)changeHeadView
{
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
        
        if (headImageIsEmpty(USERMANAGER.user.headPicPath)) {
            headScrollView.contentSize = CGSizeMake(80 * 12, 80);
            for (int i = 0; i < 12; i ++)
            {
                UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                imageButton.frame = CGRectMake(i * 80, 0, 80, 80);
                [imageButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ui2_user_icon%d",i + 1]] forState:UIControlStateNormal];
                imageButton.tag = 1001 + i;
                [imageButton addTarget:self action:@selector(selectHeadImage:) forControlEvents:UIControlEventTouchUpInside];
                [headScrollView addSubview:imageButton];
            }
        }else{
            headScrollView.contentSize = CGSizeMake(80 * 13, 80);
            for (int i = 0; i < 13; i ++)
            {
                if (i == 0) {
                    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    imageButton.frame = CGRectMake(i * 80 + 15, 15, 50, 50);
                    
                    [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:USERMANAGER.user.headPicPath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"微众世界_头像0"]];
                    
                    imageButton.layer.cornerRadius = 25;
                    imageButton.layer.masksToBounds = YES;
                    
                    imageButton.tag = 1001 + 12;
                    [imageButton addTarget:self action:@selector(selectHeadImage:) forControlEvents:UIControlEventTouchUpInside];
                    [headScrollView addSubview:imageButton];
                    
                }else{
                    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    imageButton.frame = CGRectMake((i ) * 80, 0, 80, 80);
                    [imageButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ui2_user_icon%d",i + 1 -1]] forState:UIControlStateNormal];
                    imageButton.tag = 1001 + i -1;
                    [imageButton addTarget:self action:@selector(selectHeadImage:) forControlEvents:UIControlEventTouchUpInside];
                    [headScrollView addSubview:imageButton];
                }
            }
            
        }
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
-(void)hiddenHeadView
{
    [headView removeFromSuperview];
    headView = nil;
}
-(void)selectHeadImage:(UIButton *)button
{
    headView.hidden = YES;
    int tag = (int)button.tag;
    headViewInt = tag - 1000;
    [self setHeadImage];
}
-(void)setHeadImage
{
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    NSDictionary *dic = nil;
    if (headViewInt == 13) {
        dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                @"iconId":[NSString stringWithFormat:@"%d",headViewInt],
                @"wxHead":CsqStringIsEmpty(USERMANAGER.user.headPicPath)
                };
    }else{
        dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                              @"iconId":[NSString stringWithFormat:@"%d",headViewInt]
                              };
    }
    [ZZXDataService HFZLRequest:@"user/modify-user" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil showToast:L(@"Success") inView:self.view];
             USERMANAGER.user.iconId = [NSString stringWithFormat:@"%d",headViewInt];
             [USERMANAGER save];
             [_MyTablewView reloadData];
         }else{
             [UIUtil showToast:L(@"Failed") inView:self.view];
         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
     }];
}
-(void)changeHeadWithPhone:(UIImage *)image{
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    NSDictionary *dic = nil;
    headViewInt = 14;
    
    dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
            @"iconId":[NSString stringWithFormat:@"%d",headViewInt]};
    
    NSMutableArray *PhotoDataArray = [NSMutableArray array];
    NSData *data = UIImageJPEGRepresentation(image,1);
    [PhotoDataArray addObject:data];
    
    [ZZXDataService HFZLRequest:@"user/modify-user" httpMethod:@"POST" params1:dic   file:@{@"files":PhotoDataArray,@"apiName":@"file"} success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil showToast:L(@"Success") inView:self.view];
             USERMANAGER.user.iconId = [NSString stringWithFormat:@"%d",headViewInt];
             NSDictionary *userDict = data[@"data"][@"userInfo"];
             if (!kDictIsEmpty(userDict)) {
                 USERMANAGER.user.upPicPath = GetData(userDict, @"headPicPath");
             }
             USERMANAGER.user.headPicPath = @"0";
             [USERMANAGER save];
             [_MyTablewView reloadData];
         }else{
             [UIUtil showToast:L(@"Failed") inView:self.view];
         }
         
//         NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//         // 判断沙盒里是否有图片文件
//         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//         NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@HeadImage.png",[userdefaults stringForKey:@"123"]]];   // 保存文件的名称
//         NSFileManager *fileManager = [NSFileManager defaultManager];
//         BOOL result = [fileManager fileExistsAtPath:filePath];
//         if (result) {
//             [fileManager removeItemAtPath:filePath error:nil];
//         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
     }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 52) {
        if (buttonIndex == 1) {
            if (kStringIsEmpty(nameTF.text)) {
                [UIUtil showToast:L(@"Name cannot be empty") inView:self.view];
            }else{
                [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
                NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                                      @"nickName":CsqStringIsEmpty(nameTF.text)
                                      };
                [ZZXDataService HFZLRequest:@"user/modify-user" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
                 {
                     if ([data[@"code"]integerValue] == 0) {
                         [UIUtil showToast:L(@"Success") inView:self.view];
                         USERMANAGER.user.nickname = nameTF.text;
                         [USERMANAGER save];
                         [_MyTablewView reloadData];
                     }else{
                         [UIUtil showToast:@"" inView:self.view];
                     }
                 } fail:^(NSError *error)
                 {
//                     [UIUtil showToast:@"网络异常" inView:self.view];
                 }];

            }
        }
    }
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
