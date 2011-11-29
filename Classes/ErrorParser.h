//
//  ErrorParser.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/15/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorInfo.h"

@interface ErrorParser : NSObject <NSXMLParserDelegate> {
    NSMutableArray *items;
    ErrorInfo *errorInfo;
    NSString *keyInProgress;
    NSMutableString *textInProgress;
	bool isItemInProgress;
}

@property(nonatomic, assign) bool isItemInProgress;

- (BOOL)parseData:(NSData *)d;
- (NSArray *)items;
@end
