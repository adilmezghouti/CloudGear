//
//  AccountViewController.m
//  AWSManager
//
//  Created by Adil Mezghouti on 11/12/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "AccountViewController.h"
#import "SFHFKeychainUtils.h"

@implementation AccountViewController

-(void) viewDidLoad {
	[super viewDidLoad];
	[self setTitle:@"Security Settings"];
}

-(void) viewDidAppear:(BOOL)animated {
	NSError *error = nil;
	accessKeyTxt.text = [SFHFKeychainUtils getPasswordForUsername:@"accesskeyid" andServiceName:@"com.adilmezghouti.awsmanager" error:&error];
	privateKeyTxt.text = [SFHFKeychainUtils getPasswordForUsername:@"privatekey" andServiceName:@"com.adilmezghouti.awsmanager" error:&error];
}

#pragma mark --
#pragma mark button event handling

-(void)updateKeys:(id)sender{
	NSError *error = nil;
	if([[accessKeyTxt text] length] == 0 || [[privateKeyTxt text] length] == 0){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Both private and access keys are required"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];  		
	} else {
		[SFHFKeychainUtils storeUsername:@"accesskeyid" andPassword:[accessKeyTxt text] forServiceName:@"com.adilmezghouti.awsmanager" updateExisting:1 error:&error];
		[SFHFKeychainUtils storeUsername:@"privatekey" andPassword:[privateKeyTxt text] forServiceName:@"com.adilmezghouti.awsmanager" updateExisting:1 error:&error];
	}
}

-(void)deleteKeys:(id)sender{
	NSError *error = nil;
	[SFHFKeychainUtils deleteItemForUsername:@"accesskeyid" andServiceName:@"com.adilmezghouti.awsmanager" error:&error];
	[SFHFKeychainUtils deleteItemForUsername:@"privatekey" andServiceName:@"com.adilmezghouti.awsmanager" error:&error];
	[accessKeyTxt setText:@""];
	[privateKeyTxt setText:@""];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
