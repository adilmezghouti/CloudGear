//
//  CustomTableView.m
//  AWSManager
//
//  Created by Adil Mezghouti on 5/15/11.
//  Copyright 2011 Adil Mezghouti university. All rights reserved.
//

#import "CustomTableView.h"
#import "CustomCell.h"

@implementation CustomTableView
#pragma mark Touch gestures interception

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	

	if (self.decelerating || self.editing == YES) {
		// don't try anything when the tableview is moving..
		return [super hitTest:point withEvent:event];
	}
	
	// Do not catch as a swipe if touch is inside the area of the UIControl (check switch) or far right (potential index control)
	if (point.x < 50 || point.x > 290) {
		return [super hitTest:point withEvent:event];
	}
	
	// Do not swipe if the global option is turned off
	//ShoppingAppDelegate *appDelegate = (ShoppingAppDelegate *)[[UIApplication sharedApplication] delegate];
//	if (appDelegate.globalSwipesOn == NO) {
//		return [super hitTest:point withEvent:event];
//	}
	
	// Find the cell
	NSIndexPath *indexPathAtHitPoint = [self indexPathForRowAtPoint:point];
	CustomCell *cell = (CustomCell*)[self cellForRowAtIndexPath:indexPathAtHitPoint];
	// forward to the cell unless we desire to have vertical scrolling
	if (cell != nil && [cell fingerIsMovingVertically] == NO) {
		return (UIView *)[cell contentView];
	}
	return [super hitTest:point withEvent:event];
}



- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
	return YES;
}


- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
	return YES;
}
@end
