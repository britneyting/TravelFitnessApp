//
//  postViewController.m
//  Fitness App
//
//  Created by danyguajiba on 7/17/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "postViewController.h"
#import "post.h"

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
    // Do any additional setup after loading the view.
    
    PFUser *currentUser = [PFUser currentUser];
    
    self.captionTextView.delegate = self;
    self.placeholderText = @"Write caption...";
    
    self.captionTextView.text = self.placeholderText;
    self.captionTextView.textColor = [UIColor lightGrayColor];
    
//    self.profilePictureImage.file = currentUser[@"profilePicture"];
}

//- (IBAction)tapClose:(UIBarButtonItem *)sender {
//    [self dismissViewControllerAnimated:true completion:nil];
//}

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
    self.originalImage = info[UIImagePickerControllerOriginalImage];
    self.editedImage = info[UIImagePickerControllerEditedImage];
    self.editedImage = [self resizeImage:self.originalImage withSize:CGSizeMake(400, 400)];

    self.photo = self.editedImage;
    NSData *imageData = UIImagePNGRepresentation(self.photo);
    PFFileObject *file = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"post"] = file;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully uploaded new picture to backend");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
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
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = self.placeholderText;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (IBAction)didTapShare:(id)sender {
    UIImage *resizedImage = [self resizeImage:self.photo withSize:CGSizeMake(350, 350)];
    
    [Post postUserImage:resizedImage withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Did post");
            [self.delegate didPostImage:self.photo withCaption:self.captionTextView.text];
        } else {
            NSLog(@"Error: %@", error);
        }
        [self dismissViewControllerAnimated:true completion:nil];
    }];
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
