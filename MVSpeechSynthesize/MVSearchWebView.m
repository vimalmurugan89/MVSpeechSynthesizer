//
//  MVSearchWebView.m
//  MVSpeechSynthesize
//
//  Created by admin on 17/03/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "MVSearchWebView.h"

@implementation MVSearchWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate=(id)self;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        self.delegate=(id)self;
    }
    return self;
}


#pragma mark -Webview Delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (_webviewFinished) {
        _webviewFinished(webView);
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma mark -Webview JS methods
- (NSInteger)highlightAllOccurencesOfString:(NSString*)str
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
    NSString *startSearch = [NSString stringWithFormat:@"uiWebview_HighlightAllOccurencesOfString('%@');",str];
    [self stringByEvaluatingJavaScriptFromString:startSearch];
    
    NSString *result = [self stringByEvaluatingJavaScriptFromString:@"uiWebview_SearchResultCount"];
    return [result integerValue];
}
-(void)highlightAllOccurencesOfStringWithRange:(NSUInteger)value string:(NSString*)key{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
    NSString *startSearch = [NSString stringWithFormat:@"uiWebview_HighlightAllOccurencesOfStringWithRange('%lu','%@');",(unsigned long)value,key];
    
    
    [self stringByEvaluatingJavaScriptFromString:startSearch];
}
-(void)highlightBackground:(NSString*)value{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
   
    
    
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"highlight('%@');",value]];
}
-(NSString*)childNodesDetails{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
    
    NSString *result=[self stringByEvaluatingJavaScriptFromString:@"childNodesDetails();"];
    return result;
}

- (void)removeAllHighlights
{
    [self stringByEvaluatingJavaScriptFromString:@"uiWebview_RemoveAllHighlights()"];
}

@end
