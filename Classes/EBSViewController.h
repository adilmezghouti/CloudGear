//
//  EBSViewController.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/12/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunningInstanceDetailViewController.h"


@interface EBSViewController : UITableViewController {

	RunningInstanceDetailViewController *delegate;
	NSArray *ebsArray;
	NSString *selectedVolume;
}

@property(nonatomic, retain) RunningInstanceDetailViewController *delegate;
@property(nonatomic, retain) NSArray *ebsArray;
@property(nonatomic, retain) NSString *selectedVolume;

-(IBAction)attachEbsAction:(id)sender;
-(IBAction)detachEbsAction:(id)sender;

@end
