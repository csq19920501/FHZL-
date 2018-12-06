//
//  listenSoundVC.m
//  FHZL
//
//  Created by hk on 2018/1/18.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "listenSoundVC.h"
#import "MJRefresh.h"
#import "FFDropDownMenuView.h"
#import "recordCell.h"
#import "recordModel.h"
#import "Header.h"
#import "VoiceConverter.h"
@interface listenSoundVC ()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource,FFDropDownMenuViewDelegate,AVAudioPlayerDelegate>
{
    UIView *pickBackView;
    int selectInt;
    int recordInt;
    int reGetSoundTime;
    
    NSMutableArray *alarmDataArray;
    UILabel *titleLabel;
    UIImageView *titleImage;
    BOOL isSeleOne;
    NSString *lastId;
    
    NSString *_downStr;
    NSString *_saveStr;
    NSURLConnection * _connection;//创建链接对象，它不能在函数结束时消失，所以写成成员变量
    NSMutableData * _data;//数据对象，装载数据
    recordModel *downRecordModel;
    recordModel *playRecordModel;
    NSTimer *TimeTimer;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstanr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)   AVAudioPlayer *Rplayer;
@property (nonatomic, copy)     NSString *        filePath;
@property (nonatomic, strong) FFDropDownMenuView *dropdownMenu;
@property (weak, nonatomic) IBOutlet UIButton *listenButton;
@end

@implementation listenSoundVC
- (IBAction)recordClick:(id)sender {
    [self NoGT10];
    if (!isSeleOne) {
        [UIUtil showToast:L(@"Select a device") inView:self.view];
        return;
    }
    if ([USERMANAGER.seleCar.macType isEqualToString:GT31] || [USERMANAGER.seleCar.macType isEqualToString:GT51] || [USERMANAGER.seleCar.macType isEqualToString:GT52] || [USERMANAGER.seleCar.macType isEqualToString:GT121]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:L(@"This device is not supported") message:nil preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:L(@"OK") style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
        return;
    }
    if (!pickBackView) {
        pickBackView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 284, kScreenWidth, 240)];
        pickBackView.backgroundColor = HBackColor;
        [self.view addSubview:pickBackView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(5, 5,  80, 30);
        [cancelButton setTitle:L(@"Cancel") forState:UIControlStateNormal];
        if (IOS_VERSION >= 10.0) {
            [cancelButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        }
        cancelButton.titleLabel.font = [UIFont  boldSystemFontOfSize:18];
        [cancelButton addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [pickBackView addSubview:cancelButton];
        
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.frame = CGRectMake(kScreenWidth - 80, 5, 80, 30);
        if (IOS_VERSION >= 10.0) {
            [saveButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        }
        [saveButton setTitle:L(@"OK") forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont  boldSystemFontOfSize:18];
        [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [pickBackView addSubview:saveButton];
        
        UIPickerView * pickTimeView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth ,200)];
        pickTimeView.backgroundColor = [UIColor whiteColor];
        pickTimeView.dataSource = self;
        pickTimeView.delegate = self;
        pickTimeView.showsSelectionIndicator = YES;
        [pickBackView addSubview:pickTimeView];
        
    }else{
        pickBackView.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.topConstant.constant = kTopHeight;
    self.bottomConstanr.constant = kTabBarHeight;
    [self.listenButton setTitle:L(@"Receive") forState:UIControlStateNormal];
    
    alarmDataArray = [NSMutableArray array];
    lastId = @"0";
    selectInt = 10;
    reGetSoundTime = 0;
    [_myTableView registerNib:[UINib nibWithNibName:@"recordCell" bundle:nil] forCellReuseIdentifier:@"recordCell"];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = [UIColor clearColor];
    [self setNavi];
    
    //头部刷新 addAlarmListRefresh
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAlarmListRefresh)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _myTableView.mj_header = header;
    
    _myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addAlarmListRefresh)];
    
    [_myTableView.mj_header beginRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeTitleView];
    [self setupDropDownMenu];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAlarmListRefresh) name:@"SoundPush" object:nil];
}
-(void)changeTitleView{
    if (!isSeleOne) {
        titleLabel.text = L(@"All Equipment");
    }else{
        titleLabel.text = USERMANAGER.seleCar.macName;
    }
    CGRect rect = [titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT,44 ) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil];
    titleLabel.frame = CGRectMake((200 - TITLEWIGTH2 - 30)/2, 0, TITLEWIGTH2, 44);
    titleImage.frame = CGRectMake(titleLabel.right, 7, 30, 30);
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [TimeTimer invalidate];
    TimeTimer = nil;
}
/** 初始化下拉菜单 */
-(void)setupDropDownMenu{
    NSArray *modelsArray = [self getMenuModelsArray];
    [self.dropdownMenu removeFromSuperview];
    self.dropdownMenu = nil;
    
    self.dropdownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelsArray menuWidth:FFDefaultFloat eachItemHeight:FFDefaultFloat menuRightMargin:FFDefaultFloat triangleRightMargin:FFDefaultFloat];
    
    //如果有需要，可以设置代理（非必须）
    self.dropdownMenu.delegate = self;
    self.dropdownMenu.ifShouldScroll = YES;
    [self.dropdownMenu setup];
}
- (void)showDropDownMenu {
    [self.dropdownMenu showMenu];
}
-(void)ffDropDownMenuViewWillAppear{
    NSLog(@"菜单出现");
    titleImage.image = [UIImage imageNamed:@"up1.png"];
}
-(void)ffDropDownMenuViewWillDisappear{
    NSLog(@"菜单消失");
    titleImage.image = [UIImage imageNamed:@"down1.png"];
}
- (NSArray *)getMenuModelsArray {
    NSMutableArray *menuArray = [NSMutableArray array];
    FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:L(@"All Equipment") menuItemIconName:nil  menuBlock:^{
        isSeleOne = NO;
        [self getAlarmListRefresh];
        [self changeTitleView];
    }];
    [menuArray addObject:menuModel0];
    
    for (LocationModel*model in USERMANAGER.GT10CarArray) {
        FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:model.macName menuItemIconName:nil  menuBlock:^{
            isSeleOne = YES;
            USERMANAGER.seleCar = model;
            [self getAlarmListRefresh];
            [self changeTitleView];
        }];
        [menuArray addObject:menuModel0];
    }
    return menuArray;
}
-(void)NoGT10{
    if (kArrayIsEmpty(USERMANAGER.GT10CarArray)) {
        [UIUtil showProgressHUD:L(@"Please bind the device") inView:self.view];
        return;
    }
}
-(void)getAlarmListRefresh{
    [self NoGT10];
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    lastId = @"0";
    NSDictionary *dic = nil;
    NSString *pageNum = alarmDataArray.count >= 30?[NSString stringWithFormat:@"%ld",alarmDataArray.count]:@"30";
        if (!isSeleOne) {
            dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                    @"lastId":CsqStringIsEmpty(lastId) ,
                    @"pageNum":CsqStringIsEmpty(pageNum),
                    };
        }else{
            dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                    @"macId":CsqStringIsEmpty(USERMANAGER.seleCar.macId) ,
                    @"lastId":CsqStringIsEmpty(lastId) ,
                    @"pageNum":CsqStringIsEmpty(pageNum),
                   
                    };
        }
        
    
    [alarmDataArray removeAllObjects];
    [ZZXDataService HFZLRequest:@"record/get-record-info" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil hideProgressHUD];
             
             NSArray *dataArray = data[@"data"][@"recordInfos"];
             if (!kArrayIsEmpty(dataArray)) {
                 for (NSDictionary *dataDict in dataArray) {
                     recordModel *model = [recordModel provinceWithDictionary:dataDict];
                     [alarmDataArray addObject:model];
                     lastId = model.recordID;
                 }
             }
         }else{
             [UIUtil hideProgressHUD];
         }
         [_myTableView.mj_header endRefreshing];
         [_myTableView reloadData];
         [self changeEmptyView];
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
         [_myTableView.mj_header endRefreshing];
         [_myTableView reloadData];
         [self changeEmptyView];
     }];
}
-(void)addAlarmListRefresh{
    [self NoGT10];
    
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
 
    NSDictionary *dic = nil;
    
    if (!isSeleOne) {
        dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                @"lastId":CsqStringIsEmpty(lastId) ,
                @"pageNum":CsqStringIsEmpty(@"30"),
                };
    }else{
        dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                @"macId":CsqStringIsEmpty(USERMANAGER.seleCar.macId) ,
                @"lastId":CsqStringIsEmpty(lastId) ,
                @"pageNum":CsqStringIsEmpty(@"30"),
                
                };
    }
    
    
  
    [ZZXDataService HFZLRequest:@"record/get-record-info" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         
         if ([data[@"code"]integerValue] == 0) {
             
             NSArray *dataArray = data[@"data"][@"recordInfos"];
             if (!kArrayIsEmpty(dataArray)) {
                 for (NSDictionary *dataDict in dataArray) {
                     recordModel *model = [recordModel provinceWithDictionary:dataDict];
                     [alarmDataArray addObject:model];
                     lastId = model.recordID;
                 }
             }
         }else{
             
         }
         [UIUtil hideProgressHUD];
         [_myTableView.mj_footer endRefreshing];
         [_myTableView reloadData];
         [self changeEmptyView];
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
         [_myTableView.mj_footer endRefreshing];
         [_myTableView reloadData];
         [self changeEmptyView];
     }];
}
-(void)changeEmptyView{
    if (alarmDataArray.count == 0) {
        [_myTableView addEmptyViewWithImageName:@"" title:L(@"The current device is not recorded")];
        _myTableView.emptyView.hidden = NO;
    }else{
        _myTableView.emptyView.hidden = YES;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.5;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return alarmDataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"recordCell";
    recordCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.tag = 100 + indexPath.row;
    [cell setModel:alarmDataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    recordModel *model = alarmDataArray[indexPath.row];
    switch ([model.loadStatusStr intValue]) {
        case 1:
        {
            NSLog(@"下载");
            downRecordModel = model;
            [self downSound:model.downPathStr :[NSString stringWithFormat:@"/%@%@.amr",model.imeiStr,model.recordID]];
        }
            break;
        case 2:
            NSLog(@"正在下载");
            break;
        case 3:
        {
            NSLog(@"播放");
            if (model != playRecordModel) {
                playRecordModel.isPlay = NO;
                playRecordModel = model;
                playRecordModel.isPlay = YES;
                
                [self playRecord:model.saveRoadStr];
            }else{
                if (playRecordModel.isPlay) {
                    [self stopRecord];
                }else{
                    playRecordModel.isPlay = YES;
                    [self playRecord:model.saveRoadStr];
                }
            }
            [_myTableView reloadData];
        }
            break;
        case 4:
        {
            NSLog(@"重新下载");
            downRecordModel = model;
            [self  downSound:model.downPathStr :[NSString stringWithFormat:@"/%@%@.amr",model.imeiStr,model.recordID]];
            break;
        }
        default:
            break;
    }
}

-(void)downSound:(NSString *)downStr :(NSString*)saveStr{
    NSLog(@"downStr = %@",downStr);
    _downStr = downStr;
    //http://www.ifengstar.com:80/download/2/h4/3917227447_9536.amr
    //http://agt10.ifengstar.com:80/xqgt/record/1/h4/1358035805456_074755.amr
    // http://agt10.ifengstar.com:80/xqgt/record/1/h5/1358035805456_083256.amr
    _saveStr = saveStr;
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    downRecordModel.loadStatusStr = @"2";
    [_myTableView reloadData];
    
    NSURL * url = [NSURL URLWithString:_downStr];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    _connection = nil;
    _data = nil;
    _connection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self];
    //创建数据对象，用于装载数据
    _data = [[NSMutableData alloc]init];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(nonnull NSURLResponse *)response{
    NSLog(@"收到服务器响应，即将建立链接下载数据");
    //如果协议是http响应，证明响应是正确的，打印响应的状态。200成功，404失败
    if ([response isKindOfClass:[NSHTTPURLResponse class]] == YES) {
        NSHTTPURLResponse * httpResponse = (id)response;
        NSLog(@"%ld",httpResponse.statusCode);
    }
    //接收到响应，即将下载时清空data
    _data.length = 0;
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data{
    //如果数据比较大，这个函数会反复调用，每次获取部分数据，数据就是参数data
    //将每次下载到的数据拼接到一起
    [_data appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"数据接收完毕");
    NSLog(@"%s",_data.bytes);
    
    self.filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingString:_saveStr];
    [_data writeToFile:self.filePath atomically:YES];
//    NSLog(@"%@",[self getVoiceFileInfoByPath:self.filePath convertTime:0]);
    NSString* wavPath = [self.filePath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];
    
    NSLog(@"wavPath = %@",wavPath);
    if ([VoiceConverter ConvertAmrToWav:self.filePath wavSavePath:wavPath]){
        
        downRecordModel.loadStatusStr = @"3";
        downRecordModel.saveRoadStr = [NSString stringWithFormat:@"/%@%@.wav",downRecordModel.imeiStr, downRecordModel.recordID];
        //                    if(!playRecordModel.isPlay){
        playRecordModel.isPlay = NO;
        playRecordModel = downRecordModel;
        playRecordModel.isPlay = YES;
        [self playRecord:playRecordModel.saveRoadStr];
        //                    }
        [_myTableView reloadData];
        [UIUtil hideProgressHUD];
        
//        for (recordModel *model in remoteNotiArray) {
//            if ([model.recordID isEqualToString:downRecordModel.recordID]) {
//                model.loadStatusStr = @"3";
//                model.saveRoadStr = [NSString stringWithFormat:@"/%@.wav",model.recordID];
//            }
//        }
//        NSData* remoteNotiData = [NSKeyedArchiver archivedDataWithRootObject:remoteNotiArray];
//        if (remoteNotiArray.count != 0) {
//            [USER_PLIST setObject:remoteNotiData forKey:@"RECORDNOTI"];
//            [USER_PLIST synchronize];
//        }
    }else{
        [self downDefult];
    }
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"下载发生错误: %@",error);
    [self downDefult];
}

-(void)playRecord:(NSString*)wavPath{
    if (kStringIsEmpty(wavPath)) {
        [UIUtil showToast:L(@"Play path error") inView:self.view];
        [self stopRecord];
        return;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    NSError *playError;
    
    self.Rplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingString:wavPath]] error:&playError];
    if (self.Rplayer == nil) {
        NSLog(@"Error crenting player: %@", [playError description]);
    }
    self.Rplayer.delegate = self;
    [self.Rplayer play];
}
-(void)stopRecord{
    playRecordModel.isPlay = NO;
    [_myTableView reloadData];
    [self.Rplayer stop];
    self.Rplayer = nil;
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //按钮标题变为播放
    NSLog(@"播放完毕");
    [self stopRecord];
}
-(void)downDefult{
    downRecordModel.loadStatusStr = @"4";
    [_myTableView reloadData];
    [UIUtil hideProgressHUD];
//    for (recordModel *model in remoteNotiArray) {
//        if ([model.recordID isEqualToString:downRecordModel.recordID]) {
//            model.loadStatusStr = @"4";
//        }
//    }
//    NSData* remoteNotiData = [NSKeyedArchiver archivedDataWithRootObject:remoteNotiArray];
//    if (remoteNotiArray.count != 0) {
//        [USER_PLIST setObject:remoteNotiData forKey:@"RECORDNOTI"];
//        [USER_PLIST synchronize];
//    }
    
}

-(void)setNavi{
    self.view.backgroundColor = HBackColor;

    UIButton *titileBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    titileBUtton.frame = CGRectMake(0, 0, 200, 44);
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 170, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [titileBUtton addSubview:titleLabel];
    
    titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(170, 7, 30, 30)];
    titleImage.image = [UIImage imageNamed:@"down1.png"];
    [titileBUtton addSubview:titleImage];
    [titileBUtton addTarget:self action:@selector(showDropDownMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titileBUtton;
    isSeleOne = NO;
}
-(void)showLeft{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma pickDele
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//每组有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 6;
    }else
        return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *timeArray = @[@"10S",@"20S",@"30S",@"40S",@"50S",@"60S"];
    return timeArray[row];
}

//选择了某行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectInt = (int)(row + 1)*10;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50.0;
}
-(void)saveClick{
    pickBackView.hidden = YES;
    recordInt = 0;
    if (reGetSoundTime == 0) {
        [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
        [self getRecord];
    }else{
        [UIUtil showToast:L(@"The device is recording")  inView:self.view];
    }
}
-(void)cancelButton{
    pickBackView.hidden = YES;
}
-(void)getRecord{
    UISwitch *ch = [UISwitch new];
    ch.tag = 100;
    [self sendInstr:0 :ch];
}
-(void)sendInstr:(int)intCount :(UISwitch*)switCH{
    NSLog(@"intCount = %d;",intCount);
    int tag = (int)switCH.tag - 100;
    NSString *instructionStr ;
    NSString *typeStr;
    switch (tag) {
        case 0:
        {
            instructionStr = [NSString stringWithFormat:@"RECODE,%@",[NSString   stringWithFormat:@"%d",selectInt]];
            typeStr = @"RECODE";
        }
            break;
        
        default:
            break;
    }
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(USERMANAGER.seleCar.macId),//
                          @"instructions":instructionStr,
                          @"type":typeStr,
                          @"count":[NSString stringWithFormat:@"%ld",(long)intCount]
                          };
    intCount++;
    [ZZXDataService HFZLRequest:@"instruction/send" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         
         if ([data[@"code"]integerValue] == 101054) {
             if (intCount <= mostNunber) {
                 CSQ_DISPATCH_AFTER(2.0, ^{
                     [self sendInstr:intCount :switCH];
                 })
             }
             
             else{
                 [UIUtil showToast:L(@"Connection timeout") inView:self.view];
                 switCH.on = !switCH.on;
             }
         }else if([data[@"code"]integerValue] == 0){
             [UIUtil showToast:L(@"Send command successful") inView:self.view];
             switch (tag) {
                 case 0:
                    {
                        if (TimeTimer == nil) {
                            reGetSoundTime = selectInt + selectInt /10 + 5;
                            TimeTimer  = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                          target:self
                                                                        selector:@selector(timeDele)
                                                                        userInfo:nil
                                                                         repeats:YES];
                        }
                    }
                     break;
                 
                 default:
                     break;
             }
             
             
         }
         showErrorCode(switCH.on = !switCH.on;)
//         else if ([data[@"code"]integerValue] == 101051){
//             [UIUtil showToast:@"设备不在线" inView:self.view];
//             switCH.on = !switCH.on;
//         }else if ([data[@"code"]integerValue] == 101052){
//             [UIUtil showToast:@"未连接到设备" inView:self.view];
//             switCH.on = !switCH.on;
//         }
//         else{
//             [UIUtil showToast:data[@"msg"] inView:self.view];
//             switCH.on = !switCH.on;
//         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
         switCH.on = !switCH.on;
     }];
    
}
-(void)timeDele{
    reGetSoundTime--;
    if (reGetSoundTime == 0) {
        [TimeTimer invalidate];
        TimeTimer = nil;
        reGetSoundTime = 0;
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
