//
//  AESCipher.m
//  AESCipher
//
//  Created by Welkin Xie on 8/13/16.
//  Copyright © 2016 WelkinXie. All rights reserved.
//
//  https://github.com/WelkinXie/AESCipher-iOS
//

#import "AESCipher.h"
#import "NSData+Addition.h"
#import "NSString+Utils.h"
#import <CommonCrypto/CommonCryptor.h>

NSString const *kInitVector = @"A-16-Byte-String";
size_t const kKeySize = kCCKeySizeAES128;

NSData * cipherOperation(NSData *contentData, NSData *keyData, CCOperation operation) {
    NSUInteger dataLength = contentData.length;
    //ECB模式可以不填初始向量，这里不填纯粹是为和java保持统一
    void const *initVectorBytes = [kInitVector dataUsingEncoding:NSUTF8StringEncoding].bytes;
    void const *contentBytes = contentData.bytes;
    void const *keyBytes = keyData.bytes;
    
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    size_t actualOutSize = 0;
    
    //第三个字段只写kCCOptionPKCS7Padding代表CBC模式
    //写kCCOptionPKCS7Padding | kCCOptionECBMode代表ECB模式
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionECBMode|kCCOptionPKCS7Padding,
                                          keyBytes,
                                          kKeySize,
                                          NULL,
                                          contentBytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize];
    }
    free(operationBytes);
    return nil;
}

//使用dataToHexString和hexStringToData纯粹是为和java保持统一
NSString * aesEncryptString(NSString *content, NSString *key) {
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key hexStringToData];
    NSData *encrptedData = aesEncryptData(contentData, keyData);
    return [[encrptedData dataToHexString] uppercaseString];
//    return [encrptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

NSString * aesDecryptString(NSString *content, NSString *key) {
//    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *contentData = [content hexStringToData];
//    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key hexStringToData];
    NSData *decryptedData = aesDecryptData(contentData, keyData);
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

NSData * aesEncryptData(NSData *contentData, NSData *keyData) {
    NSString *hint = [NSString stringWithFormat:@"The key size of AES-%lu should be %lu bytes!", kKeySize * 8, kKeySize];
    NSCAssert(keyData.length == kKeySize, hint);
    return cipherOperation(contentData, keyData, kCCEncrypt);
}

NSData * aesDecryptData(NSData *contentData, NSData *keyData) {
    NSString *hint = [NSString stringWithFormat:@"The key size of AES-%lu should be %lu bytes!", kKeySize * 8, kKeySize];
    NSCAssert(keyData.length == kKeySize, hint);
    return cipherOperation(contentData, keyData, kCCDecrypt);
}
