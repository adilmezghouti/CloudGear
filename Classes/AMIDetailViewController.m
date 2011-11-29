//
//  AMIDetailViewController.m
//  AWSManager
//
//  Created by Adil Mezghouti on 10/21/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "AMIDetailViewController.h"
#import "AWSUtils.h"
#import "Response.h"
#import "Connection.h"
#import "RunInstanceParser.h"
#import "ErrorInfo.h"
#import "ErrorParser.h"
#import "LaunchingInstancePropertiesViewController.h"


@implementation AMIDetailViewController
@synthesize instanceInfo, amiInfo;

#pragma mark -
#pragma mark View lifecycle


-(id) initWithAMIInfo:(AMIInfo *)amiInformation {
	if([self init]){
		self = [self initWithNibName:@"AMIDetailViewController" bundle:nil];
		[self setAmiInfo:amiInformation];
	}
	return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"AMI Details"];
	[imageId setText:[self.amiInfo imageId]];
	[imageState setText:[self.amiInfo imageState]];
	[imageLocation setText:[self.amiInfo imageLocation]];
}

-(void) launchCustomInstance:(id)sender {
    LaunchingInstancePropertiesViewController *controller = [[LaunchingInstancePropertiesViewController alloc] initWithImageId:amiInfo.imageId];
    [self.navigationController pushViewController:controller animated:true];
    [controller release];
}


-(void) launchInstance:(id)sender {
	NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [date dateByAddingTimeInterval:120];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *date1 = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *date2 = [dateFormatter stringFromDate:date];
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"RunInstances" forKey:@"Action"];
	[dict setObject:@"2010-08-31" forKey:@"Version"];
	[dict setObject:[amiInfo imageId] forKey:@"ImageId"];
	[dict setObject:@"1" forKey:@"MaxCount"];
	[dict setObject:@"1" forKey:@"MinCount"];
	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
	
	NSString *urlToUse = [AWSUtils getQueryString:dict];
	Response *response = [Connection get:urlToUse];
	
	if([response statusCode] == 200){
		RunInstanceParser *parser = [[[RunInstanceParser alloc] init] autorelease];
		if([parser parseData:	[response body]]){
			[self setInstanceInfo:(RunInstanceInfo*)[[parser items] objectAtIndex:0]];
		}				
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:[NSString stringWithFormat:@"An instance has been launched successfully"]
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
    //self.imageId = nil;
//	self.imageState = nil;
//	self.imageLocation = nil;
}


- (void)dealloc {
	[instanceInfo release];
	[amiInfo release];
    [super dealloc];
}


@end

