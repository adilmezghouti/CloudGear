//
//  HomeViewController.m
//  AWSManager
//
//  Created by Adil Mezghouti on 10/17/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "HomeViewController.h"
#import "AMIListViewController.h"
#import "RunningInstanceViewController.h"
#import "AccountViewController.h"
#import "SFHFKeychainUtils.h"

#define kActivityIndicatorWidth  15.0
#define kActivityIndicatorHeight  15.0

@implementation HomeViewController
@synthesize banner,activityIndicator1, activityIndicator2, activityIndicator3, activityIndicator4, activityIndicator5;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"Cloud Gear Menu"];
	
	if(banner == nil)
    {
        [self createADBannerView];
    }
    [self layoutForCurrentOrientation:NO];
	
	
	CGRect frame = CGRectMake((360  - kActivityIndicatorWidth - 90), 
							  ((50 - kActivityIndicatorWidth) / 2.0), 
							  kActivityIndicatorWidth, 
							  kActivityIndicatorWidth);
	[self setActivityIndicator1:[[UIActivityIndicatorView alloc] initWithFrame:frame]];
	[self setActivityIndicator2:[[UIActivityIndicatorView alloc] initWithFrame:frame]];
	[self setActivityIndicator3:[[UIActivityIndicatorView alloc] initWithFrame:frame]];
	[self setActivityIndicator4:[[UIActivityIndicatorView alloc] initWithFrame:frame]];
	[self setActivityIndicator5:[[UIActivityIndicatorView alloc] initWithFrame:frame]];
	
	[self.activityIndicator1 hidesWhenStopped];
	[self.activityIndicator2 hidesWhenStopped];
	[self.activityIndicator3 hidesWhenStopped];
	[self.activityIndicator4 hidesWhenStopped];
	[self.activityIndicator5 hidesWhenStopped];
	
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutForCurrentOrientation:NO];
}

-(void) viewDidAppear:(BOOL)animated {
	[self.activityIndicator1 stopAnimating];
	[self.activityIndicator2 stopAnimating];
	[self.activityIndicator3 stopAnimating];
	[self.activityIndicator4 stopAnimating];
	[self.activityIndicator5 stopAnimating];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
    }
	
	if(indexPath.row == 0){
		[cell.textLabel setText:@"Amazon AMIs"];
		[[cell contentView] addSubview:self.activityIndicator1];
	} else if (indexPath.row == 1) {
		[cell.textLabel setText:@"Public AMIs"];
		[[cell contentView] addSubview:self.activityIndicator2];
	} else if (indexPath.row == 2) {
		[cell.textLabel setText:@"My AMIs"];
		[[cell contentView] addSubview:self.activityIndicator3];
	} else if (indexPath.row == 3) {
		[cell.textLabel setText:@"My Running Instances"];
		[[cell contentView] addSubview:self.activityIndicator4];
	} else if (indexPath.row == 4) {
		[cell.textLabel setText:@"Security Settings"];
		[[cell contentView] addSubview:self.activityIndicator5];
	}
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSError *error = nil;
	if([SFHFKeychainUtils getPasswordForUsername:@"accesskeyid" andServiceName:@"com.adilmezghouti.awsmanager" error:&error] == nil || 
	   [SFHFKeychainUtils getPasswordForUsername:@"privatekey" andServiceName:@"com.adilmezghouti.awsmanager" error:&error] == nil){
		if (indexPath.row == 4){
			[NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self.activityIndicator5 withObject:nil];
			AccountViewController *controller = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
			[self.navigationController pushViewController:controller animated:TRUE];
			[controller release];
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Please update your security settings first."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];  		
		}
	}else {
		if(indexPath.row == 0){
			[NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self.activityIndicator1 withObject:nil];
			AMIListViewController *controller = [[AMIListViewController alloc] initWithNibName:@"AMIListViewController" amiType:@"amazon"];
			[self.navigationController pushViewController:controller animated:TRUE];
			[controller release];
		} else if (indexPath.row == 1) {
			[NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self.activityIndicator2 withObject:nil];
			AMIListViewController *controller = [[AMIListViewController alloc] initWithNibName:@"AMIListViewController" amiType:@"public"];
			[self.navigationController pushViewController:controller animated:TRUE];
			[controller release];		
		} else if (indexPath.row == 2) {
			[NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self.activityIndicator3 withObject:nil];
			AMIListViewController *controller = [[AMIListViewController alloc] initWithNibName:@"AMIListViewController" amiType:@"self"];
			[self.navigationController pushViewController:controller animated:TRUE];
			[controller release];		
		} else if (indexPath.row == 3) {
			[NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self.activityIndicator4 withObject:nil];
			RunningInstanceViewController *controller = [[RunningInstanceViewController alloc] initWithNibName:@"RunningInstanceViewController" bundle:nil];
			[self.navigationController pushViewController:controller animated:TRUE];
			[controller release];		
		} else if (indexPath.row == 4){
			[NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self.activityIndicator5 withObject:nil];
			AccountViewController *controller = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
			[self.navigationController pushViewController:controller animated:TRUE];
			[controller release];
		} 
		
	}
	
}

#pragma mark -
#pragma mark Methods implementation
-(void)createADBannerView
{
    NSString *contentSize = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifierLandscape;
    CGRect frame;
    frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:contentSize];
    frame.origin = CGPointMake(0.0, CGRectGetMaxY(self.view.bounds));
    
    // Now to create and configure the banner view
    ADBannerView *bannerView = [[ADBannerView alloc] initWithFrame:frame];
    // Set the delegate to self, so that we are notified of ad responses.
    bannerView.delegate = self;
    // Set the autoresizing mask so that the banner is pinned to the bottom
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    // Since we support all orientations in this view controller, support portrait and landscape content sizes.
    // If you only supported landscape or portrait, you could remove the other from this set.
    bannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    
    // At this point the ad banner is now be visible and looking for an ad.
    [self.view addSubview:bannerView];
    self.banner = bannerView;
    [bannerView release];
}

-(void)layoutForCurrentOrientation:(BOOL)animated
{
    CGFloat animationDuration = animated ? 0.2 : 0.0;
    // by default content consumes the entire view area
    CGRect contentFrame = self.view.bounds;
    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by the banner height to get the final position
	CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat bannerHeight = 0.0;
    
    banner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	bannerHeight = 50.0;
    
    // Depending on if the banner has been loaded, we adjust the content frame and banner location
    // to accomodate the ad being on or off screen.
    // This layout is for an ad at the bottom of the view.
    if(banner.bannerLoaded)
    {
        contentFrame.size.height -= bannerHeight;
		bannerOrigin.y -= bannerHeight;
    }
    else
    {
		bannerOrigin.y += bannerHeight;
    }
    
    // And finally animate the changes, running layout for the content view if required.
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.tableView.tableFooterView.frame = contentFrame;
                         [self.tableView.tableFooterView layoutIfNeeded];
                         banner.frame = CGRectMake(bannerOrigin.x, bannerOrigin.y, banner.frame.size.width, banner.frame.size.height);
                     }];
}


#pragma mark -
#pragma mark ADBannerViewDelegate methods

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutForCurrentOrientation:YES];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self layoutForCurrentOrientation:YES];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
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
	self.banner.delegate = nil;
	[banner release];
	[activityIndicator1 release];
	[activityIndicator2 release];
	[activityIndicator3 release];
	[activityIndicator4 release];
	[activityIndicator5 release];
    [super dealloc];
}


@end

