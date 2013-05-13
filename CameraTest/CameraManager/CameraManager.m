//
// Created by Oliver Foggin on 13/05/2013.
// Copyright (c) 2013 Oliver Foggin. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <AVFoundation/AVFoundation.h>
#import "CameraManager.h"

@interface CameraManager () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) CIContext *context;

@property(nonatomic, strong) AVCaptureDevice *rearCamera;

@end

@implementation CameraManager

- (id)init
{
    self = [super init];
    if (self) {
        // Add customisation here...

        self.context = [CIContext contextWithOptions:nil];

        [self setupCamera];
    }
    return self;
}

- (void)setupCamera
{
    self.session = [[AVCaptureSession alloc] init];
    [self.session beginConfiguration];

    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];

    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    self.rearCamera = nil;
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionBack) {
            self.rearCamera = device;
            break;
        }
    }

    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.rearCamera error:&error];
    [self.session addInput:input];

    AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES];

    NSDictionary *options = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    [dataOutput setVideoSettings:options];

    [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];

    [self.session addOutput:dataOutput];
    [self.session commitConfiguration];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // grab the pixel buffer
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef) CMSampleBufferGetImageBuffer(sampleBuffer);

    // create a CIImage from it, rotate it and zero the origin
    CIImage *image = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) {
        image = [image imageByApplyingTransform:CGAffineTransformMakeRotation(M_PI)];
    }
    CGPoint origin = [image extent].origin;
    image = [image imageByApplyingTransform:CGAffineTransformMakeTranslation(-origin.x, -origin.y)];

    // set it as the contents of the UIImageView
    CGImageRef cgImage = [self.context createCGImage:image fromRect:[image extent]];
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
//    self.imageView.image = uiImage;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"image" object:uiImage];

    CGImageRelease(cgImage);
}

- (void)startRunning
{
    [self.session startRunning];
}

- (void)focusAtPoint:(CGPoint)point
{
    if ([self.rearCamera lockForConfiguration:nil]) {
        [self.rearCamera setFocusPointOfInterest:point];
        [self.rearCamera setFocusMode:AVCaptureFocusModeAutoFocus];
        [self.rearCamera unlockForConfiguration];
    }
}

@end