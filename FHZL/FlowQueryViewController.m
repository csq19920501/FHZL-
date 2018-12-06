//
//  FlowQueryViewController.m
//  WeiZhong_ios
//
//  Created by haoke on 17/4/6.
//
//

#import "FlowQueryViewController.h"
#import "Header.h"
#define NAVCOLOR [UIColor colorWithRed:21/255. green:22/255. blue:24/255. alpha:1]

#define flowURL1 @"http://open.m-m10010.com/Html/Terminal/simcard_lt_new.aspx?userId=0&simNo=1064889414711&num=%@&num_type=iccid&simId=3697318&apptype=null&wechatId=null&mchId=&accessname=null&fromapp=h5"
#define flowURL2 @"http://open.m-m10010.com/Html/Terminal/searchsims.aspx?fromapp=h5&num=&num_type=iccid&onlyRealName=false"
#define flowURL3 @"http://open.m-m10010.com/Html/Terminal/searchsims.aspx?fromapp=h5&num=%@&num_type=iccid&onlyRealName=false"

@interface FlowQueryViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation FlowQueryViewController

static FlowQueryViewController *instance;

/*单例*/
+ (FlowQueryViewController *)shareInstance
{
    if (instance == nil)
    {
        instance = [[FlowQueryViewController alloc] init];
    }
    return instance;
}

+ (void)destroyInstance
{
    if (instance != nil)
    {
        instance = nil;
    }
}

-(UIWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREENWIDTH, SCREENHEIGHT - kTopHeight)];
    }
    return _webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavi];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREENWIDTH, SCREENHEIGHT - kTopHeight)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    NSURL *url = nil;
    if (kStringIsEmpty(_macIdStr)) {
        url = [NSURL URLWithString:flowURL2];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:flowURL3,_macIdStr]];
    }
    NSLog(@"url = %@",url);
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [UIUtil showProgressHUD:nil inView:self.view];
    [self.webView loadRequest:req];
    self.webView.scalesPageToFit = YES;
}

//设置导航栏
-(void)setNavi
{
    self.title = L(@"Flow recharge");
    self.view.backgroundColor = HBackColor;

    [self addNavigationItemWithTitles
     :@[L(@"back")] isLeft:NO target:self action:@selector(goBackButton) tags:@[@1000]];

}

-(void)showLeft
{
    [FlowQueryViewController destroyInstance];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goBackButton
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }else{
        [self showLeft];
    }
}

#pragma mark webDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (kStringIsEmpty(_macIdStr)) {
        [UIUtil showToast:L(@"The device does not have ICCID please enter manually") inView:self.view];
    }else{
        [UIUtil hideProgressHUD];
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

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

@end
