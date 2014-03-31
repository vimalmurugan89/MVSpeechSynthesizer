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




//block methods properties
@property(nonatomic,copy)MVDidStartSpeech speechStartBlock;
@property(nonatomic,copy)MVDidFinishSpeech speechFinishBlock;
@property(nonatomic,copy)MVDidPauseSpeech speechPauseBlock;
@property(nonatomic,copy)MVDidContinueSpeech speechContinueBlock;
@property(nonatomic,copy)MVDidCancelSpeech speechCancelBlock;
@property(nonatomic,copy)MVSpeakRangeSpeech speechRangeBlock;
@property(nonatomic,copy)MVSpeechSpeakingWord speechSpeakingWord;


//Start reading process with
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
-(NSArray*)listOfVoices;

//Get Current language code
-(NSString*)currentLangaugeCode;

@end
