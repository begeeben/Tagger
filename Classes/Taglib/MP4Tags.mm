//
//  MP4Tags.m
//  VGTagger
//
//  Created by Bilal Syed Hussain on 14/07/2011.
//  Copyright 2011  All rights reserved.
//

#import "MP4Tags.h"
#import "TagStructs.h"
#import "NSString+Convert.h"
#import "Fields.h"
#import "NSImage+bitmapData.h"
#include "TagPrivate.h"

#include <mp4tag.h> 
#include <mp4file.h>

#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_ERROR);

@interface MP4Tags()
- (NSString*) getFieldWithString:(TagLib::String)field;
- (TagLib::MP4::Item) getField:(TagLib::String)field;
- (bool) setFieldWithString:(TagLib::String)field
					  value:(NSString*)value;
@end

using namespace TagLib;
using namespace MP4Fields;
using namespace std;
@implementation MP4Tags

#pragma mark -
#pragma mark init/alloc

- (id) initWithFilename:(NSString *)filename
{
    self = [super initWithFilename:filename];
    if (self) {
		data->f->mp4 = new MP4::File([filename UTF8String]);
		data->file = data->f->mp4;
		[self initFields];
		kind = @"MP4";
    }
    
    return self;	
}

-(void) initFields
{	
	[super initFields];	
	const MP4::Item::IntPair tracks = [self getField:TRACK_NUMBER].toIntPair();
	const MP4::Item::IntPair discs  = [self getField:DISK_NUMBER].toIntPair();
	MP4::CoverArtList coverList;
	int i;
	
	
	albumArtist  = [self getFieldWithString:ALBUM_ARTIST];
	composer     = [self getFieldWithString:COMPOSER];
	grouping     = [self getFieldWithString:GROUPING];
	compilation  = [NSNumber numberWithBool:[self getField:COMPILATION].toBool()];
	i            = [self getField:BPM].toInt();
	bpm          = i ?  [NSNumber numberWithInt: i] : nil;
	
	disc         = discs.first   ? [NSNumber numberWithInt:discs.first]   : nil;
	totalDiscs   = discs.second  ? [NSNumber numberWithInt:discs.second]  : nil;
	totalTracks  = tracks.second ? [NSNumber numberWithInt:tracks.second] : nil;
	
	url          = [self getFieldWithString:URL];
	coverList    = [self getField:COVER].toCoverArtList();
	if (!coverList.isEmpty()){
		TagLib::ByteVector bv = coverList.front().data();
		cover = [[[NSImage alloc] initWithData: [NSData dataWithBytes:bv.data() length:bv.size()]] autorelease];
	}
	
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Fields helpers

- (MP4::Item) getField:(TagLib::String)field
{
	MP4::Tag * const t = data->f->mp4->tag();
	const MP4::ItemListMap &map =  t->itemListMap();
	if (!map.contains(field)) return 0;
	
	return  map[field];
}


- (NSString*) getFieldWithString:(TagLib::String)field
{
	MP4::Tag * const t = data->f->mp4->tag();
	const MP4::ItemListMap &map =  t->itemListMap();
	if (!map.contains(field)) return nil;
		
	const char *cstring = map[field].toStringList().front().toCString(true); 
	return [NSString stringWithUTF8String:cstring];
}


- (bool) setFieldWithString:(TagLib::String)field
					  value:(NSString*)value
{	
	MP4::Tag * const t = data->f->mp4->tag();
	MP4::ItemListMap &map =  t->itemListMap();	
	map.insert(field,StringList([value tagLibString]));
	return data->file->save();
}

- (bool) setField:(TagLib::String)field
					  value:(MP4::Item)valueItem
{	
	MP4::Tag * const t = data->f->mp4->tag();
	MP4::ItemListMap &map =  t->itemListMap();	
	map.insert(field,valueItem);
	return data->file->save();
}


#pragma mark -
#pragma mark Setters

- (void) setAlbumArtist:(NSString *)newValue
{ 
	TAG_SETTER_START(albumArtist);
	[self setFieldWithString:ALBUM_ARTIST  value:newValue]; 
}

- (void) setComposer:(NSString *)newValue
{
	TAG_SETTER_START(composer);
	[self setFieldWithString:COMPOSER  value:newValue]; 
}

- (void) setGrouping:(NSString *)newValue
{
	TAG_SETTER_START(grouping);
	[self setFieldWithString:GROUPING  value:newValue]; 
}

- (void) setBpm:(NSNumber *)newValue
{
	TAG_SETTER_START(bpm);
	[self setField:BPM value:  MP4::Item([newValue intValue])];
}

- (void) setTrack:(NSNumber *)newValue
{
	TAG_SETTER_START(track);
	[self setField:TRACK_NUMBER value:MP4::Item([newValue intValue], [totalTracks intValue])];
}

- (void) setTotalTracks:(NSNumber *)newValue
{
	TAG_SETTER_START(totalTracks);
	[self setField:TRACK_NUMBER value:MP4::Item([track intValue], [newValue intValue])];
}

- (void) setDisc:(NSNumber *)newValue
{
	TAG_SETTER_START(disc);
	[self setField:DISK_NUMBER value:MP4::Item([newValue intValue], [totalDiscs intValue])];
}

- (void) setTotalDiscs:(NSNumber *)newValue
{
	TAG_SETTER_START(totalDiscs);
	[self setField:DISK_NUMBER value:MP4::Item([disc intValue], [newValue intValue])];
}

- (void) setCompilation:(NSNumber *)newValue
{
	TAG_SETTER_START(compilation);
	[self setField:COMPILATION value:MP4::Item([newValue boolValue] )];
}

- (void) setUrl:(NSString *)newValue
{
	TAG_SETTER_START(url);
	[self setFieldWithString:URL  value:newValue]; 
}

- (void) setCover:(NSImage *)newValue
{
	using namespace TagLib::MP4;
	TAG_SETTER_START(cover);
	
	NSData *imageData = [cover bitmapDataForType:NSJPEGFileType];
	CoverArt ca = CoverArt(CoverArt::JPEG, ByteVector((const char *)[imageData bytes], (uint)[imageData length]));	
	CoverArtList list = CoverArtList();
	list.append(ca);
	[self setField:COVER value:list];
}




@end