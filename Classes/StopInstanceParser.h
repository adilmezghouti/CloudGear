//
//  StopInstanceParser.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/1/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StopInstanceInfo.h"

@interface StopInstanceParser : NSObject <NSXMLParserDelegate> {
    NSMutableArray *items;
    StopInstanceInfo *instanceInfo;
    NSString *keyInProgress;
    NSMutableString *textInProgress;
	bool isItemInProgress;
	bool isCurrentStateInProgress;
}

@property(nonatomic, assign) bool isItemInProgress;
@property(nonatomic, assign) bool isCurrentStateInProgress;

- (BOOL)parseData:(NSData *)d;
- (NSArray *)items;
@end
