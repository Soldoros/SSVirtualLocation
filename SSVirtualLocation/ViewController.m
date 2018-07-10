//
//  ViewController.m
//  SSVirtualLocation
//
//  Created by soldoros on 2018/7/10.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ChangeLoction.h"

@interface ViewController ()<CLLocationManagerDelegate>

@property(nonatomic ,strong) CLLocationManager *manager;

//经纬度和详细地址
@property(nonatomic ,strong) UILabel *titleLab;
@property(nonatomic ,strong) UILabel *detLab;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    [_manager requestWhenInUseAuthorization];
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    _manager.distanceFilter = 1.0;
    [_manager startUpdatingLocation];
    
    
    //经纬度
    _titleLab = [UILabel new];
    _titleLab.frame = CGRectMake(0, 150, self.view.frame.size.width, 25);
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLab];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.font = [UIFont systemFontOfSize:20];
    
    
    //详细地址
    _detLab = [UILabel new];
    _detLab.frame = CGRectMake(0, 160, self.view.frame.size.width-100, 40);
    _detLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_detLab];
    _detLab.textColor = [UIColor blackColor];
    _detLab.numberOfLines = 0;
    _detLab.font = [UIFont systemFontOfSize:20];
    
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [_manager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    _titleLab.text = [NSString stringWithFormat:@"纬度:%f,经度:%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
    
    
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            //看需求定义一个全局变量来接收赋值
            NSLog(@"当前国家 - %@",placeMark.country);//当前国家
            NSLog(@"当前城市 - %@",currentCity);//当前城市
            NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
            NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
            NSLog(@"具体地址 - %@",placeMark.name);//具体地址
            
            NSString *string = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placeMark.country,currentCity,placeMark.subLocality,placeMark.thoroughfare,placeMark.name,@"定位完成，确认无误后请开启钉钉或微信打卡吧！"];
            
            self.detLab.text = string;
            [self.detLab sizeToFit];
            self.detLab.center = CGPointMake(self.view.frame.size.width*0.5, 320);
        }
    }];
}






@end
