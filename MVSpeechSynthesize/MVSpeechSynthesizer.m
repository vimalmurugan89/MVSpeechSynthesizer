//
//  MVSpeechSynthesizer.m
//  MVSpeechSynthesize
//
//  Created by admin on 17/03/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "MVSpeechSynthesizer.h"

@interface MVSpeechSynthesizer()
@property(nonatomic,strong)CALayer *higlightLayer;
- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView *)textView;
-(NSString*)detectLanguage:(NSString*)string;
-(void)showHiglightLayerAt:(CGRect)rect;
@end

@implementation MVSpeechSynthesizer

#pragma mark - Singleton method
+(id)sharedSyntheSize{
    
    static dispatch_once_t once;
    static MVSpeechSynthesizer *speechSynthesizer;
    dispatch_once(&once, ^{
        speechSynthesizer = [[MVSpeechSynthesizer alloc]init];
    });
    return speechSynthesizer;
    
}


#pragma mark - init method
-(id)init{
    if (self=[super init]) {
        
        _speechSynthesizer=[[AVSpeechSynthesizer alloc]init];
        _speechSynthesizer.delegate=self;
        _speechBoundary=AVSpeechBoundaryImmediate;
        _uRate=AVSpeechUtteranceDefaultSpeechRate/4;
        _pitchMultiplier=1.2;
        _higlightColor=[UIColor blueColor];
    }
    return self;
}

#pragma mark -global method
-(void)startReadingWithString:(NSString*)readString{
    
    if (!readString)
        return;
    
    [self stopReading];
    
    if (_speechUtterence)
        _speechUtterence=nil;
    
    // NSLog(@"detected langauage-%@", [self detectLanguage:readString]);
    // _speechVoice=@"de-DE";//[self detectLanguage:readString];
    NSLog(@"setvoice=%@",_speechVoice);
    _speechUtterence=[[AVSpeechUtterance alloc]initWithString:readString];
    _speechUtterence.rate=_uRate;
    _speechUtterence.pitchMultiplier=_pitchMultiplier;
    [_speechUtterence setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:_speechVoice]];
    [_speechSynthesizer speakUtterance:_speechUtterence];
    
}

-(BOOL)isSpeaking{
    return [_speechSynthesizer isSpeaking];
}


-(BOOL)isPaused{
    return [_speechSynthesizer isPaused];
}



-(void)continueReading{
    [_speechSynthesizer continueSpeaking];
}

-(void)stopReading{
    
    if ([_speechSynthesizer isSpeaking])
        [_speechSynthesizer stopSpeakingAtBoundary:_speechBoundary];
    
}

-(void)pauseReading{
    if ([_speechSynthesizer isSpeaking])
        [_speechSynthesizer pauseSpeakingAtBoundary:_speechBoundary];
}

-(NSString*)speakingString{
    if (_speechUtterence)
        return _speechUtterence.speechString;
    
    return nil;
}

-(NSArray*)supportedLanguages{
    return [AVSpeechSynthesisVoice speechVoices];
}

-(NSString*)currentLangaugeCode{
    return [AVSpeechSynthesisVoice currentLanguageCode];
}

-(NSString*)speakingLanguage{
    return _speechVoice;
}


#pragma mark - Private methods
- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView *)textView{
    
    UITextPosition *beginning = textView.beginningOfDocument;
    UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end];
    CGRect rect = [textView firstRectForRange:textRange];
    return [textView convertRect:rect fromView:textView.textInputView];
}
-(void)showHiglightLayerAt:(CGRect)rect{
    [_higlightLayer removeFromSuperlayer];
    _higlightLayer=[CALayer layer];
    [_higlightLayer setBackgroundColor:_higlightColor.CGColor];
    [_higlightLayer setOpacity:0.5f];
    [_higlightLayer setFrame:rect];
    [[_inputView layer]addSublayer:_higlightLayer];
    
}
-(NSString*)detectLanguage:(NSString*)string{
    NSArray *tagschemes = [NSArray arrayWithObjects:NSLinguisticTagSchemeLanguage, nil];
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:tagschemes options:0];
    [tagger setString:string];
    NSString *language = [tagger tagAtIndex:0 scheme:NSLinguisticTagSchemeLanguage tokenRange:NULL sentenceRange:NULL];
    return language;
}

#pragma mark -List of AVSpeechSynthesizer delegate methods
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (_speechStartBlock) {
        _speechStartBlock(synthesizer,utterance);
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    
    if(_isTextHiglight)
        [_higlightLayer removeFromSuperlayer];
    
    if (_speechFinishBlock) {
        _speechFinishBlock(synthesizer,utterance);
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (_speechPauseBlock) {
        _speechPauseBlock(synthesizer,utterance);
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (_speechContinueBlock) {
        _speechContinueBlock(synthesizer,utterance);
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (_speechCancelBlock) {
        _speechCancelBlock(synthesizer,utterance);
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
    
    if(_isTextHiglight){
        
        CGRect finalLineRect=[self frameOfTextRange:characterRange inTextView:_inputView];
        [self showHiglightLayerAt:finalLineRect];
        [_inputView scrollRangeToVisible:characterRange];
    }
    
    if (_speechSpeakingWord) {
        _speechSpeakingWord(synthesizer,characterRange,utterance,[utterance.speechString substringWithRange:characterRange]);
    }
    
    if (_speechRangeBlock) {
        _speechRangeBlock(synthesizer,characterRange,utterance);
    }
}


@end
