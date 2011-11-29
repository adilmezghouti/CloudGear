//
//  DescribeImagesResponse.h
//  AWSManager
//
//  Created by Adil Mezghouti on 10/19/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AMIInfo : NSObject {

	NSString *imageId;
	NSString *imageLocation;
	NSString *imageState;
	NSString *imageOwnerId;
	NSString *imagePlatform;
	bool isPublic;	
}

@property(nonatomic, retain) NSString* imageId;
@property(nonatomic, retain) NSString* imageLocation;
@property(nonatomic, retain) NSString* imageState;
@property(nonatomic, retain) NSString* imageOwnerId;
@property(nonatomic, retain) NSString* imagePlatform;


@end
