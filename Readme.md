Tagger {#readmeTitle}
=====
Tagger is application that auto tags audio files. It also supports batch tag editing See the [website](http://bilalh.github.com/projects/mplayer-last-fm-scrobbler/ "details") for details 
{#description}

Prerequisites
-------------
* Mac OS X 10.6+
* 64 bit only

Install From Source
-------------------
### Prerequisites
* Mac OS X 10.6+
* Macruby 0.10+
* 64 bit only

### Introductions
Build the release version of VGTagger.

(When embeding make sure require 'rubygems'  is commented with a # before it)

Run Embed MacRuby on it which does the follows to embed the MacRuby framework

	macruby_deploy --compile --embed --gem nokogiri --gem htmlentities --verbose

To save 15mb you can remove the unused .rb files in		
  `VGTagger.app/Contents/Frameworks/MacRuby.framework/Versions/0.10/usr/lib/ruby/1.9.2`



Issues
------
* Bug in mp3 files when *replacing* (not adding) artwork on files who album art has *never* been edited in iTunes, means the file can't be added to iTunes, happen rarely4.

Libraries Used
--------------
* MacRuby
* TagLib  

* BWHyperlinkButtonCell from BWToolKit
* CCTColorLabelMenuItemView
* Lumberjack
* MASPreferencesViewController

Licence
-------
[Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-nc-sa/3.0/ "Full details")

Authors
-------
* Bilal Hussain