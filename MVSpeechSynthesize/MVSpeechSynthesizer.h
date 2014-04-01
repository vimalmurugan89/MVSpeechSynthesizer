//
//  MVSpeechSynthesizer.h
//  MVSpeechSynthesize
//
//  Created by admin on 17/03/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

//List of Blocks methods for handling delegate methods of AVSpeechSynthesizer

//Didstart method of speechsythesizer
typedef void (^MVDidStartSpeech)(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence);

//Didfinish method of speechsynthesizer
typedef void (^MVDidFinishSpeech)(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence);

//Didpause method of speechsynthesizer
typedef void (^MVDidPauseSpeech)(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence);

//Didcontinue method of speechsynthesizer
typedef void (^MVDidContinueSpeech)(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence);

//DidCancel method of speechsynthesizer
typedef void (^MVDidCancelSpeech)(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence);

//SpeakRange method of speechsynthesizer
typedef void (^MVSpeakRangeSpeech)(AVSpeechSynthesizer *synthesizer,NSRange range, AVSpeechUtterance *utterence);

//Get speaking word
typedef void (^MVSpeechSpeakingWord)(AVSpeechSynthesizer *synthesizer,NSRange range, AVSpeechUtterance *utterence,NSString *speakingWord);

@interface MVSpeechSynthesizer : NSObject<AVSpeechSynthesizerDelegate>



//Singleton method
+(id)sharedSyntheSize;


//Pass the input view
@property(nonatomic)id inputView;

//Higlight color property
@property(nonatomic,retain)UIColor *higlightColor; //Default color is blue

//Decide text higlight option
@property(nonatomic)BOOL isTextHiglight;

/* Set lenaguag for speaking
 */
@property(nonatomic,strong)NSString *speechLanguage;

//Set speaking voice
@property(nonatomic,strong)NSString *speechVoice;


//Set stop/pause boundary attribute
@property(nonatomic)AVSpeechBoundary speechBoundary;


//Speech synthesizer instance variable
@property(nonatomic,strong,readonly)AVSpeechSynthesizer *speechSynthesizer;

//SpeechUtterence value
@property(nonatomic,strong,readonly)AVSpeechUtterance *speechUtterence;


//Utterance property
//Set the utterance speech rate
@property(nonatomic)CGFloat uRate;

//Set the pitchmultiplier value for utterance
@property(nonatomic)CGFloat pitchMultiplier;

//Set post delay for utterance
@property(nonatomic)CGFloat uPostDelay;

//Set pre delay for utterance
@property(nonatomic)CGFloat uPreDelay;


//block methods properties
//will fire while start to read
@property(nonatomic,copy)MVDidStartSpeech speechStartBlock;

//Will fire once the read ended
@property(nonatomic,copy)MVDidFinishSpeech speechFinishBlock;

//Will fire once the read pause
@property(nonatomic,copy)MVDidPauseSpeech speechPauseBlock;

//Will fire when speech continued
@property(nonatomic,copy)MVDidContinueSpeech speechContinueBlock;

//Will fire when cancel the speech
@property(nonatomic,copy)MVDidCancelSpeech speechCancelBlock;

//Will fire continuously when new word read.
@property(nonatomic,copy)MVSpeakRangeSpeech speechRangeBlock;

//Will fire continuously when new word start
@property(nonatomic,copy)MVSpeechSpeakingWord speechSpeakingWord;



//- readString is speechSynthesizer going to speak
-(void)startReadingWithString:(NSString*)readString;

//Continue reading with last paused place
-(void)continueReading;

//Stop the read
-(void)stopReading;

//Pause the reading
-(void)pauseReading;

//Speaking strings
-(NSString*)speakingString;

//Get available languages
-(NSArray*)supportedLanguages;

//Get status of speaking
-(BOOL)isSpeaking;

//Get status of paused
-(BOOL)isPaused;

//Get Current language code
-(NSString*)currentLangaugeCode;

//Get speaking language
-(NSString*)speakingLanguage;

@end
