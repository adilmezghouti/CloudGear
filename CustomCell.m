//
//  CustomCell.m
//  AWSManager
//
//  Created by Adil Mezghouti on 5/15/11.
//  Copyright 2011 Adil Mezghouti university. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell
@synthesize startTouchPosition, swiping, hasSwiped, hasSwipedLeft, hasSwipedRight, fingerMovingVertically, fingerIsMovingLeftOrRight;

#pragma mark Touch gestures for custom cell view



#define HORIZ_SWIPE_DRAG_MIN  12
#define VERT_SWIPE_DRAG_MAX    4

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//	[center addObserver:self selector:@selector(reset) name:UIMenuControllerWillHideMenuNotification object:nil];
	UIMenuController *theMenu = [UIMenuController sharedMenuController];
	[theMenu setMenuVisible:FALSE animated:false];
	
    UITouch *touch = [touches anyObject];
    self.startTouchPosition = [touch locationInView:self];
	self.swiping = NO;
	self.hasSwiped = NO;
	self.hasSwipedLeft = NO;
	self.hasSwipedRight = NO;
	self.fingerIsMovingLeftOrRight = NO;
	self.fingerMovingVertically = NO;
	
	if ([self canBecomeFirstResponder]) {
  		[self becomeFirstResponder];
  		[self performSelector:@selector(showMenu) withObject:nil afterDelay:0.8f];
  	}
	[self.nextResponder touchesBegan:touches withEvent:event];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([self isTouchGoingLeftOrRight:[touches anyObject]]) {
		[self lookForSwipeGestureInTouches:(NSSet *)touches withEvent:(UIEvent *)event];
		[super touchesMoved:touches withEvent:event];
	} else {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showMenu) object:nil];
		[self.nextResponder touchesMoved:touches withEvent:event];
	}
}


// Determine what kind of gesture the finger event is generating
- (BOOL)isTouchGoingLeftOrRight:(UITouch *)touch {
    CGPoint currentTouchPosition = [touch locationInView:self];
	if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= 1.0) {
		self.fingerIsMovingLeftOrRight = YES;
		return YES;
    } else {
		self.fingerIsMovingLeftOrRight = NO;
		return NO;
	}
	if (fabsf(startTouchPosition.y - currentTouchPosition.y) >= 2.0) {
		self.fingerMovingVertically = YES;
	} else {
		self.fingerMovingVertically = NO;
	}
}


- (BOOL)fingerIsMoving {
	return self.fingerIsMovingLeftOrRight;
}

- (BOOL)fingerIsMovingVertically {
	return self.fingerMovingVertically;
}

// Check for swipe gestures
- (void)lookForSwipeGestureInTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
	
	[self setSelected:NO];
	self.swiping = YES;

	
	if (hasSwiped == NO) {
		
		// If the swipe tracks correctly.
		if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
			fabsf(startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX)
		{
			NSLog(@"A Swipe happened");
			// It appears to be a swipe.
			if (startTouchPosition.x < currentTouchPosition.x) {
				hasSwiped = YES;
				hasSwipedRight = YES;
				swiping = NO;
				
				[[NSNotificationCenter defaultCenter] postNotificationName:@"gestureDidSwipeRight" object:self];
			} else {
				hasSwiped = YES;
				hasSwipedLeft = YES;
				swiping = NO;
				
				[[NSNotificationCenter defaultCenter] postNotificationName:@"gestureDidSwipeLeft" object:self];
			}
		} else {
			// Process a non-swipe event.
		}
		
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	self.swiping = NO;
	self.hasSwiped = NO;
	self.hasSwipedLeft = NO;
	self.hasSwipedRight = NO;
	self.fingerMovingVertically = NO;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showMenu) object:nil];
	[self.nextResponder touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showMenu) object:nil];
}

- (void)showMenu {
  	//NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//  	[center addObserver:self selector:@selector(reset) name:UIMenuControllerWillHideMenuNotification object:nil];
	
  	// bring up editing menu.
  	UIMenuController *theMenu = [UIMenuController sharedMenuController];
  	CGRect myFrame = [[self superview] frame];
  	CGRect selectionRect = CGRectMake(startTouchPosition.x, myFrame.origin.y - 8.0, 0, 0);
	
  	[self setNeedsDisplayInRect:selectionRect];
  	[theMenu setTargetRect:selectionRect inView:self];
  	[theMenu setMenuVisible:YES animated:YES];
	
 
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  	BOOL answer = NO;
	
  	if (action == @selector(copy:))
  		answer = YES;
	
  	return answer;
}

- (void)copy:(id)sender {
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
  	[gpBoard setValue:[[[self text] componentsSeparatedByString:@":"] objectAtIndex:1] forPasteboardType:@"public.utf8-plain-text"];
}

@end
