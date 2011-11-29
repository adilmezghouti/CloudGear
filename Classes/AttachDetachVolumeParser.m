//
//  AttachVolumeParser.m
//  AWSManager
//
//  Created by Adil Mezghouti on 11/3/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "AttachDetachVolumeParser.h"

static NSSet *interestingKeys;

@implementation AttachDetachVolumeParser
@synthesize isItemInProgress;

+ (void)initialize
{
    if (!interestingKeys) {
        interestingKeys = [[NSSet alloc] initWithObjects:@"volumeId", @"instanceId", @"device", @"status", @"attachTime", nil];
    }
}

- (void)dealloc
{
    [items release];
    [super dealloc];
}

- (BOOL)parseData:(NSData *)d
{
    [items release];
    items = [[NSMutableArray alloc] init];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:d];
    [parser setDelegate:self];
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
    if ([elementName isEqual:@"AttachVolumeResponse"] || [elementName isEqual:@"DetachVolumeResponse"]) {
		isItemInProgress = true;
		volumeInfo = [[AttachVolumeInfo alloc] init];		
        return;
    }
	

    if ([interestingKeys containsObject:elementName]) {
        keyInProgress = [elementName copy];
        textInProgress = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqual:@"AttachVolumeResponse"] || [elementName isEqual:@"DetachVolumeResponse"]) {
		[items addObject:volumeInfo];
		[volumeInfo release];
		volumeInfo = nil;			
		isItemInProgress = false;
        return;
    }
	
	
    // Is the current key complete?
    if ([elementName isEqual:keyInProgress]) {
        if([elementName isEqual:@"volumeId"]) {
            [volumeInfo setVolumeId:textInProgress];			
        } else if([elementName isEqual:@"instanceId"]) {			
            [volumeInfo setInstanceId:textInProgress];			
        } else if([elementName isEqual:@"device"]) {			
            [volumeInfo setDevice:textInProgress];			
        }  else if([elementName isEqual:@"status"]) {			
            [volumeInfo setStatus:textInProgress];			
        } else if([elementName isEqual:@"attachTime"]) {			
            [volumeInfo setAttachTime:textInProgress];			
        }
		
        // Clear the text and key
        [textInProgress release];
        textInProgress = nil;
        [keyInProgress release];
        keyInProgress = nil;
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
