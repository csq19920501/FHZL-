//
//  FenceVC.m
//  FHZL
//
//  Created by hk on 17/12/19.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "FenceVC.h"
#import "Header.h"
#import "FenceCell.h"
#import "FenceSetVC.h"
#import "FenceModel.h"
#import "NSObject+objectFormDict.h"
@interface FenceVC ()
{
    NSMutableArray *railArray;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@end

@implementation FenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.topConstant.constant = kTopHeight;
    if (isIphoneX) {
        self.bottomConstant.constant = 34;
    }
    
    [_myTableview registerNib:[UINib nibWithNibName:@"FenceCell" bundle:nil] forCellReuseIdentifier:@"FenceCell"];
    _myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableview.bounces = NO;
    [self setNavi];
    railArray = [NSMutableArray  array];
    [UIUtil showProgressHUD:L(@"Please wait") inView:self.view];
}
-(void)viewWillAppear:(BOOL)animated{
    [self getEnclosure];
}
//查询电子围栏
-(void)getEnclosure
{
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(_carModel.macId)
                          };
    [ZZXDataService HFZLRequest:@"fence/get-fences" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if ([data[@"code"]integerValue] == 0) {
             [railArray removeAllObjects];
             NSArray *arr = data[@"data"];
             if (!kArrayIsEmpty(arr)) {
                 for(NSDictionary *dict in arr){
                     FenceModel *fenModel = [FenceModel provinceWithDictionary:dict];
                     [railArray addObject:fenModel  ];
                 }
             }
             [_myTableview reloadData];
             [UIUtil hideProgressHUD];
         }else{
             [UIUtil showToast:L(@"Failed to acquire the fence") inView:self.view];
         }
         [self changeEmptyView];
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
         [self changeEmptyView];
     }];

}
-(void)changeEmptyView{
    if (railArray.count == 0) {
        [_myTableview addEmptyViewWithImageName:@"" title:L(@"No fence")];
        _myTableview.emptyView.hidden = NO;
    }else{
        _myTableview.emptyView.hidden = YES;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return railArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*identifier = @"FenceCell";
    FenceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.fenceModel = railArray[indexPath.row];
    return cell;    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FenceSetVC *fenceSetVC = [[FenceSetVC alloc]init];
    fenceSetVC.carModel = _carModel;
    FenceModel *model = railArray[indexPath.row];
    fenceSetVC.fenModel = model;
    [self.navigationController pushViewController:fenceSetVC animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:L(@"Delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");

        FenceModel *model = railArray[indexPath.row];
        [UIUtil showToast:L(@"delete...") inView:self.view];
        [self deleFence:model number:0];
    }];
    return @[deleteAction];
}

-(void)deleFence:(FenceModel *)fenModel number:(int)number{
    
    NSDictionary *dic = @{@"userId":CsqStringIsEmpty(USERMANAGER.user.userID),
                          @"macId":CsqStringIsEmpty(_carModel.macId),
                          @"id":CsqStringIsEmpty(fenModel.fenceId),
                          @"count":[NSString stringWithFormat:@"%d",number]
                          };
    number++;
    [ZZXDataService HFZLRequest:@"fence/remove-fence" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         
         if ([data[@"code"]integerValue] == 101054) {
             if (number <= mostNunber) {
                 double delayInSeconds = 2.0f;
                 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                 dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                {
                                    [self deleFence:fenModel number:number];
                                });
             }else{
                 [UIUtil showToast:L(@"Network exception") inView:self.view];
             }
         }else if ([data[@"code"]integerValue] == 0) {
             [UIUtil showToast:L(@"Success failed") inView:self.view];
             [railArray removeObject:fenModel];
             [self changeEmptyView];
             [_myTableview reloadData];
         }else if ([data[@"code"]integerValue] == 101051) {
             [UIUtil showToast:L(@"Device not online, deletion failed") inView:self.view];
         }else{
             [UIUtil showToast:L(@"Delete failed") inView:self.view];
         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:self.view];
     }];
}
-(void)setNavi{
    self.title = L(@"Electronic fence");
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
     :@[@"电子围栏_标题栏_添加_N.png"] isLeft:NO target:self action:@selector(showRight) tags:@[@1000]];
    
//    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button2 setBackgroundImage:[UIImage imageNamed:@"电子围栏_标题栏_添加_N.png"] forState:UIControlStateNormal];
//    [button2 setBackgroundImage:[UIImage imageNamed:@"电子围栏_标题栏_添加_P.png"] forState:UIControlStateHighlighted];
//    [button2 addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
//    button2.frame = CGRectMake(0, 0, 25, 25);
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
//    
//    //    UIButton * button3 = [UIButton buttonWithType:UIButtonTypeSystem];
//    //    [button3 setBackgroundImage:[UIImage imageNamed:@"车辆追踪_标题栏_分享_N.png"] forState:UIControlStateNormal];
//    //    //    [button setBackgroundImage:[UIImage imageNamed:BackImageP] forState:UIControlStateHighlighted];
//    //    [button3 addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
//    //    button3.frame = CGRectMake(0, 0, 25, 25);
//    //    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithCustomView:button3];
//    
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:item2, nil];
}
-(void)showLeft{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRight{
    if ([_carModel.macType isEqualToString:GT121]){
        [UIUtil showToast:L(@"This device is not supported") inView:self.view];
    }else{
        if (railArray.count >=5) {
            [UIUtil showToast:L(@"The maximum number of fences is five") inView:self.view];
        }else{
            FenceSetVC *fenceSetVC = [[FenceSetVC alloc]init];
            fenceSetVC.carModel = _carModel;
            [self.navigationController pushViewController:fenceSetVC animated:YES];
        }
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
