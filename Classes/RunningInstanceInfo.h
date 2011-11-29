//
//  RunningInstanceInfo.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/1/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RunningInstanceInfo : NSObject {

	NSString* instanceId;
	NSString* imageId;
	NSString* instanceState;
	NSString* dnsName;
	NSString* instanceType;
	NSString* launchTime;
	NSString* availabilityZone;
	NSString* ipAddress;
	NSString* deviceName;
	NSString* volumeId;
	NSString* deviceStatus;
	NSString* attachTime;
	NSString* rootDeviceType;
}

@property(nonatomic, retain) NSString* instanceId;
@property(nonatomic, retain) NSString* imageId;
@property(nonatomic, retain) NSString* instanceState;
@property(nonatomic, retain) NSString* dnsName;
@property(nonatomic, retain) NSString* instanceType;
@property(nonatomic, retain) NSString* launchTime;
@property(nonatomic, retain) NSString* availabilityZone;
@property(nonatomic, retain) NSString* ipAddress;
@property(nonatomic, retain) NSString* deviceName;
@property(nonatomic, retain) NSString* volumeId;
@property(nonatomic, retain) NSString* deviceStatus;
@property(nonatomic, retain) NSString* attachTime;
@property(nonatomic, retain) NSString* rootDeviceType;

@end