//
//  ViewController.m
//  location
//
//  Created by 腾实信 on 2017/2/10.
//  Copyright © 2017年 ida. All rights reserved.
//


#import "ViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "BNCoreServices.h"
//地理编码
@interface ViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BNNaviRoutePlanDelegate>

@property (nonatomic, strong) BMKMapView* mapView;
@property (nonatomic, strong)BMKGeoCodeSearch* geocodesearch;

@end

@implementation ViewController

- (void)loadView
    {
        BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.view = mapView;
        self.mapView = mapView;
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    }
    
- (void)viewWillAppear:(BOOL)animated
    {
        
        [_mapView viewWillAppear];
        _geocodesearch.delegate = self;
        _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    
- (void)viewWillDisappear:(BOOL)animated
    {
        [_mapView viewWillDisappear];
        _geocodesearch.delegate = nil;
        _mapView.delegate = nil; // 不用时，置nil
    }

-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
    
    //调整区域
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.1475380467612894, 0.1357795084624257);
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coordinate, span);
    [mapView setRegion:region];
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){39.976646, 116.374172};
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }

}


-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        //businessCircle:北太平庄,蓟门桥,马甸
        NSArray *poilistArray = result.poiList;
        for (BMKPoiInfo *poiInfo in poilistArray) {
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = poiInfo.pt;
            annotation.title = poiInfo.name;
            annotation.subtitle = poiInfo.address;
            [_mapView addAnnotation:annotation];

        }
        
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}
#pragma mark - 导航 annotationViewForBubble
-(void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    
    
    id <BMKAnnotation> annotaiton = view.annotation;
//    NSLog(@"导航到--%f", annotaiton.coordinate);
    
    
    //节点数组
    NSMutableArray * nodesArray = [NSMutableArray array];
    //起点
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc]init];
    startNode.pos = [[BNPosition alloc]init];
    startNode.pos.x = 113.936392;
    startNode.pos.y = 22.547058;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc]init];
    endNode.pos = [[BNPosition alloc]init];
    endNode.pos.x = annotaiton.coordinate.longitude;
    endNode.pos.y = annotaiton.coordinate.latitude;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    BNCoreServices *service = [[BNCoreServices alloc]init];
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend  naviNodes:nodesArray time:nil delegete:service userInfo:nil];
//    BNCoreServices.routePlanService().startNaviRoutePlan(BNRoutePlanMode_Recommend, naviNodes: nodesArray, time: nil, delegete: self  , userInfo: nil)
    //发起路径规划
    
    
}

/*
 
 -(IBAction)onClickGeocode
 {
 isGeoSearch = true;
 BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
 geocodeSearchOption.city= _cityText.text;
 geocodeSearchOption.address = _addrText.text;
 BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
 if(flag)
 {
 NSLog(@"geo检索发送成功");
 }
 else
 {
 NSLog(@"geo检索发送失败");
 }
 
 }
 
 
 
 - (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
 {
 NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
	if (error == 0) {
 BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
 item.coordinate = result.location;
 item.title = result.address;
 [_mapView addAnnotation:item];
 _mapView.centerCoordinate = result.location;
 NSString* titleStr;
 NSString* showmeg;
 
 titleStr = @"正向地理编码";
 showmeg = [NSString stringWithFormat:@"纬度:%f,经度:%f",item.coordinate.latitude,item.coordinate.longitude];
 
 UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
 [myAlertView show];
	}
 }
 
 */

 @end


