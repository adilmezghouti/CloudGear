//
//  AMIDetailViewController.h
//  AWSManager
//
//  Created by Adil Mezghouti on 10/21/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunInstanceInfo.h"
#import "AMIInfo.h"

@interface AMIDetailViewController : UIViewController {
	RunInstanceInfo *instanceInfo;
	AMIInfo *amiInfo;
	IBOutlet UILabel *imageId;
	IBOutlet UILabel *imageState;
	IBOutlet UITextView *imageLocation;
	IBOutlet UILabel *imagePlatform;
	IBOutlet UIButton *launchInstanceBtn;
    IBOutlet UIButton *launchCustomInstanceBtn;
}

@property(nonatomic, retain) RunInstanceInfo *instanceInfo;
@property(nonatomic, retain) AMIInfo *amiInfo;

-(id) initWithAMIInfo:(AMIInfo *)amiInformation;
-(IBAction) launchInstance:(id)sender;
-(IBAction) launchCustomInstance:(id)sender;

@end
