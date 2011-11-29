//
//  CustomCell.h
//  AWSManager
//
//  Created by Adil Mezghouti on 5/15/11.
//  Copyright 2011 Adil Mezghouti university. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomCell : UITableViewCell {

	BOOL swiping;
	BOOL hasSwiped;
	BOOL hasSwipedLeft;
	BOOL hasSwipedRight;
	BOOL fingerIsMovingLeftOrRight;
	BOOL fingerMovingVertically;
	
	CGPoint startTouchPosition;
}

@property(nonatomic,assign) BOOL swiping;
@property(nonatomic,assign) BOOL hasSwiped;
@property(nonatomic,assign) BOOL hasSwipedLeft;
@property(nonatomic,assign) BOOL hasSwipedRight;
@property(nonatomic,assign) BOOL fingerIsMovingLeftOrRight;
@property(nonatomic,assign) BOOL fingerMovingVertically;

@property(nonatomic,assign) CGPoint startTouchPosition;

- (BOOL)isTouchGoingLeftOrRight:(UITouch *)touch;
- (void)lookForSwipeGestureInTouches:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL)fingerIsMovingVertically;

@end
