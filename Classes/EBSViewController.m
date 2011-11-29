//
//  EBSViewController.m
//  AWSManager
//
//  Created by Adil Mezghouti on 11/12/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "EBSViewController.h"
#import "AWSUtils.h"
#import "Connection.h"
#import "EBSDeviceListParser.h"
#import "Response.h"
#import "AttachDetachVolumeParser.h"
#import "ErrorParser.h"

@implementation EBSViewController
@synthesize delegate, ebsArray, selectedVolume;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"EBS Devices"];
	
	UIButton *attachEbsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[attachEbsBtn setFrame:CGRectMake(40, 10, 110, 25)];
	[attachEbsBtn setTitle:@"Attach Device" forState:UIControlStateNormal];
	[attachEbsBtn addTarget:self action:@selector(attachEbsAction:) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *detachEbsBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[detachEbsBtn setFrame:CGRectMake(170, 10, 110, 25)];
	[detachEbsBtn setTitle:@"Detach Device" forState:UIControlStateNormal];
	[detachEbsBtn addTarget:self action:@selector(detachEbsAction:) forControlEvents:UIControlEventTouchUpInside];
	
	
	UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(8.0, 0.0, 304.0, 122.0)] autorelease];
	[footerView addSubview:detachEbsBtn];
	[footerView addSubview:attachEbsBtn];
	[self.tableView setTableFooterView:footerView];
	
	
	if([ebsArray count] == 0){
		NSDate *date = [[[NSDate alloc] init] autorelease];
		date = [date dateByAddingTimeInterval:120];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *date1 = [dateFormatter stringFromDate:date];
		[dateFormatter setDateFormat:@"HH:mm:ss"];
		NSString *date2 = [dateFormatter stringFromDate:date];
		
		NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
		[dict setObject:@"DescribeVolumes" forKey:@"Action"];
		[dict setObject:@"2010-08-31" forKey:@"Version"];
		
		
		[dict setObject:@"2" forKey:@"SignatureVersion"];
		[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
		[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
		
		Response *response = [Connection get:[AWSUtils getQueryString:dict]];

		
		EBSDeviceListParser *parser = [[[EBSDeviceListParser alloc] init] autorelease];
		
		if([parser parseData:[response body]]){
			ebsArray = [[NSMutableArray alloc] initWithArray:[parser items]];
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
    return [ebsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
	
	[cell.textLabel setNumberOfLines:4];
	[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
	
	if([[(AttachVolumeInfo*)[ebsArray objectAtIndex:indexPath.row] status] isEqual:@"attached"] ||
	   [[(AttachVolumeInfo*)[ebsArray objectAtIndex:indexPath.row] status] isEqual:@"attaching"] ||
	   [[(AttachVolumeInfo*)[ebsArray objectAtIndex:indexPath.row] status] isEqual:@"detaching"]){
		NSString *selectedInstance = @"Current Instance";
		if(![[[delegate instanceInfo] instanceId] isEqual:[(AttachVolumeInfo*)[ebsArray objectAtIndex:indexPath.row] instanceId]]){
			selectedInstance = [(AttachVolumeInfo*)[ebsArray objectAtIndex:indexPath.row] instanceId];
		}
		[cell.textLabel setText:[NSString stringWithFormat:@"Volume Id: %@\nStatus: %@\nDelete ON Termination: %@\nAttached to: %@" ,[(AttachVolumeInfo*)[ebsArray objectAtIndex:indexPath.row] volumeId],
								 [(AttachVolumeInfo*)[ebsArray objectAtIndex:indexPath.row] status],
								 [(AttachVolumeInfo*)[ebsArray objectAtIndex:indexPath.row] deleteOnTermination],
								 selectedInstance]];
		
	} else {
		[cell.textLabel setText:[NSString stringWithFormat:@"Volume Id: %@\nStatus: %@\nDelete ON Termination: %@" ,[(AttachVolumeInfo*)[ebsArray objectAtIndex:indexPath.row] volumeId],
								 [(AttachVolumeInfo*)[ebsArray objectAtIndex:indexPath.row] status],
								 [(AttachVolumeInfo*)[ebsArray objectAtIndex:indexPath.row] deleteOnTermination]]];
		
	}
	
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self setSelectedVolume:[(AttachVolumeInfo*)[ebsArray objectAtIndex:indexPath.row] volumeId]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

#pragma mark -
#pragma mark methods implementations
-(void)attachEbsAction:(id)sender {
	NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [date dateByAddingTimeInterval:120];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *date1 = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *date2 = [dateFormatter stringFromDate:date];
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"AttachVolume" forKey:@"Action"];
	[dict setObject:@"2010-08-31" forKey:@"Version"];
	[dict setObject:[[delegate instanceInfo] instanceId] forKey:@"InstanceId"];
	[dict setObject:self.selectedVolume forKey:@"VolumeId"];
	[dict setObject:@"/dev/sdh" forKey:@"Device"];
	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
	
	Response *response = [Connection get:[AWSUtils getQueryString:dict]];
	
	
	if([response statusCode] == 200){
		AttachDetachVolumeParser *parser = [[[AttachDetachVolumeParser alloc] init] autorelease];
		AttachVolumeInfo *volumeInfo = nil;
		if([parser parseData:	[response body]]){
			volumeInfo = (AttachVolumeInfo*)[[parser items] objectAtIndex:0];
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:[NSString stringWithFormat:@"Selected volume status is: ",[volumeInfo status]]
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

-(void)detachEbsAction:(id)sender {
	NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [date dateByAddingTimeInterval:120];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *date1 = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *date2 = [dateFormatter stringFromDate:date];
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"DetachVolume" forKey:@"Action"];
	[dict setObject:@"2010-08-31" forKey:@"Version"];
	[dict setObject:[[delegate instanceInfo] instanceId] forKey:@"InstanceId"];
	[dict setObject:self.selectedVolume forKey:@"VolumeId"];
	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
	
	Response *response = [Connection get:[AWSUtils getQueryString:dict]];
	
	
	if([response statusCode] == 200){
		AttachDetachVolumeParser *parser = [[[AttachDetachVolumeParser alloc] init] autorelease];
		AttachVolumeInfo *volumeInfo = nil;
		if([parser parseData:	[response body]]){
			volumeInfo = (AttachVolumeInfo*)[[parser items] objectAtIndex:0];
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:[NSString stringWithFormat:@"Selected volume status is: ",[volumeInfo status]]
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
	[ebsArray release];
	[selectedVolume release];
}


@end

