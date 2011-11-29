//
//  AWSUtils.m
//  AWSManager
//
//  Created by Adil Mezghouti on 10/17/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "AWSUtils.h"
#include <CommonCrypto/CommonHMAC.h>
#import "Base64Encoder.h"
#import "SFHFKeychainUtils.h"

@implementation AWSUtils

+(NSString*) calculateHMACWithKey:(NSString*) key andData:(NSString*) data{
	const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
	const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
	
	unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
	
	CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
	
	NSData *hmac = [[[NSData alloc] initWithBytes:cHMAC
										  length:sizeof(cHMAC)] autorelease];
	
	return [Base64Encoder encode:hmac];
	
}

+(NSString*) urlEncode:(NSString*) url {
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
															   (CFStringRef)url,
															   NULL,
															   (CFStringRef)@"=!*'();:@+$,/?%#[]",
															   kCFStringEncodingUTF8 ) autorelease];
}

+(NSString*) getQueryString:(NSMutableDictionary*) dict{
	NSError *error = nil;
	NSEnumerator *enumerator = [[[dict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectEnumerator];
	NSString *key;
	NSMutableArray *queryArray = [[[NSMutableArray alloc] initWithCapacity:[dict count]] autorelease];
	
	while ((key = [enumerator nextObject])) {
		[queryArray addObject:[NSString stringWithFormat:@"%@=%@",[AWSUtils urlEncode:key], [AWSUtils urlEncode:(NSString*)[dict valueForKey:key]]]];
	}
	
	NSString* queryString = [queryArray componentsJoinedByString:@"&"];
	
	NSString *signedUrl = [AWSUtils 
						   calculateHMACWithKey:[SFHFKeychainUtils getPasswordForUsername:@"privatekey" andServiceName:@"com.adilmezghouti.awsmanager" error:&error]
												 andData:[NSString stringWithFormat:@"GET\nec2.amazonaws.com\n/\nAWSAccessKeyId=%@&%@",[SFHFKeychainUtils getPasswordForUsername:@"accesskeyid" andServiceName:@"com.adilmezghouti.awsmanager" error:&error],queryString]];
	
	
	NSString *encodedAndSignedUrl = [AWSUtils urlEncode:signedUrl];
	
	return [NSString stringWithFormat:@"https://ec2.amazonaws.com/?%@&Signature=%@&AWSAccessKeyId=%@",queryString, encodedAndSignedUrl, [SFHFKeychainUtils getPasswordForUsername:@"accesskeyid" andServiceName:@"com.adilmezghouti.awsmanager" error:&error]];
	
}


+(NSString*) getQueryStringForCloudWatch:(NSMutableDictionary*) dict{
	NSError *error = nil;
	NSEnumerator *enumerator = [[[dict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectEnumerator];
	NSString *key;
	NSMutableArray *queryArray = [[[NSMutableArray alloc] initWithCapacity:[dict count]] autorelease];
	
	while ((key = [enumerator nextObject])) {
		[queryArray addObject:[NSString stringWithFormat:@"%@=%@",[AWSUtils urlEncode:key], [AWSUtils urlEncode:(NSString*)[dict valueForKey:key]]]];
	}
	
	NSString* queryString = [queryArray componentsJoinedByString:@"&"];
	
	NSString *signedUrl = [AWSUtils 
						   calculateHMACWithKey:[SFHFKeychainUtils getPasswordForUsername:@"privatekey" andServiceName:@"com.adilmezghouti.awsmanager" error:&error]
						   andData:[NSString stringWithFormat:@"GET\nmonitoring.us-east-1.amazonaws.com\n/\nAWSAccessKeyId=%@&%@",[SFHFKeychainUtils getPasswordForUsername:@"accesskeyid" andServiceName:@"com.adilmezghouti.awsmanager" error:&error],queryString]];
	
	
	NSString *encodedAndSignedUrl = [AWSUtils urlEncode:signedUrl];
	
	return [NSString stringWithFormat:@"https://monitoring.us-east-1.amazonaws.com/?%@&Signature=%@&AWSAccessKeyId=%@",queryString, encodedAndSignedUrl, [SFHFKeychainUtils getPasswordForUsername:@"accesskeyid" andServiceName:@"com.adilmezghouti.awsmanager" error:&error]];
	
}

+(double) findMax:(NSMutableArray*) array{
	double max = [[[array objectAtIndex:0] description] doubleValue];
	for(int i=1;i < [array count];i++){
		if([[[array objectAtIndex:i] description] doubleValue] > max){
			max = [[[array objectAtIndex:i] description] doubleValue];
		}
		
	}
	
	return max;
}


+(double) findMin:(NSMutableArray*) array{
	double min = [[[array objectAtIndex:0] description] doubleValue];
	for(int i=1;i < [array count];i++){
		if([[[array objectAtIndex:i] description] doubleValue] < min){
			min = [[[array objectAtIndex:i] description] doubleValue];
		}
		
	}
	return min;
}

@end
