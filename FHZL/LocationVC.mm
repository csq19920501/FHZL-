//
//  LocationVC.m
//  FHZL
//
//  Created by hk on 17/12/18.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "BindDeviceVC.h"
#import "UserCenterOldVC.h"
#import "InstructionStateModel.h"
#import "NSDictionary+SetNullWithStr.h"
#import "JZLocationConverter.h"
#import "LocationVC.h"
#import "Header.h"
#import "CustomeCsqButton.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "ShowCarView.h"
//#import "CarListModel.h"
#import "LocationModel.h"
#import "CarTrackVC.h"
#import "TrackPlayBackVC.h"
#import "FenceVC.h"
#import "AlarmListVC.h"
#import "CarInfoVC.h"
#import "InstructionVC.h"
#import "UIImage+Rotate.h"
#define carViewHeigth (kScreenHeight - (TabbarHigth + carScrHeigth) - 10)
#define L(key)  NSLocalizedString(key, nil)
typedef NS_OPTIONS(NSInteger,CSQIfOpen){
//    Clock = 45,
    Half = 105,
//    Open = 205,
//    isIphone4Open = 155,
};

@interface LocationVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UIScrollViewDelegate>
{
    BMKPointAnnotation* pointAnnotationTest;
//    BMKLocationService* _locService;
    BMKPointAnnotation* pointAnnotation;
    BMKPinAnnotationView *annotationView;
    CLLocationCoordinate2D centerCoordinate;
    CLLocationCoordinate2D _userCoordinate;
    CLLocationCoordinate2D _carCoordinate;
    BOOL isFirst;
    LocationModel *carStateModel;
    NSMutableArray *carStateArray;
    LocationModel *CarModelAdding;
    NSTimer *timer;
    int tipInt;
    int isOneGeo;
    UIScrollView *CarScrView;
    CGFloat carScrHeigth;
    NSMutableArray *carAllArray;
    int seleCount;
    NSMutableArray *seleArray;
    BOOL    ChangeInfo;
    CGFloat Open;
    CGFloat Clock;
    BOOL isCanAutoMapView; //是否每次都刷新地图
    
    BOOL isCanAutoMoreView;
    BOOL isCanAutoOneView;
}
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (weak, nonatomic) IBOutlet UIView *FucnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MiddleViewHeigth;
@property (weak, nonatomic) IBOutlet UIButton *changeCarButton;
@property (weak, nonatomic) IBOutlet BMKMapView *_mapView;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;


@end

@implementation LocationVC

- (IBAction)gotoTuPai:(id)sender {
    
}

- (IBAction)reloadCar:(id)sender {
    [self AllCarRequest];
    
//    if (pointAnnotationTest == nil) {
//        pointAnnotationTest = [[BMKPointAnnotation alloc]init];
//        CLLocationCoordinate2D coor;
//        coor.latitude = 39.915;
//        coor.longitude = 116.404;
//        pointAnnotationTest.coordinate = coor;
//        pointAnnotationTest.title = @"test";
//        pointAnnotationTest.subtitle = @"此Annotation可拖拽!";
//    }
//    [__mapView addAnnotation:pointAnnotationTest];
}

- (IBAction)addLevel:(id)sender {
    __mapView.zoomLevel++;
}
- (IBAction)deleLevel:(id)sender {
    __mapView.zoomLevel--;
}
//没作用
- (IBAction)HiddenButto:(id)sender {
    UIButton *but = sender;
    if (!but.selected) {
        _MiddleViewHeigth.constant = 0;
    }else{
        _MiddleViewHeigth.constant = 100;
    }
    but.selected = !but.selected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topConstant.constant = kTopHeight;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AllCarRequest) name:@"UnBindSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeInfo) name:@"ChangeInfo" object:nil];
    
    Open = (isIphone4)? 145:205;
    Clock = (isIphone4)? 30:45;
//    Open = 155;
//    Clock = 35;
    carScrHeigth = Clock;
    seleCount = 0;
    [self  setNavi];
    [self setMap];
    
    carStateModel = [[LocationModel alloc]init];
    isFirst = YES;
//    __mapView.showsUserLocation = YES;//显示定位图层
//    [_locService startUserLocationService];

    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
    carAllArray = [NSMutableArray array];
    seleArray = [NSMutableArray array];
    [self AllCarRequest];
}

-(void)isOpenClick:(UIButton*)but{
    but.selected = !but.selected;
    
    for (ShowCarView  *carView in CarScrView.subviews) {
        if ([carView isKindOfClass:[ShowCarView class]]) {
             carView.isOpenButton.selected = but.selected;
             carView.buttonView.hidden = carView.isOpenButton.selected;
        }
    }
    
    if (but.selected) {
        NSLog(@"收缩");
        carScrHeigth = Clock;
        CarScrView.frame = CGRectMake(10, carViewHeigth, kScreenWidth - 20, carScrHeigth);
        CarScrView.contentSize = CGSizeMake(CarScrView.frame.size.width * carAllArray.count, Clock);
    }else{
        NSLog(@"伸展");
        carScrHeigth = Open;
        CarScrView.frame = CGRectMake(10, carViewHeigth, kScreenWidth - 20, carScrHeigth);
        CarScrView.contentSize = CGSizeMake(CarScrView.frame.size.width * carAllArray.count, carScrHeigth);
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [__mapView viewWillAppear];
    __mapView.delegate = self;
    _geoCodeSearch.delegate = self;
    isCanAutoMapView = YES;
    isCanAutoMoreView = YES;
    isCanAutoOneView = YES;
    [self changeNavi];
    [self changeUserInfo];
    
    if (!timer) {
        if (!isFirst) {
            [self AllCarRequestNoUiutil];
        }
        getTimer(timer,4,AllCarRequestNoUiutil)
    }
    isFirst = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [__mapView viewWillDisappear];
    __mapView.delegate = nil;
    _geoCodeSearch.delegate = nil;
    //    _locService.delegate = nil;
    //    [_locService stopUserLocationService];
    
    endTimer(timer)
}


-(void)changeUserInfo{
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID)};
    
    [ZZXDataService HFZLRequest:@"main/view" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             
             UserManager *userManager = [UserManager sharedInstance];
             userManager.user.isLogined = YES;
             
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
             
             NSArray *cardVeiwArr = data[@"data"][@"cardVeiws"];
             if (!kArrayIsEmpty(cardVeiwArr)) {
                 [userManager.AllDeviceArray removeAllObjects];
                 for (NSDictionary *cardDict in cardVeiwArr) {
                     NSLog(@"desc = %@",cardDict[@"desc"]);
                     NSDictionary *cardD;
                     if ([cardDict[@"viewId"] isEqualToString:@"101"]) {
                         NSLog(@"添加101");
                         cardD  = @{TYPE:GT10,orderNum:cardDict[@"orderNum"]};
                         [userManager.AllDeviceArray addObject:cardD];
                     }else if([cardDict[@"viewId"] isEqualToString:@"102"]){
                         NSLog(@"添加102");
                         //                         cardD = @{TYPE:MUSIC,orderNum:cardDict[@"orderNum"]};
                         //                         [userManager.AllDeviceArray addObject:cardD];
                     }else if([cardDict[@"viewId"] isEqualToString:@"103"]){
                         NSLog(@"添加103");
                         cardD = @{TYPE:SUIPAI,orderNum:cardDict[@"orderNum"]};
                         [userManager.AllDeviceArray addObject:cardD];
                     }
                     
                 }
             }
             [[UserManager sharedInstance] save];
             [self changeNavi];
      
         }else{
             //             [UIUtil showToast:@"请重新登录" inView:self.view];
             //             switch ([data[@"code"]integerValue]) {
             //                 case 101016:
             //                 {
             //                     [UIUtil showToast:@"账户密码错误" inView:self.view];
             //                 }
             //                     break;
             //                 case 101017:
             //                 {
             //                     [UIUtil showToast:@"账户未注册" inView:self.view];
             //                 }
             //                     break;
             //                 default:
             //                     [UIUtil showToast:@"登录失败" inView:self.view];
             //                     break;
             //             }
         }
     } fail:^(NSError *error)
     {
     }];
    
    
    
    [ZZXDataService HFZLRequest:@"alarm/get-condition" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             SDLog(@"condition = %@",data[@"data"]);
         }
     } fail:^(NSError *error)
     {
     }];
}
-(void)changeNavi{
    
    if ([[UserManager sharedInstance].user.iconId integerValue] >= 1 && [[UserManager sharedInstance].user.iconId integerValue] <= 12) {
        [self addNavigationItemWithImageNames
         :@[[NSString stringWithFormat:@"ui2_user_icon%ld.png",(long)[USERMANAGER.user.iconId integerValue]]] isLeft:YES target:self action:@selector(showLeft) tags:@[@1000]];
    }else if([[UserManager sharedInstance].user.iconId integerValue] == 13 ){
        if (!headImageIsEmpty(USERMANAGER.user.headPicPath) ) {
            [self addNavigationItemWithImageNames
             :@[USERMANAGER.user.headPicPath] isLeft:YES target:self action:@selector(showLeft) tags:@[@1000]];
        }else{
            [self addNavigationItemWithImageNames
             :@[@"微众世界_头像0"] isLeft:YES target:self action:@selector(showLeft) tags:@[@1000]];
        }
    }
    else if( [[UserManager sharedInstance].user.iconId integerValue] == 14){
        if (!headImageIsEmpty(USERMANAGER.user.upPicPath) ) {
            [self addNavigationItemWithImageNames
             :@[USERMANAGER.user.upPicPath] isLeft:YES target:self action:@selector(showLeft) tags:@[@1000]];
        }else{
            [self addNavigationItemWithImageNames
             :@[@"微众世界_头像0"] isLeft:YES target:self action:@selector(showLeft) tags:@[@1000]];
        }
    }else
    {
        [self addNavigationItemWithImageNames
         :@[@"微众世界_头像0"] isLeft:YES target:self action:@selector(showLeft) tags:@[@1000]];
    }
//    self.navigationController.navigationBar.hidden = NO;
//    self.title = @"主页";
}


-(void)setMap{
    __mapView.zoomLevel = 16.1;
    __mapView.delegate = self;
    __mapView.isSelectedAnnotationViewFront = YES;
//    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
//    param.isRotateAngleValid = true;
//    param.isAccuracyCircleShow = NO;
//    param.locationViewImgName = @"bnavi_icon_location_fixed@2x";
//    param.locationViewOffsetX = 0;
//    param.locationViewOffsetY = 0;
//    [__mapView updateLocationViewWithParam:param];
//    
//    _locService = [[BMKLocationService alloc]init];
//    _locService.delegate = self;
//    [_locService setPausesLocationUpdatesAutomatically:NO];
    if ([USERMANAGER.user.loginType isEqualToString:@"1"]) {
        self.changeCarButton.hidden = YES;
    }
}




-(void)AllCarRequest{
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    isCanAutoMapView = YES;

    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID)
                          };
    [ZZXDataService HFZLRequest:@"track/get-tracks" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             NSArray *userArray = data[@"data"];
             if (!kArrayIsEmpty(userArray)) {
                 [UIUtil hideProgressHUD];
                 [seleArray removeAllObjects];
                 [carAllArray removeAllObjects];
                 carStateModel = nil;
                 USERMANAGER.seleCar = carStateModel;
                 
                 
                 int modelCount = 0;
                 for (NSDictionary *carDict in userArray) {

                     
                     LocationModel *model = [LocationModel provinceWithDictionary:carDict];
                     CLLocationCoordinate2D Locateoiooo;
                     Locateoiooo.latitude = [[carDict getStringValueForKey:@"y" defaultValue:@" "]  floatValue];
                     Locateoiooo.longitude = [[carDict getStringValueForKey:@"x" defaultValue:@" "] floatValue];
                     Locateoiooo = [JZLocationConverter BD_bd09ToWgs84:Locateoiooo];
                     model.x = [NSString stringWithFormat:@"%f",Locateoiooo.longitude];
                     model.y = [NSString stringWithFormat:@"%f",Locateoiooo.latitude];
                     if (modelCount == seleCount) {
                         carStateModel = model;
                         USERMANAGER.seleCar = carStateModel;
                     }
                     if (kStringIsEmpty(model.macName)) {
                         model.macName = model.macId;
                     }
                     if ([model.ico intValue] < 1 || [model.ico intValue] > 13) {
                         model.ico = @"0";
                     }
                     if (Locateoiooo.latitude <100.) {
                         model.tagNumber = modelCount;
                         modelCount++;
                         [carAllArray addObject:model];
                     }
                 }
                 
                 [USERMANAGER.GT10CarArray removeAllObjects];
                 [USERMANAGER.GT10CarArray addObjectsFromArray:carAllArray];
                 [USERMANAGER save];
                 [self reSetAllCarView];
             }else{
                 [UIUtil showToast:L(@"You are not currently bound devices") inView:self.view];
                 [USERMANAGER.GT10CarArray removeAllObjects];
                 [USERMANAGER save];
                 [self reSetAllCarView];
             }
         }else{
             switch ([data[@"code"]integerValue]) {
                 case 200002:
                 {
                     [UIUtil showToast:L(@"You are not currently bound devices") inView:self.view];
                 }
                     break;
                 default:
                     [UIUtil showToast:L(@"For failure") inView:self.view];
                     break;
             }
         }
     } fail:^(NSError *error)
     {
     }];
}
-(void)refreshAllCarView{
    if (!__mapView.delegate) {
        return;  //防止页面disappear后刷新地图出现红色大头针
    }
    //删除已经定位过的记录
    [seleArray removeAllObjects];
    if (_changeCarButton.selected) {
        [self addOneAnnotation];
    }else{
        [self addAllAnnotation];
//        [self refreshAllAnnotation];
    }
    
    if (CarScrView != nil) {
        for (int i = 0; i < carAllArray.count; i ++) {
            ShowCarView  *carView = (ShowCarView  *)[CarScrView viewWithTag:(1200 + i)];
            
            if (isIphone4) {
                carView.topViewConstraint.constant = 30;
                carView.bottomViewConstraint.constant = 45;
            }

            LocationModel *model = carAllArray[i];
            
            //删除已经定位过的记录
            model.addressStr = nil;
            [carView setLocationModel:model];
//            [carView.getAddressButton setTitle:L(@"View Address") forState:UIControlStateNormal];
        }
    }
}

-(void)reSetAllCarView{
    //生成scrollview
    if (!__mapView.delegate) {
        return;//防止页面disappear后刷新地图出现红色大头针
    }
    [seleArray removeAllObjects];
    
    [CarScrView removeFromSuperview];
    CarScrView = nil;
    CarScrView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, carViewHeigth, kScreenWidth - 20, Open)];
    
    CarScrView.layer.cornerRadius = 8;
    CarScrView.layer.masksToBounds = YES;
    
    float width = kScreenWidth - 20   ;
    float heigth = Open;
    CarScrView.contentSize = CGSizeMake(width * carAllArray.count, heigth);
    CarScrView.showsHorizontalScrollIndicator = NO;
    CarScrView.pagingEnabled = YES;
    CarScrView.delegate = self;
    CarScrView.bounces = YES;
    [self.view addSubview:CarScrView];
    //填充自定义view
    for (int i = 0; i < carAllArray.count; i ++) {
        ShowCarView  *carView= [[ShowCarView alloc]init];
        carView.tag = 1200 + i;
        [carView showInView:CarScrView withFrame:CGRectMake(i *width, 0, width, heigth)];
        carView.isOpenButton.selected = carScrHeigth==Clock?YES:NO;
        
        if (isIphone4) {
            carView.topViewConstraint.constant = 30;
            carView.bottomViewConstraint.constant = 45;
        }
        
//        carView.buttonView.hidden = carScrHeigth==Clock?YES:NO;
        [carView.isOpenButton addTarget:self action:@selector(isOpenClick:) forControlEvents:UIControlEventTouchUpInside];
        [carView.getAddressButton addTarget:self action:@selector(getAddressClick:) forControlEvents:UIControlEventTouchUpInside];
        
        LocationModel *model = carAllArray[i];
        [carView setLocationModel:model];
        //删除已经定位过的记录
        model.addressStr = nil;
        [carView setLocationModel:model];
//        [carView.getAddressButton setTitle:L(@"View Address") forState:UIControlStateNormal];
        //生成自定义button列表
        DISPATCH_ON_MAIN_THREAD((^{
            NSArray *buttonArray = @[L(@"Track"),L(@"trajectory"),L(@"Electronic fence"),L(@"instructions"),L(@"alert"),@"SIM"];
            NSArray *imageArray = @[@"列表_4_N.png",@"列表_6_N.png",@"列表_7_N.png",@"列表_8_N.png",@"列表_9_N.png",@"SIMka_N.png",];
            NSArray *higthLigthImageArray = @[@"列表_4_P.png",@"列表_6_P.png",@"列表_7_P.png",@"列表_8_P.png",@"列表_9_P.png",@"SIMka_P.png"];
//            CGRect rect = carView.buttonView.bounds;
 
            
            CGFloat width = CarScrView.width/buttonArray.count;
            CGFloat height = 40.;
            CGFloat top = 10.;
            if (isIphone4) {
                top = 0.;
            }
            for (int i = 0 ; i < buttonArray.count; i++) {
                CustomeCsqButton *csqButtom = [[CustomeCsqButton alloc]initWithFrame:CGRectMake(i * width, top, width, height) normalImageStr:imageArray[i] seleImageStr:higthLigthImageArray[i] higligthImageStr:higthLigthImageArray[i] titleStr:buttonArray[i] numberStr:nil ClickBlock:^(NSInteger number){
                    
                    switch (number) {
                        case 0:
                        {
                            CarTrackVC *trackVC = [[CarTrackVC alloc]init];
                            trackVC.carModel = carStateModel;
                            SDLog(@"carStateModel.macType = %@",carStateModel.macType);
                            [self.navigationController pushViewController:trackVC animated:YES];
                           
                            
                        }
                            break;
                        case 1:
                        {
                            TrackPlayBackVC *viewVC = [TrackPlayBackVC new];
                            viewVC.carModel = carStateModel;
                            [self.navigationController pushViewController:viewVC animated:YES];
//                            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewVC];
//                            [self presentViewController:nav animated:YES completion:nil];
                        }
                            break;
                        case 2:
                        {
                            FenceVC *fenceVC = [[FenceVC alloc]init];
                            fenceVC.carModel = carStateModel;
                            [self.navigationController pushViewController:fenceVC animated:YES];
                        }
                            break;
                        case 3:
                        {
                            [UIUtil showProgressHUD:nil inView:self.view];
                            [self getInstrInfo];
                        }
                            break;
                        case 4:
                        {
                            AlarmListVC *alarmVC = [[AlarmListVC alloc]init];
                            alarmVC.carModel = carStateModel;
                            alarmVC.selfType = One;
                            [self.navigationController pushViewController:alarmVC animated:YES];
                        }
                            break;
                        case 5:
                        {
                            CarInfoVC *carInfoVC = [[CarInfoVC alloc]init];
                            carInfoVC.carModel = carStateModel;
                            [self.navigationController pushViewController:carInfoVC animated:YES];
                        }
                            break;
                        default:
                            break;
                    }
                }];
                csqButtom.tag = i;
                [carView.buttonView addSubview:csqButtom];
            }
        }));
    }
    //生成大头针
    if (_changeCarButton.selected) {
        [self addOneAnnotation];
        [UIView animateWithDuration:0.01 animations:^{
            //新的方法起作用
            [CarScrView setContentOffset:CGPointMake((kScreenWidth - 20)*seleCount, 0) animated:YES];
        } completion:^(BOOL finished) {
        }];
        CarScrView.scrollEnabled = NO;
    }else{
        [self addAllAnnotation];
        CarScrView.scrollEnabled = YES;
        [UIView animateWithDuration:0.01 animations:^{
            //新的方法起作用
            [CarScrView setContentOffset:CGPointMake((kScreenWidth - 20)*seleCount, 0) animated:YES];
        } completion:^(BOOL finished) {
        }];
    }
    //缩小菜单
    if (carScrHeigth == Clock) {
        UIButton *selebut = [UIButton buttonWithType:UIButtonTypeCustom];
        selebut.selected = NO;
        [self isOpenClick:selebut];
    }
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView*  annotationViewAll = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationViewAll == nil) {
        annotationViewAll = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    // 设置颜色
    annotationViewAll.pinColor = BMKPinAnnotationColorPurple;
    // 从天上掉下效果
    annotationViewAll.animatesDrop = NO;
    // 设置可拖拽
    annotationViewAll.draggable = NO;
    //mycar_top_0_n
   
    NSString *str = [NSString stringWithFormat:@"mycar_top_%d_%@",[CarModelAdding.ico intValue],[CarModelAdding.online intValue] == 0?@"p":@"n"];
    annotationViewAll.image = [UIImage imageNamed:str];//
    
    annotationViewAll.centerOffset = CGPointMake(0, 0);
    //必须设置YES 才能显示气泡
    annotationViewAll.canShowCallout = YES;
    
    annotationViewAll.tag = 1000 + CarModelAdding.tagNumber ;
    NSInteger dir = [CarModelAdding.dir integerValue];

    annotationViewAll.image = [annotationViewAll.image imageRotatedByDegrees:dir];
    
    return annotationViewAll;
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
//    NSLog(@"点击空白位置");
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    seleCount = (int)view.tag - 1000;
    if (seleCount >= 0) {
        NSLog(@"选中annotation   %d",seleCount);
        LocationModel *model = carAllArray[seleCount];
        carStateModel = model;
        USERMANAGER.seleCar = carStateModel;
        pointAnnotation =  view.annotation;
//        [self reSetAllCarView];
        
        if (_changeCarButton.selected) {
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                //新的方法起作用
                [CarScrView setContentOffset:CGPointMake((kScreenWidth - 20)*seleCount, 0) animated:YES];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (IBAction)changeCarCount:(id)sender {
    UIButton *_changeCarButton = sender;
    
    if (!_changeCarButton.selected) {
        isCanAutoOneView = YES;
        [UIUtil showToast:L(@"Enter Single Vehicle Mode") inView:self.view];
        [self addOneAnnotation];
//        CarScrView.scrollEnabled = NO;
    }else{
        isCanAutoMapView = YES;
        isCanAutoMoreView = YES;
        [UIUtil showToast:L(@"Enter Multi-Vehicle Mode") inView:self.view];
        [self addAllAnnotation];
        CarScrView.scrollEnabled = YES;
    }
    _changeCarButton.selected = !_changeCarButton.selected;
    
    UIButton *selebut = [UIButton buttonWithType:UIButtonTypeCustom];
    selebut.selected = NO;
    [self isOpenClick:selebut];
}



-(void)addAllAnnotation{
    if (isCanAutoMoreView) {
        [self autoMapView];
        isCanAutoMoreView = NO;
    }
    
    pointAnnotation = nil;
    [__mapView selectAnnotation:nil animated:YES];
    [__mapView removeAnnotations:__mapView.annotations];
    for (LocationModel *model in carAllArray) {
        CarModelAdding = model;
        CLLocationCoordinate2D carCoordinate2D = CLLocationCoordinate2DMake( [model.y floatValue],
                                                                            [model.x floatValue]);;
        BMKPointAnnotation *allPOI = [[BMKPointAnnotation alloc]init];
        allPOI.coordinate = carCoordinate2D;
        allPOI.title = CarModelAdding.macName;
        if (model == carStateModel) {
            _carCoordinate = carCoordinate2D;
            pointAnnotation = allPOI;
        }
        [__mapView addAnnotation:allPOI];
    }
    //地图添加后在设置则能显示 开关要打开
    [__mapView selectAnnotation:pointAnnotation animated:YES];
//    __mapView.isSelectedAnnotationViewFront = YES;
}
-(void)refreshAllAnnotation{
    
    [self autoMapView];
    
//    pointAnnotation = nil;
//    [__mapView selectAnnotation:nil animated:YES];
//    [__mapView removeAnnotations:__mapView.annotations];
    
    //地图添加后在设置则能显示 开关要打开
    for (int i = 0; i < carAllArray.count; i++) {
        LocationModel *model = (LocationModel*)carAllArray[i];
        BMKPointAnnotation *allPOI = (BMKPointAnnotation*)__mapView.annotations[i];
        allPOI.coordinate = CLLocationCoordinate2DMake( [model.y floatValue],
                                                       [model.x floatValue]);
    }
    _carCoordinate = pointAnnotation.coordinate;
    
//    [__mapView selectAnnotation:pointAnnotation animated:YES];

}

-(void)addOneAnnotation{
//    CarScrView.scrollEnabled = NO;
    
    pointAnnotation = nil;
    [__mapView removeAnnotations:__mapView.annotations];
    for (LocationModel *model in carAllArray) {
        if (model == carStateModel) {
            CarModelAdding = model;
            CLLocationCoordinate2D carCoordinate2D = CLLocationCoordinate2DMake( [model.y floatValue],
                                                                                [model.x floatValue]);;
            BMKPointAnnotation *allPOI = [[BMKPointAnnotation alloc]init];
            allPOI.coordinate = carCoordinate2D;
            allPOI.title = CarModelAdding.macName;
            _carCoordinate = carCoordinate2D;
            pointAnnotation = allPOI;
            [__mapView addAnnotation:allPOI];
        } 
    }
    [__mapView selectAnnotation:pointAnnotation animated:YES];
    _carCoordinate =  CLLocationCoordinate2DMake( [carStateModel.y floatValue],
                                                 [carStateModel.x floatValue]);
    BMKCoordinateRegion userRegion ;
    if (isCanAutoOneView) {
        userRegion.center = _carCoordinate;
        userRegion.span.latitudeDelta = 0.005;
        userRegion.span.longitudeDelta = 0.005;
        isCanAutoOneView = NO;
    }else{
        userRegion = __mapView.region;
        userRegion.center = _carCoordinate;
    }
    [__mapView setRegion:userRegion animated:NO];

}
-(void)getAddressClick:(UIButton *)but{
    LocationModel *model = carAllArray[seleCount];
    if (kStringIsEmpty(model.addressStr)) {
        [but setTitle:L(@"Getting location") forState:UIControlStateNormal];
        BMKReverseGeoCodeOption *reverseGeocodeOption = [[BMKReverseGeoCodeOption alloc] init];
        
        
        reverseGeocodeOption.reverseGeoPoint = CLLocationCoordinate2DMake([model.y floatValue], [model.x floatValue]);
        [_geoCodeSearch reverseGeoCode:reverseGeocodeOption];
        [seleArray addObject:[NSString stringWithFormat:@"%d",seleCount]];
    }
}
#pragma mark --- BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0)
    {
        for (NSObject *object in seleArray) {
            int seleInt = [(NSString *)object intValue];
            LocationModel *model = carAllArray[seleInt];
            if (kStringIsEmpty(model.addressStr)) {
                if (seleInt <= carAllArray.count -1) {

                    if (result.poiList.count != 0) {
                        BMKPoiInfo *modelInfo = result.poiList[0];
                        model.addressStr  = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,modelInfo.name];
                    }else{
                        model.addressStr  = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,result.sematicDescription];
                    }
                    
                    ShowCarView *carView = [self.view viewWithTag:1200+seleInt];
                    [carView.getAddressButton setTitle:model.addressStr forState:UIControlStateNormal];
                }
            }
        }
        NSLog(@"result = %@,%@,%@",result.address,result.poiList[0],result.sematicDescription);

    }
}

-(void)autoMapView{
    if (isCanAutoMapView) {
        BMKMapPoint * temppoints = new BMKMapPoint[carAllArray.count];
        
        for (int i = 0; i <carAllArray.count; i++) {
            LocationModel *model = carAllArray[i];
            CLLocationCoordinate2D coor1;
            coor1.latitude = [model.y floatValue];
            coor1.longitude = [model.x floatValue];
            //        coor1 = [JZLocationConverter wgs84ToBd09:coor1];
            BMKMapPoint pt1 = BMKMapPointForCoordinate(coor1);
            temppoints[i].x = pt1.x;
            temppoints[i].y = pt1.y;
        }
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:carAllArray.count];
        [self mapViewFitPolyLine:polyLine];
//        isCanAutoMapView = NO;
        delete []temppoints;
    }
}
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];

    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];

        
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX - (rbX - ltX)*0.6, ltY - (rbY - ltY)*0.45);
    rect.size = BMKMapSizeMake((rbX - ltX)*2.2, (rbY - ltY)*1.9);
    [__mapView setVisibleMapRect:rect];
    
  //  __mapView.zoomLevel = __mapView.zoomLevel - 2;  //加载这个会有抖动效果 每次结束后都有个收缩情况
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 当前视图中有N多UIScrollView
    if (scrollView == CarScrView) {
        seleCount  = scrollView.contentOffset.x / (kScreenWidth - 20);
        LocationModel *model = carAllArray[seleCount];
        carStateModel = model;
        USERMANAGER.seleCar = carStateModel;
//        [self addAllAnnotation];
        
 
        if (_changeCarButton.selected) {
            [self addOneAnnotation];
        }else{
            CLLocationCoordinate2D carCoordinate2D = CLLocationCoordinate2DMake( [carStateModel.y floatValue],
                                                                                [carStateModel.x floatValue]);
            for (BMKPointAnnotation *poi in __mapView.annotations) {
                if ( poi.coordinate.latitude == carCoordinate2D.latitude
                    && poi.coordinate.longitude == carCoordinate2D.longitude
                    && [poi.title isEqualToString:carStateModel.macName]) {
                    _carCoordinate = carCoordinate2D;
                    pointAnnotation = poi;
                    [__mapView selectAnnotation:pointAnnotation animated:NO];
                }
            }
        }
    }
}
-(void)setNavi{
    self.title = L(@"Location");
    self.view.backgroundColor = HBackColor;
//    [self addNavigationItemWithImageNames
//     :@[@"back_icon"] isLeft:YES target:self action:@selector(showLeft) tags:@[@1000]];
    if (![USERMANAGER.user.loginType isEqualToString:@"1"]) {
        [self addNavigationItemWithImageNames
         :@[@"APP_主页_扫码_N.png"] isLeft:NO target:self action:@selector(showRight) tags:@[@1000]];
    }
    [self addNavigationItemWithImageNames
     :@[@"ui2_user_icon0.png"] isLeft:YES target:self action:@selector(showLeft) tags:@[@1001]];
    
}
-(void)showLeft{
   
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
//    if (self.navigationController.presentingViewController != nil) {
//        [self dismissViewControllerAnimated:NO completion:nil];
//    }else{
//        APPDELEGATE.window.rootViewController = nil;
//        HomeVC *homeVC = [[HomeVC alloc]init];
//        UINavigationController *nav = [[UINavigationController   alloc]initWithRootViewController:homeVC];
//        //默认开启系统右划返回
//        nav.interactivePopGestureRecognizer.enabled = NO;
//        APPDELEGATE.window.rootViewController = nav;
//    }
    
    [self.navigationController pushViewController:[UserCenterOldVC new] animated:YES];
}
-(void)showRight{
    [self.navigationController pushViewController:[BindDeviceVC new] animated:YES];
}
-(void)configCar:(int )configInt{
        configInt++;
        NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                              @"macId":CsqStringIsEmpty(carStateModel.macId),//
                              @"instructions":@"CONFIG",
                              @"type":@"CONFIG",
                              @"count":[NSString stringWithFormat:@"%ld",(long)configInt]
                              };        
        [ZZXDataService HFZLRequest:@"instruction/send" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
         {
             if ([data[@"code"]integerValue] == 101054) {
                 if (configInt <= mostNunber) {
                     CSQ_DISPATCH_AFTER(2.0, ^{
                         [self configCar:configInt];
                     })
                 }
                 else{
                     [UIUtil showToast:L(@"Network exception") inView:self.view];
                 }
             }
             else if([data[@"code"]integerValue] == 0){
                 [UIUtil hideProgressHUD];
             }
             showErrorCode()

         } fail:^(NSError *error)
         {
//             [UIUtil showToast:@"网络异常" inView:self.view];
         }];
}
-(void)getInstrInfo{
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(carStateModel.macId)
                          };
    [ZZXDataService HFZLRequest:@"dev/get-dev-config" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             
             if ([data[@"data"] isKindOfClass:[NSDictionary class]]) {
                 [UIUtil hideProgressHUD];
                 NSDictionary *userDict = data[@"data"];
                 if (!kArrayIsEmpty(userDict)) {
                     InstructionStateModel *model = [InstructionStateModel provinceWithDictionary:userDict];
                     InstructionVC *vc = [InstructionVC new];
                     
                     vc.insStateModel = model;
                     if ([carStateModel.macType isEqualToString:DR_30]) {
                         vc.macType = DR30;
                     }else if([carStateModel.macType isEqualToString:GT31]){
                         vc.macType = GT_31;
                     }else if([carStateModel.macType isEqualToString:GT51]){
                         vc.macType = GT_51;
                     }
                     else if([carStateModel.macType isEqualToString:GT52]){
                         vc.macType = GT_52;
                     }
                     else if([carStateModel.macType isEqualToString:GT121]){
                         vc.macType = GT_121;
                     }
                     [self.navigationController pushViewController:vc animated:YES];
                }
             }else{
                 [UIUtil showToast:L(@"Fetch instruction failed") inView:self.view];
             }
         }else{
             [UIUtil showToast:L(@"Fetch instruction failed") inView:self.view];
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
-(void)AllCarRequestNoUiutil{
    NSLog(@"userID = %@",USERMANAGER.user.userID);
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID)
                          };
    [ZZXDataService HFZLRequest:@"track/get-tracks" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             NSArray *userArray = data[@"data"];
             if (!kArrayIsEmpty(userArray)) {
                 [UIUtil hideProgressHUD];
                 [seleArray removeAllObjects];
                 [carAllArray removeAllObjects];
                 carStateModel = nil;
                 USERMANAGER.seleCar = carStateModel;
                 
                 
                 int modelCount = 0;
                 for (NSDictionary *carDict in userArray) {
                     
                     LocationModel *model = [LocationModel provinceWithDictionary:carDict];
                     CLLocationCoordinate2D Locateoiooo;
                     Locateoiooo.latitude = [[carDict getStringValueForKey:@"y" defaultValue:@" "]  floatValue];
                     Locateoiooo.longitude = [[carDict getStringValueForKey:@"x" defaultValue:@" "] floatValue];
                     Locateoiooo = [JZLocationConverter BD_bd09ToWgs84:Locateoiooo];
                     model.x = [NSString stringWithFormat:@"%f",Locateoiooo.longitude];
                     model.y = [NSString stringWithFormat:@"%f",Locateoiooo.latitude];
                     if (modelCount == seleCount) {
                         carStateModel = model;
                         USERMANAGER.seleCar = carStateModel;
                     }
                     
                     
                     if ([model.ico intValue] < 1 || [model.ico intValue] > 13) {
                         model.ico = @"0";
                     }
                     if (Locateoiooo.latitude < 100.) {
                         model.tagNumber = modelCount;
                         modelCount++;
                         [carAllArray addObject:model];
                     }
                 }
                 [USERMANAGER.GT10CarArray removeAllObjects];
                 [USERMANAGER.GT10CarArray addObjectsFromArray:carAllArray];
                 [USERMANAGER save];
                 [self refreshAllCarView];
             }else{

                 [USERMANAGER.GT10CarArray removeAllObjects];
                 [USERMANAGER save];
                 [self reSetAllCarView];
             }
         }else{
             switch ([data[@"code"]integerValue]) {
                 case 200002:
                 {
//                     [UIUtil showToast:@"未绑定设备" inView:self.view];
                 }
                     break;
                 default:
//                     [UIUtil showToast:@"获取失败" inView:self.view];
                     break;
             }
         }
     } fail:^(NSError *error)
     {
     }];
}
-(void)ChangeInfo{
    ChangeInfo = YES;
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
