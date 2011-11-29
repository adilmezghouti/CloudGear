//
//  LaunchingInstancePropertiesViewController.h
//  AWSManager
//
//  Created by Adil Mezghouti on 6/5/11.
//  Copyright 2011 Adil Mezghouti university. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LaunchingInstancePropertiesViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate> {
    
    IBOutlet UIPickerView *myPickerView;
    IBOutlet UITextField *availabilityZoneTxtField;
    IBOutlet UITextField *instanceTypeTxtField;
    IBOutlet UITextField *keyPairTxtField;
    IBOutlet UITextField *securityGroupTxtField;
    IBOutlet UITextField *numberOfInstancesTxtField;
    IBOutlet UISwitch *advancedMonitoringSwitch;
    NSMutableArray* pickerDataArray;
    NSMutableArray* securityGroupsArray;
    NSMutableArray* keyPairArray;
    NSMutableArray* availabilityZonesArray;
    UITextField *currentTextField;
    NSString *imageId;
    UIActionSheet *actionSheet;
}

@property(nonatomic, retain) NSMutableArray* pickerDataArray;
@property(nonatomic, retain) UITextField* currentTextField;
@property(nonatomic, retain) NSMutableArray* securityGroupsArray;
@property(nonatomic, retain) NSMutableArray* keyPairArray;
@property(nonatomic, retain) NSMutableArray* availabilityZonesArray;
@property(nonatomic, retain) NSString* imageId;
@property(nonatomic, retain) UIActionSheet* actionSheet;

- (id)initWithImageId:(NSString *)myImageId;
-(void) retrieveKeyPair;
-(void) retrieveSecurityGroups;
-(void) retrieveAvailabilityZones;
-(IBAction) launchInstance:(id)sender;
-(void) dismissActionSheet;

@end
