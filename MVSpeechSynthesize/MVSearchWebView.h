//
//  MVSearchWebView.h
//  MVSpeechSynthesize
//
//  Created by admin on 17/03/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <UIKit/UIKit.h>


//Didstart method of speechsythesizer
typedef void (^MVWebviewDidFinished)(id webView);

@class MVSearchWebView;
@interface MVSearchWebView : UIWebView
- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;
-(void)highlightAllOccurencesOfStringWithRange:(NSUInteger)value string:(NSString*)key;
-(NSString*)childNodesDetails;
-(void)highlightBackground:(NSString*)value;
@property(nonatomic,copy)MVWebviewDidFinished webviewFinished;
@end
