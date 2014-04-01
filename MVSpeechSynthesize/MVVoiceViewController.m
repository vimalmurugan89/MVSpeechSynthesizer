//
//  MVVoiceViewController.m
//  MVSpeechSynthesize
//
//  Created by admin on 17/03/14.
//  Copyright (c) 2014 admin. All rights reserved.
//

#import "MVVoiceViewController.h"
#import "MVSpeechSynthesizer.h"

@interface MVVoiceViewController ()
@property(nonatomic,weak)IBOutlet UITableView *voiceTableview;
@property(nonatomic,strong)NSArray *supportedVoices;
@end

@implementation MVVoiceViewController

#pragma mark - NIB method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


#pragma mark -View methods
- (void)viewDidLoad{
    [super viewDidLoad];
   
    _supportedVoices=[[MVSpeechSynthesizer sharedSyntheSize] supportedLanguages];
    [_voiceTableview reloadData];
    
}

#pragma mark - Tableview delegate and data source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_supportedVoices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    AVSpeechSynthesisVoice *voice=_supportedVoices[indexPath.row];
    NSArray *tempArray=[voice.language componentsSeparatedByString:@"-"];
    NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject:tempArray[1] forKey: NSLocaleCountryCode]];
    NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
    cell.detailTextLabel.text=country;
    NSLocale *enLocale =[[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSString *displayNameString = [enLocale displayNameForKey:NSLocaleIdentifier value:tempArray[0]];
    
    cell.textLabel.text=displayNameString;
    MVSpeechSynthesizer *mvSpeech=[MVSpeechSynthesizer sharedSyntheSize];
    if ([voice.language isEqualToString:mvSpeech.speechLanguage]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
       cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVSpeechSynthesisVoice *voice=_supportedVoices[indexPath.row];
    MVSpeechSynthesizer *mvSpeech=[MVSpeechSynthesizer sharedSyntheSize];
    mvSpeech.speechLanguage=voice.language;
    [_voiceTableview reloadData];
}


#pragma mark - Received memory warnings
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
