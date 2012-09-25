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
@property (nonatomic, assign) CGFloat presentAnimationDuration, dismissAnimationDuration;
@property (nonatomic, assign) CGFloat slideOffset;
@property (nonatomic, assign, getter = isOverlayViewVisible) BOOL overlayViewVisible;
@end


@implementation FWTOverlayScrollViewHelper
@synthesize scrollView = _scrollView;

- (void)dealloc
{
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
        self.presentAnimationDuration = .2f;
        self.dismissAnimationDuration = .2f;
        self.slideOffset = 20.0f;
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
        [self.scrollView addSubview:self.overlayView];
        self.overlayView.alpha = .0f;
        [UIView animateWithDuration:self.presentAnimationDuration
                         animations:^{
                             self.overlayView.alpha = 1.0f;
                             self.overlayView.transform = CGAffineTransformMakeTranslation(-self.slideOffset, 0.0f);
                         }];
    }
    else
    {
        [self.scrollView bringSubviewToFront:self.overlayView];
        self.overlayView.frame = [self _overlayFrame];
        self.overlayView.alpha = 1.0f;
    }
}

- (CGRect)_overlayFrame
{
    // Work out positions
    CGFloat maxTableHeight = self.scrollView.contentSize.height;
    CGFloat frameTableHeight = self.scrollView.frame.size.height;
    CGFloat workingTableHeight = maxTableHeight - frameTableHeight;
    CGFloat currentTablePosition = self.scrollView.contentOffset.y;
    CGFloat currentTablePositionPercentage = currentTablePosition / workingTableHeight;
    currentTablePositionPercentage = MAX(currentTablePositionPercentage, .0f);
    currentTablePositionPercentage = MIN(currentTablePositionPercentage, 1.0f);
    
    CGSize overlaySize = self.overlayView.frame.size;
    CGRect overlayFrame = [self _overlayBounds];
    overlayFrame.origin.y += ((CGRectGetHeight(overlayFrame)-overlaySize.height)*currentTablePositionPercentage); // adjust y
    overlayFrame.size.height = overlaySize.height;
    return overlayFrame;
}

- (CGRect)_overlayBounds
{
    CGSize overlaySize = self.overlayView.frame.size;
    CGRect toReturn = UIEdgeInsetsInsetRect(self.scrollView.bounds, self.edgeInsets);
    if (self.edgeInsets.left == .0f)
        toReturn.origin.x += CGRectGetWidth(toReturn)-overlaySize.width;
    
    toReturn.size.width = overlaySize.width;
    return toReturn;
}

- (void)_dismissOverlayView
{
    if (!_dismissOverlayViewAnimating)
    {
        _dismissOverlayViewAnimating = YES;

        [UIView animateWithDuration:self.dismissAnimationDuration
                         animations:^{
                             self.overlayView.alpha = .0f;
                             self.overlayView.frame = CGRectOffset(self.overlayView.frame, self.slideOffset, .0f);
                         }
                         completion:^(BOOL finished) {
                             
                             _dismissOverlayViewAnimating = NO;
                                                          
                             // check if we did have a scroll during the animation run
                             if (self.overlayView.alpha == .0f)
                             {
                                 [self.debugView removeFromSuperview];
                                 [self.overlayView removeFromSuperview];
                                 self.overlayView.transform = CGAffineTransformIdentity;
                                 
                                 self.overlayViewVisible = NO;
                             }
                         }
         ];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.overlayViewVisible = YES;
    
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
    //
    [self _layoutSubviews];
    
    //
    if (_realDelegateHas.scrollViewDidScroll)
        [self.realDelegate scrollViewDidScroll:scrollView];
}

@end
