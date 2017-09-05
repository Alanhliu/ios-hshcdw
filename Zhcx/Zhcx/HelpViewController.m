//
//  HelpViewController.m
//  Zhcx
//
//  Created by siasun on 17/6/28.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "HelpViewController.h"
#import "SharePopView.h"
@interface HelpViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareItem;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.shareItem;
}

- (IBAction)share:(id)sender {
    [[SharePopView sharedInstance] showOnViewController:self];
    [SharePopView sharedInstance].shareType = ShareTypeImage;
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
