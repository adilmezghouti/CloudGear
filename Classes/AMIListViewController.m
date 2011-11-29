//
//  HomeViewController.m
//  AWSManager
//
//  Created by Adil Mezghouti on 10/17/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "AMIListViewController.h"
#import "AWSUtils.h"
#import "Response.h"
#import "AMIListParser.h"
#import "RunningInstanceParser.h"
#import "Connection.h"
#import "AMIDetailViewController.h"
#import "ErrorInfo.h"
#import "ErrorParser.h"


@implementation AMIListViewController
@synthesize amiArray, amiType;

#pragma mark -
#pragma mark View lifecycle

-(id) initWithNibName:(NSString *)nibNameOrNil amiType:(NSString *)amiTypeArgument {
	if((self = [self initWithNibName:@"AMIListViewController" bundle:nil])){
		[self setAmiType:amiTypeArgument];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"List of VMs"];

	if([amiArray count] == 0){
		NSDate *date = [[[NSDate alloc] init] autorelease];
		date = [date dateByAddingTimeInterval:120];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *date1 = [dateFormatter stringFromDate:date];
		[dateFormatter setDateFormat:@"HH:mm:ss"];
		NSString *date2 = [dateFormatter stringFromDate:date];
		
		NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
		[dict setObject:@"DescribeImages" forKey:@"Action"];
		[dict setObject:@"2010-08-31" forKey:@"Version"];
		
		if([self.amiType isEqualToString:@"amazon"]){
			[dict setObject:@"owner-alias" forKey:@"Filter.1.Name"];			
			[dict setObject:@"amazon" forKey:@"Filter.1.Value.1"];
			[self setTitle:@"List of Amazon AMIs"];
		} else if([self.amiType isEqualToString:@"public"]) {
			[dict setObject:@"is-public" forKey:@"Filter.1.Name"];			
			[dict setObject:@"true" forKey:@"Filter.1.Value.1"];
			[self setTitle:@"List of Public AMIs"];
		} else if([self.amiType isEqualToString:@"self"]){
			[dict setObject:@"owner-alias" forKey:@"Filter.1.Name"];			
			[dict setObject:@"self" forKey:@"Filter.1.Value.1"];
			[self setTitle:@"My AMIs"];
		}

		[dict setObject:@"image-id" forKey:@"Filter.2.Name"];			
		[dict setObject:@"*ami*" forKey:@"Filter.2.Value.1"];

		
		[dict setObject:@"2" forKey:@"SignatureVersion"];
		[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
		[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
		
		NSString *urlToUse = [AWSUtils getQueryString:dict];
		Response *response = [Connection get:urlToUse];
		
		
		if([response statusCode] == 200){
			AMIListParser *parser = [[[AMIListParser alloc] init] autorelease];
			
			
			if([parser parseData:[response body]]){
				amiArray = [[NSMutableArray alloc] initWithArray:[parser items]];
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
    return [amiArray count];
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

	[cell.textLabel setText:[(AMIInfo*)[amiArray objectAtIndex:indexPath.row] imageLocation]];
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [date dateByAddingTimeInterval:120];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *date1 = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *date2 = [dateFormatter stringFromDate:date];
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"DescribeImages" forKey:@"Action"];
	[dict setObject:@"2010-08-31" forKey:@"Version"];
	
	if([self.amiType isEqualToString:@"amazon"]){
		[dict setObject:@"owner-alias" forKey:@"Filter.1.Name"];			
		[dict setObject:@"amazon" forKey:@"Filter.1.Value.1"];
	} else if([self.amiType isEqualToString:@"public"]) {
		[dict setObject:@"is-public" forKey:@"Filter.1.Name"];			
		[dict setObject:@"true" forKey:@"Filter.1.Value.1"];
	}	
	
	[dict setObject:@"manifest-location" forKey:@"Filter.2.Name"];
	[dict setObject:[NSString stringWithFormat:@"*%@*",[searchBar text]] forKey:@"Filter.2.Value.1"];
	
	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
	
	NSString *urlToUse = [AWSUtils getQueryString:dict];
	
	
	Response *response = [Connection get:urlToUse];
	[searchBar resignFirstResponder];
	
	if([response statusCode] == 200){
		AMIListParser *parser = [[[AMIListParser alloc] init] autorelease];
		[amiArray removeAllObjects];
		if([parser parseData:[response body]]){
			amiArray = [[NSMutableArray alloc] initWithArray:[parser items]];
		}
		
		[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];		
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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	return YES;
}


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AMIDetailViewController *controller = [[AMIDetailViewController alloc] initWithAMIInfo:(AMIInfo*)[amiArray objectAtIndex:indexPath.row]];
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
	[amiArray release];
    [super dealloc];
}


@end

