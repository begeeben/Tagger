Changelog
=========

Version 1.7
-----------

### Features ###
* Open current folder In Terminal.
* Label column.
* Renaming Artists using a user specified list of names
* Renaming Tracks using a user specified list of names

### Improvements ###
* Uses taglib 1.8 hence it faster.
* Handles arranger and Performer missing for metadata searching
* Assigns the selected file to $f in the Terminal.

### Bug Fixes ### 
* Handle English (Official) in http://vgmdb.net/album/34827


Version 1.6.2 (Sat 22 Sep 2012)
-------------
### Bug Fixes ###
* Gui Fixes

Version 1.6.1 (Thu 13 Sep 2012)
-------------
### Bug Fixes ### 
* fix for http://vgmdb.net/album/33201.


Version 1.6 (Thu 13 Sep 2012 22:54:14 GMT+01:00)
-----------
### Improvements ###
* Much faster app loading (Now loads instantly compared with 10 seconds before).
* Auto taging rewriten in C++/Objective C hence much faster.
* Updated Code for Xcode 4.4 -- using the new syntax.
* Refactored Code.
* Go to Downloads shortcut changed to ⌥⌘L to comform to Finder's shortcut.
* File size reduced by over 50%.

### Bug Fixes ### 
* Fixes for 10.7.  
* Added unit tests.
* Html decoding
* Track number bug fix + tests



Version 1.5.4 (Wed 18 Jul 2012 21:55:06 +0100)
-------------
* 'Renumber Files' populates a null disc track count.
* Fixes issue #12 - Tags From Filenames > Using Custom Format : Uses the file's full path for the first tag!
* Updated to Macruby 0.12
* Update project to Xcode 4.3
* First version to built on 10.7

Version 1.5.3 (Sat Jan 14 2012 20:05:45 +0000)
-------------
* Renaming files from tags with a '/' in it, fixed.
* Help Menu.


Version 1.5.2 (Mon 02 Jan 2012  1:10:13 +0000)
-------------
### Features ###
* Poxy Icons.
* Batch Delete comments.


Version 1.5.1 (Sat 31 Dec 2011 21:18:29 +0000)
-------------
### Features ###
* Automatic updates using sparkle.
* Scripts to automatically make a release version, sign its dsa and make the appcast. 


Version 1.5 (Wed 28 Dec 2011 19:14:59 +0000)
-------------
### Features ###
* Scroll to specified row on keypress (like iTunes).
* Tabbing now goes the first cell of the next row upon reaching the end of a row.
* Spreadsheet View.
* Swapping first and last name menuitem for artist and other fields.
* Go menu icons.
* albumSort, artistSort, titleSort, composerSort and albumArtistSort field can now be edited.


### Improvements ###
* Handles missing data from vgmdb.
* Gui Improvements on Grouping and Genre field.
* Handles the different format for Performer in vgmdb that happens for some albums
* Comparing number where one of the number might be null.
* About dialog and homepage link

### Bug Fixes ### 
* MP3 cover art.

Version 1.4.3 (Sun 27 Nov 2011 05:33:51 +0000)
-------------
### Improvements ###
* Removed NSLogs.
* Deleting Tags from select files.
* Sort by date in when searching vgmdb.

### Bug Fixes ### 
* m4a delete all tags.

Version 1.4.2 (Fri 9 Sep 2011 04:09:19 +0100)
-------------
### Features ###
* Genre picker in auto tagger.
* Delete specified tags or all tags of selected tracks menu

### Improvements ###
* removed NSLogs.
* vgmdb enable.
* Fields alignment.
* Tags from file names refreshing

### Bug Fixes ### 
* Fixed most bugs in mp3 files when *replacing* (not adding) artwork on files who album art has *never* been edited in iTunes, means the file can't be added to iTunes for nearly all cases.
* Fixed  most bugs in mp4 files converted from flac using apps such XLD, when setting artwork, means the file can not be added to itunes.


Version 1.4.1 (Wed Aug 31 2011 22:01:34 +0100)
-------------
### Improvements ###
* Genre list.

### Bug Fixes ###
* Dragging files to table.
* vgmdb enable.

Version 1.4 (Tue Aug 30 2011 23:43:54 +0100)
-------------
### Features ###
* Results can be sorted when searching.
* Tooltips.
* Files can be dragged to the table.
* Added Latin as language since some soundtracks tracks are in [Latin](http://vgmdb.net/album/26335 "Puella Magi Madoka Magica Special CD 2 Original Soundtrack I").
* Arranges multiple catalog number nicely.
* Tags From Files (works like renames with tags).  
 	With error handing.  
 	and menus with predefined options.
* Rows in main table can be rearranged.
* Menu item for auto-Renumbering of files.
* Can drag a row ontop of another to copy tags.
* Genre and Grouping preferences.
	Defaults genre can be selected.
	auto complete.
* Capitalise, uppercase and lowercase tags menu.
	with all tags.
* Trim whitespace menu.

### Improvements ###
* Macruby loading.
* QuickLookTableView now works with delegate drag and drop now.
* Multiple values with ints.
* grouping and genre grow on resize

### Bug Fixes ###
* Metadata to Comments newline.
* Url when going directly to the results.
* Refresh.
* Fixed a bug where the composer was to the arranger.
* Made catalog field bigger since I found some rare long ids.
* Url when ending in a slash.
* Use jpeg when the user want jpeg instead of using png.
* Chooses the correct language if english is not there when auto tagging.
* Fixed a bug with extension checking (now uses filepath instead of display name).
* Fix nils when the album does not have a [platform](http://vgmdb.net/album/19776 "Neon Genesis Evangelion").
* Refreshing the table on renaming with custom format.
* Fixed a bug where copying tags from a mp3 to a m4a file.

Version 1.3 (Fri Aug 12 2011 16:19:09 +0100)
-----------
### Features ###
* Label colours for files shown.
* Nicer display of label colour for selected row.
* Right click menu that allows labelling files.
* Right click menu item reveal in finder.
* New 512x512 Icon 
* Can rid of unused code.
* When display search results, you can double click to go the albums webpage.

### Improvements ###
* Shows the label colour as a dot when selecting a labeled row.
* Can label multiple row at once.
* Does not show the of in disc 1 of 2 if there is total number of discs, same for tracks

### Bug Fixes ###
* When editing the data of a selected row.

Version 1.2 (Thu Aug 11 2011 03:34:20 +0100)
-----------
### Features ###
* When using using metadata to comments, the text aligns nicely in itunes.
* Allows going to the next/previous row using a keyboard (alt down/alt up).
* Updated to always show the selected row.  
* Export to Itunes menu option (alt cmd E).
* QuickLook support (allows playing of audio files).
* Shortcut cmd-Y.
* Allows multiple selection.
* Can use up down to go to next track
* Press space when on a selected track also does quicklook.
* Quicklook toolbar button.

### Improvements ###
* Disable Open Selected Folder if the user has not selected a folder.
* Disable QuickLook if the user has not selected a file.

### Bug Fixes ###
* Cover comparing with NSMultipleValuesMarker

Version 1.1.6 (Wed Aug 10 2011 05:34:41 +0100)
-------------
### Features ###
* refreshes the table on auto tagging.
* Small size (15mb smaller).

Version 1.1.5 (Wed Aug 10 2011 03:41:38 +0100)
-------------
### Features ###
* Adds formats for renaming. e.g. 01 - title .
* Are stored in the plist for easy changing.
* Can click any where on a directory row to go do it.
* Can open a selected  directory with cmd-O.

### Bug fixes ###
* highlighting When clicking on a directory.

Version 1.1 (Wed Aug 10 2011 01:31:51 +0100)
-----------
### Features ###
* Images can not be dragged for directory.
* The cover art is now named 'title - cover' which allows 
multiple cover to be dragged to the desktop/
* Which can be changed in the prefs.

Version 1.0.1 (Tue Aug 09 2011 16:52:14 +0100)
-------------
### Features ###
* Debug statement do not appear in release version. 

### Bug fixes ###
* Fix a bug with the vgmdb menu item not been enable.

Version 1.0 (Tue Aug 09 2011 05:05:41 +0100)
-----------
### Features ###
* Added a button for searching vgmdb.
* Display the result if there is only one result from the search.
* Back/forward/Reveal/Vgmdb disable when not usable instead of doing nothing.
* Menu item and shortcut cmd-1 for going to the starting directory.
* Table columns sorting and highlighting on all columns.
* Auto embed Macruby .
* Embed  tablib and fixed build settings.
* Table columns lengths
* Shows the results straight away if there only one when searching Vgmdb
* The cover art can be dragged to finder or any other place 
* Pref for how cover art is dragged

### Bug fixes ###
* Fixed a bug when vgmdb returns no results.

Version 0.13 (Sun Aug 07 2011 23:39:44 +0100)
------------
### Features ###
* Music files (m4a and mp3) can be dragged onto the dock icon to go the directory of the file.
* Can drag directory but now allows all files.
* Size column.
* Tags can now do bitrate channels sample rate and kind.
* FileSystemNode can now tell it size.
* Disc and track pairs.
* Prefs for hiding columns.
* Default values.
* Prefs for setting start directory.
* Allows using the current directory as the start directory.

### Bug fixes ###
* Fixed Warnings about missing method.
* Fixed a bug where no window was open.


Version 0.12 (Fri Aug 05 2011 02:23:54 +0100)
------------
### Features ###
* Pad the track number when renaming.
* Batch renaming using sub directories.
* Shortcuts for back and forward.
* Shortcuts for parent directory.
* Menu and shortcuts for common directories.
* Refresh menu item.
* Reveal in Finder menu item.
* Reopen menu item which opens the last open window.
* Shows that the selected tracks have different values.

### Bug fixes ###
* Fixed a bug where selection was not consecutive.
* Fixed a bug with update data when changing directory.
* Field are now not editable when selecting a directory.
* Compares images properly which shows if the selected files has the same image.

Version 0.11 (Tue Aug 02 2011 03:21:21 +0100)
------------
### Features ###
* Better error handing. 
* Allows batch renaming of files based on tags.
* Gui for batch renaming of files based on tags.


Version 0.10 (Sun Jul 31 2011 04:51:54 +0100)
------------
### Features ###
* Made comments tag iTunes compatible.
* Muti-row editing.
* Some bug fixes.


Version 0.9 (Fri Jul 29 2011 15:05:00 +0100)
-----------
### Features ###
* The length of track can now be found using Tags.
* Auto tagging for tracks names is done
* Allows choosing the language.
* Auto tagging for other fields done.
* Allows choosing which fields to update.
* Show the url, which is clickable.
* Read and write of url tag.
* Allows saving of url of from auto tagger.
* Read/write mp3 cover art.
* Read/write mp4 cover art.

### Bug fixes ###
* Made length column uneditable since it should not be changed.


Version 0.8 (Mon Jul 25 2011 02:55:27 +0100)
-----------
### Features ###
* Complete mp3 (IDV tag read/write support.
* Allows clearing number fields e.g year.
* Validate number fields to allow only numbers. 
* Allows changes the language of each field in the results from vgmdb.
* Now allows search using the tags of the song to allow easier searching.

### Bug fixes ###
* Better error handing when vgmdb is missing data.
* Fixed a bug when trying to save a field with an empty string.


Version 0.7 (Fri Jul 22 2011 20:06:13 +0100)
-----------
### Features ###
* Complete mp4 tag read/write support.
* File browser with previous and forward buttons.
* Allows user specified directory with a open dialog. 
* Allows going to parent directories easily.  


Older Versions
--------------
### Features ###
* Allow editing of data directory in the table view
* Able to search for albums on vgmdb and get the data for that album.
* Using a gui.
* Allows searching three languages English, Romaji and Kanji.
* Menu items for to Uppercase ^U, to Lowercase Shift ^U, Capitalise Command ^U
* GUI
* Classes 

