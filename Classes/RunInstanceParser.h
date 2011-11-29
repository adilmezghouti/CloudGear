//
//  RunInstanceParser.h
//  AWSManager
//
//  Created by Adil Mezghouti on 10/28/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunInstanceInfo.h"


@interface RunInstanceParser : NSObject <NSXMLParserDelegate> {
    NSMutableArray *items;
    RunInstanceInfo *instanceInfo;
    NSString *keyInProgress;
    NSMutableString *textInProgress;
	bool isItemInProgress;
	bool isSubItemInProgress;
}

@property(nonatomic, assign) bool isItemInProgress;
@property(nonatomic, assign) bool isSubItemInProgress;

- (BOOL)parseData:(NSData *)d;
- (NSArray *)items;
@end
