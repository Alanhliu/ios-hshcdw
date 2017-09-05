//
//  HomeViewController.m
//  Zhcx
//
//  Created by siasun on 17/6/9.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "HomeViewController.h"
#import "LocationTableViewController.h"
#import "ShareManager.h"
#import "SharePopView.h"
#import "NotifyConstant.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "JSHandler.h"
#import "HttpManager.h"
#import "NSObject+JSContextTracker.h"
#import "CityConstant.h"
#import "NSString+Utils.h"
#import "LocalSaveManager.h"
static NSString *const JSContextObject = @"jsHandler";

@interface HomeViewController ()<BMKLocationServiceDelegate,UIWebViewDelegate,UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareBarButtonItem;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) BMKUserLocation *userLocation;

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) JSHandler *jsHandler;

@property (nonatomic, assign) NSInteger count;

@end

@implementation HomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 1;
    self.jsHandler = [JSHandler new];
    
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.delegate = self;
    
    self.locationService = [[BMKLocationService alloc] init];
    self.locationService.delegate = self;
    self.locationService.distanceFilter = 10;
    [self.locationService startUserLocationService];
    
    self.tabBarController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWebView) name:ZRefreshHomeVCNotification object:nil];
    
    NSString *city_code = [[NSUserDefaults standardUserDefaults] objectForKey:CITY_CODE];
    NSString *city_url = [[NSUserDefaults standardUserDefaults] objectForKey:CITY_URL];
    
    if (city_code) {
        NSString *url = [NSString stringWithFormat:@"%@?cid=%@&chd=%@&di=%@&pn=%@",city_url,city_code,GRD,[NSString uniqueUUID],[[LocalSaveManager sharedInstance] getPhone]];
        
        self.locationBarButtonItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:CITY_NAME];
        self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];
    } else {
        [self locationBarButtonItemAction:self];
        return;
    }

    
    [self.webView loadRequest:self.request];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createJSContext:) name:JSContextTrackerNotifycation object:nil];
}

-(void)createJSContext:(NSNotification*)noti
{
    //注意以下代码如果不在主线程调用会发生闪退。
    dispatch_async( dispatch_get_main_queue(), ^{
    
        self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        self.jsContext[JSContextObject] = self.jsHandler;
        
        self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
            context.exception = exceptionValue;
            NSLog(@"异常信息：%@", exceptionValue);
        };
    });
}

- (void)refreshWebView
{
    self.locationBarButtonItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:CITY_NAME];
    
    NSString *city_code = [[NSUserDefaults standardUserDefaults] objectForKey:CITY_CODE];
    NSString *city_url = [[NSUserDefaults standardUserDefaults] objectForKey:CITY_URL];

    NSString *url = [NSString stringWithFormat:@"%@?cid=%@&chd=%@&di=%@&pn=%@",city_url,city_code,GRD,[NSString uniqueUUID],[[LocalSaveManager sharedInstance] getPhone]];
    self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];
    [self.webView loadRequest:self.request];
}

- (IBAction)locationBarButtonItemAction:(id)sender {
    LocationTableViewController *locationTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationTableViewController"];
    [self.navigationController pushViewController:locationTableViewController animated:YES];
}

- (IBAction)shareBarButtonItemAction:(id)sender {
    [[SharePopView sharedInstance] showOnViewController:self];
    [SharePopView sharedInstance].shareType = ShareTypeWebPage;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = (UINavigationController *)viewController;
    
    if ([nav.topViewController isKindOfClass:HomeViewController.class]) {
        self.count++;
        if (self.count > 1) {//当重复点击时刷新
            [self.webView loadRequest:self.request];
            [self.webView reload];
        }
    } else {
        self.count = 0;
    }
}

#pragma mark - webView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *jsString = [NSString stringWithFormat:@"show_nearby_stations(%f,%f)",self.userLocation.location.coordinate.longitude,self.userLocation.location.coordinate.latitude];
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

#pragma mark - BMKLocationServiceDelegate
//万一定位成功之后，webView还没有didLoad完，没加载js文件不识别show_nearby_stations，怎么办?
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.userLocation = userLocation;
    NSString *jsString = [NSString stringWithFormat:@"show_nearby_stations(%f,%f)",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude];
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
