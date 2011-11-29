//
//  RunningInstanceDetailViewController.m
//  AWSManager
//
//  Created by Adil Mezghouti on 11/1/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "RunningInstanceDetailViewController.h"
#import "StopInstanceInfo.h"
#import "StopInstanceParser.h"
#import "AWSUtils.h"
#import "Response.h"
#import "Connection.h"
#import "AttachVolumeInfo.h"
#import "AttachDetachVolumeParser.h"
#import "EBSViewController.h"
#import "ErrorInfo.h"
#import "ErrorParser.h"
#import "RunningInstanceParser.h"
#import "CustomCell.h"
#import "CustomTableView.h"
#import "CloudWatchViewController.h"

@implementation RunningInstanceDetailViewController
@synthesize instanceInfo;

#pragma mark -
#pragma mark View lifecycle
-(id) initWithInstanceInfo:(RunningInstanceInfo *)instanceInformation {
	if([self init]){
		self = [self initWithNibName:@"RunningInstanceDetailViewController" bundle:nil];
		[self setInstanceInfo:instanceInformation];
	}
	return self;
}


-(void) viewDidLoad {
	[super viewDidLoad];
	[self setTitle:@"Instance Details"];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)] 
											  autorelease];
	
	UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(8.0, 0.0, 304.0, 122.0)] autorelease];
	
	int delta = 1;
	int height = 20;
	int factor = 1;
	
	UIButton *terminateInstanceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[terminateInstanceBtn setFrame:CGRectMake(50, 0, 200, height)];
	[terminateInstanceBtn setTitle:@"Terminate Instance" forState:UIControlStateNormal];
	[terminateInstanceBtn setShowsTouchWhenHighlighted:TRUE];
	[terminateInstanceBtn addTarget:self action:@selector(terminateInstanceAction:) forControlEvents:UIControlEventTouchUpInside];
	
	
	if([[instanceInfo rootDeviceType] isEqual:@"ebs"]){
		if([[instanceInfo instanceState] isEqual:@"stopped"]){
			UIButton *startInstanceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[startInstanceBtn setFrame:CGRectMake(50, height + delta, 200, height)];
			[startInstanceBtn setTitle:@"Start Instance" forState:UIControlStateNormal];
			[startInstanceBtn addTarget:self action:@selector(startInstanceAction:) forControlEvents:UIControlEventTouchUpInside];
			[startInstanceBtn setShowsTouchWhenHighlighted:TRUE];
			[footerView addSubview:startInstanceBtn];
			
		} else {
			UIButton *stopInstanceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[stopInstanceBtn setFrame:CGRectMake(50, height + delta, 200, height)];
			[stopInstanceBtn setTitle:@"Stop Instance" forState:UIControlStateNormal];
			[stopInstanceBtn addTarget:self action:@selector(stopInstanceAction:) forControlEvents:UIControlEventTouchUpInside];
			[stopInstanceBtn setShowsTouchWhenHighlighted:TRUE];
			[footerView addSubview:stopInstanceBtn];	
            
            factor++; 
            UIButton *attachEbsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [attachEbsBtn setFrame:CGRectMake(50, factor*(height + delta), 200, height)];
            [attachEbsBtn setTitle:@"Attach/Detach Devices" forState:UIControlStateNormal];
            [attachEbsBtn setShowsTouchWhenHighlighted:TRUE];
            [attachEbsBtn addTarget:self action:@selector(attachEbsAction:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:attachEbsBtn];
            
            factor++;
            UIButton *cloudWatchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [cloudWatchBtn setFrame:CGRectMake(50, factor*(height + delta), 200, height)];
            [cloudWatchBtn setTitle:@"Cloud Watch" forState:UIControlStateNormal];
            [cloudWatchBtn setShowsTouchWhenHighlighted:TRUE];
            [cloudWatchBtn addTarget:self action:@selector(cloudWatchAction:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:cloudWatchBtn];                
		}
	} else {
         UIButton *attachEbsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [attachEbsBtn setFrame:CGRectMake(50, factor*(height + delta), 200, height)];
        [attachEbsBtn setTitle:@"Attach/Detach Devices" forState:UIControlStateNormal];
        [attachEbsBtn setShowsTouchWhenHighlighted:TRUE];
        [attachEbsBtn addTarget:self action:@selector(attachEbsAction:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:attachEbsBtn];
        
        factor++;       
        UIButton *cloudWatchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cloudWatchBtn setFrame:CGRectMake(50, factor*(height + delta), 200, height)];
        [cloudWatchBtn setTitle:@"Cloud Watch" forState:UIControlStateNormal];
        [cloudWatchBtn setShowsTouchWhenHighlighted:TRUE];
        [cloudWatchBtn addTarget:self action:@selector(cloudWatchAction:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:cloudWatchBtn];        
    }
	
	
	

	
	[footerView addSubview:terminateInstanceBtn];


	[self.tableView setTableFooterView:footerView];
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(CustomTableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(CustomTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
}


// Customize the appearance of table view cells.
- (CustomCell *)tableView:(CustomTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	
    switch (indexPath.row) {
		case 0:
			[cell.textLabel setText:[NSString stringWithFormat:@"Instance Id: %@",[instanceInfo instanceId]]];
			break;
		case 1:
			[cell.textLabel setText:[NSString stringWithFormat:@"Image Id: %@",[instanceInfo imageId]]];
			break;
		case 2:
			[cell.textLabel setText:[NSString stringWithFormat:@"Instance State: %@",[instanceInfo instanceState]]];
			break;
		case 3:
			[cell.textLabel setNumberOfLines:2];
			[cell.textLabel setText:[NSString stringWithFormat:@"dns Name: %@",[instanceInfo dnsName]]];
			break;
		case 4:
			[cell.textLabel setText:[NSString stringWithFormat:@"Launch Time: %@",[instanceInfo launchTime]]];
			break;
		case 5:
			[cell.textLabel setText:[NSString stringWithFormat:@"Availability Zone: %@",[instanceInfo availabilityZone]]];
			break;
		case 6:
			[cell.textLabel setText:[NSString stringWithFormat:@"IP Address: %@",[instanceInfo ipAddress]]];
			break;
			//		case 7:
			//			[cell.textLabel setText:[NSString stringWithFormat:@"Device: %@ => %@",[instanceInfo deviceName],[instanceInfo deviceStatus]]];
			//			break;
			//		case 8:
			//			[cell.textLabel setText:[NSString stringWithFormat:@"Device Status: %@",[instanceInfo deviceStatus]]];
			//			break;
			//		case 9:
			//			[cell.textLabel setText:[NSString stringWithFormat:@"Attach Time: %@",[instanceInfo attachTime]]];
			//			break;
	}
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(CustomTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}


#pragma mark -
#pragma mark button event handling

-(void) terminateInstanceAction:(id)sender {
	NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [date dateByAddingTimeInterval:120];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *date1 = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *date2 = [dateFormatter stringFromDate:date];
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"TerminateInstances" forKey:@"Action"];
	[dict setObject:@"2010-08-31" forKey:@"Version"];
	[dict setObject:[instanceInfo instanceId] forKey:@"InstanceId.1"];
	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
	
	NSString *urlToUse = [AWSUtils getQueryString:dict];
	Response *response = [Connection get:urlToUse];
	
	if([response statusCode] == 200){
		StopInstanceParser *parser = [[[StopInstanceParser alloc] init] autorelease];
		StopInstanceInfo *stopInstanceInfo = nil;
		if([parser parseData:	[response body]]){
			stopInstanceInfo = (StopInstanceInfo*)[[parser items] objectAtIndex:0];
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:[NSString stringWithFormat:@"An instance with id: %@ is %@", [stopInstanceInfo instanceId],[stopInstanceInfo currentState]]
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];  		
	} else {
		ErrorParser *parser = [[[ErrorParser alloc] init] autorelease];
		ErrorInfo *errorInfo = nil;
		if([parser parseData:	[response body]]){
			errorInfo = (ErrorInfo*)[[parser items] objectAtIndex:0];
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[errorInfo code] message:[errorInfo message]
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];  
	}
	
}



-(void) stopInstanceAction:(id)sender {
	NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [date dateByAddingTimeInterval:120];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *date1 = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *date2 = [dateFormatter stringFromDate:date];
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"StopInstances" forKey:@"Action"];
	[dict setObject:@"2010-08-31" forKey:@"Version"];
	[dict setObject:[instanceInfo instanceId] forKey:@"InstanceId.1"];
	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
	
	NSString *urlToUse = [AWSUtils getQueryString:dict];
	Response *response = [Connection get:urlToUse];
	
	if([response statusCode] == 200){
		StopInstanceParser *parser = [[[StopInstanceParser alloc] init] autorelease];
		StopInstanceInfo *stopInstanceInfo = nil;
		if([parser parseData:	[response body]]){
			stopInstanceInfo = (StopInstanceInfo*)[[parser items] objectAtIndex:0];
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:[NSString stringWithFormat:@"An instance with id: %@ is %@", [stopInstanceInfo instanceId],[stopInstanceInfo currentState]]
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];  
	} else {
		ErrorParser *parser = [[[ErrorParser alloc] init] autorelease];
		ErrorInfo *errorInfo = nil;
		if([parser parseData:	[response body]]){
			errorInfo = (ErrorInfo*)[[parser items] objectAtIndex:0];
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[errorInfo code] message:[errorInfo message]
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];  
	}
}

-(void) startInstanceAction:(id)sender {
	NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [date dateByAddingTimeInterval:120];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *date1 = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *date2 = [dateFormatter stringFromDate:date];
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"StartInstances" forKey:@"Action"];
	[dict setObject:@"2010-08-31" forKey:@"Version"];
	[dict setObject:[instanceInfo instanceId] forKey:@"InstanceId.1"];
	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
	
	NSString *urlToUse = [AWSUtils getQueryString:dict];
	Response *response = [Connection get:urlToUse];
	
	if([response statusCode] == 200){
		StopInstanceParser *parser = [[[StopInstanceParser alloc] init] autorelease];
		StopInstanceInfo *stopInstanceInfo = nil;
		if([parser parseData:	[response body]]){
			stopInstanceInfo = (StopInstanceInfo*)[[parser items] objectAtIndex:0];
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:[NSString stringWithFormat:@"An instance with id: %@ is %@", [stopInstanceInfo instanceId],[stopInstanceInfo currentState]]
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];  
	} else {
		ErrorParser *parser = [[[ErrorParser alloc] init] autorelease];
		ErrorInfo *errorInfo = nil;
		if([parser parseData:	[response body]]){
			errorInfo = (ErrorInfo*)[[parser items] objectAtIndex:0];
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[errorInfo code] message:[errorInfo message]
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];  
	}
}


-(void) attachEbsAction:(id)sender {
	EBSViewController *controller = [[EBSViewController alloc] initWithNibName:@"EBSViewController" bundle:nil];
	[controller setDelegate:self];
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}

-(void) cloudWatchAction:(id)sender {
	CloudWatchViewController *controller = [[CloudWatchViewController alloc] initWithInstanceId:[instanceInfo instanceId]];
	//[controller setDelegate:self];
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}


-(void) refresh:(id)sender {
	NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [date dateByAddingTimeInterval:120];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *date1 = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *date2 = [dateFormatter stringFromDate:date];
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"DescribeInstances" forKey:@"Action"];
	[dict setObject:[instanceInfo instanceId] forKey:@"InstanceId.1"];
	[dict setObject:@"2010-08-31" forKey:@"Version"];
	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
	
	
	Response *response = [Connection get:[AWSUtils getQueryString:dict]];
	
	if([response statusCode] == 200){
		RunningInstanceParser *parser = [[[RunningInstanceParser alloc] init] autorelease];
		
		if([parser parseData:[response body]]){
			[self setInstanceInfo:(RunningInstanceInfo*)[[[[NSMutableArray alloc] initWithArray:[parser items]] autorelease] objectAtIndex:0]];
		}		
		
		[self.tableView reloadData];
	} else {
		ErrorParser *parser = [[[ErrorParser alloc] init] autorelease];
		ErrorInfo *errorInfo = nil;
		if([parser parseData:	[response body]]){
			errorInfo = (ErrorInfo*)[[parser items] objectAtIndex:0];
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[errorInfo code] message:[errorInfo message]
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];  	
	}

}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	// For example: self.myOutlet = nil;
}


- (void)dealloc {
	[super dealloc];
}


@end

