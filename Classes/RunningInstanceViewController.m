//
//  RunningInstanceViewController.m
//  AWSManager
//
//  Created by Adil Mezghouti on 11/1/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "RunningInstanceViewController.h"
#import "RunningInstanceParser.h"
#import "AWSUtils.h"
#import "Response.h"
#import "Connection.h"
#import "RunningInstanceInfo.h"
#import "RunningInstanceDetailViewController.h"
#import "ErrorInfo.h"
#import "ErrorParser.h"

@implementation RunningInstanceViewController
@synthesize instanceArray;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"My Running Instances"];
	
	if([instanceArray count] == 0){
		NSDate *date = [[[NSDate alloc] init] autorelease];
		date = [date dateByAddingTimeInterval:120];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *date1 = [dateFormatter stringFromDate:date];
		[dateFormatter setDateFormat:@"HH:mm:ss"];
		NSString *date2 = [dateFormatter stringFromDate:date];
		
		NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
		[dict setObject:@"DescribeInstances" forKey:@"Action"];
		[dict setObject:@"2010-08-31" forKey:@"Version"];
		[dict setObject:@"2" forKey:@"SignatureVersion"];
		[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
		[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];

		//show the running instances in all the regions
		[dict setObject:@"availability-zone" forKey:@"Filter.1.Name"];
		[dict setObject:@"*" forKey:@"Filter.1.Value"];
		
		
		Response *response = [Connection get:[AWSUtils getQueryString:dict]];
		
		if([response statusCode] == 200){
			RunningInstanceParser *parser = [[[RunningInstanceParser alloc] init] autorelease];
			
			if([parser parseData:[response body]]){
				instanceArray = [[NSMutableArray alloc] initWithArray:[parser items]];
			}
			
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
	
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [instanceArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];	
		
	}
	
	[cell.textLabel setNumberOfLines:3];
	[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	[cell.textLabel setText:[(RunningInstanceInfo*)[instanceArray objectAtIndex:indexPath.row] instanceId]];
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RunningInstanceDetailViewController *controller = [[RunningInstanceDetailViewController alloc] initWithInstanceInfo:(RunningInstanceInfo*)[instanceArray objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:controller animated:TRUE];
	[controller release];
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARNING");
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[instanceArray release];
    [super dealloc];
}


@end

