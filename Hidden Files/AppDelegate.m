//
//  AppDelegate.m
//  Hidden Files
//
//  Copyright (c) 2012 MJ Lyco LLC. (http://mjlyco.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "AppDelegate.h"

@implementation AppDelegate

#define CLOSE_APP_KEY @"CLOSE_APP_KEY"
#define AUTO_CLICK_KEY @"AUTO_CLICK_KEY"

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.preferencesWindow.delegate = self;
    
    [self setDefaultValuesForSettings];
    [self setButtonsToCorrectStates];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:AUTO_CLICK_KEY])
    {
        [self checkFinderState];
        [self hideShowButtonTapped:nil];
    }
}

- (void)setDefaultValuesForSettings
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:CLOSE_APP_KEY] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:CLOSE_APP_KEY];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:AUTO_CLICK_KEY] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AUTO_CLICK_KEY];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setButtonsToCorrectStates
{    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CLOSE_APP_KEY])
    {
        [self.radioGroup selectCellAtRow:0 column:0];
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:AUTO_CLICK_KEY])
    {
        [self.radioGroup selectCellAtRow:1 column:0];
    }
    else
    {
        [self.radioGroup selectCellAtRow:2 column:0];
    }
}

- (void)checkFinderState
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"CheckFinder" ofType:@"scpt"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSDictionary* errors = [NSDictionary dictionary];
    NSAppleScript* appleScript = [[NSAppleScript alloc] initWithContentsOfURL:url error:&errors];
    
    NSAppleEventDescriptor *theResult = [appleScript executeAndReturnError:&errors];
    
    if ([theResult booleanValue])
    {
        self.hideShowButton.title = @"Hide Hidden Files";
        self.hideShowButton.tag = 1;
    }
    else
    {
        self.hideShowButton.title = @"Show Hidden Files";
        self.hideShowButton.tag = 0;
    }
}

- (IBAction)hideShowButtonTapped:(id)sender
{
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimation:nil];
    
    NSString *path = nil;
    if (self.hideShowButton.tag == 1)
    {
        path = [[NSBundle mainBundle] pathForResource:@"HideFiles" ofType:@"scpt"];
        self.hideShowButton.title = @"Show Hidden Files";
        self.hideShowButton.tag = 0;
    }
    else
    {
        path = [[NSBundle mainBundle] pathForResource:@"ShowFiles" ofType:@"scpt"];
        self.hideShowButton.title = @"Hide Hidden Files";
        self.hideShowButton.tag = 1;
    }
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSDictionary *errors = [NSDictionary dictionary];
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithContentsOfURL:url error:&errors];
    
    [appleScript executeAndReturnError:&errors];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:AUTO_CLICK_KEY] && [[NSUserDefaults standardUserDefaults] boolForKey:CLOSE_APP_KEY])
    {
        [[NSApplication sharedApplication] terminate:self];
    }
    
    [self.activityIndicator stopAnimation:nil];
    [self.activityIndicator setHidden:YES];
}

- (IBAction)radioGroupTapped:(id)sender
{
    switch (self.radioGroup.selectedRow)
    {
        case 0:
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CLOSE_APP_KEY];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AUTO_CLICK_KEY];
            break;
            
        case 1:
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:CLOSE_APP_KEY];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AUTO_CLICK_KEY];
            break;
            
        case 2:            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:CLOSE_APP_KEY];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AUTO_CLICK_KEY];
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self checkFinderState];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [self.window makeKeyAndOrderFront:nil];
}

@end
