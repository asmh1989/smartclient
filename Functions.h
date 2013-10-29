//
//  Functions.h
//  SmartClient
//
//  Created by sun on 13-10-24.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _TOSTRIING(N)           [NSString stringWithFormat:@"%d", (int)(N)]
#define COMBINE(N, M)           [NSString stringWithFormat:@"%c%@",(N), (M)]

#define MYKEY_SHIFT               COMBINE(0x1b, @"[Z")
#define MYKEY_RETURN              COMBINE(0x0d, @"")
#define MYKEY_DEL                 COMBINE(0x0, @"\b")
#define MYKEY_ENTER               COMBINE(0x0, @"\r")
#define MYKEY_F1                  COMBINE(0x1b, @"OP")
#define MYKEY_F2                  COMBINE(0x1b, @"OQ")
#define MYKEY_F3                  COMBINE(0x1b, @"OR")
#define MYKEY_F4                  COMBINE(0x1b, @"OS")
#define MYKEY_F5                  COMBINE(0x1b, @"Ot")
#define MYKEY_F6                  COMBINE(0x1b, @"Ou")
#define MYKEY_F7                  COMBINE(0x1b, @"Ov")
#define MYKEY_F8                  COMBINE(0x1b, @"Ol")
#define MYKEY_UP                  COMBINE(0x1b, @"[A")
#define MYKEY_LEFT                COMBINE(0x1b, @"[D")
#define MYKEY_RIGHT               COMBINE(0x1b, @"[C")
#define MYKEY_DWON                COMBINE(0x1b, @"[B")



#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 // iOS 5.0 supported

//    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000 // iOS 5.0 supported and required
//
//        #define IS_SECURE_TRANSPORT_AVAILABLE      YES
//        #define SECURE_TRANSPORT_MAYBE_AVAILABLE   1
//        #define SECURE_TRANSPORT_MAYBE_UNAVAILABLE 0
//
//    #else                                         // iOS 5.0 supported but not required
//
//        #ifndef NSFoundationVersionNumber_iPhoneOS_5_0
//            #define NSFoundationVersionNumber_iPhoneOS_5_0 881.00
//        #endif
//
//        #define IS_SECURE_TRANSPORT_AVAILABLE     (NSFoundationVersionNumber >= NSFoundationVersionNumber_iPhoneOS_5_0)
//        #define SECURE_TRANSPORT_MAYBE_AVAILABLE   1
//        #define SECURE_TRANSPORT_MAYBE_UNAVAILABLE 1
//
//    #endif

    #define USE_IOS7_METHOD YES
#endif

@interface Functions : NSObject
@end
