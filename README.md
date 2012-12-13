#FWTOverlayView

![FWTOverlayView screenshot](http://grab.by/ige8)

FWTOverlayView extends scrollview and make it easy to add a floating overlay view. The overlay view hovers through your scrollview frame and helps tracking the current offset.
This component is inspired by Path app and tries to expose a generic and flexible interface.
It uses associative reference to add a custom property to a UIScrollView category.


##Requirements
* XCode 4.4.1 or higher
* iOS 5.0

##Features
FWTOverlayView is a small collection of objective-c categories.

* **UIScrollView (FWTRelativeContentOffset)**, adds the relative content offset property
* **UIScrollView (FWTOverlayView)** hides a private helper class and exposes a small set of properties to make the overlay view customization easy
* **UITableView (FWTOverlayView)** adds a handy property to get the indexPath from the current overlay view position.

##How to use it: configure

####UIScrollView (FWTRelativeContentOffset)

* **fwt_relativeContentOffset** the point, in the unit coordinate space, at which the origin of the content view is offset from the origin of the scroll view 
* **fwt_relativeContentOffsetNormalized:(BOOL)normalized** returns the relative content offset and if enabled it clamps to [0, 1] values

####UIScrollView (FWTOverlayView)

* **fwt_overlayView** the custom view to display on top of the scrollview
* **fwt_overlayViewEdgeInsets** the inset or outset margins for the edges of the available overlay view area 
* **fwt_overlayViewFlexibleMargin** 
* **fwt_overlayViewHideAfterDelay**
* **fwt_layoutBlock**
* **fwt_dismissBlock**

####UITableView (FWTOverlayView) 

* **fwt_overlayViewIndexPath** returns the index path identifying the row and section below the overlay view

##For your interest
say about **FWTOverlayScrollViewHelper**

##Demo
The sample project shows how to use the categories and how to create a custom overlay view.

``` objective-c

	- (void)loadView
	{
		[super loadView];

		// set and configure the overlay view	
		CGRect frame = CGRectMake(.0f, .0f, 80.0f, 34.0f);
    	self.tableView.fwt_overlayView = [[[OverlayView alloc] initWithFrame:frame] autorelease];
    	self.tableView.fwt_overlayViewEdgeInsets = (UIEdgeInsets){2.0f, 2.0f, 2.0f, 10.0f};
    	self.tableView.fwt_overlayViewFlexibleMargin = UIViewAutoresizingFlexibleLeftMargin;
    }
    
    - (void)scrollViewDidScroll:(UIScrollView *)scrollView
	{
		// update the overlay view displayed values
    	Item *item = [self.data objectAtIndex:self.tableView.fwt_overlayViewIndexPath.row];
    	OverlayView *overlayView = (OverlayView *)scrollView.fwt_overlayView;
    	overlayView.textLabel.text = item.timeString;
    	overlayView.detailTextLabel.text = item.dateString;
	}

```

##Licensing
Apache License Version 2.0

##Support, bugs and feature requests
If you want to submit a feature request, please do so via the issue tracker on github.
If you want to submit a bug report, please also do so via the issue tracker, including a diagnosis of the problem and a suggested fix (in code).
