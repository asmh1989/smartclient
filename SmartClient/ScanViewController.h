//
//  ScanViewController.h
//  SmartClient
//
//  Created by sun on 13-11-13.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <Decoder.h>
#import <parsedResults/ParsedResult.h>

@protocol ZXingDelegate;

#if !TARGET_IPHONE_SIMULATOR
#define HAS_AVFF 1
#endif

@interface ScanViewController : UIViewController<DecoderDelegate,
UINavigationControllerDelegate
#if HAS_AVFF
, AVCaptureVideoDataOutputSampleBufferDelegate
#endif
> {
    NSSet *readers;
    ParsedResult *result;
    SystemSoundID beepSound;
    BOOL showCancel;
    NSURL *soundToPlay;
    BOOL wasCancelled;
    BOOL oneDMode;
#if HAS_AVFF
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *prevLayer;
#endif
    BOOL decoding;
    BOOL isStatusBarHidden;
}

#if HAS_AVFF
@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *prevLayer;
#endif
@property (nonatomic, retain ) NSSet *readers;
@property (nonatomic, assign) id<ZXingDelegate> delegate;
@property (nonatomic, retain) NSURL *soundToPlay;
@property (nonatomic, retain) ParsedResult *result;

- (id)initWithDelegate:(id<ZXingDelegate>)delegate showCancel:(BOOL)shouldShowCancel OneDMode:(BOOL)shouldUseoOneDMode;
- (id)initWithDelegate:(id<ZXingDelegate>)scanDelegate showCancel:(BOOL)shouldShowCancel OneDMode:(BOOL)shouldUseoOneDMode showLicense:(BOOL)shouldShowLicense;

- (BOOL)fixedFocus;
- (void)setTorch:(BOOL)status;
- (BOOL)torchIsOn;

@end

@protocol ZXingDelegate
- (void)zxingController:(ScanViewController*)controller didScanResult:(NSString *)result;
- (void)zxingControllerDidCancel:(ScanViewController*)controller;
@end

