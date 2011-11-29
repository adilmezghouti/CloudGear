//
//  HomeViewController1.h
//  AWSManager
//
//  Created by Adil Mezghouti on 10/17/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface HomeViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate>{

	ADBannerView *banner;
	UIActivityIndicatorView *activityIndicator1;
	UIActivityIndicatorView *activityIndicator2;
	UIActivityIndicatorView *activityIndicator3;
	UIActivityIndicatorView *activityIndicator4;
	UIActivityIndicatorView *activityIndicator5;
}

@property(nonatomic, retain) IBOutlet ADBannerView *banner;
@property(nonatomic, retain) UIActivityIndicatorView *activityIndicator1;
@property(nonatomic, retain) UIActivityIndicatorView *activityIndicator2;
@property(nonatomic, retain) UIActivityIndicatorView *activityIndicator3;
@property(nonatomic, retain) UIActivityIndicatorView *activityIndicator4;
@property(nonatomic, retain) UIActivityIndicatorView *activityIndicator5;

-(void)createADBannerView;
-(void)layoutForCurrentOrientation:(BOOL)animated;
@end
