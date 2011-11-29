//
//  AMIListParser.h
//  AWSManager
//
//  Created by Adil Mezghouti on 10/20/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMIInfo.h"


@interface AMIListParser : NSObject <NSXMLParserDelegate> {
    NSMutableArray *items;
    AMIInfo *amiInfo;
    NSString *keyInProgress;
    NSMutableString *textInProgress;
}
- (BOOL)parseData:(NSData *)d;
- (NSArray *)items;

@end
