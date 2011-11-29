//
//  AWSUtils.h
//  AWSManager
//
//  Created by Adil Mezghouti on 10/17/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AWSUtils : NSObject {

}

+(NSString*) calculateHMACWithKey:(NSString*) key andData:(NSString*) data;
+(NSString*) urlEncode:(NSString*) url;
+(NSString*) getQueryString:(NSMutableDictionary*) dict;
+(NSString*) getQueryStringForCloudWatch:(NSMutableDictionary*) dict;
+(double) findMax:(NSMutableArray*) array;
+(double) findMin:(NSMutableArray*) array;

@end
