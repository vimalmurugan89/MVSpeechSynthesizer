//
//  MVSpeechSynthesizer.m
//  MVSpeechSynthesize
//
//  Created by admin on 17/03/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "MVSpeechSynthesizer.h"

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

-(id)init{
    if (self=[super init]) {
        _speechSynthesizer=[[AVSpeechSynthesizer alloc]init];
        _speechSynthesizer.delegate=self;
        _speechBoundary=AVSpeechBoundaryImmediate;
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
    
    _speechUtterence=[[AVSpeechUtterance alloc]initWithString:readString];
    _speechUtterence.rate=AVSpeechUtteranceDefaultSpeechRate/4;
    [_speechUtterence setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:_speechVoice]];
    [_speechSynthesizer speakUtterance:_speechUtterence];
    
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

-(NSArray*)listOfVoices{
    return [AVSpeechSynthesisVoice speechVoices];
}

-(NSString*)currentLangaugeCode{
    return [AVSpeechSynthesisVoice currentLanguageCode];
}


#pragma mark -List of AVSpeechSynthesizer delegate methods
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (_speechStartBlock) {
        _speechStartBlock(synthesizer,utterance);
    }
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
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
    
   
    
    if (_speechSpeakingWord) {
        _speechSpeakingWord(synthesizer,characterRange,utterance,[utterance.speechString substringWithRange:characterRange]);
    }
    
    if (_speechRangeBlock) {
        _speechRangeBlock(synthesizer,characterRange,utterance);
    }
}


@end
