//
//  ClouWatchDatPointsParser.m
//  AWSManager
//
//  Created by Adil Mezghouti on 5/19/11.
//  Copyright 2011 Adil Mezghouti university. All rights reserved.
//

#import "CloudWatchDataPointsParser.h"
#import "CloudWatchDatapointInfo.h"

static NSSet *interestingKeys;

@implementation CloudWatchDataPointsParser
@synthesize isItemInProgress, startParsing, dataPointsInfo, dateFormatter;

+ (void)initialize
{
    if (!interestingKeys) {
        interestingKeys = [[NSSet alloc] initWithObjects:@"Unit",@"Timestamp",@"Maximum", nil];
    }
}

- (void)dealloc
{
    [items release];
    [super dealloc];
}

- (BOOL)parseData:(NSData *)d
{
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	[dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
	
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
	
	if([elementName isEqual:@"Datapoints"]){
		startParsing = true;
		return;
	}
	
	if(startParsing){
		// Is it the start of a new item?
		if ([elementName isEqual:@"member"]) {		
			isItemInProgress = true;
			dataPointsInfo = [[CloudWatchDatapointInfo alloc] init];		
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
	
	if([elementName isEqual:@"Datapoints"]){
		startParsing = false;
		return;
	}
	
	if(startParsing){
		// Is the current item complete?
		if ([elementName isEqual:@"member"]) {
				[items addObject:dataPointsInfo];
				
				// Clear the current item
				[dataPointsInfo release];
				dataPointsInfo = nil;			
				isItemInProgress = false;
			return;
		}
		
		
		// Is the current key complete?
		if ([elementName isEqual:keyInProgress]) {
			if ([elementName isEqual:@"Timestamp"]) {
				NSDate* date = [NSDate dateWithNaturalLanguageString:textInProgress
															   locale:[[NSLocale alloc] init]];
				 
				[dataPointsInfo setTimeStamp:[dateFormatter stringFromDate:date]];
			} else if([elementName isEqual:@"Unit"]) {
				[dataPointsInfo setUnit:textInProgress];			
			} else if([elementName isEqual:@"Maximum"]) {
				[dataPointsInfo setValue:textInProgress];

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