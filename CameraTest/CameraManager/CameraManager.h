//
// Created by Oliver Foggin on 13/05/2013.
// Copyright (c) 2013 Oliver Foggin. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>

@interface CameraManager : NSObject

- (void)startRunning;

- (void)focusAtPoint:(CGPoint)point;
@end