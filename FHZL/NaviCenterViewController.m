//
//  NaviCenterViewController.m
//  WeiZhong_ios
//
//  Created by hk on 17/9/25.
//
//
#define DISPATCH_AFTER(afterTime,agterQueueBlock) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), agterQueueBlock);

#import "NaviCenterViewController.h"
#import "Header.h"
#import "RemoteNotiCell2.h"
#import "UITableView+WFEmpty.h"
#import "AppData.h"
#import "JZLocationConverter.h"
@interface NaviCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *NaviModelArray;
    NaviModel *selectModel;
}
@property (weak, nonatomic) IBOutlet UITableView *myTablewView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContast;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;

@end

@implementation NaviCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topContast.constant = kTopHeight;
    ifIphoneX(self.bottomConstant.constant = 34)
    NaviModelArray = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    [self setNaiv];
    [_myTablewView registerNib:[UINib nibWithNibName:@"RemoteNotiCell2" bundle:nil] forCellReuseIdentifier:@"RemoteNotiCell2"];
    _myTablewView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
//    for (int i = 0 ; i < 10; i++) {
//        NaviModel *model = [[NaviModel alloc]init];
//        model.sendTime = @"2016-05-06 12:13:44";
//        model.addName = @"测试数据";
//        model.content = @"南山智园";
//        [NaviModelArray  addObject:model];
//    }
    [_myTablewView reloadData];
    

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [UIUtil showProgressHUD:@"请稍候" inView:self.view];
//        NSData* remoteNotiData = [USER_PLIST objectForKey:@"NAVIARRAY"];
//        [NaviModelArray addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:remoteNotiData]];
//        
//        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//        [NaviModelArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            return [[dateFormatter1 dateFromString:((NaviModel*)obj1).sendTime] timeIntervalSince1970] < [[dateFormatter1 dateFromString:((NaviModel*)obj2).sendTime] timeIntervalSince1970];//简写方式
//        }];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [UIUtil hideProgressHUD];
//        
//            DISPATCH_AFTER(0.05,^(void){
//                [self changeEmptyView];
//                [_myTablewView reloadData];
//            })
//        });
//        
//    });//不加多线程加载数据时间长主线程阻塞
    DISPATCH_AFTER(0.05,^(void){
                        [self changeEmptyView];
                        [_myTablewView reloadData];
                    })
}
-(void)changeEmptyView{
    if (NaviModelArray.count == 0) {
        [_myTablewView addEmptyViewWithImageName:@"" title:L(@"No message")];
        _myTablewView.emptyView.hidden = NO;
    }else{
        _myTablewView.emptyView.hidden = YES;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return NaviModelArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  88;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"RemoteNotiCell2";
    RemoteNotiCell2 * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    [cell setModel:NaviModelArray[indexPath.row]];
    NaviModel *model = NaviModelArray[indexPath.row];
    cell.titelLabel.text = model.addName;
    cell.timeLabel.text = model.sendTime;
    cell.concentLabel.text = model.content;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectModel = NaviModelArray[indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:L(@"导航") message:L(@"Whether to navigate to the historical address") delegate:self cancelButtonTitle:L(@"Cancel") otherButtonTitles:L(@"OK"), nil];
    alertView.delegate = self;
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        NSLog(@"NaviNOTI save  model.srcY = %f  model.srcX = %f",selectModel.srcY,selectModel.srcX);
        
        if (1 == [AppData useMapType])
        {
            NSString* stringURL = [[NSString stringWithFormat:@"baidumap://map/navi?location=%.8f,%.8f&coord_type=bd09ll", selectModel.srcY, selectModel.srcX ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL* url = [NSURL URLWithString:stringURL];
            [[UIApplication sharedApplication] openURL:url];
        }
        else if(3 == [AppData useMapType]){
            if ([USER_PLIST objectForKey:@"userlatitude"]) {
                
                
                NSString *str=[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f&saddr=%f,%f",selectModel.srcY, selectModel.srcX,[[USER_PLIST objectForKey:@"userlatitude"]floatValue],[[USER_PLIST objectForKey:@"userlongitude"]floatValue]];
                NSURL* url = [NSURL URLWithString:str];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        else if(2 == [AppData useMapType])
        {
            CLLocationCoordinate2D _userCoordinate;
            _userCoordinate.latitude = selectModel.srcY;
            _userCoordinate.longitude = selectModel.srcX;
            _userCoordinate = [JZLocationConverter bd09ToGcj02:_userCoordinate];
            
            NSString* stringURL = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=broker&backScheme=openbroker2&poiname=%@&poiid=BGVIS&lat=%.8f&lon=%.8f&dev=0&style=2", selectModel.addName, _userCoordinate.latitude, _userCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL* url = [NSURL URLWithString:stringURL];
            [[UIApplication sharedApplication] openURL:url];
        }
        else if(4 == [AppData useMapType])
        {
            NSString* stringURL = [NSString stringWithFormat:@"iosamap://plan?coordType=broker&src=openbroker2&dest=%f,%f,%@&strategy=10&via=", selectModel.srcY, selectModel.srcX,selectModel.addName];
            NSURL* url = [NSURL URLWithString:stringURL];
            [[UIApplication sharedApplication] openURL:url];
        }

    }
}
-(void)setNaiv{

    self.view.backgroundColor = HBackColor;
    self.title = L(@"Message center");
    
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getNaviNOTI:(NSDictionary*)dict{
    
    

    
    
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
