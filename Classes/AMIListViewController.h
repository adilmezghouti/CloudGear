//
//  HomeViewController.h
//  AWSManager
//
//  Created by Adil Mezghouti on 10/17/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AMIListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{

	NSMutableArray *amiArray;
	NSString* amiType;
}

@property(nonatomic, retain) NSArray *amiArray;
@property(nonatomic, retain) NSString *amiType;

-(id)initWithNibName:(NSString *)nibNameOrNil amiType:(NSString *)amiType;
@end
