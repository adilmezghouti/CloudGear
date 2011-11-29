//
//  RunningInstanceDetailViewController.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/1/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunningInstanceInfo.h"

@interface RunningInstanceDetailViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{

	RunningInstanceInfo *instanceInfo;
}

@property(nonatomic, retain) RunningInstanceInfo *instanceInfo;

-(id) initWithInstanceInfo:(RunningInstanceInfo *)instanceInformation;

@end
