//
//  Vgmdb.m
//  Tagger
//
//  Created by Bilal Hussain on 23/07/2012.
//  Copyright (c) 2012 All rights reserved.
//

#import "Vgmdb.h"
#import "Vgmdb+private.h"

#import "NSString+Convert.h"

#import "Logging.h"
LOG_LEVEL(LOG_LEVEL_VERBOSE);

#include <string>
#include <iostream>
#include <set>

#include <htmlcxx/html/ParserDom.h>

#include "hcxselect.h"
#include "VgmdbStruct.h"


static const NSDictionary *namesMap;

using namespace std;
using namespace hcxselect;




static const NSString const *testFolder = @"/Users/bilalh/Projects/Tagger/Test Files/Albums/";
@implementation Vgmdb

#pragma mark -
#pragma mark init


- (id)init
{
    self = [super init];
    if (self) {
        DDLogVerbose(@"ddd");
//        [self searchResults:@"Rorona"];
        
//        NSString *s=  [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://vgmdb.net/album/13192"]
//                                               encoding:NSUTF8StringEncoding
//                                                  error:nil];
//        [s writeToFile:[@"~/ar.html" stringByExpandingTildeInPath]
//            atomically:NO
//              encoding:NSUTF8StringEncoding
//                 error:nil];
        
        NSString *name = @"muti-disk.html";
        NSString *_url = [testFolder stringByAppendingPathComponent:name];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:_url];
        
//        NSDictionary *d =[self getAlbumData:url];
//        DDLogInfo(@"%@ ", d);
    }
    return self;
}

+ (void)initialize
{
    namesMap = [NSDictionary dictionaryWithObjectsAndKeys:
                @"@english", @"en",
                @"@kanji",   @"ja",
                @"@romaji",  @"ja-Latn",
                @"@english", @"English",
                @"@kanji",   @"Japanese ",
                @"@romaji",  @"Romaji",
                @"latin",    @"",
                nil];
}

#pragma mark -
#pragma mark Searching 

- (NSArray*) searchResults:(NSString*)search
{
    NSString *baseUrl = @"http://vgmdb.net/search?q=";
    NSString *tmp = [baseUrl stringByAppendingString:search];
    NSString *_url = [tmp stringByAddingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
    NSError *err = nil;
    string *html  = [self cppstringWithContentsOfURL:[NSURL URLWithString:_url]
                                              error:&err];
    
    if (!err){
        htmlcxx::HTML::ParserDom parser;
        tree<htmlcxx::HTML::Node> dom = parser.parseTree(*html);
        Selector s(dom);
        
        NSMutableArray *rows = [[NSMutableArray alloc] init];
        
        Selector res = s.select("div#albumresults tbody > tr");
//        cout << "Selector num:" << res.size() << "\n";
        
        Selector::iterator it = res.begin();    
        for (; it != res.end(); ++it) {
//            [self printNode:*it inHtml:html];
            
            Node *catalog_td = (*it)->first_child;
            string _catalog = catalog_td->first_child->first_child->data.text();
            NSString *catalog = [[NSString alloc] initWithCppString:&_catalog];
            
            Node *title_td = catalog_td->next_sibling->next_sibling;
            Node *first_title = title_td->first_child->first_child;
            NSDictionary *album =[self splitLanguagesInNodes:first_title];
            
            Node *url_a = title_td->first_child;
            url_a->data.parseAttributes();
            map<string, string> att= url_a->data.attributes();
            string _url = att["href"];
            NSString *url = [[NSString alloc] initWithCppString:&_url];
            
            Node *year_td = title_td->next_sibling;
            Node *year_t = year_td;
            while(year_t->data.isTag()){
                year_t = year_t->first_child;
            }
            
            
            string _year = year_t->data.text();
            NSString *year = [[NSString alloc] initWithCppString:&_year];

            [rows addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                             catalog, @"catalog" ,
                             year,    @"released",
                             album,   @"album",
                             url,     @"url",
                             nil]];
        }
        
        return rows; 
        
    }else {
        DDLogInfo(@"%@", [err localizedFailureReason]);
    }
    
    return [NSArray new];
}

#pragma mark -
#pragma mark Album data

// 
- (NSDictionary*) getAlbumTitles:(const tree<htmlcxx::HTML::Node>&)dom
                         forHtml:(const std::string&)html
{
    Selector s(dom);
    Selector res = s.select("h1>span.albumtitle");
    Node *n = *res.begin();
//    [self printNode:n inHtml:html];
    NSDictionary *titles = [self splitLanguagesInNodes:n];
    return titles;
}

- (Node*) getNodeFrom:(std::string) selector
        usingSelector:(Selector) s
{
    Selector res = s.select("h1>span.albumtitle");
    Node *n = *res.begin();
    return n;
}


- (void) storeMetadata:(const tree<htmlcxx::HTML::Node>&)dom
               forHtml:(const std::string&)html
                in:(NSDictionary*)data
{
    Node *n;
    Selector s(dom);
    Selector meta = s.select("table#album_infobit_large");
    
    /* Catalog */
    Selector catalogElem = meta.select("tr td[width='100%']");
    n = *catalogElem.begin();
    
    string _catalog = n->first_child->data.text();
    NSString *catalog = [[NSString alloc] initWithCppString:&_catalog];
    catalog =  [catalog stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [data setValue:catalog forKey:@"catalog"];
    
    Node *m = *meta.begin();
    
    // Get the text value of the specifed node
    NSString* (^get_data)(Node*) = ^(Node *n){
        Node *m = n->last_child;
        while (m->data.isTag()) {
            m = m ->first_child;
        }
        string temp =  m->data.text();
        return [NSString stringWithCppStringTrimmed:&temp];
	};
    
    Node *ndate = m->first_child->next_sibling->next_sibling->next_sibling;
    NSString *date = get_data(ndate);
    [data setValue:date forKey:@"date"];
    
    NSRegularExpression* dateRegex = [NSRegularExpression regularExpressionWithPattern:@"\\d{4}$"
                                                                               options:0
                                                                                 error:nil];
    NSTextCheckingResult *result =[dateRegex firstMatchInString:date
                                                    options:0
                                                      range:NSMakeRange(0, [date length])];
    NSString *year = [date substringWithRange:result.range];
    [data setValue:year forKey:@"year"];
    
    
    Node *npub = ndate->next_sibling->next_sibling;
    [data setValue:get_data(npub) forKey:@"publishedFormat"];
    
    Node *nprice = npub->next_sibling->next_sibling;
    [data setValue:get_data(nprice) forKey:@"price"];

    Node *nfor = nprice->next_sibling->next_sibling;
    [data setValue:get_data(nfor) forKey:@"mediaFormat"];
    
    
    
}
 
- (NSDictionary*)getAlbumData:(NSURL*) url
{
    NSMutableDictionary *data = [NSMutableDictionary new];
    
    NSError *err;
    string *html = [self cppstringWithContentsOfURL:url error:&err];
    
    if (html == NULL){
        NSLog(@"Error %@", [err localizedDescription]);
        return data;
    }
    
    htmlcxx::HTML::ParserDom parser;
    tree<htmlcxx::HTML::Node> dom = parser.parseTree(*html);
    Selector s(dom);
    
    [data setValue:[self getAlbumTitles:dom forHtml:*html]
            forKey:@"album"];
    
    [self storeMetadata:dom forHtml:*html in:data];
    
    [data setValue:url forKey:@"url"];
    return data;
}


#pragma mark -
#pragma mark Common

- (NSDictionary*)splitLanguagesInNodes:(Node*)node
{
    NSMutableDictionary *titles= [NSMutableDictionary new];
    while (node) {
        
        node->data.parseAttributes();
        map<string, string> att= node->data.attributes();
//        cout << att.size();
        map<string, string>::iterator itLang= att.find("lang");
        
        NSString *lang;
        if (att.end() != itLang){
            string _lang  = itLang->second;
            lang = [[NSString alloc] initWithCppString:&_lang];
            lang = [namesMap valueForKey:lang];
        }else{
            lang = @"@english";
        }
        
        if (node->next_sibling){
            Node *titleNode = node->first_child;
            while(titleNode->data.isTag()){
                if (!titleNode->next_sibling){
                    titleNode = titleNode->first_child;
                }else{
                    titleNode = titleNode->next_sibling;
                }
            }
            
            string _title = titleNode->data.text();
            NSString *title = [[NSString alloc] initWithCppString:&_title];
            
            [titles setValue: title forKey:lang];
        }
        
        node = node->next_sibling;
    }
    return titles;
}

#pragma mark -
#pragma mark Html helpers  

- (void)printNode:(Node*)node
           inHtml:(std::string)html
{
    cout << html.substr(node->data.offset(), node->data.length()) << "\n\n\n";
}

- (std::string*) cppstringWithContentsOfURL:(NSURL*)url
                                     error:(NSError**)error
{
    NSString *_html = [NSString stringWithContentsOfURL: url
                                               encoding:NSUTF8StringEncoding
                                                  error:error];
    if (!(*error)){
        return new string([_html UTF8String]);
    }
    return NULL;
}

@end