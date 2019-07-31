//
//  EventsViewController.m
//  Fitness App
//
//  Created by britneyting on 7/31/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "EventsViewController.h"
#import "CreateEventCell.h"

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (strong, nonatomic) IBOutlet UITableView *tableView2;
@property (strong, nonatomic) NSArray *cell1Info;
@property (strong, nonatomic) NSArray *cell2Info;

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.cell1Info = [[NSArray alloc] initWithObjects:@"Title", @"Location", @"Date", nil];
    self.cell2Info = [[NSArray alloc] initWithObjects:@"Activity Type", @"RSVPs Limit", @"Equipment", @"More info", nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)createEvent:(id)sender {
    // store the info in the text fields to backend in an 'Event' class to post later on
    [self createEventforPlace];
}

- (void)createEventforPlace {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView1) {
        return 3;
    }
    else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView1) {
        CreateEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateEventCell1" forIndexPath:indexPath];
        NSString *placeholderText = self.cell1Info[indexPath.row];
        cell.infoField1.borderStyle = UITextBorderStyleNone;
        cell.infoField1.placeholder = placeholderText;
        return cell;
    }
    else {
        CreateEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateEventCell2" forIndexPath:indexPath];
        NSString *placeholderText = self.cell2Info[indexPath.row];
        cell.infoField1.borderStyle = UITextBorderStyleNone;
        cell.infoField2.placeholder = placeholderText;
        return cell;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
