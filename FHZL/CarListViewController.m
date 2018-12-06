//
//  CarListViewController.m
//  FHZL
//
//  Created by hk on 17/12/18.
//  Copyright © 2017年 hk. All rights reserved.
//
#import "CSQNaviModel.h"
#import "CarListViewController.h"
#import "Header.h"
#import "TopSwitchCsqView.h"
#import "CarListCell.h"
#import "CarListModel.h"
#import "CarTrackVC.h"
#import "TrackPlayBackVC.h"
#import "FenceVC.h"
#import "AlarmListVC.h"
#import "CarInfoVC.h"
#import "LocationModel.h"
#import "MJRefresh.h"
#import "InstructionStateModel.h"
#import "InstructionVC.h"



@interface CarListViewController ()<UITableViewDelegate,UITableViewDataSource,TopSwitchDele>
{
    NSMutableArray *dataMutableArray;

    int topButtonInt;
}
@property (weak, nonatomic) IBOutlet TopSwitchCsqView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;
@end

@implementation CarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topConstant.constant = kTopHeight;
    self.bottomConstant.constant = TabbarHigth;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GoToCarTrack:) name:@"GoToCarTrack" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AllCarRequest) name:@"UnBindSuccess" object:nil];
    [self  setNaiv];
    topButtonInt = 0;
    
    [_myTablewView registerNib:[UINib nibWithNibName:@"CarListCell" bundle:nil] forCellReuseIdentifier:@"CarListCell"];
    _myTablewView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataMutableArray = [NSMutableArray array];
    [dataMutableArray addObjectsFromArray:USERMANAGER.GT10CarArray];
    if (dataMutableArray.count >= 1) {
        LocationModel *model = dataMutableArray[0];
        model.isOpen = YES;
    }
    int activiInt = 0;
    int notActiviInt = 0;
    for (LocationModel *model in USERMANAGER.GT10CarArray) {
        if ([model.online isEqualToString:@"1"]) {
            activiInt++;
        }else{
            notActiviInt++;
        }
    }
    DISPATCH_ON_MAIN_THREAD((^{
        [self.topView codered:self.topView.bounds :@[L(@"All"),L(@"On-line"),L(@"Off-line"),L(@"Not activated")] categryStr:nil];
        self.topView.topSwitchDele = self;
        [self.topView reSetTitleStr:@[[NSString stringWithFormat:@"%@(%lu)",L(@"All"),(unsigned long)USERMANAGER.GT10CarArray.count],[NSString stringWithFormat:@"%@(%d)",L(@"On-line"),activiInt],[NSString stringWithFormat:@"%@(%d)",L(@"Off-line"),notActiviInt],[NSString stringWithFormat:@"%@(%d)",L(@"Not activated"),0]]];
    }))
    
    
    //头部刷新 addAlarmListRefresh
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(AllCarRequest)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _myTablewView.mj_header = header;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [_myTablewView reloadData];
    [self changeEmptyView];
}
#pragma -mark topSwitchDele
-(void)topButtonClick:(int )tag categryStr:(NSString*)categryStr{
    
    [dataMutableArray removeAllObjects];
    switch (tag) {
        case 0:
        {
            [dataMutableArray addObjectsFromArray:USERMANAGER.GT10CarArray];
        }
            break;
        case 1:
        {
            for (LocationModel *model in USERMANAGER.GT10CarArray) {
                if ([model.online isEqualToString:@"1"]) {
                    [dataMutableArray addObject:model];
                }
            }

        }
            break;
        case 2:
        {
            for (LocationModel *model in USERMANAGER.GT10CarArray) {
                if (![model.online isEqualToString:@"1"]) {
                    [dataMutableArray addObject:model];
                }
            }
        }
            break;
        case 3:
        {
            
        }
            break;
            
            
        default:
            break;
    }
    topButtonInt = tag;
    [_myTablewView reloadData];
    [self changeEmptyView];
}
-(void)GoToCarTrack:(NSNotification*)noti{
    NSDictionary *dict= noti.userInfo;
    int type = [dict[@"Type"]intValue];
    LocationModel *model = dict[@"CarModel"];
    USERMANAGER.seleCar = model;
    switch (type) {
        case 0:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:L(@"Navigate to the device location") preferredStyle:  UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:L(@"Navigate")] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"导航到目的地");
                
                [CSQNaviModel sendNaviWithModel:model];
                
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:L(@"Cancel")] style:
                              UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                  
                              }]];
            //    [[AppData lastWindow] endEditing: YES];
            [self.navigationController presentViewController:alert animated:true completion:nil];
        }
            break;
        case 1:
        {
            TrackPlayBackVC *viewVC = [[TrackPlayBackVC alloc]init];
            viewVC.carModel = model;
            [self.navigationController pushViewController:viewVC animated:YES];
        }
            break;
        case 2:
        {
            FenceVC *fenceVC = [[FenceVC alloc]init];
            fenceVC.carModel = model;
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
            alarmVC.carModel = model;
            alarmVC.selfType = One;
            [self.navigationController pushViewController:alarmVC animated:YES];
        }
            break;
        case 5:
        {
            CarInfoVC *carInfoVC = [[CarInfoVC alloc]init];
            carInfoVC.carModel = model;
            [self.navigationController pushViewController:carInfoVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}
-(void)setNaiv{
    self.view.backgroundColor = HBackColor;
    self.title = L(@"list");
}
-(void)showLeft{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark TableViewDele
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataMutableArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationModel *model = dataMutableArray[indexPath.row];
    if (model.isOpen) {
        return 141;
    }else{
        return 73;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CarListCell";
    CarListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    LocationModel *model = dataMutableArray[indexPath.row];
    [cell setCarModel:model];
    [cell.LocalButton addTarget:self action:@selector(carLocation:) forControlEvents:UIControlEventTouchUpInside];
    cell.LocalButton.tag = 1000 + indexPath.row;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (LocationModel *carModel in dataMutableArray) {
        carModel.isOpen = NO;
    }
    LocationModel *carModel = dataMutableArray[indexPath.row];
    carModel.isOpen = YES;
    [tableView reloadData];
}
-(void)carLocation:(UIButton *)but{
    int tag = but.tag - 1000;
    LocationModel *model = dataMutableArray[tag];
    
    CarTrackVC *viewVC = [[CarTrackVC alloc]init];
    viewVC.carModel = model;
    [self.navigationController pushViewController:viewVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)AllCarRequest{
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    NSLog(@"userID = %@",USERMANAGER.user.userID);
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID)
                          };
    
    [ZZXDataService HFZLRequest:@"track/get-tracks" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {

         if ([data[@"code"]integerValue] == 0) {
            
             NSArray *userArray = data[@"data"];
             if (!kArrayIsEmpty(userArray)) {
                  [UIUtil hideProgressHUD];
                  [dataMutableArray removeAllObjects];
                 
                 int modelCount = 0;
                 for (NSDictionary *carDict in userArray) {
                     
                     
                     LocationModel *model = [LocationModel provinceWithDictionary:carDict];
                     CLLocationCoordinate2D Locateoiooo;
                     Locateoiooo.latitude = [[carDict getStringValueForKey:@"y" defaultValue:@" "]  floatValue];
                     Locateoiooo.longitude = [[carDict getStringValueForKey:@"x" defaultValue:@" "] floatValue];
                     Locateoiooo = [JZLocationConverter BD_bd09ToWgs84:Locateoiooo];
                     model.x = [NSString stringWithFormat:@"%f",Locateoiooo.longitude];
                     model.y = [NSString stringWithFormat:@"%f",Locateoiooo.latitude];
//                     if (modelCount == seleCount) {
//                         carStateModel = model;
//                         USERMANAGER.seleCar = carStateModel;
//                     }
                     if ([model.ico intValue] < 1 || [model.ico intValue] > 13) {
                         model.ico = @"0";
                     }
                     if (Locateoiooo.latitude <100.) {
                         model.tagNumber = modelCount;
                         modelCount++;
                         [dataMutableArray addObject:model];
                     }
                 }
                 [USERMANAGER.GT10CarArray removeAllObjects];
                 [USERMANAGER.GT10CarArray addObjectsFromArray:dataMutableArray];
                 [self reSetAllCarView];
             }else{
                 [UIUtil showToast:L(@"You are not currently bound devices") inView:self.view];
                 [USERMANAGER.GT10CarArray removeAllObjects];
                 [self reSetAllCarView];
             }
         }else{
             switch ([data[@"code"]integerValue ]) {
                 case 200002:
                     {
                         [UIUtil showToast:L(@"You are not currently bound devices") inView:self.view];
                         [USERMANAGER.GT10CarArray removeAllObjects];
                         [self reSetAllCarView];
                     }
                     break;
                     
                 default:
                     break;
             }
         }
         [_myTablewView.mj_header endRefreshing];
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
         [_myTablewView.mj_header endRefreshing];
     }];
}
-(void)reSetAllCarView{
    [self topButtonClick:topButtonInt categryStr:nil];
    if (dataMutableArray.count >= 1) {
        LocationModel *model = dataMutableArray[0];
        model.isOpen = YES;
    }
    int activiInt = 0;
    int notActiviInt = 0;
    for (LocationModel *model in USERMANAGER.GT10CarArray) {
        if ([model.online isEqualToString:@"1"]) {
            activiInt++;
        }else{
            notActiviInt++;
        }
    }
    [self.topView reSetTitleStr:@[[NSString stringWithFormat:@"%@(%lu)",L(@"All"),(unsigned long)USERMANAGER.GT10CarArray.count],[NSString stringWithFormat:@"%@(%d)",L(@"On-line"),activiInt],[NSString stringWithFormat:@"%@(%d)",L(@"Off-line"),notActiviInt],[NSString   stringWithFormat:@"%@(%d)",L(@"Not activated"),0]]];
    [_myTablewView reloadData];
    [self changeEmptyView];
}
-(void)changeEmptyView{
    if (dataMutableArray.count == 0) {
        [_myTablewView addEmptyViewWithImageName:@"" title:L(@"There is no device in this state")];
        _myTablewView.emptyView.hidden = NO;
    }else{
        _myTablewView.emptyView.hidden = YES;
    }
}
-(void)getInstrInfo{
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(USERMANAGER.seleCar.macId)
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
                     if ([USERMANAGER.seleCar.macType isEqualToString:DR_30]) {
                         vc.macType = DR30;
                     }else if([USERMANAGER.seleCar.macType isEqualToString:GT31]){
                         vc.macType = GT_31;
                     }
                     else if([USERMANAGER.seleCar.macType isEqualToString:GT51]){
                         vc.macType = GT_51;
                     }
                     else if([USERMANAGER.seleCar.macType isEqualToString:GT52]){
                         vc.macType = GT_52;
                     }
                     else if([USERMANAGER.seleCar.macType isEqualToString:GT121]){
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
