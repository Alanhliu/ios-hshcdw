//
//  PBOCDES.cpp
//  VCDemo
//
//  Created by zqc on 16/7/31.
//  Copyright (c) 2016年 TrueStudio. All rights reserved.
//

#include "PBOCDES.h"

namespace PBOCDES {
    
    const char __syms[] = "0123456789ABCDEF";
    
    byte rotations[16] = {
        1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1
    };
    
    byte PC1[56] = {
        57, 49, 41, 33, 25, 17, 9,
        1, 58, 50, 42, 34, 26, 18,
        10, 2, 59, 51, 43, 35, 27,
        19, 11, 3, 60, 52, 44, 36,
        63, 55, 47, 39, 31, 23, 15,
        7, 62, 54, 46, 38, 30, 22,
        14, 6, 61, 53, 45, 37, 29,
        21, 13, 5, 28, 20, 12, 4
    };
    
    byte PC2[48] = {
        14, 17, 11, 24, 1, 5,
        3, 28, 15, 6, 21, 10,
        23, 19, 12, 4, 26, 8,
        16, 7, 27, 20, 13, 2,
        41, 52, 31, 37, 47, 55,
        30, 40, 51, 45, 33, 48,
        44, 49, 39, 56, 34, 53,
        46, 42, 50, 36, 29, 32
    };
    
    byte IP[64] = {
        58, 50, 42, 34, 26, 18, 10, 2,
        60, 52, 44, 36, 28, 20, 12, 4,
        62, 54, 46, 38, 30, 22, 14, 6,
        64, 56, 48, 40, 32, 24, 16, 8,
        57, 49, 41, 33, 25, 17, 9, 1,
        59, 51, 43, 35, 27, 19, 11, 3,
        61, 53, 45, 37, 29, 21, 13, 5,
        63, 55, 47, 39, 31, 23, 15, 7
    };
    
    byte E[48] = {
        32, 1, 2, 3, 4, 5,
        4, 5, 6, 7, 8, 9,
        8, 9, 10, 11, 12, 13,
        12, 13, 14, 15, 16, 17,
        16, 17, 18, 19, 20, 21,
        20, 21, 22, 23, 24, 25,
        24, 25, 26, 27, 28, 29,
        28, 29, 30, 31, 32, 1
    };
    
    byte P[32] = {
        16, 7, 20, 21,
        29, 12, 28, 17,
        1, 15, 23, 26,
        5, 18, 31, 10,
        2, 8, 24, 14,
        32, 27, 3, 9,
        19, 13, 30, 6,
        22, 11, 4, 25
    };
    
    byte FP[] = {
        40, 8, 48, 16, 56, 24, 64, 32,
        39, 7, 47, 15, 55, 23, 63, 31,
        38, 6, 46, 14, 54, 22, 62, 30,
        37, 5, 45, 13, 53, 21, 61, 29,
        36, 4, 44, 12, 52, 20, 60, 28,
        35, 3, 43, 11, 51, 19, 59, 27,
        34, 2, 42, 10, 50, 18, 58, 26,
        33, 1, 41, 9, 49, 17, 57, 25
    };

    
    byte S[8][64] = {{
        14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7,
        0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8,
        4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0,
        15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13
    }, {
        15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10,
        3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5,
        0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15,
        13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9
    }, {
        10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8,
        13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1,
        13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7,
        1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12
    }, {
        7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15,
        13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9,
        10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4,
        3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14
    }, {
        2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9,
        14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6,
        4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14,
        11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3
    }, {
        12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11,
        10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8,
        9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6,
        4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13
    }, {
        4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1,
        13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6,
        1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2,
        6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12
    }, {
        13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7,
        1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2,
        7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8,
        2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11
    }};

    
    int charToNibble(char c) {
        if (c >= '0' && c <= '9') {
            return (c - '0');
        } else if (c >= 'a' && c <= 'f') {
            return (10 + c - 'a');
        } else if (c >= 'A' && c <= 'F') {
            return (10 + c - 'A');
        } else {
            return 0;
        }
    }
    
    Int64 permute(byte table[], int tableLength, int srcWidth, Int64 src) {
        Int64 dst = 0;
        for (int i = 0; i < tableLength; i++) {
            int srcPos = srcWidth - table[i];
            dst = (dst << 1) | (src >> srcPos & 0x01);
        }
        return dst;
    }
    
    Int64 getPC1(Int64 src) {
        return permute(PC1, 56, 64, src);
    } // 56-bit output
    
    Int64 getPC2(Int64 src) {
        return permute(PC2, 48, 56, src);
    } // 48-bit output
    
    Int64 getIP(Int64 src) {
        return permute(IP, 64, 64, src);
    } // 64-bit output
    
    Int64 getE(int src) {
        return permute(E, 48, 32, src & 0xFFFFFFFFLL);
    } // 48-bit output
    
    byte getS(int boxNumber, byte src) {
        // The first aindex based on the following bit shuffle:
        // abcdef => afbcde
        src = (byte) ((src & 0x20) | ((src & 0x01) << 4) | ((src & 0x1E) >> 1));
        return S[boxNumber - 1][src];
    }
    
    Int64 getFP(Int64 src) {
        return permute(FP, 64, 64, src);
    } // 64-bit output
    
    int getP(int src) {
        return (int) permute(P, 32, 32, src & 0xFFFFFFFFLL);
    } // 32-bit output
    
    int feistel(int r, /* 48 bits */ Int64 subkey) {
        // 1. expansion
        Int64 e = getE(r);
        // 2. key mixing
        Int64 x = e ^ subkey;
        // 3. substitution
        unsigned int dst = 0;
        for (int i = 0; i < 8; i++) {
            dst >>= 4;
            int s = getS(8 - i, (byte) (x & 0x3F));
            dst |= s << 28;
            x >>= 6;
        }
        // 4. permutation
        return getP(dst);
    }
    
    // outSubkey length must be 16
    void createSubkeys(Int64 key, Int64Vector &outSubkey) {
        // perform the PC1 permutation
        key = getPC1(key);
        
        // split into 28-bit left and right (c and d) pairs.
        int c = (int) (key >> 28);
        int d = (int) (key & 0x0FFFFFFF);
        
        // for each of the 16 needed subkeys, perform a bit
        // rotation on each 28-bit keystuff half, then join
        // the halves together and permute to generate the
        // subkey.
        for (int i = 0; i < 16; i++) {
            // rotate the 28-bit values
            if (rotations[i] == 1) {
                // rotate by 1 bit
                c = ((c << 1) & 0x0FFFFFFF) | (c >> 27);
                d = ((d << 1) & 0x0FFFFFFF) | (d >> 27);
            } else {
                // rotate by 2 bits
                c = ((c << 2) & 0x0FFFFFFF) | (c >> 26);
                d = ((d << 2) & 0x0FFFFFFF) | (d >> 26);
            }
            
            // join the two keystuff halves together.
            Int64 cd = (c & 0xFFFFFFFFLL) << 28 | (d & 0xFFFFFFFFLL);
            
            // perform the PC2 permutation
            outSubkey[i] = getPC2(cd);
        }
    }
    
    Int64 encryptBlock(Int64 m, /* long[16] */ Int64Vector subkeys)
    {
        // perform the initial permutation
        Int64 ip = getIP(m);
        
        // split the 32-bit value into 16-bit left and right halves.
        int l = (int) (ip >> 32);
        int r = (int) (ip & 0xFFFFFFFFLL);
        
        // perform 16 rounds
        for (int i = 0; i < 16; i++) {
            int previous_l = l;
            // the right half becomes the new left half.
            l = r;
            // the Feistel function is applied to the old left half
            // and the resulting value is stored in the right half.
            r = previous_l ^ feistel(r, subkeys[i]);
        }
        
        // reverse the two 32-bit segments (left to right; right to left)
        Int64 rl = (r & 0xFFFFFFFFLL) << 32 | (l & 0xFFFFFFFFLL);
        
        // apply the final permutation
        Int64 fp = getFP(rl);
        
        // return the ciphertext
        return fp;
    }
    
    Int64 decryptBlock(Int64 c, /* long[16] */ Int64Vector subkeys) {
        
        // perform the initial permutation
        Int64 ip = getIP(c);
        
        // split the 32-bit value into 16-bit left and right halves.
        int l = (int) (ip >> 32);
        int r = (int) (ip & 0xFFFFFFFFLL);
        
        // perform 16 rounds
        // NOTE: reverse order of subkeys used!
        for (int i = 15; i > -1; i--) {
            int previous_l = l;
            // the right half becomes the new left half.
            l = r;
            // the Feistel function is applied to the old left half
            // and the resulting value is stored in the right half.
            r = previous_l ^ feistel(r, subkeys[i]);
        }
        
        // reverse the two 32-bit segments (left to right; right to left)
        Int64 rl = (r & 0xFFFFFFFFLL) << 32 | (l & 0xFFFFFFFFLL);
        
        // apply the final permutation
        Int64 fp = getFP(rl);
        
        // return the message
        return fp;
        
    }
    
    Int64 des_ede(Int64Vector skL,Int64Vector skR,Int64 m,bool enc)
    {
        Int64 c=0;
        if(enc)
        {
            c=encryptBlock(m,skL);
            c=decryptBlock(c,skR);
            c=encryptBlock(c,skL);
            return c;
        }
        else
        {
            c=decryptBlock(m,skL);
            c=encryptBlock(c,skR);
            c=decryptBlock(c,skL);
            return c;
        }
    }

    
    int padding_ISO9796M2(ByteVector& src)
    {
        src.push_back(0x80);
        byte pad_count=src.size()%8;
        if(pad_count) src.resize(src.size()+(8-pad_count),0);
        return (int)src.size();
    }
    
    void padding_ISO9796M2Long(ByteVector& bv_input){
        unsigned long input_len = bv_input.size();
        bv_input.insert(bv_input.begin(), (byte)(input_len&0xFF));
        bv_input.insert(bv_input.begin(), (byte)(((input_len>>8)&0xFF)));
        padding_ISO9796M2(bv_input);
    }
    
    Int64 getLongFromBytes(ByteVector ba, int offset) {
        Int64 l = 0;
        for (int i = 0; i < 8; i++) {
            byte value;
            if ((offset + i) < ba.size()) {
                // and last bits determine which 16-value row to
                // reference, so we transform the 6-bit input into an
                // absolute
                value = ba[offset + i];
            } else {
                value = 0;
            }
            l = l << 8 | (value & 0xFFLL);
        }
        return l;
    }
    
    void getBytesFromLong(ByteVector &ba, int offset, Int64 l) {
        for (int i = 7; i > -1; i--) {
            if ((offset + i) < ba.size()) {
                ba[offset + i] = (byte) (l & 0xFF);
                l = l >> 8;
            } else {
                break;
            }
        }
    }
    
    void hexString2Bytes(string s, ByteVector &outByteVector){
        for (int i = 0; i < s.length(); i += 2) {
            outByteVector[i / 2] = (byte) (charToNibble(s[i]) << 4 | charToNibble(s[i + 1]));
        }
    }
    
    string bytes2HexString(ByteVector vector)
    {
        unsigned long s_in_len = vector.size();
        if(s_in_len == 0){
            return "";
        }
        std::string result;
        result.reserve(s_in_len*2+1);
        
        for (unsigned int it = 0; it < s_in_len; it++)
        {
            result += __syms[((vector[it] >> 4) & 0xf)];
            result += __syms[vector[it] & 0xf];
        }
        return result;
        
    }
    
    void pboc3DESEncryptForLongWithByte(ByteVector key16, ByteVector &input, ByteVector &output, bool appLD, bool pad)
    {
        if(pad)
        {
            padding_ISO9796M2Long(input);
        }
//        else
//        {
//            if((input.length%8)!=0)
//                return null;// arg invalid.
//            pinput=input;
//            
//        }
//        byte[] output=new byte[pinput.length];
//        ByteVector output(input.size());
        output.resize(input.size());
        Int64 kL=getLongFromBytes(key16,0);
        Int64 kR=getLongFromBytes(key16,8);
        Int64Vector skL(16);
        createSubkeys(kL, skL);
        Int64Vector skR(16);
        createSubkeys(kR, skR);
        
        Int64 m=0;
        Int64 c=0;
        
        for(int i=0;i<input.size();i+=8)
        {
            m=getLongFromBytes(input,i);
            c=des_ede(skL,skR,m,true);
            getBytesFromLong(output,i,c);
        }
    }
    
    string PBOC3DESEncryptForLong(string sesKey, string input){
        ByteVector keyByte(sesKey.length() / 2,0);
        hexString2Bytes(sesKey, keyByte);
        ByteVector outputByte(input.size());
        
        ByteVector inputBytes(input.begin(), input.end());
//        inputBytes.push_back('\0');

        pboc3DESEncryptForLongWithByte(keyByte, inputBytes, outputByte, true, true);
        
        return bytes2HexString(outputByte);
        
    }
    
    void pboc3DESDecrypt(ByteVector key16,ByteVector &input, ByteVector &output)
    {
        Int64 kL=getLongFromBytes(key16,0);
        Int64 kR=getLongFromBytes(key16,8);
        Int64Vector skL(16);
        createSubkeys(kL, skL);
        Int64Vector skR(16);
        createSubkeys(kR, skR);
        output.resize(input.size());
        
        Int64 m=0;
        Int64 c=0;
        
        for(int i=0;i<input.size();i+=8)
        {
            m=getLongFromBytes(input,i);
            c=des_ede(skL,skR,m,false);
            getBytesFromLong(output,i,c);
        }
    }
    
    string PBOC3DESDecryptForLong(string sesKey, string input){
        ByteVector keyByte(sesKey.length() / 2,0);
        hexString2Bytes(sesKey, keyByte);
        ByteVector outputByte(input.size());
        
        ByteVector inputBytes(input.length() / 2,0);
        hexString2Bytes(input, inputBytes);
        
        
        //        inputBytes.push_back('\0');
        
        pboc3DESDecrypt(keyByte, inputBytes, outputByte);
        
        ByteVector lengthByte(&outputByte[0], &outputByte[2]);
        int length = 0;
        try {
            length = stoi(bytes2HexString(lengthByte), nullptr, 16);
        } catch (exception e) {
            
        }
        if (length == 0) {
            return "";
        }else if (length > outputByte.size() - 2){
            return "";
        }else{
//            ByteVector realOutputByte(outputByte[2], outputByte[2 + length]);
            string result(&outputByte[2], &outputByte[2 + length]);
            return result;
        }
        
    }
    
    
}
