//
//  CloudWatchViewController.m
//  AWSManager
//
//  Created by Adil Mezghouti on 5/17/11.
//  Copyright 2011 Adil Mezghouti university. All rights reserved.
//

#import "CloudWatchViewController.h"
#import "Response.h"
#import "Connection.h"
#import "AWSUtils.h"
#import "CloudWatchDataPointsParser.h"
#import "ErrorInfo.h"
#import "ErrorParser.h"
#import "CloudWatchDatapointInfo.h"

@implementation CloudWatchViewController
@synthesize instanceId, dataPointsArray, chartArray, CPUUtilizationView, networkView, banner;

#pragma mark -
#pragma mark View lifecycle


- (id) initWithInstanceId:(NSString*) myInstanceId {
	if([self init]){
		self = [self initWithNibName:@"CloudWatchViewController" bundle:nil];
		[self setInstanceId:myInstanceId];
		chartArray = [[NSMutableArray alloc] init];
	}
	
	return self;
	
}

NSInteger sortData(id v1, id v2, void *context){
    NSDate* date1 = [NSDate dateWithNaturalLanguageString:((CloudWatchDatapointInfo*)v1).timeStamp
                                                  locale:[[NSLocale alloc] init]];
    NSDate* date2 = [NSDate dateWithNaturalLanguageString:((CloudWatchDatapointInfo*)v2).timeStamp
                                                   locale:[[NSLocale alloc] init]];

    return [date1 compare:date2];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"Last 10 Hours Stats"];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	double maxNetworkIn = 0;
	NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [date dateByAddingTimeInterval:120];
	NSDate *startDate = [[[NSDate alloc] init] autorelease];
	startDate = [startDate dateByAddingTimeInterval:-36000];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	NSDateFormatter *timeFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *expirationDate = [dateFormatter stringFromDate:date];
	[timeFormatter setDateFormat:@"HH:mm:ss"];
	NSString *expirationTime = [timeFormatter stringFromDate:date];
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setObject:@"GetMetricStatistics" forKey:@"Action"];
	[dict setObject:@"2010-08-01" forKey:@"Version"];
	[dict setObject:@"2" forKey:@"SignatureVersion"];
	[dict setObject:@"HmacSHA256" forKey:@"SignatureMethod"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@-07:00", expirationDate, expirationTime] forKey:@"Expires"];
	
	[dict setObject:@"CPUUtilization" forKey:@"MetricName"];
	[dict setObject:@"600" forKey:@"Period"];
	[dict setObject:@"Maximum" forKey:@"Statistics.member.1"];
	[dict setObject:@"InstanceId" forKey:@"Dimensions.member.1.Name"];
	[dict setObject:self.instanceId forKey:@"Dimensions.member.1.Value"];
	[dict setObject:@"AWS/EC2" forKey:@"Namespace"];
	
	NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
	[dateFormatter setTimeZone:timeZone];
	[timeFormatter setTimeZone:timeZone];
	
	[dict setObject:[NSString stringWithFormat:@"%@T%@",[dateFormatter stringFromDate:startDate],[timeFormatter stringFromDate:startDate]] forKey:@"StartTime"];
	[dict setObject:[NSString stringWithFormat:@"%@T%@",[dateFormatter stringFromDate:date],[timeFormatter stringFromDate:date] ] forKey:@"EndTime"];
	
	//Populate the CPU Utilization graph
	Response *response = [Connection get:[AWSUtils getQueryStringForCloudWatch:dict]];
	
	if([response statusCode] == 200){
		 
		CloudWatchDataPointsParser *parser = [[[CloudWatchDataPointsParser alloc] init] autorelease];
		
		[parser parseData:[response body]];
        NSMutableArray *networkDataArray = [[NSMutableArray alloc] initWithArray:[parser items]];
        [networkDataArray sortUsingFunction:sortData context:nil];
		NSString *cpuData = [networkDataArray componentsJoinedByString:@","];

		NSString* chartUrl = [NSString stringWithFormat:@"http://chart.googleapis.com/chart?cht=lc&chs=250x150&chd=t:%@&chxt=x,y&chxs=0,ff0000,12,0,lt|1,0000ff,10,1,lt&chxl=0:|-10|-9|-8|-7|-6|-5|-4|-3|-2|-1&chdl=CPU Utilization&chdlp=bv",cpuData];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[chartUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
		NSURLResponse *response1;
		NSError *error;
		
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response1 error:&error];
		UIImage *image = [[UIImage alloc] initWithData:data];
		if(image){
			[CPUUtilizationView setImage:image];					
		}
        [networkDataArray release];
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
	
	NSString *networkInData = [[NSString alloc] init];
	//Populate the NetworkIn graph
	[dict setObject:@"NetworkIn" forKey:@"MetricName"];
	
	response = [Connection get:[AWSUtils getQueryStringForCloudWatch:dict]];
	
	if([response statusCode] == 200){
		
		CloudWatchDataPointsParser *parser = [[[CloudWatchDataPointsParser alloc] init] autorelease];
		
		[parser parseData:[response body]];
		NSMutableArray *networkDataArray = [[NSMutableArray alloc] initWithArray:[parser items]];
        [networkDataArray sortUsingFunction:sortData context:nil];
		maxNetworkIn = [AWSUtils findMax:networkDataArray];
		networkInData = [networkDataArray componentsJoinedByString:@","];
		[networkDataArray release];
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
	
	//Populate the NetworkIn graph
	[dict setObject:@"NetworkOut" forKey:@"MetricName"];
	
	response = [Connection get:[AWSUtils getQueryStringForCloudWatch:dict]];
	
	if([response statusCode] == 200){
		
		CloudWatchDataPointsParser *parser = [[[CloudWatchDataPointsParser alloc] init] autorelease];
		
		[parser parseData:[response body]];
		NSMutableArray *networkDataArray = [[NSMutableArray alloc] initWithArray:[parser items]];
        [networkDataArray sortUsingFunction:sortData context:nil];
		NSString *networkOutData = [networkDataArray componentsJoinedByString:@","];
		

        
		double maxNetworkOut = [AWSUtils findMax:networkDataArray];
		double max = maxNetworkOut > maxNetworkIn ? maxNetworkOut : maxNetworkIn;
		NSString *axisLabel = [NSString stringWithFormat:@"1:||%1.0f|%1.0f|%1.0f|%1.0f|%1.0f",max/5,2*max/5,3*max/5,4*max/5,max];
		NSString* chartUrl = [NSString stringWithFormat:@"http://chart.googleapis.com/chart?cht=lc&chs=250x150&chd=t:%@|%@&chxt=x,y&chxs=0,ff0000,12,0,lt|1,0000ff,10,1,lt&chds=0,1&chxl=0:|-10|-9|-8|-7|-6|-5|-4|-3|-2|-1|%@&chdl=Network In Bytes/s|Network Out Bytes/s&chco=FF0000,0000FF&chdlp=bv&chds=0,%f&chxr=0,0,%f",networkInData,networkOutData,axisLabel,max,max/10];
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[chartUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
		NSURLResponse *response1;
		NSError *error;
		
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response1 error:&error];
		UIImage *image = [[UIImage alloc] initWithData:data];
		if(image){
			[networkView setImage:image];					
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
	
	
	//create the ad
	[self createADBannerView];
	
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
    
	[bannerView setDelegate:self];
	
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
                         self.view.frame = contentFrame;
                         [self.banner layoutIfNeeded];
                         banner.frame = CGRectMake(bannerOrigin.x, bannerOrigin.y, banner.frame.size.width, banner.frame.size.height);
                     }];
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
	self.banner = nil;
}


- (void)dealloc {
    [super dealloc];
	self.banner = nil;
}


@end

