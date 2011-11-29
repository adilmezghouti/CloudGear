//
//  RunningInstanceParser.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/1/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunningInstanceInfo.h"


@interface RunningInstanceParser : NSObject <NSXMLParserDelegate> {
    NSMutableArray *items;
    RunningInstanceInfo *instanceInfo;
    NSString *keyInProgress;
    NSMutableString *textInProgress;
	bool isItemInProgress;
	bool isSubItemInProgress;
	bool startParsing;
}

@property(nonatomic, assign) bool isItemInProgress;
@property(nonatomic, assign) bool isSubItemInProgress;
@property(nonatomic, assign) bool startParsing;
@property(nonatomic, retain) RunningInstanceInfo *instanceInfo;

- (BOOL)parseData:(NSData *)d;
- (NSArray *)items;
@end
