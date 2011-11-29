//
//  MainMenuTableViewCell.h
//
//  Created by Adil Mezghouti on 10/21/10.
//  Copyright 2010 Northeastern university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HomeViewController.h"

@interface MainMenuTableViewCell : UITableViewCell {
    IBOutlet UIView *accessoryView;
    IBOutlet UIView *backgroundView;
    IBOutlet UIView *editingAccessoryView;
    IBOutlet UIView *selectedBackgroundView;
	IBOutlet UIButton *amiButton;
	IBOutlet UIButton *ebsButton;
	IBOutlet UIButton *profileButton;
	
	NSString *buttonSelected;
	HomeViewController *delegate;
}

@property(nonatomic, retain) NSString *buttonSelected;
@property(nonatomic, retain) HomeViewController *delegate;

-(IBAction) amiAction:(id) sender;
-(IBAction) ebsAction:(id) sender;
-(IBAction) profileAction:(id) sender;

-(void) setDelegate:(HomeViewController*)controller;

@end
