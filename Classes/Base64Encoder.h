//
//  Base64Encoder.h
//  MobileDepositCapture
//

#import <Foundation/Foundation.h>


@interface Base64Encoder : NSObject {
	
}

+ (NSString*) encode:(NSData*) rawBytes;

@end
