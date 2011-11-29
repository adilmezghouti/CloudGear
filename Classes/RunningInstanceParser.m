//
//  RunningInstanceParser.m
//  AWSManager
//
//  Created by Adil Mezghouti on 11/1/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "RunningInstanceParser.h"
#import "RunningInstanceInfo.h"

static NSSet *interestingKeys;

@implementation RunningInstanceParser
@synthesize isItemInProgress, isSubItemInProgress, startParsing, instanceInfo;

+ (void)initialize
{
    if (!interestingKeys) {
        interestingKeys = [[NSSet alloc] initWithObjects:@"instanceId",@"imageId",@"name", @"dnsName",@"launchTime",
						   @"availabilityZone",@"ipAddress",@"deviceName",@"status",@"attachTime", @"rootDeviceType", nil];
    }
}

- (void)dealloc
{
    [items release];
    [super dealloc];
}

- (BOOL)parseData:(NSData *)d
{
    // Release the old itemArray
    [items release];
	
    // Create a new, empty itemArray
    items = [[NSMutableArray alloc] init];
	
    // Create a parser
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:d];
    [parser setDelegate:self];
	
    // Do the parse
    [parser parse];
	
    [parser release];
	
    return YES;
}

- (NSArray *)items
{
    return items;
}

#pragma mark Delegate calls

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
	//NSLog(@"starting Element: %@", elementName);
	
	if([elementName isEqual:@"instancesSet"]){
		startParsing = true;
		return;
	}
	
	if(startParsing){
		// Is it the start of a new item?
		if ([elementName isEqual:@"item"]) {
			if(!isItemInProgress){			
				isItemInProgress = true;
				instanceInfo = [[RunningInstanceInfo alloc] init];		
			} else {
				isSubItemInProgress = true;
			}
			return;
		}
		
		if ([interestingKeys containsObject:elementName]) {
			keyInProgress = [elementName copy];
			// This is a string we will append to as the text arrives
			textInProgress = [[NSMutableString alloc] init];
		}
	}
    
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    //NSLog(@"ending Element: %@", elementName);
	
	if([elementName isEqual:@"instancesSet"]){
		startParsing = false;
		return;
	}
	
	if(startParsing){
		// Is the current item complete?
		if ([elementName isEqual:@"item"]) {
			if(isSubItemInProgress){
				isSubItemInProgress = false;
			} else {
				[items addObject:instanceInfo];
				
				// Clear the current item
				[instanceInfo release];
				instanceInfo = nil;			
				isItemInProgress = false;
			}
			
			return;
		}
		
		
		// Is the current key complete?
		if ([elementName isEqual:keyInProgress]) {
			if ([elementName isEqual:@"instanceId"]) {
				[instanceInfo setInstanceId:textInProgress];
			} else if([elementName isEqual:@"imageId"]) {
				[instanceInfo setImageId:textInProgress];			
			} else if([elementName isEqual:@"name"]) {
				[instanceInfo setInstanceState:textInProgress];
			} else if([elementName isEqual:@"dnsName"]) {
				[instanceInfo setDnsName:textInProgress];
			}  else if([elementName isEqual:@"launchTime"]) {
				[instanceInfo setLaunchTime:textInProgress];
			}  else if([elementName isEqual:@"availabilityZone"]) {
				[instanceInfo setAvailabilityZone:textInProgress];
			}  else if([elementName isEqual:@"ipAddress"]) {
				[instanceInfo setIpAddress:textInProgress];
			}  else if([elementName isEqual:@"deviceName"]) {
				[instanceInfo setDeviceName:textInProgress];
			}  else if([elementName isEqual:@"status"]) {
				[instanceInfo setDeviceStatus:textInProgress];
			}  else if([elementName isEqual:@"attachTime"]) {
				[instanceInfo setAttachTime:textInProgress];
			} else if([elementName isEqual:@"rootDeviceType"]){
				[instanceInfo setRootDeviceType:textInProgress];
			}
			
			// Clear the text and key
			[textInProgress release];
			textInProgress = nil;
			[keyInProgress release];
			keyInProgress = nil;
		}
	}
    
}

// This method can get called multiple times for the
// text in a single element
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
    [textInProgress appendString:string];
}


@end
