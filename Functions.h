//
//  Functions.h
//  SmartClient
//
//  Created by sun on 13-10-24.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _TOSTRIING(N) [NSString stringWithFormat:@"%d", (int)(N)]

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
