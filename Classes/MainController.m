//
//  Controller.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 05/07/2011.
//  Copyright 2011 St. Andrews KY16 9XW. All rights reserved.
//

#import "MainController.h"
#import "Tags.h"
#import "MP4Tags.h"
#import "VgmdbController.h"
#import "DisplayController.h"
#import "FileSystemNode.h"
#import "NSMutableArray+Stack.h"
#import "ImageAndTextCell.h"

#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_ERROR;

@interface MainController()

- (void) initDirectoryTable;
- (void) setPopupMenuIcons;
- (IBAction) open:(id)sender;

/// Change the current directory to the clicked entries
- (IBAction) onClick:(id)sender;
@end

@implementation MainController
@synthesize window, directoryStack, currentNode,forwardStack, selectedNodeindex, parentNodes;
#pragma mark -
#pragma mark Table Methods 

- (IBAction) backForwordDirectories:(id)sender
{
	DDLogVerbose(@"backForwordDirectories");
    NSInteger tag = [[sender cell] tagForSegment:[sender selectedSegment]];
	DDLogVerbose(@"tag :%zd  ds %zd fs %zd", tag,  [directoryStack count],[forwardStack count] );
	
	// updates the gui
	void (^common)() = ^{
		self.parentNodes = [[directoryStack lastObject] parentNodes];
		DDLogVerbose(@"%@ bf parentNodes %@", [[directoryStack lastObject] displayName], parentNodes);
		
		[self setPopupMenuIcons];
		self.selectedNodeindex = [NSNumber numberWithInt:0];
		DDLogVerbose (@"directoryStack %@", directoryStack);
		[table reloadData];
	};
	
	
	if (tag == 0 && [directoryStack count] >= 2){
		[forwardStack addObject:[directoryStack pop]];
		common();
	}else if (tag == 1 && [forwardStack count] >= 1){
		[directoryStack addObject:[forwardStack pop]];
		common();
	}
	
}


- (IBAction) onClick:(id)sender
{
	// code to make cells that are editable go to edit
	NSEvent *currentEvent = [NSApp currentEvent];
	NSInteger column = [table clickedColumn];
	NSInteger row = [table clickedRow];
	NSCell *theCell = [table preparedCellAtColumn:column row:row];
	NSRect cellFrame = [table frameOfCellAtColumn:column row:row];
	NSUInteger hitTestResult = [theCell hitTestForEvent:currentEvent inRect:cellFrame ofView:table];
	
	if ( ( hitTestResult & NSCellHitEditableTextArea ) != NSCellHitEditableTextArea ) return;
	if ([[[table tableColumns] objectAtIndex:column] isEditable]){
		[table editColumn:column row:row withEvent:currentEvent select:YES];	
		return;
	}
	
	NSArray *children = [[directoryStack lastObject] children];
	FileSystemNode *node = [children objectAtIndex:row];
	DDLogVerbose(@"onClick selected %@", node);
	if ([node isDirectory]){
		[directoryStack addObject:node];
		[table reloadData];
		[parentNodes insertObject:node atIndex:0];
		[popup insertItemWithTitle:[node displayName] atIndex:0];
		[[popup itemAtIndex:0] setImage:[node icon]];
		self.selectedNodeindex = [NSNumber numberWithInteger:0];
		// clear the forward stack since it would not make sence any more
		[forwardStack removeAllObjects];
	}	
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView 
{
    return [[[directoryStack lastObject] children] count];
}

- (id)          tableView:(NSTableView *)aTableView 
objectValueForTableColumn:(NSTableColumn *)aTableColumn 
					  row:(NSInteger)rowIndex 
{
	NSArray *children = [[directoryStack lastObject] children];

	FileSystemNode *node = [children objectAtIndex:rowIndex];
	
	if ( [[aTableColumn identifier] isEqualToString:@"filename"] ){
		return [node displayName];
		
	}else if([node isDirectory]){
		return @"";
	}
	
	return [node.tags valueForKey:[aTableColumn identifier]];
}


- (void)tableView:(NSTableView *)tableView 
  willDisplayCell:(id)cell 
   forTableColumn:(NSTableColumn *)tableColumn
			  row:(NSInteger)rowIndex
{
	if ([[tableColumn identifier] isEqualToString:@"filename"]){
		NSArray *children = [[directoryStack lastObject] children];
		NSImage *icon = [[children objectAtIndex:rowIndex] icon];
		[icon setSize:NSMakeSize(16, 16)];
		[(ImageAndTextCell*)cell setImage: icon];		
	}
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	const NSInteger selectedRow = [table selectedRow];
	if (selectedRow == -1){
		self.currentNode = nil;
	}else{
		self.currentNode = [[[directoryStack lastObject] children] objectAtIndex:selectedRow];
	}
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn
{
	DDLogVerbose(@"headerClicked");
}

#pragma mark -
#pragma mark Directory Manipulation Methods

-(IBAction) goToParent:(id)sender
{
	DDLogVerbose(@"i:%@ pN:%@", selectedNodeindex, [parentNodes objectAtIndex:[selectedNodeindex intValue]]);
	int index = [selectedNodeindex intValue];
	if (index == 0) {
		return;
	}
	
	// remove all the child elements
	int i;
	for (i =0; i < index; ++i) {
		[parentNodes removeObjectAtIndex:0];
		[popup  removeItemAtIndex:0];
	}
	
	//Refresh the gui
	self.selectedNodeindex = [NSNumber numberWithInt:0];
	
	[directoryStack addObject:[parentNodes objectAtIndex:0]];
	DDLogInfo(@"directoryStack %@", directoryStack);
	[table reloadData];
}

- (void) setPopupMenuIcons
{
	int i =0; 
	for (i=0; i< [popup numberOfItems]; ++i) {
		[[popup itemAtIndex:i] setImage:[[parentNodes objectAtIndex:i] icon]];
	}
}

- (IBAction) open:(id)sender
{
	NSOpenPanel *op = [NSOpenPanel openPanel];
	[op setCanChooseFiles:NO];
	[op setCanChooseDirectories:YES];
    if ([op runModal] != NSOKButton) return;
    
	NSURL *url = [op URL];
	DDLogInfo(@"%@ selected", url);
	FileSystemNode *node  = [[FileSystemNode alloc ] initWithURL:url];
	[parentNodes removeAllObjects];
	[parentNodes addObjectsFromArray:[node parentNodes] ];
	
 	[directoryStack addObject:node];
	[table reloadData];
	
	NSInteger popupCount = [popup numberOfItems];
	NSInteger min = MIN([parentNodes count], popupCount);
	DDLogVerbose(@"min:%zu pN:%zu popN:%zu", min, [parentNodes count], popupCount);

	// Correct the number of items in the popupmenu
	NSInteger i;
	for (i=min; i < [parentNodes count]; ++i) {
		[popup addItemWithTitle:[[NSNumber numberWithLong:i] stringValue] ];
		DDLogVerbose(@"pN:%zu popN:%zu", [parentNodes count], [popup numberOfItems]);
	}	
	
	for (i=min; i < popupCount; ++i) {
		[popup removeItemAtIndex:0];
	}
	
	for (i=0; i < [popup numberOfItems]; ++i) {
		[[popup itemAtIndex:i] setTitle:[[parentNodes objectAtIndex:i] displayName]];
		[[popup itemAtIndex:i] setImage:[[parentNodes objectAtIndex:i] icon]];
	}	
	
}

#pragma mark -
#pragma mark Gui Callback

- (IBAction) search:(id)sender{
	if (vgc == nil){
		vgc = [[VgmdbController alloc] initWithFiles:[[directoryStack lastObject] children]];	
	}else{
		[vgc reset:[[directoryStack lastObject] children]];	
	}
	[NSApp beginSheet: [vgc window]
	   modalForWindow: self.window
		modalDelegate: vgc 
	   didEndSelector: @selector(didEndSheet:returnCode:mainWindow:)
		  contextInfo: self.window]; 	
}

- (id)valueForUndefinedKey:(NSString *)key
{
	NSLog(@"valueForUndefinedKey:%@",key);
	return @"ERROR";
}

#pragma mark -
#pragma mark Alloc/init

-(void) awakeFromNib
{	
	[self setPopupMenuIcons];
	[table setDoubleAction:@selector(onClick:)];
	[[table tableColumnWithIdentifier:@"filename"] setEditable:false];
	[[table tableColumnWithIdentifier:@"title"] setEditable:true];
	[table setTarget:self];
}

-(void) initDirectoryTable
{
	directoryStack = [[NSMutableArray alloc] init];
	forwardStack   = [[NSMutableArray alloc] init];

	FileSystemNode *currentDirectory = [[FileSystemNode alloc] initWithURL:
										[NSURL fileURLWithPath:@"/Users/bilalh/Movies/add/start/Atelier Meruru OST/"]];
	[directoryStack push:currentDirectory];
	
	self.currentNode       = nil;
	self.selectedNodeindex = [NSNumber numberWithInt:0];
	parentNodes            = [currentDirectory parentNodes];
	
	DDLogVerbose(@"Staring parentNodes%@", parentNodes);
}

- (id)init
{
    self = [super init];
    if (self) {
		[self initDirectoryTable ];
    }
	
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


@end
