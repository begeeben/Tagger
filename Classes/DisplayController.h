//
//  SettingsSheetController.h
//  SheetFromOtherNib
//
//  Created by grady player on 6/21/11.
//  Copyright 2011 Objectively Better, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DisplayController : NSWindowController {
@private
	IBOutlet NSWindow    *window;
	id vgmdb; // macruby Vgmdb class
	NSDictionary *albumDetails; // contains all the infomation
	NSString *selectedLanguage; 

	NSArray  *tracks; // array of tracks info
	
	NSMutableDictionary *fieldValues; // The value of the fields
	NSDictionary *fieldProperties;    // The properties e.g. language
}

- (id)initWithUrl:(NSString*)url
			vgmdb:(id)vgmdbObject;

-(IBAction) changeLanguage:(NSMutableDictionary*)properties
		  buttonProperties:(NSMutableDictionary*)buttonProperties;

- (IBAction)cancelSheet:sender;
- (IBAction)confirmSheet:sender;


@end