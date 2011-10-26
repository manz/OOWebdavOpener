//
//  OOWebdavOpenerAppDelegate.m
//  OOWebdavOpener
//
//  Created by Emmanuel Peralta on 14/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOWebdavOpenerAppDelegate.h"


@implementation OOWebdavOpenerAppDelegate

- (id) init {
    if (self = [super init]) {
        NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
        [em 
         setEventHandler:self 
         andSelector:@selector(getUrl:withReplyEvent:) 
         forEventClass:kInternetEventClass 
         andEventID:kAEGetURL];
        NSLog(@"MyInit");
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}


- (void)getUrl:(NSAppleEventDescriptor *)event 
withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    
    NSLog(@"Handling URL");
    
    NSString *ooBundleId = @"org.openoffice.script";
    NSString *loBundleId = @"org.libreoffice.script";
    // checking for openoffice or libreoffice
    NSURL *oourl = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:@"org.openoffice.script"];
    NSURL *lourl = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:@"org.libreoffice.script"];
    
    NSString *bundleId = nil;
    NSURL *bURL;
    
    if (lourl == nil) {
        bURL = oourl;
        bundleId = ooBundleId;
    }
    else {
        bURL  = lourl;
        bundleId = loBundleId;
    }
    
    
    if (bURL == nil) {
        id alert = [NSAlert alertWithMessageText:@"Veuillez installer openoffice ou libreoffice." defaultButton:@"Ok" alternateButton:nil otherButton:nil informativeTextWithFormat:nil];
        [alert runModal];
        [NSApp terminate:self];
    }

    
    NSWorkspace * ws = [NSWorkspace sharedWorkspace];
    
    // find the parameter
    NSString * f =[[event paramDescriptorForKeyword:keyDirectObject] 
                   stringValue];;
    NSArray  * myArray2 = [NSArray arrayWithObjects:f,nil];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:myArray2 forKey:NSWorkspaceLaunchConfigurationArguments];
    
    [ws launchApplicationAtURL:bURL options:NSWorkspaceLaunchDefault configuration:dict error:nil];
    
    sleep(5);
    
    [NSApp terminate:self];
}


@end
