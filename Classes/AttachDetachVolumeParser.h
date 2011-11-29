//
//  AttachVolumeParser.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/3/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttachVolumeInfo.h"

@interface AttachDetachVolumeParser : NSObject <NSXMLParserDelegate> {
    NSMutableArray *items;
    AttachVolumeInfo *volumeInfo;
    NSString *keyInProgress;
    NSMutableString *textInProgress;
	bool isItemInProgress;
}

@property(nonatomic, assign) bool isItemInProgress;

- (BOOL)parseData:(NSData *)d;
- (NSArray *)items;
@end
