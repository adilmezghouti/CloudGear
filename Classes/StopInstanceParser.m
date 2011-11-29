//
//  StopInstanceParser.m
//  AWSManager
//
//  Created by Adil Mezghouti on 11/1/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "StopInstanceParser.h"

static NSSet *interestingKeys;

@implementation StopInstanceParser
@synthesize isItemInProgress, isCurrentStateInProgress;

+ (void)initialize
{
    if (!interestingKeys) {
        interestingKeys = [[NSSet alloc] initWithObjects:@"instanceId", @"name", nil];
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
	 
    // Is it the start of a new item?
    if ([elementName isEqual:@"item"]) {
		isItemInProgress = true;
		instanceInfo = [[StopInstanceInfo alloc] init];		
        return;
    }
	
	if([elementName isEqual:@"currentState"]){
		self.isCurrentStateInProgress = TRUE;
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
	
    // Is the current item complete?
    if ([elementName isEqual:@"item"]) {
			[items addObject:instanceInfo];
			
			// Clear the current item
			[instanceInfo release];
			instanceInfo = nil;			
			isItemInProgress = false;
        return;
    }
	if([elementName isEqual:@"currentState"]){
		self.isCurrentStateInProgress = FALSE;
	}
	
    // Is the current key complete?
    if ([elementName isEqual:keyInProgress]) {
        if([elementName isEqual:@"instanceId"]) {
            [instanceInfo setInstanceId:textInProgress];			
        } else if([self isCurrentStateInProgress] && [elementName isEqual:@"name"]) {			
            [instanceInfo setCurrentState:textInProgress];			
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