//
//  EventsViewController.m
//  Fitness App
//
//  Created by britneyting on 7/31/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "EventsViewController.h"
#import "CreateEventCell.h"
#import "Event.h"
#import "ProgressHUD.h"

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *choicePicker;
@property (strong, nonatomic) NSArray *choices;
@property (strong, nonatomic) NSArray *cell1Info;
@property (strong, nonatomic) NSArray *cell2Info;

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.choicePicker.delegate = self;
    self.choicePicker.dataSource = self;
    self.choices = [[NSArray alloc] initWithObjects:@"Hiking", @"Biking", @"Walking", @"Fishing", @"Rock Climbing", nil];
    
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
    NSMutableArray *info = [[NSMutableArray alloc] init];
    
    //turns strings to #s
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    [ProgressHUD show:@"Please wait..."];
    
    for (CreateEventCell *cell in self.tableView.visibleCells) {
        [info addObject:cell.infoField1.text];
    }
    [Event createEvent:info[0] withLocation:info[1] withEventDate:info[2] withActivityType:info[3] withRSVPsLimit:[formatter numberFromString:info[4]] withEquipment:info[5] withMoreInfo:info[6] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully created event and uploaded to backend!");
            [self.delegate didCreate];
            [ProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"Failed to create event :^(: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)endEditing:(id)sender {
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // first section is for user to fill out basic info: event title, date, location
    if (section == 0) {
        return self.cell1Info.count;
    }
    
    // second section is for user to fill out additional info: RSVP limit, activity type, equipment, and description
    else if (section == 1) {
        return self.cell2Info.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Default is 1 if not implemented
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // fixed font style. use custom view (UILabel) if you want something different
    return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CreateEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateEventCell" forIndexPath:indexPath];
    cell.infoField1.borderStyle = UITextBorderStyleNone;
    
    if (indexPath.section == 0) {
        NSString *placeholderText = self.cell1Info[indexPath.row];
        cell.infoField1.placeholder = placeholderText;
        if ([placeholderText isEqualToString:@"Date"]) {
            self.datePicker = [[UIDatePicker alloc] init];
            self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            self.datePicker.backgroundColor = [UIColor whiteColor];
            [cell.infoField1 setInputView:self.datePicker];
            UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            [toolBar setTintColor:[UIColor grayColor]];
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action: @selector(ShowSelectedDate:)];
            UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
            [cell.infoField1 setInputAccessoryView:toolBar];
        }
        if ([placeholderText isEqualToString:@"Location"]) {
            cell.infoField1.text = self.locationHere;
            [cell.infoField1 setUserInteractionEnabled:NO];
        }
    }
    if (indexPath.section == 1) {
        NSString *placeholderText = self.cell2Info[indexPath.row];
        cell.infoField1.placeholder = placeholderText;
        if ([placeholderText isEqualToString:@"RSVPs Limit"]) {
            [cell.infoField1 setKeyboardType:UIKeyboardTypeNumberPad];
        }
        else if ([placeholderText isEqualToString:@"Activity Type"]) {
//            self.choicePicker = [[UIPickerView alloc] init];
//            self.choicePicker.backgroundColor = [UIColor whiteColor];
//            self.choicePicker.contentMode = UIViewContentModeCenter;
//            [self.choicePicker setValue:[UIColor blackColor] forKey:@"textColor"];
//            [cell.infoField1 setInputView:self.choicePicker];
//            UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//            [toolBar setTintColor:[UIColor darkGrayColor]];
//            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action: @selector(ShowSelectedActivity:)];
//            UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//            [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
//            [cell.infoField1 setInputAccessoryView:toolBar];
        }
    }
    return cell;
}

- (void)ShowSelectedDate:(id)sender {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM d, yyyy h:mm a"];
    NSIndexPath *indexPath = [[NSIndexPath alloc] init];
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    CreateEventCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.infoField1.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
    [self.view endEditing:YES];
}

- (void)ShowSelectedActivity:(id)sender {
    [self.view endEditing:YES];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.choices.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.choices[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

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
