//
//  CloudWatchViewController.h
//  AWSManager
//
//  Created by Adil Mezghouti on 5/17/11.
//  Copyright 2011 Adil Mezghouti university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface CloudWatchViewController : UIViewController<ADBannerViewDelegate> {

	NSString* instanceId;
	NSArray* dataPointsArray;
	NSMutableArray* chartArray;
	IBOutlet UIImageView * CPUUtilizationView;
	IBOutlet UIImageView * networkView;
	IBOutlet ADBannerView *banner;
}

@property(retain, nonatomic) NSString* instanceId;
@property(retain, nonatomic) NSArray* dataPointsArray;
@property(retain, nonatomic) NSMutableArray* chartArray;
@property(retain, nonatomic) UIImageView* CPUUtilizationView;
@property(retain, nonatomic) UIImageView* networkView;
@property(retain, nonatomic) ADBannerView *banner;

- (id) initWithInstanceId:(NSString*) instanceId;
-(void)createADBannerView;
-(void)layoutForCurrentOrientation:(BOOL)animated;
@end
