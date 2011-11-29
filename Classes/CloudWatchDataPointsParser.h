//
//  ClouWatchDatPointsParser.h
//  AWSManager
//
//  Created by Adil Mezghouti on 5/19/11.
//  Copyright 2011 Adil Mezghouti university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudWatchDatapointInfo.h"

@interface CloudWatchDataPointsParser : NSObject<NSXMLParserDelegate> {
    NSMutableArray *items;
    CloudWatchDatapointInfo *dataPointsInfo;
    NSString *keyInProgress;
    NSMutableString *textInProgress;
	bool isItemInProgress;
	bool startParsing;
	NSDateFormatter *dateFormatter;
}

@property(nonatomic, assign) bool isItemInProgress;
@property(nonatomic, assign) bool startParsing;
@property(nonatomic, retain) CloudWatchDatapointInfo *dataPointsInfo;
@property(nonatomic, retain) NSDateFormatter *dateFormatter;

- (BOOL)parseData:(NSData *)d;
- (NSArray *)items;
@end
