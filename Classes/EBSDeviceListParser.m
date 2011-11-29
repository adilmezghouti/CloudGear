//
//  EBSDeviceListParser.m
//  AWSManager
//
//  Created by Adil Mezghouti on 11/12/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "EBSDeviceListParser.h"

static NSSet *interestingKeys;

@implementation EBSDeviceListParser
@synthesize isItemInProgress, startParsing, isItem2InProgress;

+ (void)initialize
{
    if (!interestingKeys) {
        interestingKeys = [[NSSet alloc] initWithObjects:@"volumeId", @"instanceId", @"device", @"status", @"attachTime", @"deleteOnTermination", nil];
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
	
	if([elementName isEqualToString:@"attachmentSet"]){
		startParsing = TRUE;
	}
	
    // Is it the start of a new item?
    if ([elementName isEqual:@"item"]) {
		if(!isItemInProgress){
			isItemInProgress = true;
			volumeInfo = [[AttachVolumeInfo alloc] init];
		} else {
			isItem2InProgress = true;
		}
		
        return;
    }
	
	
    if ([interestingKeys containsObject:elementName]) {
        keyInProgress = [elementName copy];
        // This is a string we will append to as the text arrives
        textInProgress = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    //NSLog(@"ending Element: %@", elementName);
	
	if([elementName isEqualToString:@"attachmentSet"]){
		startParsing = false;
	}
	
	
    // Is the current item complete?
    if ([elementName isEqual:@"item"]) {
		if(isItem2InProgress){
			self.isItem2InProgress = false;
		} else {
			[items addObject:volumeInfo];
			
			// Clear the current item
			[volumeInfo release];
			volumeInfo = nil;			
			isItemInProgress = false;
		}
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
        } else if([elementName isEqual:@"deleteOnTermination"]){
			[volumeInfo setDeleteOnTermination:textInProgress];
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
