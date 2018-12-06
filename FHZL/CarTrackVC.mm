//
//  CarTrackVC.m
//  FHZL
//
//  Created by hk on 17/12/19.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "CSQNaviModel.h"
#import "JSHAREService.h"

#import "UIImage+Rotate.h"
#import "ShowCarView.h"
#import "CarTrackVC.h"
#import "Header.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "ShareChooseViewController.h"

#import <BaiduPanoSDK/BaiduPanoramaView.h>
#import <BaiduPanoSDK/BaiduPanoUtils.h>
#define changeHeigth _noUseLabel.frame.size.height/2

#define  getTimer(Timer,repeatTime,selectorStr)    Timer = [NSTimer scheduledTimerWithTimeInterval:repeatTime target:self selector:@selector(selectorStr) userInfo:nil repeats:YES];
#define endTimer(Timer) [Timer invalidate]; Timer = nil;
#define allFrame CGRectMake(10, kScreenHeight - carScrHeigth + 50, kScreenWidth -20, carScrHeigth)
#define L(key)  NSLocalizedString(key, nil)
@interface CarTrackVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BaiduPanoramaViewDelegate>
{
    BMKLocationService* _locService;
    BMKPointAnnotation* pointAnnotation;
    BMKPinAnnotationView *annotationView;
    CLLocationCoordinate2D centerCoordinate;
    CLLocationCoordinate2D _userCoordinate;
    CLLocationCoordinate2D _carCoordinate;
    BOOL isFirst;
//    LocationModel *carStateModel;
    NSMutableArray *carStateArray;
    LocationModel *CarModelAdding;
    NSTimer *timer;
    int tipInt;
    int isOneGeo;
    
    NSTimer *reloadTimer;
    CGFloat carScrHeigth;
    ShowCarView *_showCarView;
    BOOL isCanAutoOneView;
}

@property (nonatomic, strong) ShareView * shareView;
@property (weak, nonatomic) IBOutlet UILabel *jiaoduLabel;
@property (weak, nonatomic) IBOutlet BMKMapView *_mapView;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *carDoorLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noUseLabel;

@property (weak, nonatomic) IBOutlet UILabel *gpsTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gsmTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pamoramaHeigth2;
@property (nonatomic ,strong)BaiduPanoramaView*panoramaView;
@property (weak, nonatomic) IBOutlet UIView *panoBackView;
@property (weak, nonatomic) IBOutlet UIButton *panoButton;
@property (weak, nonatomic) IBOutlet UIButton *CarMenButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carMenButtonBottomConstant;
@end

@implementation CarTrackVC


//- (void)shareLinkWithPlatform:(JSHAREPlatform)platform {
//    JSHAREMessage *message = [JSHAREMessage message];
//    message.mediaType = JSHARELink;
//    message.url = @"https://www.jiguang.cn/";
//    message.text = [NSString stringWithFormat:@"时间:%@ JShare SDK支持主流社交平台、帮助开发者轻松实现社会化功能！",[self localizedStringTime]];
//    message.title = @"欢迎使用极光社会化组件JShare";
//    message.platform = platform;
//    NSString *imageURL = @"http://img2.3lian.com/2014/f5/63/d/23.jpg";
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
//
//    message.image = imageData;
//    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
//        [self showAlertWithState:state error:error];
//    }];
//}
- (IBAction)NavClick:(id)sender {
    NSLog(@"导航到目的地");
    [CSQNaviModel sendNaviWithModel:_carModel];
}


- (IBAction)CR_click:(id)sender {
    if ([_carModel.macType isEqualToString:GT121] || [_carModel.macType isEqualToString:GT52]) {
        [UIUtil showToast:L(@"This device is not supported") inView:[AppData theTopView]];
    }else{
        UISwitch *switCH = [UISwitch new];
        switCH.tag = 100;
        [self sendInstr:0 :switCH];
        [UIUtil showProgressHUD:nil inView:[AppData theTopView]];
    }
}
-(void)sendInstr:(int)intCount :(UISwitch*)switCH{
    NSLog(@"intCount = %d;",intCount);
    int tag = (int)switCH.tag - 100;
    NSString *instructionStr ;
    NSString *typeStr;
    
    switch (tag) {
            
        case 0:
        {
            instructionStr = [NSString stringWithFormat:@"CR"];
            typeStr = @"CR";
        }
            break;
        default:
            break;
    }
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(_carModel.macId),//
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
                 [UIUtil showToast:L(@"Connection timeout") inView:[AppData theTopView]];
                 switCH.on = !switCH.on;
             }
         }else if([data[@"code"]integerValue] == 0){
             [UIUtil hideProgressHUD];
             switch (tag) {
                 case 0:
                     [UIUtil hideProgressHUD];
                     break;
                 default:
                     break;
             }
             
             
         }
         showErrorCode(switCH.on = !switCH.on;)
//         else if ([data[@"code"]integerValue] == 101051){
//             [UIUtil showToast:@"设备不在线" inView:[AppData theTopView]];
//             switCH.on = !switCH.on;
//         }else if ([data[@"code"]integerValue] == 101052){
//             [UIUtil showToast:@"未连接到设备" inView:[AppData theTopView]];
//             switCH.on = !switCH.on;
//         }
//         else if ([data[@"code"]integerValue] == 101055){
//             [UIUtil showToast:@"车速过快，断电失败" inView:[AppData theTopView]];
//             switCH.on = !switCH.on;
//         }
//         else if ([data[@"code"]integerValue] == 101052){
//             [UIUtil showToast:@"GPS未定位，待GPS恢复后自动执行断油断电" inView:[AppData theTopView]];
//             switCH.on = !switCH.on;
//         }
//         else if ([data[@"code"]integerValue] == 101057)
//         {
//             [UIUtil showToast:@"已发送离线指令" inView:[AppData theTopView]];
//             switCH.on = !switCH.on;
//         }
//         else{
//             [UIUtil showToast:data[@"msg"] inView:self.view];
//             switCH.on = !switCH.on;
//         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:[AppData theTopView]];
         switCH.on = !switCH.on;
     }];
}
- (IBAction)isWeiXing:(id)sender {
    UIButton *but = (UIButton *)sender;
    but.selected = !but.selected;
    if (but.selected) {
        __mapView.mapType = BMKMapTypeSatellite;
    }else{
        __mapView.mapType = BMKMapTypeStandard;
    }
}
- (IBAction)isLuKuang:(id)sender {
    UIButton *but = (UIButton *)sender;
    but.selected = !but.selected;
    [__mapView setTrafficEnabled:but.selected];
}
- (IBAction)isCarAndeRen:(id)sender {
    _CarMenButton.selected = !_CarMenButton.selected;
    if (_CarMenButton.selected) {
        BMKCoordinateRegion userRegion;
        userRegion.center = _userCoordinate;
        userRegion.span.latitudeDelta = 0.01;
        userRegion.span.longitudeDelta = 0.01;
        [__mapView setRegion:userRegion animated:YES];
        __mapView.showsUserLocation = YES;
        pointAnnotation = nil;
        [__mapView removeAnnotations:__mapView.annotations];
    }else{
//        BMKCoordinateRegion userRegion ;
//        userRegion.center = _carCoordinate;
//        userRegion.span.latitudeDelta = 0.01;
//        userRegion.span.longitudeDelta = 0.01;
//        [__mapView setRegion:userRegion animated:YES];
        
        [self addOneAnnotation];
        __mapView.showsUserLocation = NO;
    }
}

- (IBAction)isSelected:(id)sender {
    UIButton *bu = sender;
    bu.selected = !bu.selected;
    if (bu.selected) {
        _pamoramaHeigth2.constant = changeHeigth;
        if (!_panoramaView) {
            [self setPanorama];
        }
        else{
            _panoramaView.frame = CGRectMake(0, 0, kScreenWidth, changeHeigth);
            _panoramaView.hidden = NO;
        }
        [_panoramaView setPanoramaWithLon:[_carModel.x floatValue] lat:[_carModel.y floatValue]];
    }else{
        _pamoramaHeigth2.constant = 0;
        _panoramaView.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isCanAutoOneView = YES;
    carScrHeigth = 205;
    
    [self  setNavi];
    [self setMap];
    
//    isFirst = YES;
    __mapView.showsUserLocation = NO;//显示定位图层
    [_locService startUserLocationService];
    
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;

//    [self reSetCarInfo];
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    [self ReloadCarInfo];
//    [self setPanorama];
    
    _pamoramaHeigth2.constant = 0;
    getTimer(reloadTimer,2,ReloadCarInfo)
}
-(void)setPanorama{
    _panoramaView = [[BaiduPanoramaView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, changeHeigth) key:baiduKey];
    // 为全景设定一个代理
    _panoramaView.delegate = self;
    // 设定全景的清晰度， 默认为middle
    [_panoramaView setPanoramaImageLevel:ImageDefinitionHigh];
    [_panoramaView setPanoramaWithLon:116.40391285827147 lat:39.91403075654526];
    [_panoBackView addSubview:_panoramaView];
}

-(void)ReloadCarInfo{
    NSLog(@"reloadcarinfo");
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(_carModel.macId)
                          };
    [ZZXDataService HFZLRequest:@"track/get-track" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil hideProgressHUD];
             NSDictionary *carDict = data[@"data"];
             
             if (!kDictIsEmpty(carDict)) {
                     LocationModel *model = [LocationModel provinceWithDictionary:carDict];
                     CLLocationCoordinate2D Locateoiooo;
                     Locateoiooo.latitude = [[carDict getStringValueForKey:@"y" defaultValue:_carModel.y]  floatValue];
                     Locateoiooo.longitude = [[carDict getStringValueForKey:@"x" defaultValue:_carModel.x] floatValue];
                 
                 NSLog(@"_carModel.y = %f _carModel.x = %f",[[carDict getStringValueForKey:@"y" defaultValue:_carModel.y]  floatValue],[[carDict getStringValueForKey:@"y" defaultValue:_carModel.x]  floatValue]);
                 
//                    Locateoiooo.latitude = 22.5923;
//                    Locateoiooo.longitude = 113.958942;
                 
                 
                 
                     Locateoiooo = [JZLocationConverter BD_bd09ToWgs84:Locateoiooo];
                 
                     model.x = [NSString stringWithFormat:@"%f",Locateoiooo.longitude];
                     model.y = [NSString stringWithFormat:@"%f",Locateoiooo.latitude];
                    _carModel = model;
              }
             if (_showCarView) {
                 [self refreshCarInfo];
             }else{
                    [self reSetCarInfo];
             }

         }else{
             [UIUtil showToast:L(@"Failed to update") inView:self.view];
         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
     }];
}
-(void)refreshCarInfo{
    [_showCarView setLocationModel:_carModel];
    
    if (!_CarMenButton.selected) {
        [self addOneAnnotation];
    }
    if (_panoButton.selected) {
        [_panoramaView setPanoramaWithLon:[_carModel.x floatValue] lat:[_carModel.y floatValue]];
    }
    
    if (_showCarView.isOpenButton.selected) {
        _showCarView.midView.hidden = YES;
    }else{
        _showCarView.midView.hidden = NO;
    }
}
-(void)reSetCarInfo{

    
    [_showCarView removeFromSuperview];
    _showCarView = nil;
    _showCarView= [[ShowCarView alloc]init];
    [_showCarView showInView:self.view withFrame:allFrame];
    _showCarView.buttonView.hidden = YES;
    _showCarView.backgroundColor = [UIColor clearColor];
    _showCarView.isOpenButton.selected = carScrHeigth==105?YES:NO;
    [_showCarView.isOpenButton addTarget:self action:@selector(isOpenClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_showCarView.getAddressButton addTarget:self action:@selector(getAddressClick:) forControlEvents:UIControlEventTouchUpInside];
//    LocationModel *model = _carModel;
//    SDLog(@"carStateModel.macType = %@",model.macType);
    [_showCarView setLocationModel:_carModel];
//    _showCarView.macIdLable.text = model.macName; //设备名称
//    CGFloat widthF = autoWidthFrame(model.macName,16,13).size.width + 15;
//    _showCarView.nameWidthConstraint.constant = widthF >= 160?160:widthF;
//
//    _showCarView.speedLabel.text = [NSString stringWithFormat:@"%ldkm/h",[model.speed integerValue]];
//    _showCarView.LocationTypeLabel.text = [NSString stringWithFormat:@"%@%%",model.battery];;
//    _showCarView.batteryLabel.text = [NSString stringWithFormat:@"%@",[model.bvalid intValue] ==1?@"GPS":[model.bvalid intValue] ==2?@"LBS":@"未定位"];//设备定位方式
//    _showCarView.carDoorLabel.text = [NSString stringWithFormat:@"%@",[model.door intValue] == 0?@"关闭":@"打开"];
//    _showCarView.gpsTimeLabel.text = [UserManager getDateDisplayString:[model.gpsTime longLongValue]];
//    _showCarView.gsmTimeLabel.text = [UserManager getDateDisplayString:[model.gsmTime longLongValue]];
//    _showCarView.statusLabel.text = [NSString stringWithFormat:@"%@",[model.status intValue] == 0?@"点火":@"熄火"];
//    _showCarView.stopLabel.text = [model.online intValue] ==1?@"在线":@"离线";
//
//    if ([_carModel.macType isEqualToString:DR_30] || [_carModel.macType isEqualToString:GT51]) {
//        _showCarView.carDoorLabel.hidden = YES;
//        _showCarView.carDoorImage.hidden = YES;
//        _showCarView.GpsImageLeadingContast.constant = (kScreenWidth - 20)/4 - 40;
//        _showCarView.batteryImageLeadingContast.constant = (kScreenWidth - 20)/4 - 10;
//    }
//    if ([_carModel.macType isEqualToString:GT31] || [_carModel.macType isEqualToString:GT121]) {
//        _showCarView.carDoorLabel.hidden = YES;
//        _showCarView.carDoorImage.hidden = YES;
//        _showCarView.statusImageV.hidden = YES;
//        _showCarView.statusLabel.hidden = YES;
//        _showCarView.GpsImageLeadingContast.constant = - (kScreenWidth - 20)/4 + 7.5;
//        _showCarView.batteryImageLeadingContast.constant = 6;
//    }
     [_showCarView.getAddressButton addTarget:self action:@selector(getAddressClick) forControlEvents:UIControlEventTouchUpInside];
    if (!_CarMenButton.selected) {
        [self addOneAnnotation];
    }
    if (_panoButton.selected) {
        [_panoramaView setPanoramaWithLon:[_carModel.x floatValue] lat:[_carModel.y floatValue]];
    }

    if (_showCarView.isOpenButton.selected) {
        _showCarView.midView.hidden = YES;
    }else{
        _showCarView.midView.hidden = NO;
    }
}
-(void)getAddressClick{
    BMKReverseGeoCodeOption *reverseGeocodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeOption.reverseGeoPoint = CLLocationCoordinate2DMake([_carModel.y floatValue], [_carModel.x floatValue]);
    [_geoCodeSearch reverseGeoCode:reverseGeocodeOption];
}
-(void)isOpenClick:(UIButton*)but{
    but.selected = !but.selected;
    _showCarView.isOpenButton.selected = but.selected;
    if (but.selected) {
        NSLog(@"收缩");
        carScrHeigth = 105;
        _showCarView.frame = allFrame;
        _carMenButtonBottomConstant.constant = 60;
        _showCarView.midView.hidden = YES;
    }else{
        NSLog(@"伸展");
        carScrHeigth = 205;
        _showCarView.frame = allFrame;
        _carMenButtonBottomConstant.constant = 160;
        _showCarView.midView.hidden = NO;
    }
}
#pragma mark --- BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0)
    {
        
        if (result.poiList.count != 0) {
                BMKPoiInfo *modelInfo = result.poiList[0];
                _carModel.addressStr  = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,modelInfo.name];
        }else{
                _carModel.addressStr  = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,result.sematicDescription];
        }
//        _addressLabel.text = [NSString stringWithFormat:@"地址：%@",CsqStringIsEmpty(_carModel.addressStr)];
        NSLog(@"result = %@,%@,%@",result.address,result.poiList[0],result.sematicDescription);
        [_showCarView.getAddressButton setTitle:CsqStringIsEmpty(_carModel.addressStr) forState:UIControlStateNormal];
    }
}
-(void)addOneAnnotation{
    //    CarScrView.scrollEnabled = NO;
    pointAnnotation = nil;
    [__mapView removeAnnotations:__mapView.annotations];
    
    CarModelAdding = _carModel;
    CLLocationCoordinate2D carCoordinate2D = CLLocationCoordinate2DMake( [_carModel.y floatValue],
                                                                                [_carModel.x floatValue]);;
    BMKPointAnnotation *allPOI = [[BMKPointAnnotation alloc]init];
    allPOI.coordinate = carCoordinate2D;
    _carCoordinate = carCoordinate2D;
    pointAnnotation = allPOI;
    [__mapView addAnnotation:allPOI];
    
    _carCoordinate =  CLLocationCoordinate2DMake( [_carModel.y floatValue],
                                                 [_carModel.x floatValue]);
    if (!_CarMenButton.selected) {

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
    annotationViewAll.draggable = YES;
    
    if([CarModelAdding.ico intValue] <0 || [CarModelAdding.ico intValue] >9){
        CarModelAdding.ico = @"0";
    }
    NSString *str = [NSString stringWithFormat:@"mycar_top_%d_%@",[CarModelAdding.ico intValue],[CarModelAdding.online intValue] == 0?@"p":@"n"];
    annotationViewAll.image = [UIImage imageNamed:str];
    

    annotationViewAll.centerOffset = CGPointMake(0, 0);
    annotationViewAll.canShowCallout = NO;
    
    annotationViewAll.tag = 1000 + CarModelAdding.tagNumber ;
    
    NSInteger dir = [CarModelAdding.dir integerValue];
    
    annotationViewAll.image = [annotationViewAll.image imageRotatedByDegrees:dir];
//    _jiaoduLabel.text = [NSString stringWithFormat:@"旋转角度%d",dir];
    return annotationViewAll;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [__mapView viewWillAppear];
    __mapView.delegate = self;
    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [__mapView viewWillDisappear];
    __mapView.delegate = nil;
    
    [_locService stopUserLocationService];
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    [__mapView updateLocationData:userLocation];
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    [__mapView updateLocationData:userLocation];
    
    _userCoordinate = CLLocationCoordinate2DMake( userLocation.location.coordinate.latitude,
                                                 userLocation.location.coordinate.longitude);
    if (isFirst) {
        isFirst = NO;
        BMKCoordinateRegion userRegion ;
        userRegion.center = _userCoordinate;
        userRegion.span.latitudeDelta = 0.01;
        userRegion.span.longitudeDelta = 0.01;
        [__mapView setRegion:userRegion animated:NO];
    }
    
}

-(void)setMap{
    __mapView.zoomLevel = 16.1;
    __mapView.delegate = self;
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.isRotateAngleValid = true;
    param.isAccuracyCircleShow = NO;
    param.locationViewImgName = @"bnavi_icon_location_fixed@2x";
    param.locationViewOffsetX = 0;
    param.locationViewOffsetY = 0;
    [__mapView updateLocationViewWithParam:param];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService setPausesLocationUpdatesAutomatically:NO];
    //  [_locService setAllowsBackgroundLocationUpdates:YES];
}








-(void)setNavi{
    self.title = L(@"Vehicle tracking");
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
    
    [self addNavigationItemWithImageNames
     :@[@"车辆追踪_标题栏_分享_N.png"] isLeft:NO target:self action:@selector(showRight:) tags:@[@1001]];//@"车辆追踪_标题栏_列表_N.png",
    
//    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button2 setBackgroundImage:[UIImage imageNamed:@"车辆追踪_标题栏_列表_N.png"] forState:UIControlStateNormal];
////    [button setBackgroundImage:[UIImage imageNamed:BackImageP] forState:UIControlStateHighlighted];
//    [button2 addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
//    button2.frame = CGRectMake(0, 0, 25, 25);
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
//
//    UIButton * button3 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button3 setBackgroundImage:[UIImage imageNamed:@"车辆追踪_标题栏_分享_N.png"] forState:UIControlStateNormal];
//    //    [button setBackgroundImage:[UIImage imageNamed:BackImageP] forState:UIControlStateHighlighted];
//    [button3 addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
//    button3.frame = CGRectMake(0, 0, 25, 25);
//    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithCustomView:button3];
////    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"车辆追踪_标题栏_分享_N.png"] style:UIBarButtonItemStylePlain target:self action:@selector(pauseSelected)];
////    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"车辆追踪_标题栏_列表_N.png"] style:UIBarButtonItemStylePlain target:self action:@selector(downloadSelected)];
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:item2, item3, nil];
}
-(void)showLeft{
//    [self dismissViewControllerAnimated:NO completion:nil];
    if (_panoramaView){
        _panoramaView.delegate = nil;
        [_panoramaView removeFromSuperview];
        _panoramaView = nil;
    }
    endTimer(reloadTimer)
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRight:(id)sender{
    
    
    [UIUtil showProgressHUD:L(@"Get Shared links") inView:self.view];
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(_carModel.macId)
                          };
    [ZZXDataService HFZLRequest:@"instruction/get-location" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         
         if ([data[@"code"]integerValue] == 0) {
  
             
             if ([data[@"data"] isKindOfClass:[NSString class]]) {
                 if (!kStringIsEmpty(data[@"data"])) {
                     [UIUtil hideProgressHUD];
//                     ShareChooseViewController* viewController = [[ShareChooseViewController alloc] init];
//                     viewController.text = [NSString stringWithFormat:@"%@%@",@"您的好友分享给您的位置信息:",data[@"data"]];
//                     [self.navigationController presentSemiViewController:viewController withOptions:@{ KNSemiModalOptionKeys.pushParentBack:@(NO), KNSemiModalOptionKeys.animationDuration:@(0.15f), KNSemiModalOptionKeys.shadowOpacity:@(0.0f), }];
                     
                     [_shareView removeFromSuperview];
                     _shareView = nil;
                     NSDictionary *dict = @{@"shareUrl":data[@"data"],@"shareText":L(@"Click to see my current live location"),@"shareTitle":L(@"ZhiLian location services"),@"shareImageUrl":IconImageUrl};
                     _shareView = [ShareView getFactoryShareViewWithCsqDiction:dict];
                     [_shareView showInView:self.view];
                     [_shareView showWithContentType:JSHARELink];
                     
                 }else{
                     
                     [UIUtil showToast:L(@"For failure") inView:self.view];
                 }
             }else{
                 
                 [UIUtil showToast:L(@"For failure") inView:self.view];
             }
         }else{
             [UIUtil showToast:L(@"For failure") inView:self.view];
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
- (void)dealloc {
    NSLog(@"dealloc");
    
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
