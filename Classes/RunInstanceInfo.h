//
//  RunInstanceInfo.h
//  AWSManager
//
//  Created by Adil Mezghouti on 10/28/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RunInstanceInfo : NSObject {

	NSInteger* code;
	NSString* instanceId;
	NSString* instanceType;
	NSString* availabilityZone;
	NSString* virtualizationType;
}

@property(nonatomic, assign) NSInteger* code;
@property(nonatomic, retain) NSString* instanceId;
@property(nonatomic, retain) NSString* instanceType;
@property(nonatomic, retain) NSString* availabilityZone;
@property(nonatomic, retain) NSString* virtualizationType;

@end
