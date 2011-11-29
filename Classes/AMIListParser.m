//
//  AMIListParser.m
//  AWSManager
//
//  Created by Adil Mezghouti on 10/20/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import "AMIListParser.h"

static NSSet *interestingKeys;
bool isItemInProgress = false;
bool isSubItemInProgress = false;


@implementation AMIListParser
+ (void)initialize
{
    if (!interestingKeys) {
        interestingKeys = [[NSSet alloc] initWithObjects:@"imageId",
						   @"imageLocation",@"imageState",@"imageOwnerId",@"imagePlatform", nil];
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
   // NSLog(@"starting Element: %@", elementName);
	
    // Is it the start of a new item?
    if ([elementName isEqual:@"item"]) {
		if(!isItemInProgress){			
			isItemInProgress = true;
			amiInfo = [[AMIInfo alloc] init];		
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

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    //NSLog(@"ending Element: %@", elementName);
	
    // Is the current item complete?
    if ([elementName isEqual:@"item"]) {
		if(isSubItemInProgress){
			isSubItemInProgress = false;
		} else {
			[items addObject:amiInfo];
			
			// Clear the current item
			[amiInfo release];
			amiInfo = nil;			
			isItemInProgress = false;
		}

        return;
    }
	
    // Is the current key complete?
    if ([elementName isEqual:keyInProgress]) {
        if ([elementName isEqual:@"imageId"]) {
            [amiInfo setImageId:textInProgress];
        } else if([elementName isEqual:@"imageLocation"]) {
            [amiInfo setImageLocation:textInProgress];
			
        } else if([elementName isEqual:@"imageState"]) {
			[amiInfo setImageState:textInProgress];
		} else if([elementName isEqual:@"imageOwnerId"]) {
			[amiInfo setImageOwnerId:textInProgress];
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
