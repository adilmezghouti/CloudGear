//
//  LaunchingInstancePropertiesViewController.m
//  AWSManager
//
//  Created by Adil Mezghouti on 6/5/11.
//  Copyright 2011 Adil Mezghouti university. All rights reserved.
//

#import "LaunchingInstancePropertiesViewController.h"
#import "Response.h"
#import "ErrorInfo.h"
#import "ErrorParser.h"
#import "Connection.h"
#import "AWSUtils.h"
#import "XPathQuery.h"

@implementation LaunchingInstancePropertiesViewController
@synthesize pickerDataArray,keyPairArray,securityGroupsArray, availabilityZonesArray, currentTextField, imageId,actionSheet;

- (id)initWithImageId:(NSString *)myImageId
{
    
    if([self = self init]){
        self = [self initWithNibName:@"LaunchingInstancePropertiesViewController" bundle:nil];
        self.imageId = myImageId;
    }
    return self;
}


#pragma mark -
#pragma mark - UIPickerView Methods implementation
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerDataArray count];
    
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerDataArray objectAtIndex:row];
}


#pragma mark - Some picker helper methods
-(CGRect) pickerFrameWithSize:(CGSize) size andY:(CGFloat)y {
    CGRect pickerRect = CGRectMake(0, y, size.width, size.height - 50);
    return pickerRect;
                         
}

-(void) createPickerForTextField:(UITextField*) textField {
    if(textField == availabilityZoneTxtField){
        [self.pickerDataArray removeAllObjects];
        [self.pickerDataArray addObjectsFromArray:availabilityZonesArray];
    } else if(textField == keyPairTxtField){
        [self.pickerDataArray removeAllObjects];
        [self.pickerDataArray addObjectsFromArray:keyPairArray];
    } else if(textField == securityGroupTxtField){
        [self.pickerDataArray removeAllObjects];
        [self.pickerDataArray addObjectsFromArray:securityGroupsArray];
    } else if(textField == instanceTypeTxtField){
        [self.pickerDataArray removeAllObjects];
        [self.pickerDataArray addObjectsFromArray:[NSArray arrayWithObjects:
         @"1.small", @"m1.large", @"m1.xlarge",
         @"c1.medium", @"c1.xlarge", @"m2.xlarge", @"m2.2xlarge",
         @"m2.4xlarge",@"cc1.4xlarge",@"cg1.4xlarge",@"t1.micro",nil]];
    }
    
    
    
    
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        
        CGRect pickerFrame = CGRectMake(0, 40, 0, -40);
        
        myPickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
        myPickerView.showsSelectionIndicator = YES;
        myPickerView.dataSource = self;
        myPickerView.delegate = self;
        
        [actionSheet addSubview:myPickerView];
        [myPickerView release];
        
        UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
        closeButton.momentary = YES; 
        closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
        closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
        closeButton.tintColor = [UIColor blackColor];
        [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
        [actionSheet addSubview:closeButton];
        [closeButton release];
        
        [actionSheet showInView:self.view];
        
        [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
        
    
    

//    if(myPickerView == nil){
//        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
//        myPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//        CGSize pickerSize = [myPickerView sizeThatFits:CGSizeZero];
//        myPickerView.frame = [self pickerFrameWithSize:pickerSize andY:textField.bounds.origin.y];
//        myPickerView.showsSelectionIndicator = YES; // note this is default to NO
//        myPickerView.delegate = self;
//        myPickerView.dataSource = self;
//        [self.view addSubview:myPickerView];
//    } else {
//        myPickerView.hidden = false;
//        [myPickerView reloadAllComponents];
//    }
    

}

-(void) dismissActionSheet {    
    currentTextField.text = [pickerDataArray objectAtIndex:[myPickerView selectedRowInComponent:0]];
    [actionSheet dismissWithClickedButtonIndex:0 animated:true]; 
}

-(void) retrieveKeyPair {
    NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [date dateByAddingTimeInterval:120];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *date1 = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *date2 = [dateFormatter stringFromDate:date];
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"DescribeKeyPairs" forKey:@"Action"];
	[dict setObject:@"2010-08-31" forKey:@"Version"];
	//[dict setObject:@"*" forKey:@"KeyName.1"];
	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
	
	NSString *urlToUse = [AWSUtils getQueryString:dict];
	Response *response = [Connection get:urlToUse];

	//NSLog(@"XPath=====> %@",[PerformXMLXPathQuery([response body], @"//keyName/text()") objectAtIndex:0]);
    self.keyPairArray = [NSMutableArray arrayWithArray:PerformXMLXPathQuery([response body], @"//keyName/text()")];
    
}

-(void) retrieveSecurityGroups {
    NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [date dateByAddingTimeInterval:120];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *date1 = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *date2 = [dateFormatter stringFromDate:date];
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"DescribeSecurityGroups" forKey:@"Action"];
	[dict setObject:@"2010-08-31" forKey:@"Version"];

	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
	
	NSString *urlToUse = [AWSUtils getQueryString:dict];
	Response *response = [Connection get:urlToUse];
	
    //NSLog(@"XPath=====> %@",[PerformXMLXPathQuery([response body], @"//groupName/text()") objectAtIndex:0]);
    self.securityGroupsArray = [[NSMutableArray alloc] init];
    NSSet *set = [NSSet setWithArray:PerformXMLXPathQuery([response body], @"//groupName/text()")];                            
    [securityGroupsArray addObjectsFromArray:[set allObjects]];
}

-(void) retrieveAvailabilityZones {
    NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [date dateByAddingTimeInterval:120];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *date1 = [dateFormatter stringFromDate:date];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *date2 = [dateFormatter stringFromDate:date];
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"DescribeAvailabilityZones" forKey:@"Action"];
	[dict setObject:@"2010-08-31" forKey:@"Version"];
    
	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
	
	NSString *urlToUse = [AWSUtils getQueryString:dict];
	Response *response = [Connection get:urlToUse];
	
    self.availabilityZonesArray = [NSMutableArray arrayWithArray:PerformXMLXPathQuery([response body], @"//item/zoneName/text()")];

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
	[dict setObject:imageId forKey:@"ImageId"];
	[dict setObject:[numberOfInstancesTxtField text] forKey:@"MaxCount"];
	[dict setObject:@"1" forKey:@"MinCount"];
    [dict setObject:[availabilityZoneTxtField text] forKey:@"Placement.AvailabilityZone"];
	[dict setObject:[advancedMonitoringSwitch isOn] ? @"true":@"false"  forKey:@"Monitoring.Enabled"];
    [dict setObject:[securityGroupTxtField text] forKey:@"SecurityGroup.1"];
    [dict setObject:[keyPairTxtField text] forKey:@"KeyName"];
    
	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", date1, date2] forKey:@"Expires"];
	
	NSString *urlToUse = [AWSUtils getQueryString:dict];
	Response *response = [Connection get:urlToUse];
	
	if([response statusCode] == 200){
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


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Custom Instance Launch"];

    availabilityZoneTxtField.delegate = self;
    securityGroupTxtField.delegate = self;
    keyPairTxtField.delegate = self;
    numberOfInstancesTxtField.delegate = self;
    instanceTypeTxtField.delegate = self;
    pickerDataArray = [[NSMutableArray alloc] init];
    
    [self retrieveKeyPair];
    [self retrieveSecurityGroups];
    [self retrieveAvailabilityZones];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if(textField == numberOfInstancesTxtField){
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField != numberOfInstancesTxtField){
        [self createPickerForTextField:textField];
        self.currentTextField = textField;
        return NO;
    } else {
        return YES;
    }
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    [actionSheet dismissWithClickedButtonIndex:0 animated:true]; 
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


@end
