//
//  ViewController.m
//  collectionview
//
//  Created by Guna Sundari on 02/06/17.
//  Copyright © 2017 Guna Sundari. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "AFNetworking.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic) NSArray *items;
@property (strong,nonatomic) NSArray *imageitems;

@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting Up Activity Indicator View
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    self.collectionView.delegate = self;
   // [self.collectionView reloadData];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://www.kaleidosblog.com/tutorial/get_images.php" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.imageitems = responseObject;
        NSLog(@"%@",_imageitems);
        [self.activityIndicatorView stopAnimating];
        self.items = @[@"abc",@"def",@"ghi"];

        [self.collectionView reloadData];

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma UICollectionviewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageitems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

{
    static NSString *cellIdentifier = @"collectioncell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row < [self.items count])
    {
    NSString *text = [self.items objectAtIndex:indexPath.row];
    cell.label.text = text;
    }
    else
        cell.label.text = @"";
    
    NSString *imageUrl = [self.imageitems objectAtIndex:indexPath.row];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];

    cell.imageView.image = [UIImage imageWithData:imageData];

    
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//       cell.imageView.image = [UIImage imageWithData:data];
//    }];
    
    
    //cell.imageView.image = [UIImage imageWithContentsOfURL:@"http://kaleidosblog.com/tutorial/img/photo-1441906363162-903afd0d3d52.jpg"];

    return cell;
}

#pragma UICollectionviewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selected = [self.items objectAtIndex:indexPath.row];
    
    NSLog(@"selected:%@",selected);
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
