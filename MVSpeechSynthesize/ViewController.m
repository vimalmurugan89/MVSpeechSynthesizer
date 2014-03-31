//
//  ViewController.m
//  MVSpeechSynthesize
//
//  Created by admin on 17/03/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,weak)IBOutlet MVSearchWebView *searchWebView;
@property(nonatomic,weak)NSMutableAttributedString *sampleAttributedText;
@property(nonatomic,weak)IBOutlet UITextView *sampleTextview;
@property(nonatomic,strong)UIView *higlightTextView;
@property(nonatomic,strong)CALayer *higlightLayer;
@property(nonatomic)NSRange sampleRange;
@property(nonatomic,weak)IBOutlet UIButton *readButton;
-(IBAction)startRead:(id)sender;
-(IBAction)higlight:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    _readButton.enabled=NO;
    _searchWebView.hidden=NO;
    _sampleTextview.hidden=YES;
    
    
    _higlightTextView=[[UIView alloc]init];
    _higlightTextView.backgroundColor=[UIColor yellowColor];
   // [_sampleTextview addSubview:_higlightTextView];
    
    _higlightLayer=[CALayer layer];
   
    
    //[_higlightLayer setCornerRadius:5.0f];
    [_higlightLayer setBackgroundColor:[[UIColor blueColor]CGColor]];
    [_higlightLayer setOpacity:0.2f];
    [[_sampleTextview layer]addSublayer:_higlightLayer];
  //  [_higlightLayer setBorderColor:[[UIColor blackColor]CGColor]];
 //   [_higlightLayer setBorderWidth:3.0f];
  //  [_higlightLayer setShadowColor:[[UIColor blackColor]CGColor]];
   // [_higlightLayer setShadowOffset:CGSizeMake(20.0f, 20.0f)];
   // [_higlightLayer setShadowOpacity:1.0f];
   // [_higlightLayer setShadowRadius:10.0f];
  //  [[_sampleTextview layer]addSublayer:_higlightLayer];
    
    
 /*   [_searchWebView loadHTMLString:@"<html><head></head><body id='value'>I can't see any reason why the US version would have any less voices. Indeed it presumably has at least one more as Siri in the US has a choice of male and female voices - the male voice sounds like it be Alex from the Mac, but there doesn't seem to be any way to access it programmatically.</body></html>" baseURL:nil];*/
    
  /*  [_searchWebView loadHTMLString:@"<!DOCTYPE HTML><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"></head><body><div id=\"main\" contenteditable=\"false\" style=\"border:solid 1px black; width:300px; height:300px\"><div>Hello world!</div><div><br></div><div>This is a paragraph</div></div></body></html>" baseURL:nil];*/
    
    _searchWebView.webviewFinished=^(id webView){
        _readButton.enabled=YES;
    };
    
  /*  _sampleTextview.text=@"I can't see any reason why the US version would have any less voices. Indeed it presumably has at least one more as Siri in the US has a choice of male and female voices - the male voice sounds like it be Alex from the Mac, but there doesn't seem to be any way to access it programmatically.";
    //_sampleAttributedText=_sampleTextview.attributedText.mutableCopy;*/
    
    
    [_searchWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.co.in"]]];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)startRead:(id)sender{
    
    
    _searchWebView.hidden=YES;
    _sampleTextview.hidden=NO;
    [sender setEnabled:NO];
    NSString *webViewString=[_searchWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerText;"];
    NSLog(@"webview =%@",webViewString);
    _sampleTextview.text=webViewString;
    
    
    MVSpeechSynthesizer *mvSpeech=[MVSpeechSynthesizer sharedSyntheSize];
    [mvSpeech startReadingWithString:webViewString];
    
    mvSpeech.speechFinishBlock=^(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence){
        [sender setEnabled:YES];
        _searchWebView.hidden=NO;
        _sampleTextview.hidden=YES;
       // _sampleRange=NSMakeRange(-1, 0);
       // _sampleTextview.attributedText=nil;
         [_higlightLayer removeFromSuperlayer];
    };
    
    mvSpeech.speechSpeakingWord=^(AVSpeechSynthesizer *synthesizer,NSRange range, AVSpeechUtterance *utterence,NSString *speakingWord){
   
        //NSLog(@"rect==%@",));
        
        CGRect finalLineRect=[self frameOfTextRange:range inTextView:_sampleTextview];
       // _higlightTextView.frame=rectFrame;
        [_higlightLayer setFrame:finalLineRect];
        [_higlightLayer setBounds:finalLineRect];
        [_higlightLayer removeFromSuperlayer];
        [[_sampleTextview layer]addSublayer:_higlightLayer];
                                            
      /*   NSMutableAttributedString *textViewAttributedString = _sampleTextview.attributedText.mutableCopy;
   
        
        if(_sampleRange.location!=NSNotFound){
            [textViewAttributedString removeAttribute:NSBackgroundColorAttributeName range:_sampleRange];
        }
            
        
        [textViewAttributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
   
        _sampleTextview.attributedText=textViewAttributedString;
        _sampleRange=range;*/
        [_sampleTextview scrollRangeToVisible:range];
       
        
    };
    
}

- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView *)textView
{
    UITextPosition *beginning = textView.beginningOfDocument; //Error=: request for member 'beginningOfDocument' in something not a structure or union
    
    UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end];
    CGRect rect = [textView firstRectForRange:textRange];  //Error: Invalid Intializer
    
    return [textView convertRect:rect fromView:textView.textInputView]; // Error: request for member 'textInputView' in something not a structure or union
    
    
    
}

-(IBAction)higlight:(id)sender{
  //  [_searchWebView highlightAllOccurencesOfString:@"Siri"];
    [_searchWebView highlightBackground:@"see"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
