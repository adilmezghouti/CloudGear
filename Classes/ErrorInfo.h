//
//  ErrorInfo.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/15/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ErrorInfo : NSObject {

	NSString *code;
	NSString *message;
}

@property(nonatomic, retain) NSString *code;
@property(nonatomic, retain) NSString *message;

@end
