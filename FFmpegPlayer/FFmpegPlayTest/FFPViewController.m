//
//  FFPViewController.m
//  FFmpegPlayTest
//
//  Created by Jack on 10/16/12.
//  Copyright (c) 2012 Jack. All rights reserved.
//

#import "FFPViewController.h"
#import "FFMoviePlayerController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface FFPViewController ()
{
    FFMoviePlayerController* moviePlayer;
}

-(void) openVideo: (NSString*) videoPath;
-(IBAction)load:(id)sender;
-(IBAction)play:(id)sender;
-(IBAction)pause:(id)sender;
-(IBAction)stop:(id)sender;
-(IBAction)runFaster:(id)sender;
-(IBAction)runSlower:(id)sender;
-(IBAction)seekForward:(id)sender;
-(IBAction)seekBackward:(id)sender;
-(IBAction)subtitleON:(id)sender;
-(IBAction)subtitleOFF:(id)sender;
-(IBAction)scaleMode:(id)sender;

@end

@implementation FFPViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) openVideo:(NSString *)videoPath
{
    
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (moviePlayer) {
        if (UIInterfaceOrientationIsLandscape([self interfaceOrientation])) {
            
            [moviePlayer.view setFrame:[self.view bounds]];
        } else
            [moviePlayer.view setFrame:CGRectMake(0, 0, 320, 250)];
    };
}

#pragma mark - Utilities
- (void) stopPlaying
{
    //[moviePlayer ]
}


#pragma mark - Handle UI events

-(IBAction)load:(id)sender
{

    NSString *fileName = @"big-buck-bunny_trailer";
    NSString *fileType = @"webm";
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSString* savePath = [documentPath stringByAppendingPathComponent:fileName];
    NSLog(@"%@", savePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    // if fileName of type fileType exist
    if ([fileManager fileExistsAtPath:savePath] == YES) {
        // delete it
        [fileManager removeItemAtPath:savePath error:&error];
    }
    
    // check the file was not already copied into the Documents folder
    if ([fileManager fileExistsAtPath:savePath] == NO)
    {
        // copy the file from main app bundle to Document folder
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
        [fileManager copyItemAtPath:resourcePath toPath:savePath error:&error];
        NSLog(@"\nfile: %@ \n copied from : %@ \nto:\n %@", fileName, resourcePath, savePath);
    }
    
    if (error == nil) {
        if ([fileManager fileExistsAtPath:savePath] == YES) {
            NSURL *savePathURL = [NSURL fileURLWithPath:savePath];
            moviePlayer = [[FFMoviePlayerController alloc] initWithContentURL: savePathURL];
        } else {
            NSLog(@"Test video file failed!!");
        }
    }
    

    
    //TODO:Remenmber to send notification to notificationCenter in FFMoviePlayerController
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    moviePlayer.controlStyle = MPMovieControlStyleDefault;
    moviePlayer.shouldAutoplay = NO;
    [moviePlayer.view setFrame:CGRectMake(0, 0, 320, 250)];
    moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:moviePlayer.view];

}

// Handle both play and pause button
- (IBAction)play:(id)sender
{
    [moviePlayer play];
    [moviePlayer setFullscreen:YES animated:YES];
}

- (void) moviePlaybackDidFinish: (NSNotification*) notification
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [moviePlayer.view removeFromSuperview];
        moviePlayer = nil; // ARC automatically release this obj
    }

}

-(IBAction)pause:(id)sender
{
    [moviePlayer pause];
}

-(IBAction)stop:(id)sender
{
    // ???: Should stop generate didFinish notification??
    [moviePlayer stop];
}

-(IBAction)runFaster:(id)sender
{
    
}
-(IBAction)runSlower:(id)sender
{
    
}
-(IBAction)seekForward:(id)sender
{
    
}
-(IBAction)seekBackward:(id)sender
{
    
}
-(IBAction)subtitleON:(id)sender
{
    
}
-(IBAction)subtitleOFF:(id)sender
{
    
}
-(IBAction)scaleMode:(id)sender
{
    
}

@end
