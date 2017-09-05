//
//  PackageViewController.m
//  Zhcx
//
//  Created by siasun on 17/6/12.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "PackageViewController.h"
#import <UIImageView+AFNetworking.h>
@interface PackageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation PackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *imageUrl = @"http://221.180.167.139/cdw/images/summary_image_20161103_143619_1478154979558.jpg";
    [self.imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    [self.button.layer setCornerRadius:8.0];
    [self.button.layer setMasksToBounds:YES];
}

- (IBAction)openCardPackage:(id)sender {
    NSURL *url = [NSURL URLWithString:@"EmptyCircleCallProtocol://"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"是否去下载我的卡包" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *downLoadAction = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/wo-de-ka-bao/id1113353958?mt=8"] options:@{} completionHandler:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:downLoadAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
