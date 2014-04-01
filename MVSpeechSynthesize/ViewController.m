//
//  ViewController.m
//  MVSpeechSynthesize
//
//  Created by admin on 17/03/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,weak)IBOutlet UITextView *sampleTextview;
@property(nonatomic,weak)IBOutlet UIButton *readButton;
-(IBAction)startRead:(id)sender;
-(IBAction)stopRead:(id)sender;
-(IBAction)voicePress:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _sampleTextview.text=@"THE WIND AND THE SUN.\nOnce the Wind and the Sun had an argument. I am stronger than you said the Wind. No, you are not, said the Sun. Just at that moment they saw a traveler walking across the road. He was wrapped in a shawl. The Sun and the Wind agreed that whoever could separate the traveller from his shawl was stronger. The Wind took the first turn. He blew with all his might to tear the traveller’s shawl from his shoulders. But the harder he blew, the tighter the traveller gripped the shawl to his body. The struggle went on till the Wind’s turn was over. Now it was the Sun’s turn. The Sun smiled warmly. The traveller felt the warmth of the smiling Sun. Soon he let the shawl fall open. The Sun’s smile grew warmer and warmer... hotter and hotter. Now the traveller no longer needed his shawl. He took it off and dropped it on the ground. The Sun was declared stronger than the Wind. \nMoral: Brute force can’t achieve what a gentle smile can.";
    //;@"Lässt du dir vor dem Schlafen gehen gerne von deinen Eltern eine gute Nacht Geschichte vorlesen? Hier bekommst du ein paar nette Geschichten die du Ausdrucken kannst und deinen Eltern zum Vorlesen geben kannst.";
}

#pragma mark - Button Press
-(IBAction)voicePress:(id)sender{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    MVVoiceViewController *controller = (MVVoiceViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MVVoiceViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)startRead:(id)sender{
    
    [sender setEnabled:NO];
    MVSpeechSynthesizer *mvSpeech=[MVSpeechSynthesizer sharedSyntheSize];
    mvSpeech.inputView=_sampleTextview;
    mvSpeech.speechVoice=@"hi-IN";//@"en-US";//@"de-DE";
    
    //    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    //    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    //    NSLog(@"country code=%@,%@",countryCode,[NSLocale canonicalLanguageIdentifierFromString:@"en"]);//[NSLocale ISOCountryCodes]);
    mvSpeech.higlightColor=[UIColor yellowColor];
    mvSpeech.isTextHiglight=YES;
    [mvSpeech startReadingWithString:_sampleTextview.text];
    NSLog(@"curr=%@",[mvSpeech supportedLanguages]);
    mvSpeech.speechFinishBlock=^(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence){
        [sender setEnabled:YES];
    };
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_sampleTextview resignFirstResponder];
}

-(IBAction)stopRead:(id)sender{
    
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
