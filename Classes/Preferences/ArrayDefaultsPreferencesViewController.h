//
//  GroupingsPreferencesViewController.h
//  Tagger
//
//  Created by Bilal Syed Hussain on 29/08/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "MASPreferencesViewController.h"

@interface ArrayDefaultsPreferencesViewController : NSViewController <MASPreferencesViewController>{
@private
	NSString *key;
}

- (id)initWithKey:(NSString *)aKey;

- (IBAction) addRow:sender;
- (IBAction) removeRow:sender;

@property  IBOutlet NSTableView *table;
@property  IBOutlet NSString *title;

@end
