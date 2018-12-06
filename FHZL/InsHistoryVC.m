//
//  InsHistoryVC.m
//  FHZL
//
//  Created by hk on 2018/1/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "InsHistoryVC.h"
#import "instructionCell.h"
#import "InstructionModel.h"
#import "Header.h"
#import "MJRefresh.h"
@interface InsHistoryVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *InsArray;
    NSString *lastId;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonConstant;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation InsHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ifIphoneX(self.bottonConstant.constant = 34)
    // Do any additional setup after loading the view from its nib.
    [self setNavi];    
    [_myTableView registerNib:[UINib nibWithNibName:@"instructionCell" bundle:nil] forCellReuseIdentifier:@"instructionCell"];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = [UIColor clearColor];
    InsArray = [NSMutableArray array];
    
    //头部刷新 addAlarmListRefresh
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAlarmListRefresh)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _myTableView.mj_header = header;
    
    _myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addAlarmListRefresh)];
    
    [_myTableView.mj_header beginRefreshing];
    
}
-(void)getAlarmListRefresh{
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    lastId = @"0";
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                @"macId":CsqStringIsEmpty(USERMANAGER.seleCar.macId) ,
                @"lastId":CsqStringIsEmpty(lastId) ,
                @"pageNum":CsqStringIsEmpty(@"30")
                };
    
    [ZZXDataService HFZLRequest:@"instruction/historys" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         [_myTableView.mj_header endRefreshing];
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil hideProgressHUD];
             [InsArray removeAllObjects];
             NSArray *dataArray = data[@"data"];
             if (!kArrayIsEmpty(dataArray)) {
                 for (NSDictionary *dataDict in dataArray) {
                     
                     InstructionModel *model = [InstructionModel provinceWithDictionary:dataDict];
                     [InsArray addObject:model];
                     lastId = model.instrID;
                 }
                 //                 alarmModel *model = [alarmModel provinceWithDictionary:dataArray[0]];
                 //                 lastId = model.alarmId;
                 [_myTableView reloadData];
             }
             [self changeEmptyView];
         }else{
             [UIUtil hideProgressHUD];
             
         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
         [_myTableView.mj_header endRefreshing];
     }];
}
-(void)addAlarmListRefresh{
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(USERMANAGER.seleCar.macId) ,
                @"lastId":CsqStringIsEmpty(lastId) ,
                @"pageNum":CsqStringIsEmpty(@"30")
                };
    
    [ZZXDataService HFZLRequest:@"instruction/historys" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         [_myTableView.mj_footer endRefreshing];
         if ([data[@"code"]integerValue] == 0) {
             [UIUtil hideProgressHUD];
             
             NSArray *dataArray = data[@"data"];
             if (!kArrayIsEmpty(dataArray)) {
                 for (NSDictionary *dataDict in dataArray) {
                     InstructionModel *model = [InstructionModel provinceWithDictionary:dataDict];
                     [InsArray addObject:model];
                     lastId = model.instrID;
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
-(void)setNavi{
    self.title = L(@"History instruction");
}
-(void)changeEmptyView{
    if (InsArray.count == 0) {
        [_myTableView addEmptyViewWithImageName:@"" title:L(@"No instructions")];
        _myTableView.emptyView.hidden = NO;
    }else{
        _myTableView.emptyView.hidden = YES;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return InsArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"instructionCell";
    instructionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.insHistoryModel = InsArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showLeft{
    
    [self.navigationController popViewControllerAnimated:YES];
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
