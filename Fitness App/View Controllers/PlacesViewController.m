//
//  PlacesViewController.m
//  Fitness App
//
//  Created by britneyting on 7/17/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import "PlacesViewController.h"
#import "EventCollectionViewCell.h"
#import "PlaceDetailsViewController.h"
#import "Place.h"



@interface PlacesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *places;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchPlaces];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)fetchPlaces {
    NSURL *url = [NSURL URLWithString:@"https://reverse.geocoder.api.here.com/6.2/reversegeocode.json?app_id=iy3n2fifoeJ39mPMVvg1&app_code=ItjY8yqzUcQMPmVjXtciqw&mode=retrieveLandmarks&prox=37.7442,-119.5931,1000"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)  {
        // error
        // runs when network request comes back
        if (error != nil)
            NSLog(@"%@", [error localizedDescription]);
        
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dataDictionary = dataDictionary[@"Response"];
            NSArray *completeAPIResponse = dataDictionary[@"View"];
            NSDictionary *dictionary = completeAPIResponse[0];
            NSArray *result = dictionary[@"Result"];
            self.places = [NSMutableArray new];
            for (NSDictionary *myLandmarkDictionary in result) {
                NSDictionary *myLocations= myLandmarkDictionary[@"Location"];
                Place *place = [[Place alloc]init];
                place.placeType = myLocations[@"LocationType"];
                place.placeName =  myLocations[@"Name"];
                NSDictionary *myCoordinates = myLocations[@"DisplayPosition"];
                PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:[myCoordinates[@"Latitude"]floatValue] longitude:[myCoordinates[@"Longitude"]floatValue]];
                place.placeCoordinates = geoPoint;
                
                UIImage *picture = [UIImage imageNamed:place.placeName];
                if(picture == nil)
                    picture = [UIImage imageNamed:@"Yosemite National Park"];
                NSData *imageData = UIImageJPEGRepresentation(picture, 1.0);
                place.image = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
                
                
                [self.places addObject:place];
                
            }
        }
        [self.collectionView reloadData];
    }];
    
    [task resume];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Place *test = [Place new];
    EventCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventCollectionViewCell" forIndexPath:indexPath];
    
//    NSDictionary *locations = self.places[indexPath.row];
    test = ((Place *)(self.places[indexPath.row]));
//    cell.place = test;
    cell.placeName.text = test.placeName;
    cell.placeType = test.placeType;
    UIImage *img = [UIImage imageNamed:cell.placeName.text];
    cell.posterView.image = img;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.places.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    
    
    
    Place *place = self.places[indexPath.row];
    PlaceDetailsViewController *placeDetailsViewController = [segue destinationViewController];
    placeDetailsViewController.location = place;
//    placeDetailsViewController.place = place;
}

@end
