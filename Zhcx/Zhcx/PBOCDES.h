//
//  PBOCDES.h
//  VCDemo
//
//  translated from PBOCDES.java
//  by zqc on 16/7/31.
//
//  Copyright (c) 2016年 TrueStudio. All rights reserved.
//

#ifndef __VCDemo__PBOCDES__
#define __VCDemo__PBOCDES__

#include <stdio.h>
#include <string>
#include <vector>

using namespace std;

typedef unsigned char                   byte;
typedef unsigned char                   UInt8;
#if __LP64__
typedef unsigned int                    UInt32;
#else
typedef unsigned long                   UInt32;
#endif
typedef vector<byte> ByteVector;
typedef long long                       Int64;
typedef vector<Int64> Int64Vector;
namespace PBOCDES
{

    // s 长度必须为偶数，vector长度为s.length/2
    void hexString2Bytes(string s, ByteVector &outByteVector);
    string bytes2HexString(ByteVector vector);
    
    
    string PBOC3DESEncryptForLong(string sesKey, string input);
    string PBOC3DESDecryptForLong(string sesKey, string input);
    
}

#endif /* defined(__VCDemo__PBOCDES__) */
