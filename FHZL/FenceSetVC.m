//
//  FenceSetVC.m
//  FHZL
//
//  Created by hk on 17/12/21.
//  Copyright © 2017年 hk. All rights reserved.
//
#define radiusStep 100
#import "FenceSetVC.h"
#import "UIImage+Rotate.h"
#import "Header.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface FenceSetVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate>
{
    BMKLocationService* _locService;
    BMKPointAnnotation* _FenceAnnotation;
    BMKPointAnnotation *_CarAnnotation;
    BMKPinAnnotationView* _fenceView;
    BMKPinAnnotationView* _carView;
    BMKCircle *_FenceCircle;
    CLLocationCoordinate2D _fenceCoordinate;
    CLLocationCoordinate2D _carCoordinate;
    CLLocationCoordinate2D _userCoordinate;
    LocationModel *carStateModel;
    BOOL isChange;
    NSTimer *timer;
    int setFenceInt;
    BOOL isAddFence;
    UILabel *radiosLabel;
}
@property (weak, nonatomic) IBOutlet BMKMapView *_mapView;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (weak, nonatomic) IBOutlet UIButton *goInButton;
@property (weak, nonatomic) IBOutlet UIButton *goOutButton;
@property (weak, nonatomic) IBOutlet UILabel *fenceName;
@property (weak, nonatomic) IBOutlet UITextField *fenceNameTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

@end

@implementation FenceSetVC


- (IBAction)goInClick:(id)sender {
    _goInButton.selected = !_goInButton.selected;
    isChange = YES;
    if (_goInButton.selected) {
        if (_goOutButton.selected) {
            _fenModel.activate = @"0";
        }else{
            _fenModel.activate = @"2";
          
        }
    }else{
        if (_goOutButton.selected) {
            _fenModel.activate = @"3";

        }else{
            _fenModel.activate = @"1";
        }
    }
}
- (IBAction)goOutClick:(id)sender {
    _goOutButton.selected = !_goOutButton.selected;
    isChange = YES;
    if (_goInButton.selected) {
        if (_goOutButton.selected) {
            _fenModel.activate = @"0";
        }else{
            _fenModel.activate = @"2";
            
        }
    }else{
        if (_goOutButton.selected) {
            _fenModel.activate = @"3";
            
        }else{
            _fenModel.activate = @"1";
            
        }
    }
}

//减少
- (IBAction)radiosDele:(id)sender {
    _radiusSlider.value = _radiusSlider.value - radiusStep;
    radiosLabel.text = [NSString stringWithFormat:@"%d%@",(int)_radiusSlider.value,L(@"meter")];
    [[NSUserDefaults standardUserDefaults] setInteger:(int)_radiusSlider.value forKey:@"FENCERADIUS"];
    [self refreshCircle];
    isChange = YES;
}
//增加
- (IBAction)radios:(id)sender {
    _radiusSlider.value = _radiusSlider.value + radiusStep;
    radiosLabel.text = [NSString stringWithFormat:@"%d%@",(int)_radiusSlider.value,L(@"meter")];
    [[NSUserDefaults standardUserDefaults] setInteger:(int)_radiusSlider.value forKey:@"FENCERADIUS"];
    [self refreshCircle];
    isChange = YES;
}

- (IBAction)sliderChange:(id)sender {
    int a = _radiusSlider.value / radiusStep;
    [_radiusSlider setValue:a*radiusStep animated:YES];
    radiosLabel.text = [NSString stringWithFormat:@"%d%@",(int)_radiusSlider.value,L(@"meter")];
    [[NSUserDefaults standardUserDefaults] setInteger:(int)_radiusSlider.value forKey:@"FENCERADIUS"];
    [self refreshCircle];
    isChange = YES;
}


-(void)refreshCircle
{
    [__mapView removeOverlay:_FenceCircle];
    _FenceCircle = nil;
    _FenceCircle = [BMKCircle circleWithCenterCoordinate:_fenceCoordinate radius:_radiusSlider.value];
    [__mapView addOverlay:_FenceCircle];
    if (_fenceCoordinate.latitude != 0) {
        [self changeMapLevelWithRadious];
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topConstant.constant = kTopHeight;
    if (isIphoneX) {
        self.bottomConstant.constant = 34;
    }
    self.minRadius.text = [NSString stringWithFormat:@"300%@",L(@"M")];
    self.maxRadius.text = [NSString stringWithFormat:@"10%@",L(@"KM")];
    self.nameTF.placeholder = L(@"Name of electronic fence");
    self.typeLabel.text = L(@"Alarm mode settings");
    [self.inBUtton setTitle:L(@"Get in alarm") forState:UIControlStateNormal];
    [self.outBUtton setTitle:L(@"Leave alarm") forState:UIControlStateNormal];
    
    [self  setNavi];
    [self setMap];    
//    carStateModel = [[LocationModel alloc]init];
    __mapView.showsUserLocation = YES;//显示定位图层
    [_locService startUserLocationService];
    
    if (_fenModel != nil) {
        isAddFence = NO;
        _fenceName.text = [NSString stringWithFormat:@"%@:%@",L(@"Name of electronic fence"),_fenModel.name];
        _fenceNameTF.text = [NSString stringWithFormat:@"%@",_fenModel.name];
        if ([self.fenModel.y floatValue] > [self.fenModel.x floatValue]) {
            NSString *a = self.fenModel.y;
            self.fenModel.y = self.fenModel.x;
            self.fenModel.x = a;
        }
        
        _fenceCoordinate.latitude = [self.fenModel.y floatValue];
        _fenceCoordinate.longitude = [self.fenModel.x floatValue];
        _fenceCoordinate = [JZLocationConverter BD_bd09ToWgs84:_fenceCoordinate];
        _radiusSlider.value = [self.fenModel.radius floatValue];
        radiosLabel.text = [NSString stringWithFormat:@"%d%@",(int)_radiusSlider.value,L(@"meter")];
        [self addFlagAction:_fenceCoordinate];
        [self addCarAnnotation2];//显示车  和 围栏
    }else{
        isAddFence = YES;
        _fenModel = [[FenceModel alloc]init];
        _radiusSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:@"FENCERADIUS"];
                radiosLabel.text = [NSString stringWithFormat:@"%d%@",(int)_radiusSlider.value,L(@"meter")];
        _fenceName.text = [NSString stringWithFormat:@"%@:%@",L(@"Name of electronic fence"),@""];
        _fenModel.activate = @"1";
        [self addCarAnnotation]; //更新车位置
        [self showCar];
    }
    
   
        switch ([_fenModel.activate intValue]) {
            case 0:
            {
                _goOutButton.selected = YES;
                _goInButton.selected = YES;
            }
                break;
            case 1:
            {
                _goOutButton.selected = NO;
                _goInButton.selected = NO;
            }
                break;
            case 2:
            {
                _goOutButton.selected = NO;
                _goInButton.selected = YES;
            }
                break;
            case 3:
            {
                _goOutButton.selected = YES;
                _goInButton.selected = NO;
            }
                break;
            default:
                break;
        }

    
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [__mapView viewWillAppear];
    __mapView.delegate = self;
    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:30
                                                 target:self
                                               selector:@selector(getCarData)
                                               userInfo:nil
                                                repeats:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [__mapView viewWillDisappear];
    __mapView.delegate = nil;
    _geoCodeSearch.delegate = nil;
    
    [_locService stopUserLocationService];
    _locService.delegate = nil;
    [timer invalidate];
    timer = nil;
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    [__mapView updateLocationData:userLocation];
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    [__mapView updateLocationData:userLocation];    
    _userCoordinate = CLLocationCoordinate2DMake( userLocation.location.coordinate.latitude,
                                                 userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
//    BMKCoordinateRegion userRegion ;
//    userRegion.center = _userCoordinate;
//    userRegion.span.latitudeDelta = 0.005;
//    userRegion.span.longitudeDelta = 0.005;
//    [__mapView setRegion:userRegion animated:NO];
    
}
-(void)addFlagAction:(CLLocationCoordinate2D)coordinate
{
    [__mapView removeAnnotation:_FenceAnnotation];
    _FenceAnnotation = nil;
    _FenceAnnotation = [[BMKPointAnnotation alloc] init];
    _FenceAnnotation.coordinate = coordinate;
    _fenceCoordinate = coordinate;
    [__mapView addAnnotation:_FenceAnnotation];
    [__mapView removeOverlay:_FenceCircle];
    _FenceCircle = nil;
    _FenceCircle = [BMKCircle circleWithCenterCoordinate:coordinate radius:_radiusSlider.value];
    [__mapView addOverlay:_FenceCircle];
    
    BMKReverseGeoCodeOption *reverseGeocodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeOption.reverseGeoPoint = _fenceCoordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeocodeOption];
}
#pragma mark --- BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0)
    {
        
        if (result.poiList.count != 0) {
            BMKPoiInfo *modelInfo = result.poiList[0];
            _fenModel.address  = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,modelInfo.name];
        }else{
            _fenModel.address   = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,result.sematicDescription];
        }

        NSLog(@"result = %@,%@,%@",result.address,result.poiList[0],result.sematicDescription);
    }
}
//查询车的位置
-(void)getCarData
{
    /*
    //    [UIUtil showProgressHUD:L(@"Get device information") inView:self.view];
    NSDictionary *dic = @{@"appFlag":appFlag,
                          @"appCookie":[UserManager sharedInstance].user.appCookie,
                          @"appVersion":appVersion,
                          @"appType":APPTYPE,
                          @"userId":[NSString stringWithFormat:@"%ld",(long)[UserManager sharedInstance].user.userID],
                          @"macId":[NSString stringWithFormat:@"%@",[UserManager sharedInstance].user.IMEI]
                          };
    [ZZXDataService ZZXRequest:APPURL httpMethod:@"POST" params1:@{@"a":@"user",@"m":@"getCarLocation",@"arg":@""} params2:dic file:nil success:^(id data)
     {
         NSLog(@"data = %@ ",data);
         NSLog(@"data[retDesc] = %@",data[@"retDesc"]);
         
         if ([data[@"staCode"] integerValue] == 220000)
         {
             NSDictionary *d = data[@"userRelevanceTrackInfo"];
             
             //转成百度地图坐标系
             CLLocationCoordinate2D Locateoiooo;
             Locateoiooo.latitude = [[d getStringValueForKey:@"lat" defaultValue:@" "] floatValue];
             Locateoiooo.longitude = [[d getStringValueForKey:@"lng" defaultValue:@" "] floatValue];;
             Locateoiooo = [JZLocationConverter BD_bd09ToWgs84:Locateoiooo];
             
             carStateModel.carAddress = [d getStringValueForKey:@"address" defaultValue:@""];
             carStateModel.carBattery = [d getIntValueForKey:@"battery" defaultValue:100];
             carStateModel.gpstime  = [UserManager changeDataStrWithStrInZero:[d getStringValueForKey:@"gpstime" defaultValue:@"2000-01-01"]];
             carStateModel.carLat = [NSString stringWithFormat:@"%f",Locateoiooo.latitude];
             carStateModel.carLng = [NSString stringWithFormat:@"%f",Locateoiooo.longitude];
             if (_RailModel == nil) {
                 [self addCarAnnotation];
                 BMKCoordinateRegion userRegion ;
                 userRegion.center = _carCoordinate;
                 
                 userRegion.span.latitudeDelta = 0.05;
                 userRegion.span.longitudeDelta = 0.05;
                 [__mapView setRegion:userRegion animated:NO];
             }else{
                 //                 [self addCarAnnotation2]; //显示车和围栏中心
                 [self addCarAnnotation]; //更新车位置
             }
             [UIUtil hideProgressHUD];
         }
         else
         {
             [UIUtil showToast:L(@"Failed to obtain device information") inView:self.view];
             if (self.RailModel != nil) {
                 //                [self showFence];
             }else{
                 [_locService startUserLocationService];
             }
         }
     } fail:^(NSError *error)
     {
         [UIUtil showToast:L(@"HintRequestFailed") inView:self.view];
         if (self.RailModel != nil) {
             //             [self showFence];
         }else{
             [_locService startUserLocationService];
         }
         
     }];
     */
}

//围栏在地图中心
-(void)showFence{
    
    CGFloat spanDelta = 0.05 > [_fenModel.radius floatValue]*6.0 /100000.?0.05:[_fenModel.radius floatValue]*6.0 /100000.;
    BMKCoordinateRegion userRegion ;
    userRegion.center = _fenceCoordinate;
    userRegion.span.latitudeDelta = spanDelta;
    userRegion.span.longitudeDelta = spanDelta;
    [__mapView setRegion:userRegion animated:YES];
}

//围栏在地图中心
-(void)changeMapLevelWithRadious{
    
    CGFloat spanDelta = 0.05 > _radiusSlider.value*6.0 /100000.?0.05:_radiusSlider.value*6.0 /100000.;
    BMKCoordinateRegion userRegion ;
    userRegion.center = _fenceCoordinate;
    userRegion.span.latitudeDelta = spanDelta;
    userRegion.span.longitudeDelta = spanDelta;
    [__mapView setRegion:userRegion animated:YES];
}


-(void)saveFenckClick{
//    if (!isChange || _fenceCoordinate.latitude == 0.) {
//        [UIUtil showToast:L(@"Not added electronic fence") inView:self.view];
//    }else{
//        [UIUtil showProgressHUD:L(@"Save") inView:self.view];
//        setFenceInt = 0;
//        [self saveFence];
//    }
}
//-(void)saveFence{
    /*
    setFenceInt++;
    CLLocationCoordinate2D clikCoordinate = [JZLocationConverter bd09ToWgs84:_fenceCoordinate];
    
    NSLog(@"_fenceCoordinate.x = %f  clikCoordinate.x = %F",_fenceCoordinate.longitude,clikCoordinate.longitude);
        
    NSDictionary *dict = nil;
    if (_fenModel != nil) {
        
        dict  = @{@"appFlag":appFlag,
                  @"appCookie":[UserManager sharedInstance].user.appCookie,
                  @"appVersion":appVersion,
                  @"appType":APPTYPE,
                  @"userId":[NSString stringWithFormat:@"%ld",(long)[UserManager sharedInstance].user.userID],
                  @"y":[NSString stringWithFormat:@"%f",clikCoordinate.latitude],
                  @"x":[NSString stringWithFormat:@"%f",clikCoordinate.longitude],
                  @"radius":[NSString stringWithFormat:@"%d",(int)_radiusSlider.value],
                  @"activate":@"1",
                  @"id":[NSString stringWithFormat:@"%d",_RailModel.IDInt],
                  @"macId":USERMANAGER.user.IMEI,
                  @"count":[NSString stringWithFormat:@"%d",setFenceInt - 1]
                  };
    }else{
        
        dict  = @{@"appFlag":appFlag,
                  @"appCookie":[UserManager sharedInstance].user.appCookie,
                  @"appVersion":appVersion,
                  @"appType":APPTYPE,
                  @"userId":[NSString stringWithFormat:@"%ld",(long)[UserManager sharedInstance].user.userID],
                  @"y":[NSString stringWithFormat:@"%f",clikCoordinate.latitude],
                  @"x":[NSString stringWithFormat:@"%f",clikCoordinate.longitude],
                  @"radius":[NSString stringWithFormat:@"%d",(int)_radiusSlider.value],
                  @"activate":@"1",
                  @"macId":USERMANAGER.user.IMEI,
                  @"count":[NSString stringWithFormat:@"%d",setFenceInt - 1]
                  };
    }
    
    
    [ZZXDataService ZZXRequest:APPURL httpMethod:@"POST" params1:@{@"a":@"user",@"m":@"setEnclosure",@"arg":@""} params2:dict file:nil success:^(id data)
     {
         LOGDATA(dict)
         
         if ([data[@"retCode"] integerValue] == 1)
         {
             if ([data[@"status"]intValue] == 3 || [data[@"status"]intValue] == 0) {
                 if (setFenceInt <= mostNunber) {
                     double delayInSeconds = 2.0f;
                     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                     dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                    {
                                        [self saveFence];
                                    });
                 }else{
                     [UIUtil showToast:L(@"Save failed") inView:self.view];
                 }
             }else if([data[@"status"]intValue] == 2 || [data[@"status"]intValue] == -1){
                 [UIUtil showToast:L(@"Save failed") inView:self.view];
             }
             else if([data[@"status"]intValue] == 1){
                 isChange = NO;
                 [UIUtil showToast:L(@"Save successfully") inView:self.view];
                 DISPATCH_AFTER(1.5,^{
                     [self.navigationController popViewControllerAnimated:YES];
                 })
             }
         }
         else
         {
             [UIUtil showToast:data[@"retDesc"] inView:self.view];
         }
         
     } fail:^(NSError *error)
     {
         [UIUtil showToast:L(@"HintRequestFailed") inView:self.view];
     }];
     */
//}

//只修改车位置
-(void)addCarAnnotation{
    _carCoordinate =  CLLocationCoordinate2DMake( [_carModel.y floatValue],
                                                 [_carModel.x floatValue]);
    [__mapView removeAnnotation:_CarAnnotation];
    _CarAnnotation = nil;
    _CarAnnotation = [[BMKPointAnnotation alloc]init];
    _CarAnnotation.coordinate = _carCoordinate;
    [__mapView addAnnotation:_CarAnnotation];
    [self refreshCircle];
}
//围栏在地图中心
-(void)showCar{
    
//    CGFloat spanDelta = 0.05 > [_fenModel.radius floatValue]*6.0 /100000.?0.05:[_fenModel.radius floatValue]*6.0 /100000.;
//    BMKCoordinateRegion userRegion ;
//    userRegion.center = _fenceCoordinate;
//    userRegion.span.latitudeDelta = spanDelta;
//    userRegion.span.longitudeDelta = spanDelta;
//    [__mapView setRegion:userRegion animated:YES];
    
    _carCoordinate =  CLLocationCoordinate2DMake( [_carModel.y floatValue],
                                                 [_carModel.x floatValue]);
    BMKCoordinateRegion userRegion ;
    userRegion.center = _carCoordinate;
    
    userRegion.span.latitudeDelta = 0.01;
    userRegion.span.longitudeDelta = 0.01;
    [__mapView setRegion:userRegion animated:NO];
}
//同时显示车和围栏
-(void)addCarAnnotation2{
    _carCoordinate =  CLLocationCoordinate2DMake( [_carModel.y floatValue],
                                                 [_carModel.x floatValue]);
    [__mapView removeAnnotation:_CarAnnotation];
    _CarAnnotation = nil;
    _CarAnnotation = [[BMKPointAnnotation alloc]init];
    _CarAnnotation.coordinate = _carCoordinate;
    [__mapView addAnnotation:_CarAnnotation];
    
    
    CLLocationCoordinate2D centerCoordinate =  CLLocationCoordinate2DMake((_carCoordinate.latitude + _fenceCoordinate.latitude  )   / 2.f,
                                                                          (_carCoordinate.longitude + _fenceCoordinate.longitude) / 2.f );
    CGFloat spanlatitudeDelta ,spanlongitudeDelta;
    spanlatitudeDelta = (_carCoordinate.latitude - _fenceCoordinate.latitude);
    if (spanlatitudeDelta < 0) {
        spanlatitudeDelta = -spanlatitudeDelta;
    }
    spanlongitudeDelta = _carCoordinate.longitude - _fenceCoordinate.longitude;
    if (spanlongitudeDelta < 0) {
        spanlongitudeDelta = -spanlongitudeDelta;
    }
    
    CGFloat spanDelta = spanlatitudeDelta > spanlongitudeDelta?spanlatitudeDelta:spanlongitudeDelta;
    spanDelta =  spanDelta *1.2 + 0.005;
    spanDelta = spanDelta > [_fenModel.radius floatValue]*2 /100000.?spanDelta:[_fenModel.radius floatValue]*2 /100000.;
    
    BMKCoordinateRegion userRegion ;
    userRegion.center = centerCoordinate;
    
    userRegion.span.latitudeDelta = spanDelta;
    userRegion.span.longitudeDelta = spanDelta;
    [__mapView setRegion:userRegion animated:NO];
    
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    isChange = YES;
    [self addFlagAction:coordinate];
    [self changeMapLevelWithRadious];
}
-(void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi
{
    [self addFlagAction:mapPoi.pt];
    isChange = YES;
}
-(void)carAnnotationClick{
    NSLog(@"点击车图标");
    [self addFlagAction:_carCoordinate];
    isChange = YES;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    if (view == _carView) {
        NSLog(@"点击车图标");
        [self addFlagAction:_carCoordinate];
        isChange = YES;
    }
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (annotation == _CarAnnotation) {
        NSString *AnnotationViewID = @"_carView";
        _carView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (_carView == nil) {
            _carView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            _carView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            _carView.animatesDrop = NO;
            // 设置可拖拽
            _carView.draggable = YES;
            
//            if (isIphonePLUS)
//            {
//                _carView.image = [UIImage imageNamed:@"MAIN_0_车（720x1280）.png"];
//            }
//            else
//            {
//                _carView.image = [UIImage imageNamed:@"MAIN_0_车（480x800）.png"];
//            }
            
            NSString *str = [NSString stringWithFormat:@"mycar_top_%d_%@",[_carModel.ico intValue],[_carModel.status intValue] == 0?@"p":@"n"];
            _carView.image = [UIImage imageNamed:str];
            NSInteger dir = [_carModel.dir integerValue];
            
            _carView.image = [_carView.image imageRotatedByDegrees:dir];
            
            _carView.centerOffset = CGPointMake(0, 0);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(0, 0,_carView.image.size.width, _carView.image.size.height);
            [btn addTarget:self action:@selector(carAnnotationClick) forControlEvents:UIControlEventTouchUpInside];
            _carView.enabled = YES;
            _carView.userInteractionEnabled = YES;
            [_carView addSubview:btn];
            
            
        }
        return _carView;
    }
    if (annotation == _FenceAnnotation) {
        NSString *AnnotationViewID = @"_fenceView";
        _fenceView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (_fenceView == nil) {
            _fenceView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            _fenceView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            _fenceView.animatesDrop = NO;
            // 设置可拖拽
            _fenceView.draggable = YES;
            if (isIphonePLUS)
            {
                _fenceView.image = [UIImage imageNamed:@"小红旗@3x.png"];
            }
            else
            {
                _fenceView.image = [UIImage imageNamed:@"小红旗@3x.png"];
            }
            _fenceView.centerOffset = CGPointMake(0, 0);
            _fenceView.canShowCallout = YES;
            
            [radiosLabel removeFromSuperview];
            radiosLabel = nil;
            radiosLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 15)];
            radiosLabel.textAlignment = NSTextAlignmentCenter;
            radiosLabel.textColor = [UIColor redColor];
            radiosLabel.font = [UIFont systemFontOfSize:12];
            radiosLabel.text = [NSString stringWithFormat:@"%d%@",(int)_radiusSlider.value,L(@"meter")];
            CGRect frame = [radiosLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT,15 ) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            radiosLabel.backgroundColor = [UIColor whiteColor];
            radiosLabel.frame = CGRectMake((_fenceView.width -frame.size.width)/2 , (_fenceView.height -frame.size.height)/2+15, frame.size.width, 15);
           
//            radiosLabel.center = _fenceView.center;
            radiosLabel.alpha = 0.5;
            [_fenceView addSubview:radiosLabel];
            if (IOS_VERSION >= 10.) {
                radiosLabel.adjustsFontSizeToFitWidth = YES;
            }
        }
        return _fenceView;
    }
    return nil;
}
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    //圆
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView *circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        //填充颜色
        circleView.fillColor = [UIColor colorWithRed:239 / 225. green:88 / 225. blue:47 / 225. alpha:0.5];
        //画笔颜色
        circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.5];
        //画笔宽度(默认为0)
        circleView.lineWidth = 0.5;
        return circleView;
    }
    return nil;
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
    self.title = L(@"Set fence");
    self.view.backgroundColor = HBackColor;
    [self addNavigationItemWithImageNames
     :@[@"设置围栏_标题栏_保存_N.png"] isLeft:NO target:self action:@selector(showRight) tags:@[@1000]];
}
-(void)showLeft{
    //    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRight{
    if (!isChange || _fenceCoordinate.latitude == 0.) {
        [UIUtil showToast:L(@"Please set or change it successfully before saving") inView:self.view];
    }else{
        [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
        [self saveFence:0];
    }
}
-(void)saveFence:(int )setFenceInt{
    
    CLLocationCoordinate2D changeCoordinate = _fenceCoordinate;
    changeCoordinate = [JZLocationConverter bd09ToWgs84:changeCoordinate];
    NSString* lonF = [NSString stringWithFormat:@"%.8f",changeCoordinate.longitude];
    NSString* latF = [NSString stringWithFormat:@"%.8f",changeCoordinate.latitude];
    NSString* radiousStr = [NSString stringWithFormat:@"%f",_radiusSlider.value];
    
    
    if (!isAddFence) {
        NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                              @"macId":CsqStringIsEmpty(_carModel.macId),
                              @"id":CsqStringIsEmpty(_fenModel.fenceId),
                              @"name":CsqStringIsEmpty(_fenceNameTF.text),
                              @"radius":CsqStringIsEmpty(radiousStr),
                              @"activate":CsqStringIsEmpty(_fenModel.activate),
                              @"address":CsqStringIsEmpty(_fenModel.address),
                              @"x":CsqStringIsEmpty(lonF),
                              @"count":[NSString stringWithFormat:@"%ld",setFenceInt],
                              @"y":CsqStringIsEmpty(latF)
                              };
        setFenceInt++;
        [ZZXDataService HFZLRequest:@"fence/set-fence" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
         {
             
             if ([data[@"code"]integerValue] == 101054) {
                     if (setFenceInt <= mostNunber) {
                         double delayInSeconds = 2.0f;
                         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                         dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                        {
                                            [self saveFence:setFenceInt];
                                        });
                     }else{
                         [UIUtil showToast:L(@"Network exception") inView:self.view];
                     }
             }else if([data[@"code"]integerValue] == 0){
                 isChange = NO;
                 [UIUtil showToast:L(@"Save successfully") inView:self.view];
                 CSQ_DISPATCH_AFTER(1.5,^{
                     [self.navigationController popViewControllerAnimated:YES];
                 })
             }
             else{
                 [UIUtil showToast:data[@"msg"] inView:self.view];
             }
         } fail:^(NSError *error)
         {
//             [UIUtil showToast:@"网络异常" inView:self.view];
         }];
    }else{
        NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                              @"macId":CsqStringIsEmpty(_carModel.macId),
                              @"macType":CsqStringIsEmpty(_carModel.macType),
//                              @"id":CsqStringIsEmpty(_fenModel.fenceId),
                              @"name":CsqStringIsEmpty(_fenceNameTF.text),
                              @"radius":CsqStringIsEmpty(radiousStr),
                              @"activate":CsqStringIsEmpty(_fenModel.activate),
                              @"address":CsqStringIsEmpty(_fenModel.address),
                              @"x":CsqStringIsEmpty(lonF),
                              @"y":CsqStringIsEmpty(latF),
                              @"count":[NSString stringWithFormat:@"%ld",setFenceInt]
                              };
        setFenceInt++;
        [ZZXDataService HFZLRequest:@"fence/add-fence" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
         {
             if ([data[@"code"]integerValue] == 101054) {
                 if (setFenceInt <= mostNunber) {
                     double delayInSeconds = 2.0f;
                     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                     dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                    {
                                        [self saveFence:setFenceInt];
                                    });
                 }
             }else if([data[@"code"]integerValue] == 0){
                 isChange = NO;
                 [UIUtil showToast:L(@"Save successfully") inView:self.view];
                 CSQ_DISPATCH_AFTER(1.5,^{
                     [self.navigationController popViewControllerAnimated:YES];
                 })
             }
             else{
                 [UIUtil showToast:data[@"msg"] inView:self.view];
             }
         } fail:^(NSError *error)
         {
//             [UIUtil showToast:@"网络异常" inView:self.view];
         }];
    }
}
#pragma mark textfileDele
-(void)textFieldDidEndEditing:(UITextField *)textField{
    isChange = YES;
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
