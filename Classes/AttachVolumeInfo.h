//
//  AttachVolumeInfo.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/3/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AttachVolumeInfo : NSObject {
	NSString *volumeId;
	NSString *instanceId;
	NSString *device;
	NSString *status;
	NSString *attachTime;
	NSString *deleteOnTermination;
	
}

@property(nonatomic, retain) NSString *volumeId;
@property(nonatomic, retain) NSString *instanceId;
@property(nonatomic, retain) NSString *device;
@property(nonatomic, retain) NSString *status;
@property(nonatomic, retain) NSString *attachTime;
@property(nonatomic, retain) NSString *deleteOnTermination;


@end
