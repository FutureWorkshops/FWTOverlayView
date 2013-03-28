//
//  OverlayView.m
//  FWTClockKit_Test
//
//  Created by Marco Meschini on 21/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "OverlayView.h"
#import <QuartzCore/QuartzCore.h>

@interface OverlayView ()
@property (nonatomic, readwrite, retain) UILabel *textLabel;
@property (nonatomic, readwrite, retain) UILabel *detailTextLabel;
@property (nonatomic, retain) UIImageView *imageView;
@end

@implementation OverlayView
@synthesize textLabel = _textLabel;
@synthesize imageView = _imageView;

- (void)dealloc
{
    self.imageView = nil;
    self.detailTextLabel = nil;
    self.textLabel = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.layer.shadowOpacity = .2f;
//        self.layer.shadowRadius = 6.0f;
//        self.layer.shadowOffset = CGSizeMake(.0f, 2.0f);
//        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!self.imageView.superview)
        [self addSubview:self.imageView];
    
    self.imageView.frame = self.bounds;
        
    if (!self.textLabel.superview)
        [self addSubview:self.textLabel];
    
    CGRect labelFrame = CGRectInset(self.bounds, 2.0f, 4.0f);
    labelFrame.size.height *= .5f;
    self.textLabel.frame = labelFrame;
    
    if (!self.detailTextLabel.superview)
        [self addSubview:self.detailTextLabel];
    
    labelFrame = CGRectInset(self.bounds, 2.0f, 4.0f);
    labelFrame.origin.y += (labelFrame.size.height)*.5f;
    labelFrame.size.height *= .5f;
    self.detailTextLabel.frame = labelFrame;
}

- (UILabel *)textLabel
{
    if (!self->_textLabel)
    {
        self->_textLabel = [[UILabel alloc] init];
        self->_textLabel.numberOfLines = 0;
        self->_textLabel.backgroundColor = [UIColor clearColor];
        self->_textLabel.textColor = [UIColor redColor];
        self->_textLabel.font = [UIFont Ristretto_lightFontOfSize:8.0f];
        self->_textLabel.textAlignment = UITextAlignmentCenter;
        self->_textLabel.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:.7f];
        self->_textLabel.shadowOffset = CGSizeMake(.0f, 1.0f);
    }
    return self->_textLabel;
}

- (UILabel *)detailTextLabel
{
    if (!self->_detailTextLabel)
    {
        self->_detailTextLabel = [[UILabel alloc] init];
        self->_detailTextLabel.numberOfLines = 0;
        self->_detailTextLabel.backgroundColor = [UIColor clearColor];
        self->_detailTextLabel.textColor = [UIColor blackColor];
        self->_detailTextLabel.font = [UIFont Ristretto_mediumFontOfSize:8.0f];
        self->_detailTextLabel.textAlignment = UITextAlignmentCenter;
        self->_detailTextLabel.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:.7f];
        self->_detailTextLabel.shadowOffset = CGSizeMake(.0f, 1.0f);
    }
    return self->_detailTextLabel;
}

- (UIImageView *)imageView
{
    if (!self->_imageView)
    {
        self->_imageView = [[UIImageView alloc] initWithImage:[self _backgroundImage]];
    }
    
    return self->_imageView;
}

- (UIImage *)_backgroundImage
{
    CGSize ctxSize = CGSizeMake(20.0f, 20.0f);
    CGRect ctxRect = CGRectMake(.0f, .0f, ctxSize.width, ctxSize.height);
    UIGraphicsBeginImageContextWithOptions(ctxSize, NO, .0f);
    ctxRect = CGRectInset(ctxRect, 5, 5);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:ctxRect cornerRadius:3];
    
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, CGSizeMake(.0f, 1.0f), 4.0f, [UIColor blackColor].CGColor);
    [[UIColor blackColor] set];
    [bp fill];
    [bp addClip];
    CGContextClearRect(ctx, ctxRect);
    CGContextRestoreGState(ctx);
    
    [[[UIColor whiteColor] colorWithAlphaComponent:.7f] set];
    [bp stroke];
    
    bp = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(ctxRect, 2, 2) cornerRadius:2];
    [[[UIColor whiteColor] colorWithAlphaComponent:.5f] set];
    [bp fill];
    [bp stroke];
    
    //
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 9.0f, 9.0f)];
}

@end
