//
//  InstructionVC.m
//  FHZL
//
//  Created by hk on 2018/1/10.
//  Copyright © 2018年 hk. All rights reserved.
//
#import "Header.h"
#import "InstructionVC.h"
#import "noPictureCell.h"
#import "InsHistoryVC.h"
#import "FXXTalertView.h"
#import "WorkModeSele.h"
#import "AppData.h"
#import "GT121HuiChuanVC.h"
#import "Gt121Model.h"
#import "FHZLspeedSetView.h"
typedef enum {
    ZhenDong = 1001,
    SOS = 1002    //SOS指定位长传间隔   将错就错
}CSQPickType;
@interface InstructionVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    UIView *navView;
    int scrollViewPage;
    UITableView *OpenTableview;
    UITableView *SetTableview;
    NSArray *setArray;
    NSArray *OpenArray;
    BOOL isGT_12;
    UIView *pickBackView;
    UIView *hiddenView;
    int selectInt;
    int SOSint;
    FXXTalertView *FXXTalertVIew;
    FXXTalertView *tipAlertView;
    FHZLspeedSetView *speedLimitView;
    int ModeInt;
    int selectModeInt;
    WorkModeSele *workModeSeleView;
    UIView  *ModePickBackView;
    UIPickerView *ModePickView;
    UIView *TimePickBackView;
    UIPickerView *TimePickView;
    
    NSInteger HourSelectInt;
    NSInteger MinSelectInt;
}

@property (weak, nonatomic) IBOutlet UIScrollView *musciScroll;
@property (nonatomic,strong)Gt121Model* gt121ModelA;

@end

@implementation InstructionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavi];
    selectInt = [_insStateModel.vibAlarm intValue];
    SOSint = [_insStateModel.upTime intValue];
    if (SOSint != 20 && SOSint != 60 && SOSint != 600 && SOSint != 3600 && SOSint != 1 && SOSint != 30) {
        if (_macType == GT_52) {
            SOSint = 30;
        }else{
            SOSint = 20;
        }
    }
    if (_macType == DR30) {
        OpenArray = @[L(@"Blind district alarm"),L(@"Low electrical alarm"),L(@"ACC alarm"),L(@"Working mode")];
        setArray = @[L(@"Location upload interval"),L(@"Restore factory settings"),L(@"Version"),L(@"Custom instruction")];
    }else if (_macType == GT_31) {
        OpenArray = @[L(@"Blind district alarm"),L(@"Low electrical alarm")];//,@"ACC报警",@"工作模式"
        setArray = @[L(@"Location upload interval"),L(@"Restore factory settings"),L(@"Version"),L(@"Custom instruction")];
    }
    else if (_macType == GT_51) {
        OpenArray = @[L(@"Oil break power off"),L(@"Blind district alarm"),L(@"ACC alarm"),L(@"Low electrical alarm"),L(@"External power failure alarm"),L(@"Vibration alarm")];
        setArray = @[L(@"Location upload interval"),L(@"Restore factory settings"),L(@"Version"),L(@"Custom instruction")];
    }
    else if (_macType == GT_52) {
        OpenArray = @[L(@"Oil break power off"),L(@"External power failure alarm"),L(@"Overspeed alarm settings")];//
        setArray = @[L(@"Location upload interval"),L(@"Restore factory settings"),L(@"Custom instruction"),L(@"Overspeed alarm settings")];
    }
    else if (_macType == GT_121) {
        
//        self.gt121Model = [[Gt121Model alloc]init];
        [self getGT121Model];
        OpenArray = @[L(@"Anti-demolition alarm switch")];
        setArray = @[L(@"Backpass setup"),L(@"Restore factory settings"),L(@"Custom instruction"),L(@"Overspeed alarm settings")];
    }
    else{
        OpenArray = @[L(@"Oil break power off"),L(@"Arming"),L(@"Door alarm"),L(@"Blind district alarm"),L(@"ACC alarm"),L(@"Low electrical alarm"),L(@"External power failure alarm"),L(@"Displacement alarm"),L(@"Vibration alarm")];
        setArray = @[L(@"Location upload interval"),L(@"SOS phone number setting"),L(@"Restore factory settings"),L(@"Version"),L(@"Custom instruction")];
    }
    
    if (_macType == DR30) {
        CGFloat modeFloat = [_insStateModel.mode intValue];
        if (modeFloat != 1 && modeFloat != 3) {
            selectModeInt = 0;
        }else if(modeFloat == 1){
            selectModeInt = 0;
        }else if (modeFloat == 3){
            if ([_insStateModel.modeTime intValue] == 0) {
                selectModeInt = 1;
            }else{
                selectModeInt = 2;
            }
        }
    }
    
    NSArray * array = [_insStateModel.modeTime componentsSeparatedByString:@":"];
    if (array.count >= 2) {
        array = [[UserManager changeHourDataStrFromZeroToLocal:_insStateModel.modeTime] componentsSeparatedByString:@":"];
        NSString *hourStr = array[0];
        NSString *minStr = array[1];
        HourSelectInt = [hourStr integerValue];
        MinSelectInt = [minStr integerValue];
    }else{
        HourSelectInt = 10;
        MinSelectInt = 0;
    }
    NSDictionary *userDict = @{@"mode":@"1",@"timing":@"0",@"week":@"0",@"weekTime":@"0000",@"weekSel":@[],@"alarmClock":@"0",@"alarmClockTime":@[],@"removeAl":@"0"};
    self.gt121ModelA = [Gt121Model provinceWithDictionary:userDict];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (!OpenTableview) {
        [self setViews];
    }
}

-(void)setNavi{
    self.navigationController.navigationBar.translucent = NO;
    self.title = L(@"instructions");
    [self addNavigationItemWithImageNames
     :@[@"指令_标题栏_历史记录_N.png",@"指令_内容区_参数同步_N"] isLeft:NO target:self action:@selector(showRight:) tags:@[@1001,@1000]];
    
    navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    NSArray *buArray = @[L(@"Functional switch"),L(@"Parameter Settings")];
    for (int i = 0; i < buArray.count; i++) {
        UIButton *buttonT = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonT.frame = CGRectMake(SCREENWIDTH /buArray.count * (i), 0, SCREENWIDTH /buArray.count, 44);
        buttonT.backgroundColor = [UIColor clearColor];
        [buttonT setTitle:buArray[i] forState:UIControlStateNormal];
        buttonT.titleLabel.font = [UIFont systemFontOfSize:18];
        [buttonT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [buttonT setTitleColor:HTextColor forState:UIControlStateSelected];
        buttonT.tag = 100 + i;
        [buttonT addTarget:self action:@selector(changeM:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:buttonT];
        if (i == 0) {
            buttonT.selected = YES;
            scrollViewPage = 0;
        }
        if (i == 0 ) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(buttonT.frame.size.width - 1, 10, 1, buttonT.frame.size.height - 20)];
            label.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.4];
            [buttonT addSubview:label   ];
        }
    }
}
-(void)changeM:(UIButton*)bu{
    for (UIButton *button in navView.subviews) {
        button.selected = NO;
    }
    bu.selected = YES;
    int i = bu.tag - 100;
    [UIView animateWithDuration:0.3 animations:^{
        [_musciScroll scrollRectToVisible:CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, SCREENHEIGHT - 124 - 54) animated:YES];
        scrollViewPage = i;
    } completion:^(BOOL finished){
    }];
}
-(void)setViews{
    float width = _musciScroll.frame.size.width ;
    float heigth = _musciScroll.frame.size.height;
    _musciScroll.contentSize = CGSizeMake(width * 2, heigth);
    _musciScroll.showsHorizontalScrollIndicator = NO;
    _musciScroll.pagingEnabled = YES;
    _musciScroll.delegate = self;
    _musciScroll.bounces = NO;
    
    OpenTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width, heigth )];
    OpenTableview.delegate = self;
    OpenTableview.dataSource = self;
    OpenTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [OpenTableview registerNib:[UINib nibWithNibName:@"noPictureCell" bundle:nil] forCellReuseIdentifier:@"noPictureCell"];
    OpenTableview.backgroundColor = [UIColor clearColor];
    OpenTableview.bounces = NO;
    [_musciScroll addSubview:OpenTableview];
    
    SetTableview = [[UITableView alloc]initWithFrame:CGRectMake(width, 0, width, heigth )];
    SetTableview.delegate = self;
    SetTableview.dataSource = self;
    SetTableview.bounces = NO;
    SetTableview.backgroundColor = [UIColor clearColor];
    SetTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [SetTableview registerNib:[UINib nibWithNibName:@"noPictureCell" bundle:nil] forCellReuseIdentifier:@"noPictureCell"];
    [_musciScroll addSubview:SetTableview];
}
-(void)showLeft{
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRight:(id)sender{
    UIButton *but = (UIButton*)sender;
    switch (but.tag) {
        case 1001:
            {
                InsHistoryVC *insHistoryVC = [[InsHistoryVC alloc]init];
                [self.navigationController pushViewController:insHistoryVC animated:YES];
            }
            break;
        case 1000:
        {
            [UIUtil showProgressHUD:nil inView:self.view];
            [self synchro];

        }
            break;
            
        default:
            break;
    }
    
}
-(void)synchro{
    if (self.macType == GT_121) {
        [self getInstrInfo];
    }else{
        UISwitch *switCH = [UISwitch new];
        switCH.tag = 112;
        [self sendInstr:0 :switCH];
    }
}
-(void)getInstrInfo{
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(_insStateModel.macId)
                          };
    
    [ZZXDataService HFZLRequest:@"dev/get-dev-config" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil showToast:L(@"Success") inView:self.view];
             NSDictionary *userDict = data[@"data"];
             if (!kDictIsEmpty(userDict)) {
                 InstructionStateModel *model = [InstructionStateModel provinceWithDictionary:userDict];
                _insStateModel = model;
                [OpenTableview reloadData];
                [SetTableview reloadData];
             }
         }else{
             [UIUtil showToast:L(@"Failed") inView:self.view];
         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
     }];
}
#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == OpenTableview) {
        return OpenArray.count;
    }
    else{
        return setArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*identifier = @"noPictureCell";
    if (tableView == OpenTableview ) {
  
        noPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.nameLabel.text = OpenArray[indexPath.row];
        
        cell.lineLabel.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell点击效果
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        if (![cell.nameLabel.text isEqualToString:L(@"Vibration alarm")]) {
            cell.switchOn.hidden = NO;
            cell.nextPicture.hidden = YES;
        }
        if (_macType == DR30) {
            switch (indexPath.row) {
                
//                case 0:
//                    cell.switchOn.tag = 100 + 2;
//                    [cell.switchOn setOn:[_insStateModel.doorAlarm intValue]  == 0?NO:YES];
//                    break;
                case 0:
                {
                    cell.switchOn.tag = 100 + 3;
                    [cell.switchOn setOn:[_insStateModel.blindAlarm intValue]  == 0?NO:YES];
                }
                    break;
                
                case 1:
                {
                    cell.switchOn.tag = 100 + 5;
                    [cell.switchOn setOn:[_insStateModel.lowbat intValue]  == 0?NO:YES];
                }
                    break;
                case 2:
                {
//                    cell.switchOn.tag = 100 + 6;
//                    [cell.switchOn setOn:[_insStateModel.powerAlarm intValue]  == 0?NO:YES];
                    cell.switchOn.tag = 100 + 4;
                    [cell.switchOn setOn:[_insStateModel.accAlarm intValue]  == 0?NO:YES];
                }
                    break;
                case 3:{
                    cell.switchOn.hidden = YES;
                    cell.nextPicture.hidden = NO;
                 
                }
                    break;
                default:
                    break;
            }
        }else if (_macType == GT_31) {
            switch (indexPath.row) {
                case 0:
                {
                    cell.switchOn.tag = 100 + 3;
                    [cell.switchOn setOn:[_insStateModel.blindAlarm intValue]  == 0?NO:YES];
                }
                    break;
                    
                case 1:
                {
                    cell.switchOn.tag = 100 + 5;
                    [cell.switchOn setOn:[_insStateModel.lowbat intValue]  == 0?NO:YES];
                }
                    break;
                default:
                    break;
            }
        }else if (_macType == GT_51) {
            
            switch (indexPath.row) {
                case 0:
                {
                    [cell.switchOn setOn:[_insStateModel.re intValue] == 0?NO:YES];
                    cell.switchOn.tag = 100 + 0;
                }
                    break;

                case 1:
                {
                    [cell.switchOn setOn:[_insStateModel.blindAlarm intValue]  == 0?NO:YES];
                    cell.switchOn.tag = 100 + 3;
                }
                    break;
                case 2:
                {
                    [cell.switchOn setOn:[_insStateModel.accAlarm intValue]  == 0?NO:YES];
                    cell.switchOn.tag = 100 + 4;

                }
                    break;
                case 3:
                {
                    [cell.switchOn setOn:[_insStateModel.lowbat intValue]  == 0?NO:YES];
                    cell.switchOn.tag = 100 + 5;

                }
                    break;
                case 4:
                {
                    [cell.switchOn setOn:[_insStateModel.powerAlarm intValue]  == 0?NO:YES];
                    cell.switchOn.tag = 100 + 6;

                }
                    break;

                case 5:{
                    NSString *str = _insStateModel.vibAlarm;
                    str = [str isEqualToString:@"4"]?L(@"Level Four"):[str isEqualToString:@"3"]?L(@"Level Three"):[str isEqualToString:@"2" ]?L(@"Level Two"):[str isEqualToString:@"1" ]?L(@"Level One"):L(@"OFF");
                    cell.nameLabel.text = [NSString stringWithFormat:@"%@  %@",L(@"Vibration alarm"),str];
                }
                    break;
                default:
                    break;
                }
        }
        else if (_macType == GT_52) {
            switch (indexPath.row) {
                case 0:
                {
                    [cell.switchOn setOn:[_insStateModel.re intValue] == 0?NO:YES];
                    cell.switchOn.tag = 100 + 0;
                }
                    break;
                case 1:
                {
                    [cell.switchOn setOn:[_insStateModel.powerAlarm intValue]  == 0?NO:YES];
                    cell.switchOn.tag = 100 + 6;
                }
                    break;
                case 2:
                {
                    [cell.switchOn setOn:[_insStateModel.speedLimit intValue]  == 0 && [_insStateModel.speedLimitRunTime intValue]  == 0?NO:YES];
                    cell.switchOn.tag = 100 + 17;
                }
                    break;
                default:
                    break;
            }
        }
        else if (_macType == GT_121) {
            
            switch (indexPath.row) {
                case 0:
                {
                    [cell.switchOn setOn:[self.gt121ModelA.removeAl intValue] == 0?NO:YES];
                    cell.switchOn.tag = 100 + 15;
                }
                    break;

                default:
                    break;
            }
        }
        else {
            cell.switchOn.tag = 100 + indexPath.row;
            switch (indexPath.row) {
                case 0:
                    [cell.switchOn setOn:[_insStateModel.re intValue] == 0?NO:YES];
                    break;
                case 1:
                    [cell.switchOn setOn:[_insStateModel.de intValue] == 0?NO:YES];
                    break;
                case 2:
                    [cell.switchOn setOn:[_insStateModel.doorAlarm intValue]  == 0?NO:YES];
                    break;
                case 3:
                {
                    [cell.switchOn setOn:[_insStateModel.blindAlarm intValue]  == 0?NO:YES];
                }
                    break;
                case 4:
                {
                    [cell.switchOn setOn:[_insStateModel.accAlarm intValue]  == 0?NO:YES];
                }
                    break;
                case 5:
                {
                    [cell.switchOn setOn:[_insStateModel.lowbat intValue]  == 0?NO:YES];
                }
                    break;
                case 6:
                {
                    [cell.switchOn setOn:[_insStateModel.powerAlarm intValue]  == 0?NO:YES];
                }
                    break;
                case 7:{
                    [cell.switchOn setOn:[_insStateModel.moviAlarm intValue]  == 0?NO:YES];
                }
                    break;
                case 8:{
                    NSString *str = _insStateModel.vibAlarm;
                    str = [str isEqualToString:@"4"]?L(@"Level Four"):[str isEqualToString:@"3"]?L(@"Level Three"):[str isEqualToString:@"2" ]?L(@"Level Two"):[str isEqualToString:@"1" ]?L(@"Level One"):L(@"OFF");
                    cell.nameLabel.text = [NSString stringWithFormat:@"%@  %@",L(@"Vibration alarm"),str];
                }
                    break;
                default:
                    break;
            }
        }
        [cell.switchOn addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    else{
        
        noPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.nameLabel.text = setArray[indexPath.row];
        
        cell.lineLabel.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置cell点击效果
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        if (_macType == DR30 || _macType == GT_31 || _macType == GT_51) {
            switch (indexPath.row) {
                case 0:
                {
                    if (_macType == GT_31) {
                        switch (SOSint) {
                            case 1:
                                cell.contentLabel.text = [NSString stringWithFormat:@"%d%@",SOSint,L(@"s")];
                                break;
                            case 20:
                                cell.contentLabel.text = [NSString stringWithFormat:@"%d%@",SOSint,L(@"s")];
                                break;
                            case 60:
                                cell.contentLabel.text = [NSString stringWithFormat:@"60%@",L(@"s")];
                                break;
                            case 600:
                                cell.contentLabel.text = [NSString stringWithFormat:@"10%@",L(@"min")];
                                break;
                            case 3600:
                                cell.contentLabel.text = [NSString stringWithFormat:@"1%@",L(@"h")];
                                break;
                            default:
                                break;
                        }
                    }else{
                    switch (SOSint) {
                        case 20:
                            cell.contentLabel.text = [NSString stringWithFormat:@"%d%@",SOSint,L(@"s")];
                            break;
                        case 60:
                            cell.contentLabel.text = [NSString stringWithFormat:@"60%@",L(@"s")];
                            break;
                        case 600:
                            cell.contentLabel.text = [NSString stringWithFormat:@"10%@",L(@"min")];
                            break;
                        case 3600:
                            cell.contentLabel.text = [NSString stringWithFormat:@"1%@",L(@"h")];
                            break;
                        default:
                            break;
                    }
                    }
                }
                    break;
//                case 1:
//                {
//                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",_insStateModel.sosPhone1];
//                }
//                    break;
//                case 2:
//                {
//
//                }
//                    break;
                case 2:
                {
                    cell.contentLabel.text = _insStateModel.version;
                }
                    break;
                    
                default:
                    break;
            }
        }else if(_macType == GT_121){
            
                
                switch (indexPath.row) {
                    case 0:
                    {
                        
                    }
                        break;
                    case 1:
                    {
                        
                    }
                        break;
                    case 2:
                    {
                        cell.contentLabel.text = _insStateModel.version;
                    }
                        break;
                    case 3:
                    {
                        
                    }
                        break;
                        
                    default:
                        break;
                }
        }
        else if(_macType == GT_52){
            
            
            switch (indexPath.row) {
                case 0:
                {
                    switch (SOSint) {
                    case 20:
                        cell.contentLabel.text = [NSString stringWithFormat:@"%d%@",SOSint,L(@"s")];
                        break;
                    case 30:
                        cell.contentLabel.text = [NSString stringWithFormat:@"30%@",L(@"s")];
                        break;
                    case 60:
                        cell.contentLabel.text = [NSString stringWithFormat:@"60%@",L(@"s")];
                        break;
                    case 600:
                        cell.contentLabel.text = [NSString stringWithFormat:@"10%@",L(@"min")];
                        break;
                    case 3600:
                        cell.contentLabel.text = [NSString stringWithFormat:@"1%@",L(@"h")];
                        break;
                    default:
                        break;
                    }
                    
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                case 2:
                {
                    
                }
                    break;
                
                    
                default:
                    break;
            }
        }
        
        else{
        
        switch (indexPath.row) {
            case 0:
            {
                switch (SOSint) {
                    case 20:
                    case 1:
                        cell.contentLabel.text = [NSString stringWithFormat:@"%d%@",SOSint,L(@"s")];
                        break;
                    case 60:
                        cell.contentLabel.text = [NSString stringWithFormat:@"60%@",L(@"s")];
                        break;
                    case 600:
                        cell.contentLabel.text = [NSString stringWithFormat:@"10%@",L(@"min")];
                        break;
                    case 3600:
                        cell.contentLabel.text = [NSString stringWithFormat:@"1%@",L(@"h")];
                        break;
                    default:
                        break;
                }
            }
                break;
            case 1:
            {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@",_insStateModel.sosPhone1];
            }
                break;
            case 2:
            {
               
            }
                break;
            case 3:
            {
                cell.contentLabel.text = _insStateModel.version;
            }
                break;
           
            default:
                break;
        }
        }
        //    cell.switCH.tag = 100 + indexPath.row;
        //    [cell.switCH addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == OpenTableview) {
        switch (indexPath.row) {
            case 8:
            {
                [self setPickBackView:ZhenDong];
            }
                break;
            case 5:
            {
                if (_macType == GT_51) {
                    [self setPickBackView:ZhenDong];
                }
            }
                break;
            case 3:
            {
                if (_macType == DR30) {
                    [self workModeSele];
                }
            }
                break;
            default:
                break;
        }
    }else if(tableView == SetTableview){
        if ((_macType == DR30 || _macType == GT_31 || _macType == GT_51)) {
            switch (indexPath.row) {
                case 0:
                {
                    [self setPickBackView:SOS];
                }
                    break;

                case 1:
                {
                    showNewAlert(L(@"Are you sure you want to restore factory settings?"),L(@"ResetDeviceRemind"),nil,^(UIAlertAction *act){
                        UISwitch *switCH = [UISwitch new];
                        switCH.tag = 111;
                        [self sendInstr:0 :switCH];
                        [UIUtil showProgressHUD:nil inView:self.view];
                    })
                }
                    break;
                case 2:{
                    [UIUtil showToast:L(@"This is the latest version at this time") inView:self.view];
                }break;
                case 3:{
                    [self tipView];
                }break;
                case 4:{
                    [self speedTipView];
                }break;
                    
                default:
                    break;
            }
        }
        else if (_macType == GT_52) {
            switch (indexPath.row) {
                case 0:
                {
                    [self setPickBackView:SOS];
                }
                    break;
                    
                case 1:
                {
                    showNewAlert(L(@"Are you sure you want to restore factory settings?"),L(@"ResetDeviceRemind"),nil,^(UIAlertAction *act){
                        UISwitch *switCH = [UISwitch new];
                        switCH.tag = 111;
                        [self sendInstr:0 :switCH];
                        [UIUtil showProgressHUD:nil inView:self.view];
                    })
                }
                    break;
                case 2:{
                    [self tipView];
                }break;
                case 3:{
                    [self speedTipView];
                }break;
                
                default:
                    break;
            }
        }
        else if(_macType == GT_121){
            switch (indexPath.row) {
                case 0:
                {
                    //gt121待修改
                    MPWeakSelf(self)
                    GT121HuiChuanVC *vc = [[GT121HuiChuanVC alloc]init];
                    vc.gt121Model = [[Gt121Model alloc]initWithMode:self.gt121ModelA];
 
                    [vc setChangeGT121:^(Gt121Model* gt121Model){
                        weakself.gt121ModelA = gt121Model;
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    showNewAlert(L(@"Are you sure you want to restore factory settings?"),L(@"ResetDeviceRemind"),nil,^(UIAlertAction *act){
                        UISwitch *switCH = [UISwitch new];
                        switCH.tag = 111;
                        [self sendInstr:0 :switCH];
                        [UIUtil showProgressHUD:nil inView:self.view];
                    })
                }
                    break;
                case 2:
                {
                    [UIUtil showToast:L(@"This is the latest version at this time") inView:self.view];
                }
                    break;
                case 3:{
                     [self tipView];
                }break;
                
                    
                default:
                    break;
            }
        }
        else{
        switch (indexPath.row) {
            case 0:
            {
                [self setPickBackView:SOS];
            }
                break;
            case 1:
            {
                [self SOSview];
            }
                break;
            case 2:
            {
                showNewAlert(L(@"Are you sure you want to restore factory settings?"),L(@"ResetDeviceRemind"),nil,^(UIAlertAction *act){
                    UISwitch *switCH = [UISwitch new];
                    switCH.tag = 111;
                    [self sendInstr:0 :switCH];
                    [UIUtil showProgressHUD:nil inView:self.view];
                })
            }
                break;
            case 3:{
                [UIUtil showToast:L(@"This is the latest version at this time") inView:self.view];
            }break;
            case 4:{
                [self tipView];
            }break;
                
            default:
                break;
        }
        }
    }
    
    
}
-(void)setSwitch:(UISwitch*)switCH{
    [UIUtil showProgressHUD:nil inView:self.view];
    if (switCH.tag == 117 ) {
        speedLimitView = [[FHZLspeedSetView alloc]init];
        if (switCH.on) {
//            [self speedTipView];
            speedLimitView.textFile1.text = @"120";
            speedLimitView.textFile3.text = @"10";
            [self sendInstr:0 :switCH];
//            [UIUtil showProgressHUD:nil inView:[AppData theTopView]];
           
        }else{
            speedLimitView.textFile1.text = @"0";
            speedLimitView.textFile3.text = @"0";
            [self sendInstr:0 :switCH];
//            [UIUtil showProgressHUD:nil inView:[AppData theTopView]];
            
        }
        
    }else{
        [self sendInstr:0 :switCH];
    }
    
}
#pragma mark --发送指令
-(void)sendInstr:(int)intCount :(UISwitch*)switCH{
    NSLog(@"intCount = %d;",intCount);
    int tag = (int)switCH.tag - 100;
    NSString *instructionStr ;
    NSString *typeStr;
    switch (tag) {
            
        case 0:
        {
            instructionStr = [NSString stringWithFormat:@"RELAY,%@",switCH.on?@"1":@"0"];
            
            typeStr = @"RELAY";
        }
            break;
            //设防
        case 1:
        {
            instructionStr = [NSString stringWithFormat:@"DEFENCE,%@",switCH.on?@"1":@"0"];
            typeStr = @"DEFENCE";
        }
            break;
            //门
        case 2:
        {
            instructionStr = [NSString stringWithFormat:@"DOORAL,%@",switCH.on?@"1":@"0"];
            typeStr = @"DOORAL";
        }
            break;
            //盲区
        case 3:
        {
            instructionStr = [NSString stringWithFormat:@"BLINDAL,%@",switCH.on?@"1":@"0"];
            typeStr = @"BLINDAL";
        }
            break;
            //acc
        case 4:
        {
            instructionStr = [NSString stringWithFormat:@"ACCAL,%@",switCH.on?@"1":@"0"];
            typeStr = @"ACCAL";
        }
            break;
        //低电量
        case 5:
        {
            instructionStr = [NSString stringWithFormat:@"LOWBAT,%@",switCH.on?@"1":@"0"];
            typeStr = @"LOWBAT";
        }
            break;
        //能量
        case 6:
        {
            instructionStr = [NSString stringWithFormat:@"POWERAL,%@",switCH.on?@"1":@"0"];
            typeStr = @"POWERAL";
        }
            break;
        //移动
        case 7:
        {
            instructionStr = [NSString stringWithFormat:@"MOVIAL,%@",switCH.on?@"1":@"0"];
            typeStr = @"MOVIAL";
        }
            break;
        case 8:
        {
            instructionStr = [NSString stringWithFormat:@"VIBALM,%@",[NSString stringWithFormat:@"%d",selectInt]];
            typeStr = @"VIBALM";
        }
            break;
        case 9:  //设置上传间隔时间
        {
            instructionStr = [NSString stringWithFormat:@"UPLOAD,0,%@,%@",[NSString stringWithFormat:@"%d",SOSint],[NSString stringWithFormat:@"%d",SOSint]];
            typeStr = @"UPLOAD";
        }
            break;
        case 10:  //设置SOS号码
        {
            instructionStr = [NSString stringWithFormat:@"SOS,%@,%@,%@",FXXTalertVIew.textFile1.text,FXXTalertVIew.textFile2.text,FXXTalertVIew.textFile3.text];
            typeStr = @"SOS";
        }
            break;
        case 11:  //恢复出厂设置
        {
            instructionStr = [NSString stringWithFormat:@"FACTORY"];
            typeStr = @"FACTORY";
        }
            break;
        case 12:  //刷新
        {
            instructionStr = [NSString stringWithFormat:@"CONFIG"];
            typeStr = @"CONFIG";
        }
            break;
        case 13:
        {
            instructionStr = [NSString stringWithFormat:@"DEFINE,%@",tipAlertView.textFile1.text];
            typeStr = @"DEFINE";
        }
            break;
        case 14: //修改模式
        {
            NSString *timeStr;
            if (_macType == DR30) {
                switch (selectModeInt) {
                    case 0:
                    {
                        timeStr = workModeSeleView.timeTF.text;
                    }
                        break;
                    case 1:
                    {
                        timeStr = @"0";
                    }
                        break;
                    case 2:
                    {
                        timeStr = workModeSeleView.timeTF.text;

                    }
                        break;

                    default:
                        break;
                }
                
            }
            else{
                timeStr = nil;
            }

            NSString *str = [NSString stringWithFormat:@"%d",selectModeInt == 0?1:3];
                        instructionStr = [NSString stringWithFormat:@"MODE,%@,%@",str,timeStr];
                        typeStr = @"MODE";
        }
            break;
        case 15:   //gt121拆除防拆  和其他指令不一样
        {
//            instructions = [NSString stringWithFormat:@"fangchai"];
//            typeStr = @"fangchai";
        }
            break;
            //超速报警，待修改
//        case 16:
//        {
//            instructionStr = [NSString stringWithFormat:@"POWERAL,%@",switCH.on?@"1":@"0"];
//            typeStr = @"POWERAL";
//        }
//            break;
        case 17:
        {
            instructionStr = [NSString stringWithFormat:@"MAXSPEED,%@,RUNTIME,%@",speedLimitView.textFile1.text,speedLimitView.textFile3.text];
            typeStr = @"MAXSPEED";
        }
            break;
        default:
            break;
    }
    if (tag != 15 ) {
        NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                              @"macId":CsqStringIsEmpty(_insStateModel.macId),//
                              @"instructions":instructionStr,
                              @"type":typeStr,
                              @"count":[NSString stringWithFormat:@"%ld",(long)intCount]
                              };
        intCount++;
        NSString *requestStr;
        if (tag == 17) {
            requestStr = @"instruction/send";
        }else{
            requestStr = @"instruction/send";
        }
        
        [ZZXDataService HFZLRequest:requestStr httpMethod:@"POST" params1:dic   file:nil success:^(id data)
         {
             
             if ([data[@"code"]integerValue] == 101054) {
                 if (intCount <= mostNunber) {
                     CSQ_DISPATCH_AFTER(2.0, ^{
                         [self sendInstr:intCount :switCH];
                     })
                 }
                 else{
                     [UIUtil showToast:L(@"Connection timeout") inView:[AppData theTopView]];
                     switCH.on = !switCH.on;
                 }
             }else if([data[@"code"]integerValue] == 0){
                 [UIUtil showToast:L(@"Sent successfully") inView:[AppData theTopView]];
                 switch (tag) {
                     case 0:
                         _insStateModel.re = [NSString stringWithFormat:@"%d",switCH.on];
                         break;
                     case 1:
                         _insStateModel.de = [NSString stringWithFormat:@"%d",switCH.on];
                         
                         break;
                     case 2:
                         _insStateModel.doorAlarm = [NSString stringWithFormat:@"%d",switCH.on];
                         break;
                     case 3:
                     {
                         _insStateModel.blindAlarm = [NSString stringWithFormat:@"%d",switCH.on];
                     }
                         break;
                     case 4:
                     {
                         _insStateModel.accAlarm = [NSString stringWithFormat:@"%d",switCH.on];
                     }
                         break;
                     case 5:
                     {
                         _insStateModel.lowbat = [NSString stringWithFormat:@"%d",switCH.on];
                     }
                         break;
                     case 6:
                     {
                         _insStateModel.powerAlarm = [NSString stringWithFormat:@"%d",switCH.on];
                     }
                         break;
                     case 7:{
                         _insStateModel.speedAlarm = [NSString stringWithFormat:@"%d",switCH.on];
                     }
                         break;
                     case 8:{
                         _insStateModel.vibAlarm = [NSString stringWithFormat:@"%d",selectInt];
                         [UIUtil showToast:L(@"success") inView:self.view];
                         [OpenTableview reloadData];
                     }
                         break;
                     case 9:{
                         _insStateModel.upTime = [NSString stringWithFormat:@"%d",SOSint];
                         [UIUtil showToast:L(@"success") inView:self.view];
                         [SetTableview reloadData];
                     }
                         break;
                     case 10:{
                         _insStateModel.sosPhone1 =   FXXTalertVIew.textFile1.text;
                         _insStateModel.sosPhone2 =   FXXTalertVIew.textFile2.text;
                         _insStateModel.sosPhone3 =   FXXTalertVIew.textFile3.text;
                         [UIUtil showToast:L(@"success") inView:self.view];
                         [FXXTalertVIew dismiss];
                         [SetTableview reloadData];//tipAlertView.textFile1.text
                     }
                         break;
                     
                     case 11:{
                         [UIUtil showToast:L(@"Restore factory Settings successfully, refresh data") inView:self.view];
                         [self synchro];
                     }
                         break;
                     case 12:{
                         if ([data[@"data"] isKindOfClass:[NSDictionary class]]) {
                             NSDictionary *dataDict = data[@"data"];
                             if (!kDictIsEmpty(dataDict)) {
                                 InstructionStateModel *model = [InstructionStateModel provinceWithDictionary:dataDict];
                                 _insStateModel = model;
                                 [OpenTableview reloadData];
                                 [SetTableview reloadData];
                             }
                         }
                     }
                         break;
                     case 13:{
                         [tipAlertView dismiss];
                         [UIUtil showToast:L(@"Custom instruction sent successfully") inView:self.view];
                     }
                         break;
                     case 14:{
                         [UIUtil showToast:L(@"success") inView:self.view];
                         NSString *timeStr;
                         switch (selectModeInt) {
                             case 0:
                             {
                                 timeStr = workModeSeleView.timeTF.text;
                             }
                                 break;
                             case 1:
                             {
                                 timeStr = @"0";
                             }
                                 break;
                             case 2:
                             {
                                 timeStr = workModeSeleView.timeTF.text;
                             }
                                 break;
                             default:
                                 break;
                         }
                         _insStateModel.mode =  [NSString stringWithFormat:@"%d",selectModeInt == 0?1:3];
                         _insStateModel.modeTime =  timeStr;
                         [OpenTableview reloadData];
                     }
                         break;
                     case 15:   //gt121待修改
                     {
                         _insStateModel.fangchai = [NSString stringWithFormat:@"%d",switCH.on];
                     }
                         break;
                     case 17:{
                         _insStateModel.speedLimit =   speedLimitView.textFile1.text;
                         _insStateModel.speedLimitRunTime =   speedLimitView.textFile3.text;
                        
                         [UIUtil showToast:L(@"success") inView:self.view];
                         [speedLimitView dismiss];
                         [OpenTableview reloadData];
                         [SetTableview reloadData];//tipAlertView.textFile1.text
                     }
                         break;
                     default:
                         break;
                 }
                 
                 
             }
             showErrorCode(switCH.on = !switCH.on;)
             
         } fail:^(NSError *error)
         {
//             [UIUtil showToast:@"网络异常" inView:[AppData theTopView]];
             switCH.on = !switCH.on;
         }];
    }else if(tag == 15){ //gt121模式下的方式
        
        NSDictionary *instructions = @{
                                       @"mode":self.gt121ModelA.mode,
                                       @"timing":self.gt121ModelA.timing,
                                       @"week":self.gt121ModelA.week,
                                       @"weekSel":self.gt121ModelA.weekSel,
                                       @"weekTime":self.gt121ModelA.weekTime,
                                       @"alarmClock":self.gt121ModelA.alarmClock,
                                       @"alarmClockTime":self.gt121ModelA.alarmClockTime,
                                       @"removeAl":switCH.on?@"1":@"0",
                                       };
        NSString *instrStr = [ZZXDataService convertToJsonData:instructions];
        NSDictionary *dic = @{@"macType":CsqStringIsEmpty(USERMANAGER.seleCar.macType),
                              @"macId":CsqStringIsEmpty(_insStateModel.macId),//
                              @"instructions":instrStr
                              };
        
        [ZZXDataService HFZLRequest:@"instruction/send-dispatch-A5" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
         {
             if([data[@"code"]integerValue] == 0){
                 self.gt121ModelA.removeAl = [NSString stringWithFormat:@"%d",switCH.on];
                  [UIUtil showToast:L(@"Success") inView:[AppData theTopView]];
             }else if([data[@"code"]integerValue] == 101057){
                 [UIUtil showToast:L(@"Send offline instruction, set up successfully") inView:[AppData theTopView]];
                 self.gt121ModelA.removeAl = [NSString stringWithFormat:@"%d",switCH.on];
             }else{
                 [UIUtil showToast:L(@"Setup failed") inView:[AppData theTopView]];
                 switCH.on = !switCH.on;
             }
         } fail:^(NSError *error)
         {
//              [UIUtil showToast:@"网络异常" inView:[AppData theTopView]];
         }];
    }
    
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 当前视图中有N多UIScrollView
    if (scrollView == _musciScroll) {
        scrollViewPage  = scrollView.contentOffset.x / SCREENWIDTH;
        [UIView animateWithDuration:0.3 animations:^{
            for (UIButton *button in navView.subviews) {
                button.selected = NO;
            }
            UIButton *bu = (UIButton *)[navView viewWithTag:scrollViewPage + 100];
            bu.selected = YES;
        }];
    }
}
#pragma mark SOSView

-(void)SOSview{
    FXXTalertVIew = [[FXXTalertView alloc]init];
    FXXTalertVIew.titleLabel.text = L(@"SOS number setting");
    FXXTalertVIew.textFile1.text =  _insStateModel.sosPhone1;
    FXXTalertVIew.textFile2.text =  _insStateModel.sosPhone2;
    FXXTalertVIew.textFile3.text =  _insStateModel.sosPhone3;
    
    FXXTalertVIew.textFile1.delegate = self;
    FXXTalertVIew.textFile2.delegate = self;
    FXXTalertVIew.textFile3.delegate = self;
    
    [FXXTalertVIew.sureButton addTarget:self action:@selector(setPhone) forControlEvents:UIControlEventTouchUpInside];
    [FXXTalertVIew showInView:[AppData theTopView]];
}
-(void)tipView{//请输入自定义指令
    tipAlertView = [[FXXTalertView alloc]init];
    tipAlertView.titleLabel.text = L(@"Please enter custom instruction");
//    tipAlertView.textFile1.text =  _insStateModel.sosPhone1;
    tipAlertView.textFile1.keyboardType = UIKeyboardTypeDefault;
    tipAlertView.textFile1.delegate = self;

    
    [tipAlertView.sureButton addTarget:self action:@selector(sendTip) forControlEvents:UIControlEventTouchUpInside];
    [tipAlertView showOneTFInView:[AppData theTopView]];
}
-(void)setPhone{
    UISwitch *switCH = [UISwitch new];
    switCH.tag = 110;
    [self sendInstr:0 :switCH];
    [UIUtil showProgressHUD:nil inView:self.view];
}
-(void)sendTip{
    UISwitch *switCH = [UISwitch new];
    switCH.tag = 113;
    [self sendInstr:0 :switCH];
    [UIUtil showProgressHUD:nil inView:[AppData theTopView]];
}
//修改速度限制设置
-(void)speedSendTip{
    if ([speedLimitView.textFile1.text isEqualToString:@"0"]
        || [speedLimitView.textFile3.text isEqualToString:@"0"]) {
        [UIUtil showToast:L(@"Can't set 0") inView:self.view];
        return;
    }
    UISwitch *switCH = [UISwitch new];
    switCH.tag = 117;
    [self sendInstr:0 :switCH];
    [UIUtil showProgressHUD:nil inView:[AppData theTopView]];
}
-(void)speedTipView{//请输入速度(单位：KM/H)
    speedLimitView = nil;
    speedLimitView = [[FHZLspeedSetView alloc]init];
    speedLimitView.titleLabel.text = L(@"Please enter speed (unit: KM/H)");
    speedLimitView.textFile1.keyboardType = UIKeyboardTypeNumberPad;
    speedLimitView.textFile1.delegate = self;
    speedLimitView.textFile1.text = _insStateModel.speedLimit;
    
    speedLimitView.titleLabel2.text = L(@"Please enter speed limit duration (unit: KM/H)");
    speedLimitView.textFile3.keyboardType = UIKeyboardTypeNumberPad;
    speedLimitView.textFile3.delegate = self;
    speedLimitView.textFile3.text = _insStateModel.speedLimitRunTime;
    [speedLimitView.sureButton addTarget:self action:@selector(speedSendTip) forControlEvents:UIControlEventTouchUpInside];
    [speedLimitView showInView:[AppData theTopView]];
}
#pragma mark PickView
-(void)setPickBackView:(int)tag{
    if (!pickBackView) {
        int height = 300;
        ifIphoneX(height = 350)
        
        pickBackView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - height, kScreenWidth, height)];
        pickBackView.tag = tag;
        pickBackView.backgroundColor = RGB(235, 235, 245);
        [self.view addSubview:pickBackView];
        
        hiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - height - kTopHeight)];
        hiddenView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:hiddenView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButton)];
        [hiddenView addGestureRecognizer:tap];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(5, 5,  60, 30);
        [cancelButton setTitle:L(@"Cancel") forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont  boldSystemFontOfSize:18];
        
        [cancelButton addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [pickBackView addSubview:cancelButton];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.frame = CGRectMake(kScreenWidth - 45, 5, 40, 30);
        [saveButton setTitle:L(@"OK") forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont  boldSystemFontOfSize:18];
        [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [pickBackView addSubview:saveButton];
        
        cancelButton.frame = CGRectMake(5, 5,  80, 30);
        if (IOS_VERSION >= 10.0) {
            [cancelButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        }
        
        saveButton.frame = CGRectMake(kScreenWidth - 80, 5, 80, 30);
        if (IOS_VERSION >= 10.0) {
            [saveButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        }
        UIPickerView * pickTimeView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth ,260)];
        pickTimeView.backgroundColor = RGB(235, 235, 245);
        pickTimeView.dataSource = self;
        pickTimeView.delegate = self;
        pickTimeView.showsSelectionIndicator = YES;
        if (pickBackView.tag == ZhenDong) {
            [pickTimeView selectRow:selectInt inComponent:0 animated:NO];
        }else if(pickBackView.tag == SOS){
            if (_macType == GT_31) {
                switch (SOSint) {
                    case 1:
                        [pickTimeView selectRow:0 inComponent:0 animated:NO];
                        break;
                    case 20:
                        [pickTimeView selectRow:1 inComponent:0 animated:NO];
                        break;
                    case 60:
                        [pickTimeView selectRow:2 inComponent:0 animated:NO];
                        break;
                    case 600:
                        [pickTimeView selectRow:3 inComponent:0 animated:NO];
                        break;
                    case 3600:
                        [pickTimeView selectRow:4 inComponent:0 animated:NO];
                        break;
                    default:
                        [pickTimeView selectRow:1 inComponent:0 animated:NO];
                        break;
                }
            }
            else if (_macType == GT_52) {
                switch (SOSint) {
                    case 20:
                        [pickTimeView selectRow:0 inComponent:0 animated:NO];
                        
                        break;
                    case 30:
                        [pickTimeView selectRow:1 inComponent:0 animated:NO];
                        
                        break;
                    case 60:
                        [pickTimeView selectRow:2 inComponent:0 animated:NO];
                        
                        break;
                    case 600:
                        [pickTimeView selectRow:3 inComponent:0 animated:NO];
                        
                        break;
                    case 3600:
                        [pickTimeView selectRow:4 inComponent:0 animated:NO];
                        
                        break;
                        
                    default:
                        [pickTimeView selectRow:1 inComponent:0 animated:NO];
                        break;
                }
            }
            else{
                switch (SOSint) {
                    case 20:
                        [pickTimeView selectRow:0 inComponent:0 animated:NO];
                        
                        break;
                    case 60:
                        [pickTimeView selectRow:1 inComponent:0 animated:NO];
                        
                        break;
                    case 600:
                        [pickTimeView selectRow:2 inComponent:0 animated:NO];
                        
                        break;
                    case 3600:
                        [pickTimeView selectRow:3 inComponent:0 animated:NO];
                        
                        break;
                        
                    default:
                        [pickTimeView selectRow:0 inComponent:0 animated:NO];
                        break;
                }
            }
        }
        [pickBackView addSubview:pickTimeView];
    }else{
//        pickBackView.hidden = NO;
//        hiddenView.hidden = NO;
//        pickBackView.tag = tag;
    }
}
-(void)saveClick{
//    pickBackView.hidden = YES;
//    hiddenView.hidden = YES;
    
    if (pickBackView.tag == ZhenDong) {
        UISwitch *switCH = [UISwitch new];
        switCH.tag = 108;
        [self sendInstr:0 :switCH];
        [UIUtil showProgressHUD:nil inView:self.view];
    }else if (pickBackView.tag == SOS){
        UISwitch *switCH = [UISwitch new];
        switCH.tag = 109;
        [self sendInstr:0 :switCH];
        [UIUtil showProgressHUD:nil inView:self.view];
    }
    
    [pickBackView removeFromSuperview];
    pickBackView = nil;
    [hiddenView removeFromSuperview];
    hiddenView = nil;
}
-(void)cancelButton{
    [pickBackView removeFromSuperview];
    pickBackView = nil;
    [hiddenView removeFromSuperview];
    hiddenView = nil;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == TimePickView) {
        return 3;
    }else{
        return 1;
    }
}
//每组有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == ModePickView) {
        return 3;
    }
    else if (pickerView == TimePickView){
        if (component == 0) {
            return 24;
        }else if (component == 1){
            return 1;
        }else{
            return 60;
        }
    }
    else{
        if (_macType == GT_31 || _macType == GT_52) {
            return 5;
        }else{
            return 4;
        }
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == ModePickView) {
        NSArray *modeArray = @[L(@"Dormant state"),L(@"Power saving tracking"),L(@"Real time tracking")];//间隔时间上传模式
        return modeArray[row];
    }else if(pickerView == TimePickView){
        if (component == 0) {
            return [NSString stringWithFormat:@"%02d",row];
        }else if (component == 1){
            return @":";
        }else{
            return [NSString stringWithFormat:@"%02d",row];
        }
    }
    
    else{
        switch (pickBackView.tag) {
            case ZhenDong:
                {
                    NSArray *timeArray = @[L(@"OFF"),L(@"Level One"),L(@"Level Two"),L(@"Level Three")];
                 return timeArray[row];
                }
            break;
            case SOS:
            {
                NSArray *timeArray = nil;
                if (_macType == GT_31) {
                  timeArray = @[@"1S",@"20S",@"60S",@"10min",@"1h"];
                }
                else if (_macType == GT_52) {
                    timeArray = @[@"20S",@"30S",@"60S",@"10min",@"1h"];
                }
                else{
                  timeArray = @[@"20S",@"60S",@"10min",@"1h"];
                }
                return timeArray[row];
            }
                break;
            default:
                return nil;
                break;
        }
    }
}

//选择了某行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == ModePickView) {
        switch (row) {
            case 0:
                selectModeInt = 0;
                break;
            case 1:
                selectModeInt = 1;
                break;
            case 2:
                selectModeInt = 2;
                break;
//            case 3:
//                selectModeInt = 3;
//                break;
            default:
                break;
    }
    }else if (pickerView == TimePickView){
        if (component == 0) {
            HourSelectInt = row;
        }else if(component == 2){
            MinSelectInt = row;
        }
    }
    else{
    
    switch (pickBackView.tag) {
        case ZhenDong:
        {
            switch (row) {
                case 0:
                    selectInt = 0;
                    break;
                case 1:
                    selectInt = 1;
                    break;
                case 2:
                    selectInt = 2;
                    break;
                case 3:
                    selectInt = 3;
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case SOS:
        {
            if (_macType == GT_31) {
                switch (row) {
                    case 0:
                        SOSint = 1;
                        break;
                    case 1:
                        SOSint = 20;
                        break;
                    case 2:
                        SOSint = 60;
                        break;
                    case 3:
                        SOSint = 600;
                        break;
                    case 4:
                        SOSint = 3600;
                        break;
                    default:
                        break;
                }
            }
            else if (_macType == GT_52) {
                switch (row) {
                    case 0:
                        SOSint = 20;
                        break;
                    case 1:
                        SOSint = 30;
                        break;
                    case 2:
                        SOSint = 60;
                        break;
                    case 3:
                        SOSint = 600;
                        break;
                    case 4:
                        SOSint = 3600;
                        break;
                    default:
                        break;
                }
            }
            else{
                switch (row) {
                    case 0:
                        SOSint = 20;
                        break;
                    case 1:
                        SOSint = 60;
                        break;
                    case 2:
                        SOSint = 600;
                        break;
                    case 3:
                        SOSint = 3600;
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        default:
            break;
    }
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (pickerView == TimePickView) {
        return 30.f;
    }else{
        return 50.0;
    }
}

-(void)workModeSele{
    workModeSeleView = [[WorkModeSele alloc]init];
    workModeSeleView.timeLabel.hidden = YES;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SelectTime)];
    [workModeSeleView.timeLabel addGestureRecognizer:tap];
    
    [workModeSeleView.ModeButton addTarget:self action:@selector(setModePickBackView) forControlEvents:UIControlEventTouchUpInside];
    workModeSeleView.timeTF.text = _insStateModel.modeTime;
    workModeSeleView.timeTF.delegate = self;
    [workModeSeleView.SetButton addTarget:self action:@selector(changeAlarmMode) forControlEvents:UIControlEventTouchUpInside];
    workModeSeleView.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",HourSelectInt,MinSelectInt];
    [self setModeViewDetail];
//    [workModeSeleView showInView:self.view];//[AppData theTopView]
    
    workModeSeleView.frame = CGRectMake(0, -kTopHeight, kScreenWidth, kScreenHeight);
    workModeSeleView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:workModeSeleView];
    
}
-(void)setModeViewDetail{
    if (_macType == DR30) {
        switch (selectModeInt) {
            case 0:
            {
                            workModeSeleView.timeLabel.hidden = YES;
                            workModeSeleView.timeTF.hidden = NO;
                            workModeSeleView.tipLabel.text = L(@"Default time interval 1440 minutes, range:10-1800");
                            [workModeSeleView.ModeButton setTitle:L(@"Dormant state") forState:UIControlStateNormal];
                            workModeSeleView.secondLabel.text = L(@"time interval:");
                
                            if (1 != [_insStateModel.mode integerValue]) {
                                workModeSeleView.timeTF.text = @"1440";
                            }else{
                                workModeSeleView.timeTF.text = _insStateModel.modeTime;
                            }
                            workModeSeleView.tipLabel.hidden = NO;
                            workModeSeleView.secondLabel.hidden = NO;
                            [workModeSeleView setH:@"ONE"];
            }
                break;
            case 1:
            {
                workModeSeleView.timeLabel.hidden = YES;
                workModeSeleView.timeTF.hidden = YES;
                workModeSeleView.tipLabel.hidden = YES;
                workModeSeleView.secondLabel.hidden = YES;
                [workModeSeleView.ModeButton setTitle:L(@"Power saving tracking") forState:UIControlStateNormal];
                [workModeSeleView setH:@"TWO"];
//                            workModeSeleView.secondLabel.text = @"时间间隔:";
                
//                            if (selectModeInt != [_insStateModel.mode integerValue]) {
//                                workModeSeleView.timeTF.text = @"0";
//                            }else{
//                                workModeSeleView.timeTF.text = _insStateModel.modeTime;
//                            }
            }
                break;
            case 2:
            {
                            workModeSeleView.timeLabel.hidden = YES;
                            workModeSeleView.timeTF.hidden = NO;
                            workModeSeleView.tipLabel.text = L(@"(The default interval is 60 seconds, range: 10-1800)");
                            [workModeSeleView.ModeButton setTitle:L(@"Real time tracking") forState:UIControlStateNormal];
                            workModeSeleView.secondLabel.text = L(@"time interval:");
                
                            if (3 != [_insStateModel.mode integerValue]) {
                                workModeSeleView.timeTF.text = @"60";
                            }else{
                                workModeSeleView.timeTF.text = _insStateModel.modeTime;
                            }
                workModeSeleView.tipLabel.hidden = NO;
                workModeSeleView.secondLabel.hidden = NO;
                [workModeSeleView setH:@"ONE"];
            }
                break;
//            case 3:
//            {
//                workModeSeleView.timeLabel.hidden = YES;
//                workModeSeleView.timeTF.hidden = NO;
//                workModeSeleView.tipLabel.text = @"(默认时间间隔60秒，设置范围:10-1800或者0)";
//                [workModeSeleView.ModeButton setTitle:@"省电模式" forState:UIControlStateNormal];
//                workModeSeleView.secondLabel.text = @"时间间隔:";
//                if (selectModeInt != [_insStateModel.mode integerValue]) {
//                    workModeSeleView.timeTF.text = @"60";
//                }else{
//                    workModeSeleView.timeTF.text = _insStateModel.modeTime;
//                }
//            }
//                break;
            default:
                break;
        }
    }
    /*
    switch (selectModeInt) {
        case 0:
        {
            workModeSeleView.timeLabel.hidden = YES;
            workModeSeleView.timeTF.hidden = NO;
            workModeSeleView.tipLabel.text = @"默认时间间隔60秒，范围:10-1800。";
            [workModeSeleView.ModeButton setTitle:@"连续追踪定位模式" forState:UIControlStateNormal];
            workModeSeleView.secondLabel.text = @"时间间隔:";
            
            if (selectModeInt != [_insStateModel.mode integerValue]) {
                workModeSeleView.timeTF.text = @"60";
            }else{
                workModeSeleView.timeTF.text = _insStateModel.modeTime;
            }
            //            workModeSeleView.timeLabel.hidden = YES;
            //            workModeSeleView.timeTF.hidden = NO;
            //            workModeSeleView.tipLabel.text = @"（默认时间间隔1440分钟，设置范围:5-7200）";
            //            [workModeSeleView.ModeButton setTitle:@"休眠模式" forState:UIControlStateNormal];
            //            workModeSeleView.secondLabel.text = @"时间间隔:";
            //
            //            if (selectModeInt != [_insStateModel.mode integerValue]) {
            //                workModeSeleView.timeTF.text = @"1440";
            //            }else{
            //                workModeSeleView.timeTF.text = _insStateModel.modeTime;
            //            }
        }
            break;
        case 1:
        {
            workModeSeleView.timeLabel.hidden = YES;
            workModeSeleView.timeTF.hidden = NO;
            workModeSeleView.tipLabel.text = @"(默认时间间隔1440分钟，设置范围:5-7200)";
            [workModeSeleView.ModeButton setTitle:@"休眠模式" forState:UIControlStateNormal];//间隔时间上传模式
            workModeSeleView.secondLabel.text = @"时间间隔:";
            if (selectModeInt != [_insStateModel.mode integerValue]) {
                workModeSeleView.timeTF.text = @"1440";
            }else{
                workModeSeleView.timeTF.text = _insStateModel.modeTime;
            }
            //            workModeSeleView.timeLabel.hidden = YES;
            //            workModeSeleView.timeTF.hidden = NO;
            //            workModeSeleView.tipLabel.text = @"（默认时间间隔0秒）";
            //            [workModeSeleView.ModeButton setTitle:@"闪电追踪" forState:UIControlStateNormal];
            //            workModeSeleView.secondLabel.text = @"时间间隔:";
            //
            //            if (selectModeInt != [_insStateModel.mode integerValue]) {
            //                workModeSeleView.timeTF.text = @"0";
            //            }else{
            //                workModeSeleView.timeTF.text = _insStateModel.modeTime;
            //            }
        }
            break;
        case 2:
        {
            workModeSeleView.timeLabel.hidden = NO;
            workModeSeleView.timeTF.hidden = YES;
            workModeSeleView.tipLabel.text = @"(设置时间后每天按照设置的时间点上传一个位置)";
            [workModeSeleView.ModeButton setTitle:@"固定时间点上传模式" forState:UIControlStateNormal];
            workModeSeleView.secondLabel.text = @"时间点:";
            if (selectModeInt != [_insStateModel.mode integerValue]) {
                workModeSeleView.timeTF.text = @"10:00";
            }else{
                workModeSeleView.timeTF.text = _insStateModel.modeTime;
            }
            //            workModeSeleView.timeLabel.hidden = YES;
            //            workModeSeleView.timeTF.hidden = NO;
            //            workModeSeleView.tipLabel.text = @"（默认时间间隔10秒，设置范围:10-1800）";
            //            [workModeSeleView.ModeButton setTitle:@"实时追踪" forState:UIControlStateNormal];
            //            workModeSeleView.secondLabel.text = @"时间间隔:";
            //
            //            if (selectModeInt != [_insStateModel.mode integerValue]) {
            //                workModeSeleView.timeTF.text = @"10";
            //            }else{
            //                workModeSeleView.timeTF.text = _insStateModel.modeTime;
            //            }
        }
            break;
        case 3:
        {
            workModeSeleView.timeLabel.hidden = YES;
            workModeSeleView.timeTF.hidden = NO;
            workModeSeleView.tipLabel.text = @"(默认时间间隔60秒，设置范围:10-1800或者0)";
            [workModeSeleView.ModeButton setTitle:@"省电模式" forState:UIControlStateNormal];
            workModeSeleView.secondLabel.text = @"时间间隔:";
            if (selectModeInt != [_insStateModel.mode integerValue]) {
                workModeSeleView.timeTF.text = @"60";
            }else{
                workModeSeleView.timeTF.text = _insStateModel.modeTime;
            }
            //            if ([workModeSeleView.timeTF.text intValue] == 0) {
            //                [workModeSeleView.ModeButton setTitle:@"省电追踪模式" forState:UIControlStateNormal];
            //            }else{
            //                [workModeSeleView.ModeButton setTitle:@"实时追踪模式" forState:UIControlStateNormal];
            //            }
        }
            break;
        default:
            break;
    }*/
    else//原始模式
    {
    
    switch (selectModeInt) {
        case 0:
        {
            workModeSeleView.timeLabel.hidden = YES;
            workModeSeleView.timeTF.hidden = NO;
            workModeSeleView.tipLabel.text = L(@"(The default interval is 60 seconds, range: 10-1800)");
            [workModeSeleView.ModeButton setTitle:L(@"Continuous tracking positioning mode") forState:UIControlStateNormal];
            workModeSeleView.secondLabel.text = L(@"time interval:");

            if (selectModeInt != [_insStateModel.mode integerValue]) {
                workModeSeleView.timeTF.text = @"60";
            }else{
                workModeSeleView.timeTF.text = _insStateModel.modeTime;
            }
        }
            break;
        case 1:
        {
            workModeSeleView.timeLabel.hidden = YES;
            workModeSeleView.timeTF.hidden = NO;
            workModeSeleView.tipLabel.text = L(@"(Default time interval 1440 minutes, range: 5-7200)");
            [workModeSeleView.ModeButton setTitle:L(@"Interval upload mode") forState:UIControlStateNormal];//间隔时间上传模式
            workModeSeleView.secondLabel.text = L(@"time interval:");
            if (selectModeInt != [_insStateModel.mode integerValue]) {
                workModeSeleView.timeTF.text = @"1440";
            }else{
                workModeSeleView.timeTF.text = _insStateModel.modeTime;
            }
        }
            break;
        case 2:
        {
            workModeSeleView.timeLabel.hidden = NO;
            workModeSeleView.timeTF.hidden = YES;
            workModeSeleView.tipLabel.text = L(@"(after setting the time, upload a location every day according to the set time point)");
            [workModeSeleView.ModeButton setTitle:L(@"Fixed time point upload mode") forState:UIControlStateNormal];
            workModeSeleView.secondLabel.text = L(@"Time Point:");
            if (selectModeInt != [_insStateModel.mode integerValue]) {
                workModeSeleView.timeTF.text = @"10:00";
            }else{
                workModeSeleView.timeTF.text = _insStateModel.modeTime;
            }
        }
            break;
    
        default:
            break;
    }
    }
}
-(void)setModePickBackView{
//    if (!ModePickBackView) {
        [ModePickBackView removeFromSuperview];
        ModePickBackView = nil;
    
        ModePickBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        ModePickBackView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
        [workModeSeleView addSubview:ModePickBackView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ModeCancelButton)];
        [ModePickBackView addGestureRecognizer:tap];
        
        
        UIView *  ModePickBackViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 240, kScreenWidth, 240)];
        ModePickBackViewBottom.backgroundColor = [UIColor whiteColor];
        [ModePickBackView addSubview:ModePickBackViewBottom];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(5, 5,  60, 30);
        [cancelButton setTitle:L(@"Cancel") forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont  boldSystemFontOfSize:18];
        [cancelButton addTarget:self action:@selector(ModeCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ModePickBackViewBottom addSubview:cancelButton];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.frame = CGRectMake(kScreenWidth - 45, 5, 40, 30);
        [saveButton setTitle:L(@"OK") forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont  boldSystemFontOfSize:18];
        [saveButton addTarget:self action:@selector(ModeSaveClick) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ModePickBackViewBottom addSubview:saveButton];
        
        
        cancelButton.frame = CGRectMake(5, 5,  80, 30);
        if (IOS_VERSION >= 10.0) {
            [cancelButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        }
        saveButton.frame = CGRectMake(kScreenWidth - 80, 5, 80, 30);
        if (IOS_VERSION >= 10.0) {
            [saveButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        }
        
        ModePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth ,200)];
        ModePickView.backgroundColor = [UIColor whiteColor];
        ModePickView.dataSource = self;
        ModePickView.delegate = self;
        ModePickView.showsSelectionIndicator = YES;
        switch (selectModeInt) {
            case 0:
                [ModePickView selectRow:0 inComponent:0 animated:NO];
                
                break;
            case 1:
                [ModePickView selectRow:1 inComponent:0 animated:NO];
                
                break;
            case 2:
                [ModePickView selectRow:2 inComponent:0 animated:NO];
                
                break;
            case 3:
                [ModePickView selectRow:3 inComponent:0 animated:NO];
                
                break;
            default:
                [ModePickView selectRow:0 inComponent:0 animated:NO];
                break;
        }
        [ModePickBackViewBottom addSubview:ModePickView];
        
//    }
//    else{
//        ModePickBackView.hidden = NO;
//        [workModeSeleView bringSubviewToFront:ModePickBackView];
//    }
}
-(void)ModeSaveClick{
    ModePickBackView.hidden = YES;
    [self setModeViewDetail];
}
-(void)ModeCancelButton{
    ModePickBackView.hidden = YES;
}
-(void)TimeSaveClick{
    TimePickBackView.hidden = YES;
    workModeSeleView.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",HourSelectInt,MinSelectInt];
}
-(void)TimeCancelButton{
    TimePickBackView.hidden = YES;
}


-(void)SelectTime{
    
    if (!TimePickBackView ) {
        TimePickBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        TimePickBackView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
        [workModeSeleView addSubview:TimePickBackView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TimeCancelButton)];
        [TimePickBackView addGestureRecognizer:tap];
        
        
        UIView *  ModePickBackViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 240, kScreenWidth, 240)];
        ModePickBackViewBottom.backgroundColor = [UIColor whiteColor];
        [TimePickBackView addSubview:ModePickBackViewBottom];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(5, 5,  60, 30);
        [cancelButton setTitle:L(@"Cancel") forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont  boldSystemFontOfSize:18];
        [cancelButton addTarget:self action:@selector(TimeCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ModePickBackViewBottom addSubview:cancelButton];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.frame = CGRectMake(kScreenWidth - 45, 5, 40, 30);
        [saveButton setTitle:L(@"OK") forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont  boldSystemFontOfSize:18];
        [saveButton addTarget:self action:@selector(TimeSaveClick) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ModePickBackViewBottom addSubview:saveButton];
        
        
        cancelButton.frame = CGRectMake(5, 5,  80, 30);
        if (IOS_VERSION >= 10.0) {
            [cancelButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        }
        saveButton.frame = CGRectMake(kScreenWidth - 80, 5, 80, 30);
        if (IOS_VERSION >= 10.0) {
            [saveButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        }
        
        TimePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth ,200)];
        TimePickView.backgroundColor = [UIColor whiteColor];
        TimePickView.dataSource = self;
        TimePickView.delegate = self;
        TimePickView.showsSelectionIndicator = YES;
        [TimePickView selectRow:HourSelectInt inComponent:0 animated:YES];
        [TimePickView selectRow:MinSelectInt inComponent:2 animated:YES];
        [ModePickBackViewBottom addSubview:TimePickView];
        
    }else{
        TimePickBackView.hidden = NO;
        [self.view bringSubviewToFront:TimePickBackView];
    }
    
}
//
-(void)changeAlarmMode{
    UISwitch *switCH = [UISwitch new];
    switCH.tag = 114;
    [self sendInstr:0 :switCH];
    [UIUtil showProgressHUD:nil inView:[AppData theTopView]];
}

-(void)getGT121Model{
    [UIUtil showProgressHUD:nil  inView:self.view];
    NSDictionary *dic = @{@"macId":CsqStringIsEmpty(_insStateModel.macId)};
    
    [ZZXDataService HFZLRequest:@"instruction/get-dispatch-A5" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil hideProgressHUD];
             NSObject *userD = data[@"data"];
             if ([userD isKindOfClass:[NSDictionary class]]) {
                 NSDictionary*userDict = (NSDictionary*)userD;
                 if (!kDictIsEmpty(userDict) ){
                     self.gt121ModelA = [Gt121Model provinceWithDictionary:userDict];
                     
                     [OpenTableview reloadData];
                     //                 [SetTableview reloadData];
                 }
             }
             
         }else{
             [UIUtil showToast:L(@"Failed") inView:self.view];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
