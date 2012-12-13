//
//  ScrollViewHelper.m
//  FWTClockKit_Test
//
//  Created by Marco Meschini on 24/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTOverlayScrollViewHelper.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+FWTOverlayView.h"

#define DEBUG_ENABLED  NO

static BOOL isMethodPartOfProtocol(SEL aSelector, Protocol *aProtocol)
{
	struct objc_method_description methodDescription = protocol_getMethodDescription(aProtocol, aSelector, YES, YES);
	if(methodDescription.name == NULL) {
		methodDescription = protocol_getMethodDescription(aProtocol, aSelector, NO, YES);
	}
	if(methodDescription.name == NULL) {
		return NO;
	} else {
		return YES;
	}
}

NSString *const keyPathDelegate = @"delegate";
NSString *const keyPathFrame = @"frame";

@interface FWTOverlayScrollViewHelper () <UIScrollViewDelegate>
{
    BOOL _dismissOverlayViewAnimating;
    BOOL _overlayViewVisible;
    
    struct {
        BOOL scrollViewWillBeginDragging : 1;
        BOOL scrollViewDidEndDecelerating : 1;
        BOOL scrollViewDidEndDragging : 1;
        BOOL scrollViewDidScroll : 1;
    } _realDelegateHas;
}
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) id<UIScrollViewDelegate> realDelegate;
@property (nonatomic, retain) UIView *debugView;
@property (nonatomic, assign, getter = isOverlayViewVisible) BOOL overlayViewVisible;
@property (nonatomic, assign, getter = isDismissAnimationRunning) BOOL dismissAnimationRunning;
@property (nonatomic, assign) BOOL overlayViewWillDisappear;
@end


@implementation FWTOverlayScrollViewHelper
@synthesize scrollView = _scrollView;

- (void)dealloc
{
    self.dismissBlock = NULL;
    self.layoutBlock = NULL;
    self.debugView = nil;
    self.overlayView = nil;
    self.realDelegate = nil;
    self.scrollView = nil;
    [super dealloc];
}

- (id)initWithScrollView:(UIScrollView *)scrollView
{
    if ((self = [super init]))
    {
        self.scrollView = scrollView;
        self.hideAfterDelay = 2.0f;
    }
    
    return self;
}

#pragma mark - Public
- (void)setScrollView:(UIScrollView *)scrollView
{
    if (self->_scrollView != scrollView)
    {
        [self->_scrollView removeObserver:self forKeyPath:keyPathDelegate];
        [self->_scrollView removeObserver:self forKeyPath:keyPathFrame];
        [self->_scrollView release];
        self->_scrollView = nil;
        
        if (scrollView)
        {
            self->_scrollView = [scrollView retain];
            
            //
            [self _swapDelegateForScrollView:self->_scrollView];
            
            //
            [self->_scrollView addObserver:self forKeyPath:keyPathDelegate options:NSKeyValueObservingOptionNew context:NULL];
            [self->_scrollView addObserver:self forKeyPath:keyPathFrame options:NSKeyValueObservingOptionNew context:NULL];
            //TODO: add observer for contentSize
        }
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:keyPathDelegate])
    {
        UIScrollView *scrollView = (UIScrollView *)object;
        if ([change objectForKey:@"new"] != [NSNull null] && scrollView.delegate != self)
        {
            [self _swapDelegateForScrollView:scrollView];
        }
    }
    
    if ([keyPath isEqualToString:keyPathFrame])
    {
        UIScrollView *scrollView = (UIScrollView *)object;
        if (scrollView.superview && [self isOverlayViewVisible])
        {
            //
            [self _layoutSubviews];
            
            //
            if (_realDelegateHas.scrollViewDidScroll)
                [self.realDelegate scrollViewDidScroll:self.scrollView];
        }
    }
}

#pragma mark - Methods forwarding
- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
	if(aProtocol==@protocol(UIScrollViewDelegate) || aProtocol==@protocol(UITableViewDelegate))
		return YES;
	else
		return [super conformsToProtocol:aProtocol];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
	BOOL result = ([super respondsToSelector:aSelector] ||
				   (isMethodPartOfProtocol(aSelector, @protocol(UIScrollViewDelegate)) && [self.realDelegate respondsToSelector:aSelector]) ||
                   (isMethodPartOfProtocol(aSelector, @protocol(UITableViewDelegate)) && [self.realDelegate respondsToSelector:aSelector]));
	return result;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    BOOL isPartOfProtocol = isMethodPartOfProtocol(aSelector, @protocol(UIScrollViewDelegate)) || isMethodPartOfProtocol(aSelector, @protocol(UITableViewDelegate));
    if (isPartOfProtocol && [self.realDelegate respondsToSelector:aSelector])
		return self.realDelegate;
	else
		return nil;
}

#pragma mark - Getters
- (UIView *)debugView
{
    if (!DEBUG_ENABLED) return nil;
    
    if (!self->_debugView)
    {
        self->_debugView = [[UIView alloc] init];
        self->_debugView.layer.borderWidth = 1.0f;
        self->_debugView.layer.borderColor = [UIColor redColor].CGColor;
    }
    
    return self->_debugView;
}

- (FWTOverlayLayoutBlock)layoutBlock
{
    if (self->_layoutBlock == NULL)
    {
        __block typeof(self) myself = self;
        self->_layoutBlock = [^(BOOL animated){
            if (animated)
            {
                CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
                anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                anim.fromValue = @.0f;
                anim.toValue = @1.0f;
                myself.overlayView.layer.opacity = 1.0f;
                [myself.overlayView.layer addAnimation:anim forKey:@"animation"];
            }
            else
                myself.overlayView.layer.opacity = 1.0f;
            
        } copy];
    }
    
    return self->_layoutBlock;
}

- (FWTOverlayDismissBlock)dismissBlock
{
    if (self->_dismissBlock == NULL)
    {
        __block typeof(self) myself = self;
        self->_dismissBlock = [^(){
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            anim.fromValue = @1.0f;
            anim.toValue = @.0f;
            myself.overlayView.layer.opacity = .0f;
            [myself.overlayView.layer addAnimation:anim forKey:@"animation"];
            
        } copy];
    }
    
    return self->_dismissBlock;
}

#pragma mark - Private
- (void)_swapDelegateForScrollView:(UIScrollView *)scrollView
{
    self.realDelegate = scrollView.delegate;
    scrollView.delegate = self;
    
    //
    _realDelegateHas.scrollViewWillBeginDragging = [self.realDelegate respondsToSelector:@selector(scrollViewWillBeginDragging)];
    _realDelegateHas.scrollViewDidEndDecelerating = [self.realDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)];
    _realDelegateHas.scrollViewDidEndDragging = [self.realDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)];
    _realDelegateHas.scrollViewDidScroll = [self.realDelegate respondsToSelector:@selector(scrollViewDidScroll:)];
}

- (void)_layoutSubviews
{
    if ([self isOverlayViewVisible])
    {
        [self _layoutDebugView];
        
        [self _layoutOverlayView];
    }
}

- (void)_layoutDebugView
{
    if (!self.debugView.superview)
        [self.scrollView addSubview:self.debugView];
    
    [self.scrollView bringSubviewToFront:self.debugView];
    self.debugView.frame = [self _overlayBounds];
}

- (void)_layoutOverlayView
{
    if (!self.overlayView.superview)
    {
        self.overlayView.frame = [self _overlayFrame];
        [self.scrollView addSubview:self.overlayView];
        self.layoutBlock(YES);
    }
    else
    {
        [self.scrollView bringSubviewToFront:self.overlayView];
        self.overlayView.frame = [self _overlayFrame];
        self.layoutBlock(NO);
    }
}

- (CGRect)_overlayFrame
{
    CGPoint contentOffsetRelative = [self.scrollView fwt_relativeContentOffsetNormalized:YES];
    CGSize overlaySize = self.overlayView.frame.size;
    CGRect overlayAvailableFrame = [self _overlayBounds];
    CGRect toReturn = overlayAvailableFrame;
    toReturn.origin.x += ((CGRectGetWidth(overlayAvailableFrame)-overlaySize.width)*contentOffsetRelative.x);
    toReturn.origin.y += ((CGRectGetHeight(overlayAvailableFrame)-overlaySize.height)*contentOffsetRelative.y);
    toReturn.size = overlaySize;
    
    if (self.flexibleMargin == UIViewAutoresizingFlexibleLeftMargin)
    {
        toReturn.origin.x += CGRectGetWidth(overlayAvailableFrame)-overlaySize.width;
    }
    else if (self.flexibleMargin == UIViewAutoresizingFlexibleTopMargin)
    {
        toReturn.origin.y += CGRectGetHeight(overlayAvailableFrame)-overlaySize.height;
    }
    
    return toReturn;
}

- (CGRect)_overlayBounds
{
    return UIEdgeInsetsInsetRect(self.scrollView.bounds, self.edgeInsets);
}

- (void)_dismissOverlayView
{
    if (![self isDismissAnimationRunning])
    {
        self.dismissAnimationRunning = YES;
        self.overlayViewWillDisappear = YES;
        
        __block typeof(self) myself = self;
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            if (myself.overlayViewWillDisappear)
            {
                [myself.debugView removeFromSuperview];
                [myself.overlayView removeFromSuperview];
                myself.overlayViewVisible = NO;
            }
            
            myself.dismissAnimationRunning = NO;
        }];
        
        self.dismissBlock();
        [CATransaction commit];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.overlayViewVisible = YES;
    self.overlayViewWillDisappear = NO;
    [self.overlayView.layer removeAllAnimations];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_dismissOverlayView) object:nil];
    
    if (_realDelegateHas.scrollViewWillBeginDragging)
        [self.realDelegate scrollViewWillBeginDragging:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_dismissOverlayView) object:nil];
    [self performSelector:@selector(_dismissOverlayView) withObject:nil afterDelay:self.hideAfterDelay];
    
    if (_realDelegateHas.scrollViewDidEndDecelerating)
        [self.realDelegate scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_dismissOverlayView) object:nil];
    [self performSelector:@selector(_dismissOverlayView) withObject:nil afterDelay:self.hideAfterDelay];
    
    if (_realDelegateHas.scrollViewDidEndDragging)
        [self.realDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self _layoutSubviews];
    
    if (_realDelegateHas.scrollViewDidScroll)
        [self.realDelegate scrollViewDidScroll:scrollView];
}

@end
