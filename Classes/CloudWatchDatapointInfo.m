//
//  CloudWatchDatapointInfo.m
//  AWSManager
//
//  Created by Adil Mezghouti on 5/19/11.
//  Copyright 2011 Adil Mezghouti university. All rights reserved.
//

#import "CloudWatchDatapointInfo.h"


@implementation CloudWatchDatapointInfo
@synthesize timeStamp, unit, value;


-(NSString*) description {
	return [NSString stringWithFormat:@"%.2f",[value doubleValue]];
}
@end
