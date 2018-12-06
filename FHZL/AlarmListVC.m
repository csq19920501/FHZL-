//
//  AlarmListVC.m
//  FHZL
//
//  Created by hk on 17/12/21.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "AlarmListVC.h"
#import "Header.h"
#import "AlarmListCell.h"
#import "alarmModel.h"
#import "AlarmScreenVC.h"
#import "MJRefresh.h"
#import "FFDropDownMenuView.h"
@interface AlarmListVC ()<UITableViewDelegate,UITableViewDataSource,FFDropDownMenuViewDelegate>
{
    NSMutableArray *alarmDataArray;
    NSString *lastId;
    NSArray *searchArray;
    UILabel *titleLabel;
    UIImageView *titleImage;
    BOOL isSeleOne;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;

@property (nonatomic, strong) FFDropDownMenuView *dropdownMenu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation AlarmListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topConstant.constant = kTopHeight;
   
    
    alarmDataArray = [NSMutableArray array];
    lastId = @"0";
    if (_selfType == One) {
        FilterModel *allModel = [[FilterModel alloc]init];
        [allModel setAll];
        searchArray = [allModel getArray];
        ifIphoneX(self.bottomConstant.constant = 34;)
        
    }else{
        self.bottomConstant.constant = TabbarHigth;
        searchArray = [USERMANAGER.filterModel getArray];
    }
    
    [_myTableView registerNib:[UINib nibWithNibName:@"AlarmListCell" bundle:nil] forCellReuseIdentifier:@"AlarmListCell"];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    if (_selfType == All) {
        [self changeTitle];
    }else{
        FilterModel *allModel = [[FilterModel alloc]init];
        [allModel setAll];
        searchArray = [allModel getArray];
    }
    [self setupDropDownMenu];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAlarmListRefresh) name:@"AlarmPush" object:nil];
}
-(void)changeTitle{
    if (!isSeleOne) {
        titleLabel.text = L(@"All Equipment");
    }else{
        titleLabel.text = USERMANAGER.seleCar.macName;
    }
    CGRect rect = [titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT,44 ) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil];
    titleLabel.frame = CGRectMake((200 - TITLEWIGTH2 - 30)/2, 0, TITLEWIGTH2, 44);
    titleImage.frame = CGRectMake(titleLabel.right, 7, 30, 30);
    searchArray = [USERMANAGER.filterModel getArray];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
//        [self viewWillAppear:NO];
        [self changeTitle];
        
    }];
    [menuArray addObject:menuModel0];
    
    for (LocationModel*model in USERMANAGER.GT10CarArray) {
        FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:model.macName menuItemIconName:nil  menuBlock:^{
            isSeleOne = YES;
            USERMANAGER.seleCar = model;
            [self getAlarmListRefresh];
//            [self viewWillAppear:NO];
            [self changeTitle];
        }];
        [menuArray addObject:menuModel0];
    }
    return menuArray;
}
-(void)getAlarmListRefresh{
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    lastId = @"0";
    NSDictionary *dic = nil;
    NSString *pageNum = alarmDataArray.count >= 30?[NSString stringWithFormat:@"%ld",alarmDataArray.count]:@"30";
    if (_selfType == One) {
        dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                              @"macId":CsqStringIsEmpty(_carModel.macId) ,
                              @"lastId":CsqStringIsEmpty(lastId) ,
                              @"pageNum":CsqStringIsEmpty(pageNum),
                              @"condition":searchArray
                              };
    }else{
        if (!isSeleOne) {
            dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                    @"lastId":CsqStringIsEmpty(lastId) ,
                    @"pageNum":CsqStringIsEmpty(pageNum),
                    @"condition":searchArray
                    };
        }else{
            dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                    @"macId":CsqStringIsEmpty(USERMANAGER.seleCar.macId) ,
                    @"lastId":CsqStringIsEmpty(lastId) ,
                    @"pageNum":CsqStringIsEmpty(pageNum),
                    @"condition":searchArray
                    };
        }
    }
    [alarmDataArray removeAllObjects];
    [ZZXDataService HFZLRequest:@"alarm/get-alarms" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil hideProgressHUD];
             
             NSArray *dataArray = data[@"data"];
             if (!kArrayIsEmpty(dataArray)) {
                 for (NSDictionary *dataDict in dataArray) {
                     alarmModel *model = [alarmModel provinceWithDictionary:dataDict];
                     [alarmDataArray addObject:model];
                     lastId = model.alarmId;
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
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    NSDictionary *dic = nil;
    if (_selfType == One) {
        dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                @"macId":CsqStringIsEmpty(_carModel.macId) ,
                @"lastId":CsqStringIsEmpty(lastId) ,
                @"pageNum":CsqStringIsEmpty(@"30"),
                @"condition":searchArray
                };
    }else{
        dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                @"lastId":CsqStringIsEmpty(lastId) ,
                @"pageNum":CsqStringIsEmpty(@"30"),
                @"condition":searchArray
                };
    }
    [ZZXDataService HFZLRequest:@"alarm/get-alarms" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         [_myTableView.mj_footer endRefreshing];
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil hideProgressHUD];

             NSArray *dataArray = data[@"data"];
             if (!kArrayIsEmpty(dataArray)) {
                 for (NSDictionary *dataDict in dataArray) {
                     alarmModel *model = [alarmModel provinceWithDictionary:dataDict];
                     [alarmDataArray addObject:model];
                     lastId = model.alarmId;
                 }
                 [_myTableView reloadData];
             }
             [self changeEmptyView];
         }else{
             [UIUtil hideProgressHUD];
         }
     } fail:^(NSError *error)
     {
         [_myTableView.mj_footer endRefreshing];
//         [UIUtil showToast:@"网络异常" inView:self.view];
     }];
}
-(void)changeEmptyView{
    if (alarmDataArray.count == 0) {
        [_myTableView addEmptyViewWithImageName:@"" title:L(@"There is no alert for the current filter condition")];
        _myTableView.emptyView.hidden = NO;
    }else{
        _myTableView.emptyView.hidden = YES;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return alarmDataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*identifier = @"AlarmListCell";
    AlarmListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    alarmModel *model = alarmDataArray[indexPath.row];
    cell.AlarmModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        NSLog(@"点击了删除");
//        //        railModel *model = railArray[indexPath.row];
//        //        deleFenceInt = 0;
//        //        [UIUtil showProgressHUD:nil inView:self.view];
//        //        [self deleFence:model];
//
//    }];
//    return @[deleteAction];
//}




-(void)setNavi{
    
    self.view.backgroundColor = HBackColor;
    
    if (_selfType == One) {
        self.title = L(@"Alarm message");
        isSeleOne = YES;
    }else{
        [self addNavigationItemWithImageNames
         :@[@"警报信息_标题栏_过滤_N.png"] isLeft:NO target:self action:@selector(showRight) tags:@[@1000]];
        
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
}
-(void)showLeft{
    if (_selfType == All) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }else {
         [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)showRight{
    AlarmScreenVC *vc = [[AlarmScreenVC alloc]init];
    [vc setBlackRefresh:^{
        searchArray = [USERMANAGER.filterModel getArray];
        [self getAlarmListRefresh];
    }];
    [self.navigationController pushViewController:vc animated:YES];
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
