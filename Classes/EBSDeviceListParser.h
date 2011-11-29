//
//  EBSDeviceListParser.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/12/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttachVolumeInfo.h"

@interface EBSDeviceListParser : NSObject <NSXMLParserDelegate> {
    NSMutableArray *items;
    AttachVolumeInfo *volumeInfo;
    NSString *keyInProgress;
    NSMutableString *textInProgress;
	bool isItemInProgress;
	bool isItem2InProgress;
	bool startParsing;
}

@property(nonatomic, assign) bool isItemInProgress;
@property(nonatomic, assign) bool isItem2InProgress;
@property(nonatomic, assign) bool startParsing;

- (BOOL)parseData:(NSData *)d;
- (NSArray *)items;
@end
