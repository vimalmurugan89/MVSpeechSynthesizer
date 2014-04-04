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
@property(nonatomic,weak)IBOutlet UIBarButtonItem *languageButton;
@property(nonatomic,weak)IBOutlet UILabel *infoLabel;
@property(nonatomic,weak)IBOutlet UIView *helpView;
@property(nonatomic,weak)IBOutlet UITextView *helpTextView;
@property(nonatomic,strong)NSString *language;
-(IBAction)startRead:(id)sender;
-(IBAction)languagePress:(id)sender;
-(IBAction)skipPress:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _infoLabel.lineBreakMode=YES;
    _infoLabel.numberOfLines=0;
    
    
    _sampleTextview.text=@"THE WIND AND THE SUN.\nOnce the Wind and the Sun had an argument. I am stronger than you said the Wind. No, you are not, said the Sun. Just at that moment they saw a traveler walking across the road. He was wrapped in a shawl. The Sun and the Wind agreed that whoever could separate the traveller from his shawl was stronger. The Wind took the first turn. He blew with all his might to tear the traveller’s shawl from his shoulders. But the harder he blew, the tighter the traveller gripped the shawl to his body. The struggle went on till the Wind’s turn was over. Now it was the Sun’s turn. The Sun smiled warmly. The traveller felt the warmth of the smiling Sun. Soon he let the shawl fall open. The Sun’s smile grew warmer and warmer... hotter and hotter. Now the traveller no longer needed his shawl. He took it off and dropped it on the ground. The Sun was declared stronger than the Wind. \nMoral: Brute force can’t achieve what a gentle smile can.";
    
    
    _helpTextView.text=@"Welcome, I am MVSpeechSynthesizer.\nI can speak the following languages those are, English, Hindi, Thai, Portuguese, Slovak, French, Romanian, Norwegian, Finnish, Polish, German, Dutch, Indonesian, Turkish, Italian, Russian, Spanish, Chinese, Swedish, Hungarian, Arabic, Korean, Czech, Danish, Greek, Japanese.\nHow can i choose language?\nPress language button which is present in the right side of top bar. There you can find list of languages, By tapping row you can choose language. \nWhat is my aim? \nMy aim is atleast one person to become a good reader by using this app.\n Who need this?\nWhoever developing the kids reading book or audio book.\n Whoever want to integrate voice navigation.\n Whoever wants to read their privacy policy and EULA to user.\nWhoever wants to read the webpage.\nWhat i can do for you? \n I can read any paragraph which is present in textbox. I can detect language myself. I can autoscroll the page myself.";
    
    
    [_languageButton setEnabled:NO];
    _helpTextView.textColor=[UIColor whiteColor];
    MVSpeechSynthesizer *mvSpeech=[MVSpeechSynthesizer sharedSyntheSize];
    mvSpeech.higlightColor=[UIColor yellowColor];
    mvSpeech.isTextHiglight=YES;
    mvSpeech.speechString=_helpTextView.text;
    _helpTextView.font=[UIFont fontWithName:@"HelveticaNeue" size:16];
    mvSpeech.inputView=_helpTextView;
    [mvSpeech startRead];
    mvSpeech.speechFinishBlock=^(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence){
         _helpView.hidden=YES;
        [_languageButton setEnabled:YES];
    };
    
}

#pragma mark - textview delegate method
- (void)textViewDidChange:(UITextView *)textView{
     MVSpeechSynthesizer *mvSpeech=[MVSpeechSynthesizer sharedSyntheSize];
    mvSpeech.speechLanguage=nil;
    _infoLabel.text=@"";
}

#pragma mark - Button Press
-(IBAction)languagePress:(id)sender{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    MVVoiceViewController *controller = (MVVoiceViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"MVVoiceViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    _infoLabel.text=@"";
}
-(IBAction)startRead:(id)sender{
    
    if([[sender currentTitle]isEqualToString:@"Read"]){
        
    [sender setTitle:@"Stop" forState:UIControlStateNormal];
        
    [_languageButton setEnabled:NO];
    MVSpeechSynthesizer *mvSpeech=[MVSpeechSynthesizer sharedSyntheSize];
    mvSpeech.inputView=_sampleTextview;
    mvSpeech.higlightColor=[UIColor yellowColor];
    mvSpeech.isTextHiglight=YES;
    mvSpeech.speechString=_sampleTextview.text;
    NSString *speechLanguage=mvSpeech.speechLanguage;
    [mvSpeech startRead];
   
    mvSpeech.speechStartBlock=^(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence){
        
        NSLog(@"speech language==%@",speechLanguage);
        
        NSArray *tempArray=[speechLanguage componentsSeparatedByString:@"-"];
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject:tempArray[1] forKey: NSLocaleCountryCode]];
        NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
        NSLocale *enLocale =[[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        NSString *displayNameString = [enLocale displayNameForKey:NSLocaleIdentifier value:tempArray[0]];
        _infoLabel.text=[NSString stringWithFormat:@"Language : %@ \nCountry    : %@",displayNameString,country];
        
        };
        
    mvSpeech.speechFinishBlock=^(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence){
                [sender setTitle:@"Read" forState:UIControlStateNormal];
                [_languageButton setEnabled:YES];
    };
    }else{
        [sender setTitle:@"Read" forState:UIControlStateNormal];
         [_languageButton setEnabled:YES];
       MVSpeechSynthesizer *mvSpeech=[MVSpeechSynthesizer sharedSyntheSize];
       [mvSpeech stopReading];
    }
    
}

-(IBAction)skipPress:(id)sender{
    MVSpeechSynthesizer *mvSpeech=[MVSpeechSynthesizer sharedSyntheSize];
    [mvSpeech stopReading];
     [_languageButton setEnabled:YES];
    _helpView.hidden=YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_sampleTextview resignFirstResponder];
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
