//
//  StopInstanceInfo.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/1/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StopInstanceInfo : NSObject {
	NSString* instanceId;
	NSString* currentState;
}

@property(nonatomic, retain) NSString* instanceId;
@property(nonatomic, retain) NSString* currentState;

@end
