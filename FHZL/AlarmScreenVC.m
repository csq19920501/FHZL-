//
//  AlarmScreenVC.m
//  FHZL
//
//  Created by hk on 2018/1/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "AlarmScreenVC.h"
#import "Header.h"
#import "screenCell.h"
#import "FilterModel.h"
@interface AlarmScreenVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *screenArray;
    FilterModel *fileterModel;
    NSArray *nameArray;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation AlarmScreenVC
- (IBAction)selectAll:(id)sender {
    [fileterModel setAll];
    [_myTableView reloadData];
}
- (IBAction)confirm:(id)sender {
    USERMANAGER.filterModel = fileterModel;
    [USERMANAGER save];
    [UIUtil showToast:L(@"Save successfully") inView:self.view];
    
    CSQ_DISPATCH_AFTER(1.5, ^{
        if (_blackRefresh) {
            self.blackRefresh();
        }
        [self showLeft];
        
    })
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.allSelectButton setTitle:L(@"All Selected") forState:UIControlStateNormal];
    [self.confirmButton setTitle:L(@"confirm") forState:UIControlStateNormal];
    if (isIphoneX) {
        self.bottomConstant.constant = 94;
    }
    self.topConstant.constant = kTopHeight;
    
    [self setNavi];
    nameArray = @[L(@"Low power alarm"),L(@"Acc open alarm"),L(@"Acc close alarm"),L(@"Alarm from external power cord"),L(@"Door opened alarm"),L(@"Vehicle speed warning"),@"SOS alarm",L(@"Enter the GPS blind area alert"),L(@"Car vibration alarm"),L(@"Car movement alarm"),L(@"Leave the GPS blind area alert"),L(@"Device removed alarm"),L(@"The electronic fence is off the alarm"),L(@"Electronic fence into alarm")];
    [_myTableView registerNib:[UINib nibWithNibName:@"screenCell" bundle:nil] forCellReuseIdentifier:@"screenCell"];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = [UIColor clearColor];
    screenArray = [NSMutableArray array];
    fileterModel = [USERMANAGER.filterModel csqCopy];
    
}
-(void)setNavi{
    self.title = L(@"Alarm information filtering");
}
-(void)changeEmptyView{
    if (screenArray.count == 0) {
        [_myTableView addEmptyViewWithImageName:@"" title:nil];
        _myTableView.emptyView.hidden = NO;
    }else{
        _myTableView.emptyView.hidden = YES;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat heigth = (isIphone6More)?60:44;
    NSLog(@"heigth = %f",heigth);
    return heigth;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nameArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"screenCell";

    
    screenCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.AlarmTypeName.text = nameArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            cell.isSelectButton.selected = fileterModel.hasOil;
        }
            break;
        case 1:
        {
            cell.isSelectButton.selected = fileterModel.hasAccOpen;
        }
            break;
        case 2:
        {
            cell.isSelectButton.selected = fileterModel.hasAccClose;
        }
            break;
        case 3:
        {
            cell.isSelectButton.selected = fileterModel.HasDropB;
        }
            break;
        case 4:
        {
            cell.isSelectButton.selected = fileterModel.HasCarDoor;
        }
            break;
        case 5:
        {
            cell.isSelectButton.selected = fileterModel.HasSpeed;
        }
            break;
        case 6:
        {
            cell.isSelectButton.selected = fileterModel.HasSoS;
        }
            break;
        case 7:
        {
            cell.isSelectButton.selected = fileterModel.hasGoInMangQu;
        }
            break;
        case 8:
        {
            cell.isSelectButton.selected = fileterModel.hasZhengDong;
        }
            break;
        case 9:
        {
            cell.isSelectButton.selected = fileterModel.HasCarMove;
        }
            break;
        case 10:
        {
            cell.isSelectButton.selected = fileterModel.hasGoOutMangQu;
        }
            break;
        case 11:
        {
            cell.isSelectButton.selected = fileterModel.HasDeviceClean;
        }
            break;
        case 12:
        {
            cell.isSelectButton.selected = fileterModel.HasCarFence;
        }
            break;
        case 13:
        {
            cell.isSelectButton.selected = fileterModel.HasCarFenceIn;
        }
            break;
        default:
            break;
    }
    [cell.isSelectButton addTarget:self action:@selector(changeSelect:) forControlEvents:UIControlEventTouchUpInside];
    cell.isSelectButton.tag = indexPath.row  + 100;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)changeSelect:(id)sender{
    UIButton *but = (UIButton*)sender;
    but.selected = !but.selected;
    NSLog(@"but.tag = %d",but.tag);
    switch (but.tag - 100) {
        case 0:
        {
            fileterModel.hasOil = but.selected;
        }
            break;
        case 1:
        {
            fileterModel.hasAccOpen = but.selected;
        }
            break;
        case 2:
        {

            fileterModel.hasAccClose = but.selected;
        }
            break;
        case 3:
        {
 
            fileterModel.HasDropB = but.selected;
        }
            break;
        case 4:
        {

            fileterModel.HasCarDoor = but.selected;
        }
            break;
        case 5:
        {
            fileterModel.HasSpeed = but.selected;
        }
            break;
        case 6:
        {
            fileterModel.HasSoS = but.selected;
        }
            break;
        case 7:
        {
            fileterModel.hasGoInMangQu = but.selected;
        }
            break;
        case 8:
        {

            fileterModel.hasZhengDong = but.selected;
        }
            break;
        case 9:
        {

            fileterModel.HasCarMove = but.selected;
        }
            break;
        case 10:
        {

            fileterModel.hasGoOutMangQu = but.selected;
        }
            break;
        case 11:
        {

            fileterModel.HasDeviceClean = but.selected;
        }
            break;
        case 12:
        {

            fileterModel.HasCarFence = but.selected;
        }
            break;
        case 13:
        {
            
            fileterModel.HasCarFenceIn = but.selected;
        }
            break;
        default:
            break;
    }
    [_myTableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIButton *but = (UIButton*)[self.view viewWithTag:indexPath.row + 100];
    but.selected = !but.selected;
    NSLog(@"but.tag = %d",but.tag);
    switch (but.tag -100) {
        case 0:
        {
            fileterModel.hasOil = but.selected;
        }
            break;
        case 1:
        {
            fileterModel.hasAccOpen = but.selected;
        }
            break;
        case 2:
        {
            
            fileterModel.hasAccClose = but.selected;
        }
            break;
        case 3:
        {
            
            fileterModel.HasDropB = but.selected;
        }
            break;
        case 4:
        {
            
            fileterModel.HasCarDoor = but.selected;
        }
            break;
        case 5:
        {
            fileterModel.HasSpeed = but.selected;
        }
            break;
        case 6:
        {
            fileterModel.HasSoS = but.selected;
        }
            break;
        case 7:
        {
            fileterModel.hasGoInMangQu = but.selected;
        }
            break;
        case 8:
        {
            
            fileterModel.hasZhengDong = but.selected;
        }
            break;
        case 9:
        {
            
            fileterModel.HasCarMove = but.selected;
        }
            break;
        case 10:
        {
            
            fileterModel.hasGoOutMangQu = but.selected;
        }
            break;
        case 11:
        {
            
            fileterModel.HasDeviceClean = but.selected;
        }
            break;
        case 12:
        {
            
            fileterModel.HasCarFence = but.selected;
        }
            break;
        case 13:
        {
            
            fileterModel.HasCarFenceIn = but.selected;
        }
            break;
        default:
            break;
    }
    [_myTableView reloadData];
    
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
