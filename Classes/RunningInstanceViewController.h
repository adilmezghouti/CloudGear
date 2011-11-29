//
//  RunningInstanceViewController.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/1/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RunningInstanceViewController : UITableViewController {
	NSMutableArray *instanceArray;
	
}

@property(nonatomic, retain) NSArray *instanceArray;
@end
