//
//  CloudWatchDatapointInfo.h
//  AWSManager
//
//  Created by Adil Mezghouti on 5/19/11.
//  Copyright 2011 Adil Mezghouti university. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CloudWatchDatapointInfo : NSObject {
	NSString* timeStamp;
	NSString* unit;
	NSString* value;
}

@property(nonatomic, retain) NSString* timeStamp;
@property(nonatomic, retain) NSString* unit;
@property(nonatomic, retain) NSString* value;

@end
