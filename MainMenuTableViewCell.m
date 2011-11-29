//
//  MainMenuTableViewCell.m
//
//  Created by Adil Mezghouti on 10/21/10.
//  Copyright 2010 Northeastern university. All rights reserved.
//

#import "MainMenuTableViewCell.h"

@implementation MainMenuTableViewCell
@synthesize buttonSelected, delegate;


-(void) amiAction:(id)sender {
	[self setButtonSelected:@"ami"];
	[self setSelected:TRUE];

}
	 
-(void) ebsAction:(id)sender {
	[self setButtonSelected:@"ebs"];
}

-(void) profileAction:(id)sender {
	[self setButtonSelected:@"profile"];
}


@end
