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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    self.title = [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

@end
