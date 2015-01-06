//
//  WebViewViewController.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 15.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rewindButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) NSURL* url;
@end

@implementation WebViewViewController

-(instancetype)initWithString:(NSString*) urlString
{
    self = [self initWithNibName:nil bundle:nil];
    if(self)
    {
        self.url = [NSURL URLWithString:urlString];
    }
    return self;
}

-(instancetype)initWithURL:(NSURL *)url
{
    self = [self initWithNibName:nil bundle:nil];
    if(self)
    {
        self.url = url;
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    [self loadRequestFromString:self.url];
}


-(void) updateButtons
{
    self.forwardButton.enabled = self.webview.canGoForward;
    self.rewindButton.enabled = self.webview.canGoBack;
    self.stopButton.enabled = self.webview.loading;
}

- (void)loadRequestFromString:(NSURL*)url
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:urlRequest];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    self.title = [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

@end
