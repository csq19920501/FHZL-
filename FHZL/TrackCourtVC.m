//
//  TrackCourtVC.m
//  FHZL
//
//  Created by hk on 2018/5/28.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "TrackCourtVC.h"
#import "FHZL-Swift.h"
//#import "TrackPointModel.swift"
#import "Header.h"
//#import "TrackCountCell.swift"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@interface TrackCourtVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView *pickBackView;
    long courtTime;
    UIView *hiddenView;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong)NSMutableArray *allTrackArray;
@property (nonatomic,strong)NSMutableArray *modelArray;
@end

@implementation TrackCourtVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topConstant.constant = kTopHeight;
    if (isIphoneX) {
        self.bottomConstant.constant = 34;
    }
    
    
    self.title = L(@"Trajectory segmentation");
    
    [self addNavigationItemWithImageNames
     :@[@"轨迹回放_图标_2_n"] isLeft:NO target:self action:@selector(setPickBackView:) tags:@[@1000]];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"TrackCountCell" bundle:nil] forCellReuseIdentifier:@"TrackCountCell"];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _allTrackArray = [NSMutableArray array];
    _modelArray = [NSMutableArray array];
    courtTime = [AppData courtTime];
    
    [self getCourtData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"_modelArray.count = %d",_modelArray.count);
    return _modelArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TrackCountCell";
    TrackCountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TrackPointModel *model = _modelArray[indexPath.row];
    cell.trackPointModel = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.cellClick) {
        NSArray * array = _allTrackArray[indexPath.row];
        
        self.cellClick(array);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setPickBackView:(int)tag{
    if (!pickBackView) {
        pickBackView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 300, kScreenWidth, 300)];
        pickBackView.tag = tag;
        pickBackView.backgroundColor = RGB(235, 235, 245);
        [self.view addSubview:pickBackView];
        
        hiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - 300 - kTopHeight)];
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
        UIPickerView * pickTimeView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth ,260)];
        pickTimeView.backgroundColor = RGB(235, 235, 245);
        pickTimeView.dataSource = self;
        pickTimeView.delegate = self;
        pickTimeView.showsSelectionIndicator = YES;
        
        switch (courtTime) {
            case 3:
                [pickTimeView selectRow:0 inComponent:0 animated:NO];
                break;
            case 5:
                [pickTimeView selectRow:1 inComponent:0 animated:NO];
                break;
            case 10:
                [pickTimeView selectRow:2 inComponent:0 animated:NO];
                break;
            case 15:
                [pickTimeView selectRow:3 inComponent:0 animated:NO];
                break;
            case 20:
                [pickTimeView selectRow:4 inComponent:0 animated:NO];
                break;
            case 30:
                [pickTimeView selectRow:5 inComponent:0 animated:NO];
                break;
            case 45:
                [pickTimeView selectRow:6 inComponent:0 animated:NO];
                break;
            case 60:
               [pickTimeView selectRow:7 inComponent:0 animated:NO];
                break;
            case 60 *6:
                [pickTimeView selectRow:8 inComponent:0 animated:NO];
                break;
            case 60*12:
                [pickTimeView selectRow:9 inComponent:0 animated:NO];
                break;
            case 60*24:
                [pickTimeView selectRow:10 inComponent:0 animated:NO];
                break;
                
                
            default:
                break;
        }

        [pickBackView addSubview:pickTimeView];
        
    }else{
    }
}
-(void)saveClick{
    [AppData setCourtTime:courtTime];
    
    [pickBackView removeFromSuperview];
    pickBackView = nil;
    [hiddenView removeFromSuperview];
    hiddenView = nil;
    
    [self getCourtData];

}
-(void)cancelButton{
    courtTime = [AppData courtTime];
    [pickBackView removeFromSuperview];
    pickBackView = nil;
    [hiddenView removeFromSuperview];
    hiddenView = nil;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//每组有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 11;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *modeArray = @[[NSString stringWithFormat:@"3%@",L(@"min")],
                           [NSString stringWithFormat:@"5%@",L(@"min")],
                           [NSString stringWithFormat:@"10%@",L(@"min")],
                           [NSString stringWithFormat:@"15%@",L(@"min")],
                           [NSString stringWithFormat:@"20%@",L(@"min")],
                           [NSString stringWithFormat:@"30%@",L(@"min")],
                           [NSString stringWithFormat:@"45%@",L(@"min")],
                           [NSString stringWithFormat:@"1%@",L(@"h")],
                           [NSString stringWithFormat:@"6%@",L(@"h")],
                           [NSString stringWithFormat:@"12%@",L(@"h")],
                           [NSString stringWithFormat:@"24%@",L(@"h")]];//间隔时间上传模式
    return modeArray[row];
}

//选择了某行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (row) {
        case 0:
            courtTime = 3;
            break;
        case 1:
            courtTime = 5;
            break;
        case 2:
            courtTime = 10;
            break;
        case 3:
            courtTime = 15;
            break;
        case 4:
            courtTime = 20;
            break;
        case 5:
            courtTime = 30;
            break;
        case 6:
            courtTime = 45;
            break;
        case 7:
            courtTime = 60;
            break;
        case 8:
            courtTime = 60 *6;
            break;
        case 9:
            courtTime = 60*12;
            break;
        case 10:
            courtTime = 60*24;
            break;
        
            
        default:
            break;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showLeft{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getCourtData{
    [_allTrackArray removeAllObjects];
    [_modelArray removeAllObjects];
    if (_trackCourtArray ) {
        long long countTime = 0;
        NSMutableArray *firstArray = [NSMutableArray array];
        for (int i = 0; i < _trackCourtArray.count; i++) {
            long long timeInt = [_trackCourtArray[i][@"gpsTime"] longLongValue];
            if ((timeInt - countTime) >= 1000 * 60 * courtTime && firstArray.count >= 5) {
                if (i != 0) {
                    NSArray *trackArray = [firstArray copy];
                    [_allTrackArray addObject:trackArray];
                }
                [firstArray removeAllObjects];
            }
            [firstArray addObject:_trackCourtArray[i]];
            countTime = [_trackCourtArray[i][@"gpsTime"] longLongValue];
            if (i == _trackCourtArray.count - 1) {
                [_allTrackArray addObject:firstArray];
            }
        }
    }
    for (NSArray *trackArray in _allTrackArray) {
        TrackPointModel *model = [[TrackPointModel alloc]init];
        //        [model testFunc];
        if (trackArray.count > 1) {
            CGFloat distacne = 0.;
            for (int i = 0; i < trackArray.count; i++) {
                
                
                if ( i == 0) {
                    
                    model.startTime  = [UserManager getDateDisplayString:[trackArray[i][@"gpsTime"] longLongValue]];
                    NSLog(@"model.startTime = %@",model.startTime);
                    
                    
                }
                if (i == trackArray.count -1) {
                    
                    model.endTime  = [UserManager getDateDisplayString:[trackArray[i][@"gpsTime"] longLongValue]];
                    NSLog(@"model.endTime = %@",model.endTime);
                }
                if (i != 0) {
                    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([trackArray[i][@"y"] floatValue], [trackArray[i][@"x"] floatValue]));
                    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([trackArray[i - 1][@"y"] floatValue], [trackArray[i -1][@"x"] floatValue]));
                    CLLocationDistance dis = BMKMetersBetweenMapPoints(point1,point2);
                    distacne = distacne + dis;
                }
            }
            model.distance = [NSString stringWithFormat:@"%f",distacne];
            
        }else if(trackArray.count == 1){
            model.startTime  = [UserManager getDateDisplayString:[trackArray[0][@"gpsTime"] longLongValue]];
            model.endTime  = [UserManager getDateDisplayString:[trackArray[trackArray.count-1][@"gpsTime"] longLongValue]];
            model.distance = @"0";
        }
        [_modelArray addObject:model];
    }
    [_myTableView reloadData];
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
