//
//  CarInfoVC.m
//  FHZL
//
//  Created by hk on 17/12/21.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "CarInfoVC.h"
#import "Header.h"
#import "CustomeCsqButton.h"
#import "APNSetingViewController.h"
#import "FlowQueryViewController.h"
#import "Masonry.h"
@interface CarInfoVC ()
{
    UIButton * rightButton;
    UIScrollView *headScrollView;
    NSString* icoStr;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *apnCenterX_constant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inquiryCenterX_Constant;


@property (weak, nonatomic) IBOutlet UIImageView *APNImage;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *simLabel;
@property (weak, nonatomic) IBOutlet UILabel *carType;
@property (weak, nonatomic) IBOutlet UIButton *unBindButton;
@property (weak, nonatomic) IBOutlet UILabel *unBindLabel;

@property (weak, nonatomic) IBOutlet UIButton *inquiryButton;
@property (weak, nonatomic) IBOutlet UILabel *IMEILabel;
@property (weak, nonatomic) IBOutlet UILabel *IMISLabel;
@property (weak, nonatomic) IBOutlet UILabel *activateLabel;


@property (weak, nonatomic) IBOutlet UILabel *EditCarLabel;
@property (weak, nonatomic) IBOutlet UILabel *EditSimLabel;
@property (weak, nonatomic) IBOutlet UITextField *EditCarTF;
@property (weak, nonatomic) IBOutlet UITextField *EditSIMTF;
@property (weak, nonatomic) IBOutlet UIView *EditCarBackView;
@property (weak, nonatomic) IBOutlet UILabel *lastDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBottomConstraint;

@end

@implementation CarInfoVC
- (IBAction)unBind:(id)sender {
    showNewAlert(L(@"Is it determined to unbind the device"),nil,nil,(^(UIAlertAction *act){
        [UIUtil showProgressHUD:nil inView:self.view];
        NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                              @"macId":CsqStringIsEmpty(_carModel.macId)
                              };
        [ZZXDataService HFZLRequest:@"user/dev-relieve" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
         {
             
             if ([data[@"code"]integerValue] == 0) {
                 [UIUtil showToast:L(@"UnBindSuccess") inView:self.view];
                 CSQ_DISPATCH_AFTER(1.5, ^{
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"UnBindSuccess" object:nil];
                     [self showLeft];
                 })
             }else{
               
             }
         } fail:^(NSError *error)
         {
//             [UIUtil showToast:@"网络异常" inView:self.view];
         }];
    }))
}
- (IBAction)apnSet:(id)sender {
    APNSetingViewController *apnSetVC = [[APNSetingViewController alloc]init];
    [self.navigationController pushViewController:apnSetVC animated:YES];
}
- (IBAction)queryTraffic:(id)sender {
    FlowQueryViewController  *apnSetVC = [FlowQueryViewController shareInstance];
    apnSetVC.macIdStr = _carModel.iccid;
    [self.navigationController pushViewController:apnSetVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    ifIphoneX(self.topConstant.constant = kTopHeight + 15)
    self.queryLabel.text = L(@"Flow recharge");
    self.unBindLabel.text = L(@"Unbound");
    self.apnLabel.text = L(@"APN settings");
    self.EditCarLabel.text = L(@"License plate:");
    [self setNavi];
    [self setInfo];
    [self getDeviceInfo];
    [self isEdit:rightButton.selected];
    DISPATCH_ON_MAIN_THREAD((^{
        CGRect rect = _EditCarBackView.bounds;
        CGFloat width = 65;
        CGFloat height = 65;
        NSArray *imageArray = @[@"车子类型_0.png",@"车子类型_1.png",@"车子类型_2.png",@"车子类型_3.png",@"车子类型_4.png",@"车子类型_5.png",@"车子类型_6.png",@"车子类型_7.png",@"车子类型_8.png",];
        headScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, 65)];
        headScrollView.contentSize = CGSizeMake(65 * imageArray.count, 65);
        headScrollView.backgroundColor  = [UIColor clearColor];
        headScrollView.showsHorizontalScrollIndicator = NO;
        [_EditCarBackView addSubview:headScrollView];
        for (int i = 0;  i < imageArray.count; i ++) {
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.frame = CGRectMake(i * 65, 0, 65, 65);
            [imageButton setBackgroundImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
//            [imageButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateSelected];
//            imageButton.layer.borderWidth = 2;
//            imageButton.layer.borderColor = [UIColor clearColor].CGColor;
//            imageButton.layer.cornerRadius = 32.5;
//            imageButton.layer.masksToBounds = YES;

            imageButton.tag = 1000 + i;
            [imageButton addTarget:self action:@selector(selectHeadImage:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.backgroundColor = [UIColor clearColor];
            [headScrollView addSubview:imageButton];
        }
        
        if ([USERMANAGER.user.loginType isEqualToString:@"1"]) {
            self.unBindButton.hidden = YES;
            self.unBindLabel.hidden = YES;
            self.apnCenterX_constant.constant = -80;
//            [self.APNButton mas_makeConstraints:^(MASConstraintMaker *make) { make.centerX.mas_equalTo(self.APNButton.superview).multipliedBy(0.6);
//            }];
            
        }
        
    }));
    
}

-(void)selectHeadImage:(UIButton *)button{
    int tag = (int)button.tag - 1001 + 1;
//    tag = (tag >= 9 ? 0:tag);
    icoStr = [NSString stringWithFormat:@"%d",tag];
    for (UIButton *but in headScrollView.subviews) {
//        but.selected = NO;
//        but.layer.borderColor = [UIColor clearColor].CGColor;
        but.backgroundColor = [UIColor clearColor];
    }
    button.selected = YES;
//    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.backgroundColor = RGB(21, 156, 255);
}

-(void)isEdit:(BOOL)isEdit{
    if (isEdit) {
        _EditCarTF.hidden = NO;
        _EditCarLabel.hidden = NO;
        _EditSimLabel.hidden = NO;
        _EditSIMTF.hidden = NO;
        _EditSIMTF.text = CsqStringIsEmpty(_carModel.sim);
        _EditCarTF.text = CsqStringIsEmpty(_carModel.macName);
        _EditCarBackView.hidden = NO;
        
        _carNumberLabel.hidden = YES;
        _simLabel.hidden = YES;
        
        int a = [_carModel.ico intValue];
        if (a == 0) {
            a = 9;
        }
        a = a + 1000;
        UIButton *but = (UIButton *)[headScrollView viewWithTag:a];
        [self selectHeadImage:but];
    }
    else{
        _EditCarTF.hidden = YES;
        _EditCarLabel.hidden = YES;
        _EditSimLabel.hidden = YES;
        _EditSIMTF.hidden = YES;
        _EditCarBackView.hidden = YES;
        
        _carNumberLabel.hidden = NO;
        _simLabel.hidden = NO;
    }
}


-(void)setInfo{
    if ([_carModel.ico intValue] < 0 || [_carModel.ico intValue] > 9) {
        _carModel.ico = @"0";
    }
    
    
//    if (!kStringIsEmpty(_carModel.ico)) {
//
//    }
    _carImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"车子类型_%d.png",[_carModel.ico intValue]]];
    icoStr = _carModel.ico ;
    if([icoStr intValue] <0 || [icoStr intValue] >9){
        icoStr = @"0";
    }

    _carNumberLabel.text = [NSString stringWithFormat:@"%@:%@",L(@"License plate"),CsqStringIsEmpty(_carModel.macName)];
    _simLabel.text = [NSString stringWithFormat:@"SIM:%@",CsqStringIsEmpty(_carModel.sim)];
    _carType.text = [NSString stringWithFormat:@"%@:%@",L(@"Type of device"),CsqStringIsEmpty(_carModel.macType)];
    
    if (isIphone4) {
        _labelBottomConstraint.constant = -60;
    }
    
    _IMEILabel.text = [NSString stringWithFormat:@"IMEI:%@",CsqStringIsEmpty(_carModel.macId)];
    _IMISLabel.text = [NSString stringWithFormat:@"IMIS:%@",CsqStringIsEmpty(_carModel.imis)];
    _activateLabel.text = [NSString stringWithFormat:@"%@:%@",L(@"Activation date"),[UserManager getDateDisplayString:[_carModel.activateDate longLongValue]]];
    
    NSInteger day = ([_carModel.effectiveDate longLongValue] - [_carModel.activateDate longLongValue])/1000/(24*3600);
    _userDateLabel.text = [NSString stringWithFormat:@"%@:%@",L(@"Validity"),day > 0 ?[UserManager getDateDisplayShortString:[_carModel.effectiveDate longLongValue]]:@""];
    _lastDayLabel.text = [NSString stringWithFormat:@"%ld%@",day > 0 ?day:0,L(@"day")];
}


-(void)getDeviceInfo{
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(_carModel.macId)
                          };
    [ZZXDataService HFZLRequest:@"dev/get-dev" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil hideProgressHUD];
             NSDictionary *dataDict = data[@"data"];
             if (!kDictIsEmpty(dataDict)) {
                 _carModel.macId = dataDict[@"macId"];
                 _carModel.macType = dataDict[@"macType"];
                 _carModel.macName = dataDict[@"macName"];
                 _carModel.imis = dataDict[@"imsi"];
                 _carModel.sim = dataDict[@"sim"];
                 _carModel.activateDate = dataDict[@"activateDate"];
                 _carModel.effectiveDate = dataDict[@"effectiveDate"];
                 _carModel.iccid  = dataDict[@"iccid"];
                 [self setInfo];
             }
         }else{
             [UIUtil showToast:L(@"For failure") inView:self.view];
         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
     }];
}
-(void)SaveInfo{
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(_carModel.macId),
                          @"macName":CsqStringIsEmpty(_EditCarTF.text),
                          @"sim":CsqStringIsEmpty(_EditSIMTF.text),
                          @"ico":CsqStringIsEmpty(icoStr)
                          };
    [ZZXDataService HFZLRequest:@"dev/update-dev" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil showToast:L(@"Save successfully") inView:self.view];
             _carModel.sim = _EditSIMTF.text;
             _carModel.macName = _EditCarTF.text;
             _carModel.ico = icoStr;
             [self setInfo];
             [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeInfo" object:nil];
         }else{
             [UIUtil showToast:L(@"Save failed") inView:self.view];
         }
         rightButton.selected = NO;
         [self isEdit:rightButton.selected];
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
         rightButton.selected = NO;
         [self isEdit:rightButton.selected];
     }];
}


-(void)setNavi{
    self.title = L(@"Device information");
    self.view.backgroundColor = HBackColor;
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
    
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button2 setBackgroundImage:[UIImage imageNamed:@"设备信息_标题区_编辑_N.png"] forState:UIControlStateNormal];
//    [button2 setBackgroundImage:[UIImage imageNamed:@"设备信息_标题区_编辑_P.png"] forState:UIControlStateHighlighted];
    [rightButton setTitle:L(@"edit") forState:UIControlStateNormal];
    [rightButton setTitle:L(@"save") forState:UIControlStateSelected];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [rightButton setTintColor:[UIColor clearColor]];
    [rightButton addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 40, 25);
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,item2, nil];
}
-(void)showLeft{
    //    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRight{
    if (!rightButton.selected) {
        rightButton.selected = !rightButton.selected;
        [self isEdit:rightButton.selected];
    }else{
        [self SaveInfo];
    }
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
