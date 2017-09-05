//
//  DiscoverViewController.m
//  Zhcx
//
//  Created by siasun on 17/6/12.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "DiscoverViewController.h"

@interface DiscoverViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://zhcx.eliaoning.net/zhcxh/discovery.html"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
    [self.webView loadRequest:request];
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
