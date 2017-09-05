//
//  HttpManager.m
//  Zhcx
//
//  Created by siasun on 17/6/21.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "HttpManager.h"
#import "NSString+Utils.h"
#import "NSData+Addition.h"
#import "NSDate+Addition.h"
#import "NSDictionary+Addition.h"
#import "PBOCDES.h"
#import "LocalSaveManager.h"
#import "AppDelegate.h"
#import "NotifyConstant.h"
#import "LoginTableViewController.h"
#import <AFNetworking.h>
#define PBOC3DES_ENCRYPTKEY @"584A109602F07C749F717232256CDF0A"

static NSString *const BaseURL = @"http://221.180.150.174/zhcx/";

@interface HttpManager ()

@property(nonatomic, strong) AFHTTPSessionManager *manager;

@end


@implementation HttpManager

+ (instancetype)sharedInstance
{
    static HttpManager *httpManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpManager = [[self alloc] init];
    });
    
    return httpManager;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.manager.requestSerializer setHTTPMethodsEncodingParametersInURI:[NSSet setWithObjects:@"GET", @"HEAD", nil]];
        [self.manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        
        NSArray *responseSerializers = @[
                                         [AFJSONResponseSerializer serializer],
                                         [AFHTTPResponseSerializer serializer]
                                         ];
        AFCompoundResponseSerializer *compoundResponseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:responseSerializers];
        self.manager.responseSerializer = compoundResponseSerializer;
    }
    
    return self;
}

#pragma mark - 工具方法
#pragma mark -
#pragma mark 构建请求参数
/**
 构建http请求字符串参数
 
 //di   终端唯一码（Android为IMEI）
 //tk   token
 //dt   客户端时间戳，格式为yyyyMMddhhmmss
 //sig  req_data明文的MD5签名
 //et   加密方式（ 1=MD5(di+ "zhcx")作为密钥pboc3des加密
                 2=MD5(tk+"zhcx")作为密钥pboc3des加密 ）
 //rd   req_data 请求数据加密后的Base64
 
 @param parameter parameter
 @return string
 */
+ (NSString *)requestStringWithParameter:(NSDictionary *)parameter
{
    //rd加密秘钥
    NSString *key;
    
    if ([[LocalSaveManager sharedInstance] getToken]) {
        key = [[NSString stringWithFormat:@"%@zhcx",[[LocalSaveManager sharedInstance] getToken]] md5];
    } else {
        key = [[NSString stringWithFormat:@"%@zhcx",[NSString uniqueUUID]] md5];
    }
    
    //加密后的请求参数
    NSString *encriptRd = [NSString stringWithUTF8String:PBOCDES::PBOC3DESEncryptForLong([key UTF8String],[[parameter dictionaryToString] UTF8String]).c_str()];
    
    //构建整个body字典
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[NSString uniqueUUID] forKey:@"di"];
    if ([[LocalSaveManager sharedInstance] getToken]) {
        [dict setObject:[[LocalSaveManager sharedInstance] getToken] forKey:@"tk"];
    }
    [dict setObject:[NSDate currentDateString] forKey:@"dt"];
    [dict setObject:[[parameter dictionaryToString] md5] forKey:@"sig"];
    if ([[LocalSaveManager sharedInstance] getToken]) {
        [dict setObject:@"2" forKey:@"et"];
    } else {
        [dict setObject:@"1" forKey:@"et"];
    }
    
    [dict setObject:[[encriptRd hexStringToData] base64EncodedStringWithOptions:0] forKey:@"rd"];
    
    //将body字典转为string
    NSString *message = [dict dictionaryToString];
    
    NSString *pboc3desString = [NSString stringWithUTF8String:PBOCDES::PBOC3DESEncryptForLong([PBOC3DES_ENCRYPTKEY UTF8String],[message UTF8String]).c_str()];
    NSString *md5String = [message md5];
    
    NSString *mergeString = [NSString stringWithFormat:@"%@%@",pboc3desString,md5String];
    
    NSData *parseData = [mergeString hexStringToData];
    
    NSString *requestString = [parseData base64EncodedStringWithOptions:0];
    
    return requestString;
}

#pragma mark 解析返回数据
/**
 解析返回数据
 
 @param data data
 @return dictionary
 */
+ (HttpResponseObject *)responseDictionaryWithNSData:(NSData *)data
{
    HttpResponseObject *httpResponseObject = [HttpResponseObject new];
    
    //得到base64编码的string
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //将base64编码的string解码成data
    NSData *dataFromBase64String = [[NSData alloc]
        initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    //截取data的0 ~ length-16位准备解析成明文
    NSData *dataForPlaintText = [dataFromBase64String subdataWithRange:NSMakeRange(0, dataFromBase64String.length-16)];
    
    //将data的0 ~ length-16位dataToHexString后，解密成明文
    NSString *plainText = [NSString stringWithUTF8String:PBOCDES::PBOC3DESDecryptForLong([PBOC3DES_ENCRYPTKEY UTF8String], [[dataForPlaintText dataToHexString] UTF8String]).c_str()];
    
    //将明文部分md5
    NSString *plainTextMD5 = [plainText md5];
    
    //将data的后16位dataToHexString
    NSString *dataLast16ToHexString = [[dataFromBase64String subdataWithRange:NSMakeRange(dataFromBase64String.length-16, 16)] dataToHexString];
    
    //忽略大小写比较plaintTextMD5和dataLast16ToHexString
    if ([plainTextMD5 compare:dataLast16ToHexString options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        
    }
    
    //将明文转化为字典(rd部分还未解密)
    NSDictionary *plainDictionary = [NSDictionary dictionaryFromString:plainText];
    
    //还未解密的rd
    NSString *rdString = plainDictionary[@"rd"];
    
    //将base64编码的string解码成data,NSDataBase64DecodingIgnoreUnknownCharacters能去掉编码中的换行
    NSData *rdData = [[NSData alloc] initWithBase64EncodedString:rdString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    //rd解密秘钥
    NSString *key;
    if ([[LocalSaveManager sharedInstance] getToken]) {
        key = [[NSString stringWithFormat:@"%@zhcx",[[LocalSaveManager sharedInstance] getToken]] md5];
    } else {
        key = [[NSString stringWithFormat:@"%@zhcx",[NSString uniqueUUID]] md5];
    }
    [[NSString stringWithFormat:@"%@zhcx",[NSString uniqueUUID]] md5];
    
    //解密后的rdString
    NSString *decryptRdString = [NSString stringWithUTF8String:PBOCDES::PBOC3DESDecryptForLong([key UTF8String],[[rdData dataToHexString] UTF8String]).c_str()];
    
    //将解密后的rdString转化为字典
    NSDictionary *decryptRdDictionary = [NSDictionary dictionaryFromString:decryptRdString];
    
    [httpResponseObject setBody:plainDictionary];
    [httpResponseObject setResponseData:decryptRdDictionary];
    
    return httpResponseObject;
}

#pragma mark 构建请求request
+ (NSMutableURLRequest *)requestWithMethod:(NSString *)method url:(NSString *)url body:(NSData *)data
{
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:url parameters:nil error:nil];
    
    request.timeoutInterval = 5;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:data];
    
    return request;
}

#pragma mark 请求方法 dataTaskMethod
- (void)dataTaskWithMethod:(NSString *)method url:(NSString *)url parameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    if (!method) method = @"POST";
    
    NSData *postData = [[HttpManager requestStringWithParameter:parameter] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [HttpManager requestWithMethod:method url:url body:postData];
    
    [[self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failureBlock) {
                failureBlock(error);
            }
        } else {
            if (successBlock) {
                HttpResponseObject *httpResponseObject = [HttpManager responseDictionaryWithNSData:responseObject];
                if (httpResponseObject.responseData) {
                    successBlock(httpResponseObject);
                } else {
                    if (failureBlock) {
                        failureBlock(error);
                    }
                    
                    UIViewController *rootViewController = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:httpResponseObject.msg preferredStyle:UIAlertControllerStyleAlert];
                    //如果token过期，删除本地token，跳转到登录界面
                    if ([httpResponseObject.cd isEqualToString:@"E101"]||
                        [httpResponseObject.cd isEqualToString:@"E102"]) {
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [[LocalSaveManager sharedInstance] removeToken];
                            [[LocalSaveManager sharedInstance] removePhone];
                            [[NSNotificationCenter defaultCenter] postNotificationName:ZRefreshMineVCNotification object:nil];
                            
                            [((UITabBarController *)rootViewController) setSelectedIndex:4];
                            UINavigationController *nav =[((UITabBarController *)rootViewController) viewControllers][4];
                            [nav popToRootViewControllerAnimated:NO];
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            LoginTableViewController *loginTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginTableViewController"];
                            [nav pushViewController:loginTableViewController animated:YES];
                        }];
                        [alertController addAction:action];
                    } else {
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:action];
                    }
                    [rootViewController presentViewController:alertController animated:YES completion:nil];
                }
            }
        }
    }] resume];
}

#pragma mark - APIs
- (void)loginWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSMutableDictionary *mParameter = [parameter platformDictionary];
    [mParameter setObject:[NSString uniqueUUID] forKey:@"dev_id"];
    [mParameter setObject:[NSString deviceString] forKey:@"dev_info"];
    [mParameter setObject:[NSString appVersion] forKey:@"app_version"];
    
    NSString *url = [BaseURL stringByAppendingString:@"login"];
    [self dataTaskWithMethod:@"POST" url:url parameter:mParameter success:successBlock failure:failureBlock];
}

- (void)sendSMSCodeWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSMutableDictionary *mParameter = [parameter platformDictionary];
    
    NSString *url = [BaseURL stringByAppendingString:@"send_sms"];
    [self dataTaskWithMethod:@"POST" url:url parameter:mParameter success:successBlock failure:failureBlock];
}

- (void)registWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSMutableDictionary *mParameter = [parameter platformDictionary];
    
    NSString *url = [BaseURL stringByAppendingString:@"register"];
    [self dataTaskWithMethod:@"POST" url:url parameter:mParameter success:successBlock failure:failureBlock];
}

- (void)logoutWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSMutableDictionary *mParameter = [parameter platformDictionary];
    [mParameter setObject:[[LocalSaveManager sharedInstance] getToken] forKey:@"token"];
    
    NSString *url = [BaseURL stringByAppendingString:@"logout"];
    [self dataTaskWithMethod:@"POST" url:url parameter:mParameter success:successBlock failure:failureBlock];
}

//需要token
- (void)modifyPasswordWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSMutableDictionary *mParameter = [parameter platformDictionary];
    [mParameter setObject:[[LocalSaveManager sharedInstance] getToken] forKey:@"token"];
    
    NSString *url = [BaseURL stringByAppendingString:@"change_pw"];
    [self dataTaskWithMethod:@"POST" url:url parameter:mParameter success:successBlock failure:failureBlock];
}

- (void)verifyPhoneWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSMutableDictionary *mParameter = [parameter platformDictionary];
    
    NSString *url = [BaseURL stringByAppendingString:@"vf_account"];
    [self dataTaskWithMethod:@"POST" url:url parameter:mParameter success:successBlock failure:failureBlock];
}

- (void)resetPasswordWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSMutableDictionary *mParameter = [parameter platformDictionary];
    
    NSString *url = [BaseURL stringByAppendingString:@"reset_pw"];
    [self dataTaskWithMethod:@"POST" url:url parameter:mParameter success:successBlock failure:failureBlock];
}

- (void)queryCityWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSMutableDictionary *mParameter = [parameter platformDictionary];
    
    NSString *url = [BaseURL stringByAppendingString:@"query_cities"];
    [self dataTaskWithMethod:@"POST" url:url parameter:mParameter success:successBlock failure:failureBlock];
}

- (void)queryFavoriteWithParameter:(NSDictionary *)parameter success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSMutableDictionary *mParameter = [parameter mutableCopy];
    [mParameter setObject:@"0240" forKey:@"cityid"];
    [mParameter setObject:[[LocalSaveManager sharedInstance] getToken] forKey:@"token"];
    
    NSString *url = [BaseURL stringByAppendingString:@"fav_list"];
    
    [self.manager POST:url parameters:mParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {            
            failureBlock(error);
        }
    }];
}

@end
