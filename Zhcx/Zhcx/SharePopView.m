//
//  SharePopView.m
//  Zhcx
//
//  Created by siasun on 17/6/20.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "SharePopView.h"
#import "SharePopViewCell.h"
#import "ShareManager.h"
#import "ZViewConstant.h"
#import <Masonry.h>

static const NSInteger count = 2;
@interface SharePopView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIControl *control;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, weak) UIViewController *viewController;
@end

@implementation SharePopView

+ (instancetype)sharedInstance
{
    static SharePopView *sharePopView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePopView = [[self alloc] init];
    });
    
    return sharePopView;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageArray = @[[UIImage imageNamed:@"share_wechat_session"],
                            [UIImage imageNamed:@"share_wechat_timeline"],
                            [UIImage imageNamed:@"share_qq_session"],
                            [UIImage imageNamed:@"share_qq_zone"]];

        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
        [self.collectionView registerNib:[UINib nibWithNibName:@"SharePopViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:self.collectionView];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@80);
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
        
        self.control = [[UIControl alloc] init];
        [self.control addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.control];
        [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.left.equalTo(self.mas_left).offset(0);
            make.bottom.equalTo(self.collectionView.mas_top).offset(0);
        }];
        
    }
    
    return self;
}

- (void)showOnViewController:(UIViewController *)viewController
{
    self.viewController = viewController;
    
    [Z_Window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}

- (void)hide
{
    [self removeFromSuperview];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SharePopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.iconImageView.image = self.imageArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self hide];
    
    UMSocialPlatformType platform;
    switch (indexPath.row) {
        case 0:
        {
            platform = UMSocialPlatformType_WechatSession;
        }
            break;
        case 1:
        {
            platform = UMSocialPlatformType_WechatTimeLine;
        }
            break;
        case 2:
        {
            platform = UMSocialPlatformType_QQ;
        }
            break;
        case 3:
        {
            platform = UMSocialPlatformType_Qzone;
        }
            break;
        default:
            break;
    }
    
    
    UMSocialMessageObject *messageObject = [[UMSocialMessageObject alloc] init];
    
    UMShareObject *shareObject;
    
    if (self.shareType == ShareTypeWebPage) {
        UMShareWebpageObject *webPageShareObject = [UMShareWebpageObject shareObjectWithTitle:@"和生活车等我" descr:@"“和生活车等我”是由中国移动集团辽宁分公司建设及运营的一款城市公交、班车、校车和地铁便民出行综合应用，为公共交通出行用户提供优质的服务。" thumImage:[UIImage imageNamed:@"share_thumb_image"]];
        
        //设置网页地址
        webPageShareObject.webpageUrl = @"http://223.100.246.45/zhcx/";
        
        shareObject = webPageShareObject;
    } else if (self.shareType == ShareTypeImage) {
        UMShareImageObject *imageShareObject = [[UMShareImageObject alloc] init];
        imageShareObject.shareImage = [UIImage imageNamed:@"QRCode"];
        
        shareObject = imageShareObject;
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    [[ShareManager sharedInstance].socialManager shareToPlatform:platform messageObject:messageObject currentViewController:self.viewController completion:^(id result, NSError *error) {
        
    }];
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        CGFloat itemWidth = Z_ScreenWidth / count;
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = CGSizeMake(itemWidth, 50);
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
    }
    return _layout;
}
@end
