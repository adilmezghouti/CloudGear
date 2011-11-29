//
//  AccountViewController.h
//  AWSManager
//
//  Created by Adil Mezghouti on 11/12/10.
//  Copyright 2010 Adil Mezghouti. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AccountViewController : UIViewController <UITextFieldDelegate>{

	IBOutlet UITextField *accessKeyTxt;
	IBOutlet UITextField *privateKeyTxt;
}

-(IBAction) updateKeys:(id)sender;
-(IBAction) deleteKeys:(id)sender;

@end
