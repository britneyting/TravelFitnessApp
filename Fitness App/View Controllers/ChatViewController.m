//
//  ChatViewController.m
//  Fitness App
//
//  Created by britneyting on 7/22/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "ChatViewController.h"
#import "Parse/Parse.h"
#import "ChatCell.h"
#import <PubNub/PubNub.h>
#import "UIImageView+AFNetworking.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, PNObjectEventListener>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
// Stores reference on PubNub client to make sure what it won't be released.
@property (nonatomic, strong) PubNub *client;
@property (nonnull, strong) NSString *hybridChannelName;
@property (nonatomic, strong) NSArray *channelsArray;
@property (nonatomic, strong) NSMutableDictionary *Message;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSNumber *earliestMessageTime;
@property BOOL loadingMore;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension; // temporary, non-dynamic row height
    self.messageField.layer.borderWidth = 1.0f;
    self.messageField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.messageField.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.messageField.layer.cornerRadius = 8;
    
    self.navigationController.navigationBar.tintColor = [self colorWithHexString:@"157F1F"];
    self.navigationController.navigationBar.barTintColor = [self colorWithHexString:@"efeeec"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[self colorWithHexString:@"0C3823"]};
    
    // set up keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.loadingMore = NO;
    
    // subscribing the user to their own channel as well as a hybrid channel between the two users. Channel name is a combination of the user and nearbyPerson's username, alphabetized
    NSString *currentUsername = self.currentUser.username;
    NSString *nearbyPersonUsername = self.nearbyPerson.username;
    NSMutableArray *hybridUsers = [[NSMutableArray alloc] initWithObjects:currentUsername, nearbyPersonUsername, nil];
    [hybridUsers sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.hybridChannelName = [NSString stringWithFormat: @"%@_%@", [hybridUsers objectAtIndex:0], [hybridUsers objectAtIndex:1]];
    NSLog(@"Hybrid Channel Name: %@_%@", [hybridUsers objectAtIndex:0], [hybridUsers objectAtIndex:1]);
    NSMutableArray *channelNames = [[NSMutableArray alloc] initWithObjects:self.currentUser.username, self.hybridChannelName, nil];
    self.channelsArray = [channelNames copy];
    NSLog(@"Channel Names: %@, %@", [self.channelsArray objectAtIndex:0], [self.channelsArray objectAtIndex:1]);
    
    self.messages = [[NSMutableArray alloc] initWithObjects:self.Message, nil];
    self.earliestMessageTime = [[NSNumber alloc] initWithInt:-1];
    
    // Initialize and configure PubNub client instance
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:@"pub-c-d75a9490-ab07-4f0b-a8a9-5224018c182b" subscribeKey:@"sub-c-59cba88e-ae3c-11e9-adf1-0649e4155de4"];
    self.client = [PubNub clientWithConfiguration:configuration];
    [self.client addListener:self];
    [self.client subscribeToChannels:self.channelsArray withPresence:YES];
    
    [self loadLastMessages];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)loadLastMessages {
    [self addHistorywithStartTime:nil endTime:nil andLimit:100];
    if (!(self.messages.firstObject == nil)) {
        NSIndexPath *indexPath = [[NSIndexPath alloc] init];
        indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)addHistorywithStartTime:(NSNumber *)start endTime:(NSNumber *)end andLimit:(NSUInteger)limit {
    [self.client historyForChannel:self.hybridChannelName start:start end:end limit:limit withCompletion:^(PNHistoryResult *result, PNErrorStatus *status) {
        
        if (result != nil && status == nil) {
            self.earliestMessageTime = result.data.start;
            [self.messages addObjectsFromArray:result.data.messages];
            [self.tableView reloadData];
            self.loadingMore = NO;
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)finishedTyping:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

- (IBAction)sendMessage:(id)sender {
    if (![self.messageField.text isEqualToString:@""]) {
        self.Message = [[NSMutableDictionary alloc] init];
        self.Message[@"message"] = self.messageField.text;
        self.Message[@"publisher"] = self.currentUser.username;
        
        NSLog(@"This is my messageObject: %@", self.Message);
        
        [self.client publish:self.Message toChannel:self.hybridChannelName withCompletion:^(PNPublishStatus *status) {
            if (!status.isError) {
                self.messageField.text = @"";
                NSLog(@"Successfully published message to hybrid channel!");
            }
        }];
    }
}

// Handle new message from one of channels on which client has been subscribed.
- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    
    // Handle new message stored in message.data.message
    if ([message.data.channel isEqualToString:message.data.subscription]) {
        
        // Message has been received on channel group stored in message.data.subscription.
        NSDictionary *messageContent = message.data.message;
        [self.messages addObject:messageContent];
        [self.tableView reloadData];
        NSIndexPath *indexPath = [[NSIndexPath alloc] init];
        indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        NSLog(@"Received message in channel: %@", message.data.message);
    }
    NSLog(@"Received message: %@ on channel %@ at %@", message.data.message[@"message"],
          message.data.channel, message.data.timetoken);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    NSDictionary *message = self.messages[indexPath.row];
    
    cell.usernameLabel.text = message[@"publisher"];
    [cell.usernameLabel setFont: [UIFont fontWithName:@"Arial" size:13.0f]];
    cell.messageLabel.text = message[@"message"];
    cell.messageLabel.numberOfLines = 0;
    [cell.messageLabel setFont: [UIFont fontWithName:@"Arial" size:15.0f]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cell.messageLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, cell.messageLabel.text.length)];
    cell.messageLabel.attributedText = attributedString;
    
    if (message[@"publisher"] == self.currentUser.username) {
        cell.usernameLabel.text = @"me";
        cell.messageLabel.textAlignment = NSTextAlignmentRight;
        cell.usernameLabel.textAlignment = NSTextAlignmentRight;

    }
    else if (message[@"publisher"] == self.nearbyPerson.username) {
        cell.messageLabel.text = message[@"message"];
        cell.messageLabel.textAlignment = NSTextAlignmentLeft;
        cell.usernameLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return cell;
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
