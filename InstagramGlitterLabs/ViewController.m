//
//  ViewController.m
//  InstagramGlitterLabs
//
//  Created by Vishal Bhadade on 13/12/15.
//  Copyright (c) 2015 Globallogic. All rights reserved.
//

#import "ViewController.h"
#import "InstagramTableViewController.h"

#define CLIENT_ID     @"d43d240bb49745918978a8b5ed328a57"
#define CLIENT_SECRET @"9b8b410fd9f64975bd0afd3c0273fdd5"
#define REDIRECT_URI  @"http://www.vish4mi.com"
#define ACCESS_TOKEN  @"access_token"

#define IMAGE_TABLE_VIEW_SEGUE @"imageTableViewController"

#define POST @"POST"

@interface ViewController ()
<
  UIWebViewDelegate,
  NSURLConnectionDataDelegate,
  NSURLConnectionDelegate
>
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) NSMutableData           *receivedData;
@property (strong, nonatomic) IBOutlet UIWebView      *signInWebView;
@property (strong, nonatomic) NSString                *accessToken;
@property (strong, nonatomic) NSURLConnection         *theConnection;
@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.signInWebView setBackgroundColor:[UIColor lightGrayColor]];
    [self.signInWebView setDelegate:self];
    //[self.view addSubview:self.signInWebView];
    //[self.view bringSubviewToFront:self.signInWebView];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGSize viewSize = self.signInWebView.bounds.size;
    [self.indicatorView setFrame:CGRectMake(viewSize.width/2, viewSize.height/2, 40, 40)];
    [self.signInWebView addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
    /**
     * Authentication URL
     **/
//    NSString *urlString  = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code&scope=public_content", CLIENT_ID, REDIRECT_URI];
    NSString *urlString  = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&scope=public_content+comments+basic",CLIENT_ID, REDIRECT_URI];
    
    NSURL *instaAuthURL = [NSURL URLWithString:urlString];
    NSURLRequest *authReq = [NSURLRequest requestWithURL:instaAuthURL];
    [self.signInWebView loadRequest:authReq];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UIWebview delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    // Stop activity indicator
    if (![self.indicatorView isAnimating])
    {
        [self.indicatorView startAnimating];
    }
    
    NSURL *url = [request URL];
    NSString *rawCodeString = [url absoluteString];
    NSString *codeString = nil;
    if ([rawCodeString hasPrefix:@"http://www.vish4mi.com"])
    {
        NSArray *componentsArray =[rawCodeString componentsSeparatedByString:@"access_token="];
        if (componentsArray && [componentsArray count])
        {
            self.accessToken = [componentsArray objectAtIndex:1];
        }
        if (self.accessToken == nil)
        {
            NSArray *componentsArray = [rawCodeString componentsSeparatedByString:@"code="];
            if (componentsArray && [componentsArray count])
            {
                codeString = [componentsArray objectAtIndex:1];
            }
            [self requestAccessToken:codeString];
        }
        [self performSegueWithIdentifier:IMAGE_TABLE_VIEW_SEGUE sender:self];
        return NO;
    }
    return  YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.indicatorView isAnimating])
    {
        [self.indicatorView stopAnimating];
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self.indicatorView isAnimating])
    {
        [self.indicatorView stopAnimating];
    }
    
}

- (void)requestAccessToken:(NSString *)code
{
    NSString *data = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",CLIENT_ID,CLIENT_SECRET,REDIRECT_URI,code];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/oauth/access_token"];
    NSURL *accessTokenURL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:accessTokenURL];
    [request setHTTPMethod:POST];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    self.theConnection=[[NSURLConnection alloc] initWithRequest:request
                                                       delegate:self];
    self.receivedData = [[NSMutableData alloc] init];
    
    [self.signInWebView removeFromSuperview];
}

#pragma mark -
#pragma mark - NSURLConnectionDelegate delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [self.receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError *error = nil;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:self.receivedData
                                                             options:kNilOptions
                                                               error:&error];
    NSString *accessToken = nil;
    if (jsonData && [jsonData count])
    {
        accessToken = [jsonData valueForKey:ACCESS_TOKEN];
        
    }
    
    self.accessToken = accessToken;
    
    // Stop activity indiacator
    if ([self.indicatorView isAnimating])
    {
        [self.indicatorView stopAnimating];
    }
    
    [self performSegueWithIdentifier:IMAGE_TABLE_VIEW_SEGUE sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:IMAGE_TABLE_VIEW_SEGUE])
    {
        InstagramTableViewController *tableVC = (InstagramTableViewController *)segue.destinationViewController;
        tableVC.accessToken = self.accessToken;
    }
}

@end
