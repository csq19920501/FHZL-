/*
 ============================================================================
 Name        : AboutUsViewController.m
 Version     : 1.0.0
 Copyright   : 
 Description : 关于我们界面
 ============================================================================
 */
#import "Header.h"
#import "AboutUsViewController.h"
#import "AboutUsItemCell.h"
#import "ShareChooseViewController.h"
#import "AppData.h"
//#import "UIViewController+KNSemiModal.h"
#import "LocalizedStringTool.h"
//#define WEBSITE       (@"http://www.ifengstar.com") //官网网址
//#define SERVICE_PHONE (@"4008619006") //客服电话
#import "ScanCodeTableViewCell.h"
@interface AboutUsViewController ()
{
    IBOutlet UITableView *_tabelView;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstang;
@property(nonatomic,strong)ShareView *shareView;
@end

@implementation AboutUsViewController
- (IBAction)shareButton:(id)sender {
//    ShareChooseViewController* viewController = [[ShareChooseViewController alloc] init];
//    viewController.text = [NSString stringWithFormat:@"%@%@",L(@"ShareText"),[NSString stringWithFormat:@"http://www.ifengstar.com/jump/jump.jsp?project=%@",APPTYPE]];
//    [self.navigationController presentSemiViewController:viewController withOptions:@{ KNSemiModalOptionKeys.pushParentBack:@(NO), KNSemiModalOptionKeys.animationDuration:@(0.15f), KNSemiModalOptionKeys.shadowOpacity:@(0.0f),}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topConstang.constant = kTopHeight;
    NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"AboutUsItemCell" owner:nil options:nil];
    AboutUsHeaderCell *headerCell = [cells objectAtIndex:1];
    _tabelView.tableHeaderView = headerCell;
    [_tabelView registerNib:[UINib nibWithNibName:@"ScanCodeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ScanCodeTableViewCell"];
    [self setNavi];
}
-(void)setNavi{
//    self.navigationController.navigationBar.hidden = NO;
    self.title = L(@"About us");
    //    self.navigationController.navigationBar.translucent = YES;
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
    [self.navigationItem setRightBarButtonItem:({
        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
//            [button setBackgroundImage:[UIImage imageNamed:@"APP_主页_扫码_N.png"] forState:UIControlStateNormal];
//            [button setBackgroundImage:[UIImage imageNamed:@"APP_主页_扫码_P.png"] forState:UIControlStateHighlighted];
            [button setTitle:L(@"Share") forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showRight) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, 40, 25);
            button;
        })];
        barButton;//APP_登录确定1_返回.png
    })];
    
}
-(void)showLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showRight{
//    ShareChooseViewController* viewController = [[ShareChooseViewController alloc] init];
//    viewController.text = [NSString stringWithFormat:@"%@%@",L(@"ShareText"),[NSString stringWithFormat:@"http://www.ifengstar.com/jump/jump.jsp?project=%@",APPTYPE]];
//    [self.navigationController presentSemiViewController:viewController withOptions:@{ KNSemiModalOptionKeys.pushParentBack:@(NO), KNSemiModalOptionKeys.animationDuration:@(0.35f), KNSemiModalOptionKeys.shadowOpacity:@(0.0f),}];
    
    
    [_shareView removeFromSuperview];
    _shareView = nil;
    NSDictionary *dict = @{@"shareUrl":[NSString stringWithFormat:@"http://www.ifengstar.com/jump/jump.jsp?project=%@",APPTYPE],@"shareText":L(@"Click to download the phoenix zhilian APP"),@"shareTitle":L(@"FHZL"),@"shareImageUrl":IconImageUrl};
    _shareView = [ShareView getFactoryShareViewWithCsqDiction:dict];
    [_shareView showInView:self.view];
    [_shareView showWithContentType:JSHARELink];
}

#pragma mark --- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//   if (indexPath.row == 0) {
//    NSString *identifier = @"AboutUsItemCell";
//    AboutUsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil)
//    {
//        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"AboutUsItemCell" owner:nil options:nil];
//        cell = [cells objectAtIndex:0];
//    }
//    cell.titleLabel.text = @"语音功能提供商";
//    cell.valueLabel.text = @"科大讯飞";
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//   }
//   else{
       static NSString *identifier2 = @"ScanCodeTableViewCell";
       ScanCodeTableViewCell *cell = [tableView    dequeueReusableCellWithIdentifier:identifier2];
       cell.ScanImageView.image = [UIImage imageNamed:@"1517211756.png"];
       return cell;
//   }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        return 61;
//
//    }else{
        return 220;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.section == 0)
//    {
//        if (indexPath.row == 0)
//        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WEBSITE]]; //调用浏览器打开网址
//        }
//        else if (indexPath.row == 1)
//        {
//            NSMutableString *strPhone = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", SERVICE_PHONE];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];
//        }
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
