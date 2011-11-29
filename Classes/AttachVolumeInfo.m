//
//  AttachVolumeInfo.m
//  AWSManager
//
//  Created by Adil Mezghouti on 11/3/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "AttachVolumeInfo.h"


@implementation AttachVolumeInfo
@synthesize volumeId, instanceId, device, status, attachTime, deleteOnTermination;

-(id)init {
	if(self = [super init]){
		[self setDeleteOnTermination:@"false"];
	}
	
	return self;
}

@end

