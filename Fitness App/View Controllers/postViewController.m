//
//  postViewController.m
//  Fitness App
//
//  Created by danyguajiba on 7/17/19.
//  Copyright © 2019 britneyting. All rights reserved.
//
#import "postViewController.h"
#import "ProfileViewController.h"
#import "post.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>


@interface postViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImage *photo;

@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *editedImage;

@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (strong, nonatomic) NSString *placeholderText;

@end

@implementation postViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self colorWithHexString:@"efeeec"];
    self.navigationController.navigationBar.tintColor = [self colorWithHexString:@"157F1F"];
    self.navigationController.navigationBar.barTintColor = [self colorWithHexString:@"efeeec"];
    
    self.photo = [UIImage imageNamed:@"imagePlaceholder"];
    self.imageView.image = self.photo;

    self.captionTextView.delegate = self;
    self.placeholderText = @"Write caption...";
    self.captionTextView.text = self.placeholderText;
    self.captionTextView.textColor = [UIColor lightGrayColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)didTapPicture:(id)sender {
    [self choosePicture:@"Choose an image using your camera or photo library" withTitle:@"Upload a Picture"];
}

- (void)choosePicture:(NSString *)message withTitle:(NSString *)title {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an photo library action
    UIAlertAction *pickPhoto = [UIAlertAction actionWithTitle:@"Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { // handle response here.
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    
    // add the photo library action to the alert controller
    [alert addAction:pickPhoto];
    
    // create a camera action
    UIAlertAction *pickCamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // handle camera response here. Doing nothing will dismiss the view.
        // calls camera if camera is available
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    
    // add the camera action to the alertController
    [alert addAction:pickCamera];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    self.photo = editedImage;
    self.imageView.image = self.photo;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:self.placeholderText]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

-(void)dismissKeyboard{
    [self.captionTextView resignFirstResponder];
}

- (IBAction)didTapShare:(id)sender {
    UIImage *resizedImage = [self resizeImage:self.photo withSize:CGSizeMake(350, 350)];
    [Post postUserImage:resizedImage withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Did post");
            [self viewDidLoad];
            [self performSegueWithIdentifier:@"unwindToContainerVC" sender:self];
        }
        else {
            NSLog(@"Error: %@", error);
        }
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -(keyboardSize.height/4);
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
