//
// Created by Oliver Foggin on 13/05/2013.
// Copyright (c) 2013 Oliver Foggin. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CameraCell.h"

@interface CameraCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CameraCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Add customisation here...
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageChanged:) name:@"image" object:nil];

        self.contentView.backgroundColor = [UIColor yellowColor];

        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.imageView];

        NSDictionary *views = NSDictionaryOfVariableBindings(_imageView);

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_imageView]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
    }
    return self;
}

- (void)imageChanged:(NSNotification *)notification
{
    self.imageView.image = notification.object;
}

@end