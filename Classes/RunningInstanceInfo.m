//
//  RunningInstanceInfo.m
//  AWSManager
//
//  Created by Adil Mezghouti on 11/1/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "RunningInstanceInfo.h"


@implementation RunningInstanceInfo
@synthesize instanceId, imageId, instanceState, dnsName, instanceType, launchTime, availabilityZone, ipAddress, deviceName, volumeId, deviceStatus, attachTime, rootDeviceType;

-(id)init {
	if(self = [super init]){
		[self setIpAddress:@""];
	}
	
	return self;
}

@end
