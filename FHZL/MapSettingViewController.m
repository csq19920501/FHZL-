/*
 ============================================================================
 Name        : MapSettingViewController.m
 Version     : 1.0.0
 Copyright   : 
 Description : 设置地图界面
 ============================================================================
 */

#import "MapSettingViewController.h"
#import "MapSettingItemCell.h"
#import "AppData.h"
#import "LocalizedStringTool.h"
#import "Header.h"

@interface MapSettingViewController ()
{
    IBOutlet UITableView *_tabelView;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

@end

@implementation MapSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topConstant.constant = kTopHeight;
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setNavi];
}


-(void)setNavi{
    self.view.backgroundColor = HBackColor;
    self.title = L(@"Map Settings");
    
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
#pragma mark --- UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MapSettingItemCell";
    MapSettingItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"MapSettingItemCell" owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    
    if (indexPath.row == 0) //苹果地图
    {
        cell.iconImageView.image = [UIImage imageNamed:@"APP_个人中心_地图设置_10.png"];
        cell.titleLabel.text = L(@"Apple map");
        cell.downloadButton.hidden = YES;
        cell.checkButton.hidden = NO;
        [cell.checkButton addTarget:self action:@selector(setAppleMap) forControlEvents:UIControlEventTouchUpInside];
        
        if ([AppData useMapType] == 3)
        {
            cell.checkButton.selected = YES;
        }
        else
        {
            cell.checkButton.selected = NO;
        }
    }
    if (indexPath.row == 1) //百度地图
    {
        cell.iconImageView.image = [UIImage imageNamed:@"ic_launcher_promote.png"];
        cell.titleLabel.text = L(@"Baidu map");
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
        {
            cell.downloadButton.hidden = YES;
            cell.checkButton.hidden = NO;
            [cell.checkButton addTarget:self action:@selector(setBaiduMap) forControlEvents:UIControlEventTouchUpInside];
            
            if ([AppData useMapType] == 1)
            {
                cell.checkButton.selected = YES;
            }
            else
            {
                cell.checkButton.selected = NO;
            }
        }
        else
        {
            cell.downloadButton.hidden = NO;
            cell.checkButton.hidden = YES;
            [cell.downloadButton addTarget:self action:@selector(downloadBaiduMap) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if(indexPath.row == 2) //高德地图
    {
        cell.iconImageView.image = [UIImage imageNamed:@"ic_notification.png"];
        cell.titleLabel.text = L(@"Scott map");
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
        {
            cell.downloadButton.hidden = YES;
            cell.checkButton.hidden = NO;
            [cell.checkButton addTarget:self action:@selector(setGaodeMap) forControlEvents:UIControlEventTouchUpInside];
            
            if ([AppData useMapType] == 2)
            {
                cell.checkButton.selected = YES;
            }
            else
            {
                cell.checkButton.selected = NO;
            }
        }
        else
        {
            cell.downloadButton.hidden = NO;
            cell.checkButton.hidden = YES;
            [cell.downloadButton addTarget:self action:@selector(downloadGaodeMap) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if(indexPath.row == 3) //百度导航
    {
        cell.iconImageView.image = [UIImage imageNamed:@"ic_notification.png"];
        cell.titleLabel.text = L(@"Baidu navigation");
        [cell.checkButton addTarget:self action:@selector(setBaiduNav) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"bdnavi://"]])
        {
            cell.downloadButton.hidden = YES;
            cell.checkButton.hidden = NO;
            
            if ([AppData useMapType] == 4)
            {
                cell.checkButton.selected = YES;
            }
            else
            {
                cell.checkButton.selected = NO;
            }
        }
        else
        {
            cell.downloadButton.hidden = NO;
            cell.checkButton.hidden = YES;
            [cell.downloadButton addTarget:self action:@selector(downloadBaiduNav) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //不显示空白处分割线
    UIView *footView = [[UIView alloc] init];
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//设置苹果地图
- (void)setAppleMap
{
    [AppData setUseMapType:3];
    
    [_tabelView reloadData];
}

//设置百度地图
- (void)setBaiduMap
{
    [AppData setUseMapType:1];
    
    [_tabelView reloadData];
}

//下载百度地图
- (void)downloadBaiduMap
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id452186370"]];
}

//设置高德地图
- (void)setGaodeMap
{
    [AppData setUseMapType:2];
    
    [_tabelView reloadData];
}

//下载高德地图
- (void)downloadGaodeMap
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id461703208"]];
}

//设置百度导航
- (void)setBaiduNav
{
    [AppData setUseMapType:4];
    
    [_tabelView reloadData];
}

//下载百度导航
- (void)downloadBaiduNav
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id645400210"]];
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
