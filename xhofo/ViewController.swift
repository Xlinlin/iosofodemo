//
//  ViewController.swift
//  xhofo
//
//  Created by linlin xiao on 2017/8/24.
//  Copyright © 2017年 linlin xiao. All rights reserved.
//

import UIKit
import CoreLocation
import SWRevealViewController
import FTIndicator

class ViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate,AMapNaviWalkManagerDelegate {
    
    //地图
    var mapView: MAMapView!
    
    // 搜索
    var searchMap: AMapSearchAPI!
    
    // 移动标志，初始化为true
    var neerbySearch = true
    
    // 大头针
    var myPin: MyPinAnnotation!
    
    // 大头针视图
    var myPinView: MAPinAnnotationView!
    
    // 起终点系统对象
    var start,end: CLLocationCoordinate2D!
    var walkManager: AMapNaviWalkManager!
    
    //底部面板
    @IBOutlet weak var indexPanel: UIView!
    
    //扫描用车
    @IBAction func scanUseBike(_ sender: UIButton) {
    }
    
    //定位
    @IBAction func location(_ sender: UIButton) {
        // 大头针移动时锁定位置，此处需要重置，已开启定位
        neerbySearch = true
        searchNearBy()
    }
    
    // 吐槽反馈
    @IBAction func feedback(_ sender: UIButton) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMap()
        // 面置到前面
        self.view.bringSubview(toFront: indexPanel)
        
        loadNavgation()
        
        loadsidebar()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 搜索周边
    func searchNearBy(){
        searchCustomLocation(mapView.userLocation.coordinate)
    }
    
    // 搜索自定义位置
    func searchCustomLocation(_ center: CLLocationCoordinate2D){
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        // 关键字
        request.keywords = "餐馆"
        // 范围 500米内
        request.radius = 500
        //是否返回扩展信息
        request.requireExtension = true
        
        searchMap.aMapPOIAroundSearch(request)
    }

    
    //加载地图
    func loadMap(){
        
        // 总代理设置权限，info.plist 添加定位权限
        
        //初始化地图
        mapView = MAMapView(frame: view.bounds)
        
        // 代理实现。MAMapViewDelegate
        mapView.delegate = self
        
        // 地图缩放界别
        mapView.zoomLevel = 12
        
        // 位置定位
        mapView.showsUserLocation = true
        // 跟踪位置
        mapView.userTrackingMode = .follow
        self.view.addSubview(mapView)
        
        //加载搜索功能
        searchMap = AMapSearchAPI()
        searchMap.delegate = self
        
        //加载步行导航
        walkManager = AMapNaviWalkManager()
        walkManager.delegate = self
        
    }
    
    //侧边栏实现
    func loadsidebar(){
        
        //获取父容器
        if let sidebar = revealViewController() {
            //宽度，此处与广告图的宽度保持一致
            sidebar.rearViewRevealWidth = 310
            
            //左侧按钮 点击展示
            self.navigationItem.leftBarButtonItem?.target = sidebar
            // 添加切换方法
            self.navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            // 添加平移手势
            self.view.addGestureRecognizer(sidebar.panGestureRecognizer())
        }
    }
    
    
    //加载导航条信息
    func loadNavgation(){
        
        //使用源图标背景，否则导航条默认的颜色会覆盖图片的颜色
        self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "leftTopImage").withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "rightTopImage").withRenderingMode(.alwaysOriginal)
        
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ofoLogo"))
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    /// 大头针 坠落效果
    func pinAnimate(){
        // Y轴操作
        let endFrame = myPinView.frame
        
        //相对位移
        myPinView.frame = endFrame.offsetBy(dx: 0, dy: -20)
        // view的弹性动画
        UIView.animate(withDuration: 0.5, delay: 0, options: [],
                       animations: {
            self.myPinView.frame = endFrame
        }, completion: nil)
    }
    
    // MARK: MAP search delegate
    //代理实现，搜索后处理
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.count == 0 {
            print("周边无可用单车")
            return
        }
        
        //转成标记
        var annotations: [MAPointAnnotation] = []
        
        annotations = response.pois.map{
            let annotation = MAPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            
            //实现红包以及正常单车区别
            if $0.distance < 100 {
                annotation.title = "红包区域内开锁任意小黄车"
                annotation.subtitle = "骑行10分钟可获得红包"
            } else {
                annotation.title = "正常"
            }
            
            return annotation
        }
        
        mapView.addAnnotations(annotations)
        
        // 用户移动 地图不进行缩放，解决大头针的效果
        if neerbySearch {
            // 显示缩放效果
            mapView.showAnnotations(annotations, animated: true)
            neerbySearch = !neerbySearch
        }
    }
    
    // MARK: Map view Delegate
    
    /// 自定义大头针效果
    ///
    /// - Parameters:
    ///   - mapView: MAMapView
    ///   - views: 所有annotations
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let aViews = views as! [MAAnnotationView]
        
        for aview in aViews {
            //保证是MAPointAnnotation
            guard aview.annotation is MAPointAnnotation else {
                continue
            }
            
            //缩放效果
            aview.transform = CGAffineTransform(scaleX: 0, y: 0)
            //自定义动画
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                aview.transform = .identity
            }, completion: nil)
        }
    }
    
    /// 重载显示效果，图钉 更改自定义图片
    ///
    /// - Parameters:
    ///   - mapView: MAMapView
    ///   - annotation: 标注
    /// - Returns: 标注视图
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        //排除自身位置
        if annotation is MAUserLocation {
            return nil
        }
        
        //自定义显示到屏幕上的大头针
        if annotation is MyPinAnnotation{
            let reuseid = "anchor"
            var anv = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MAPinAnnotationView
            
            if anv == nil {
                anv = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
            }
            
            anv?.image = #imageLiteral(resourceName: "homePage_wholeAnchor")
            anv?.canShowCallout = false
            
            myPinView = anv
            return anv
        }
        
        let reuseid = "myid"
        // 重用图标
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MAPinAnnotationView
        if annotationView == nil {
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
        }
        
        if annotation.title == "正常" {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
        }else{
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBikeRedPacket")
        }
        
        //显示气泡
        annotationView?.canShowCallout = true
        //动画效果
        annotationView?.animatesDrop = false
        
        
        return annotationView
    }
    
    
    /// 地图初始化完成后事件
    /// 添加地图上自定义的大头针
    /// - Parameter mapView: <#mapView description#>
    func mapInitComplete(_ mapView: MAMapView!) {
        myPin = MyPinAnnotation()
        
        //定位屏幕中心
        myPin.coordinate = mapView.centerCoordinate
        myPin.lockedScreenPoint =  CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
        myPin.isLockedToScreen = true
        
        mapView.addAnnotation(myPin)
        mapView.showAnnotations([myPin], animated: true)
        
        //初始化后调用一次 搜索
        searchNearBy()
    }
    
    /// 用户移动地图操作
    ///
    /// - Parameters:
    ///   - mapView: <#mapView description#>
    ///   - wasUserAction: 是否移动
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        
        if wasUserAction {
            //继续锁定大头针
            myPin.isLockedToScreen = true
            //移动之后的坐标
            searchCustomLocation(mapView.centerCoordinate)
            pinAnimate()
        }
    }
    
    
    /// 路线规划实现
    /// 
    /// 1.点击地图上显示的大头针事件
    /// 2.初始化高德地图导航 AMapNaviWalkManager，实现AMapNaviWalkManagerDelegate 步行导航代理
    /// 3.起点终点计算
    /// 4.规划显示
    ///
    ///
    /// - Parameters:
    ///   - mapView: <#mapView description#>
    ///   - view: <#view description#>
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        start = myPin.coordinate
        end = view.annotation.coordinate
        
        let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(start.longitude))!
        let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude))!
        
        walkManager.calculateWalkRoute(withStart: [startPoint], end: [endPoint])
        
    }
    
    
    /// 设置折线的样式
    ///
    /// - Parameters:
    ///   - mapView: <#mapView description#>
    ///   - overlay: <#overlay description#>
    /// - Returns: <#return value description#>
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            
            // 释放大头针
            myPin.isLockedToScreen = false
            
            //地图缩放至 规划的线路 可是区域
            mapView.visibleMapRect = overlay.boundingMapRect
            
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 8.0
            renderer.strokeColor = UIColor.blue
            
            return renderer
        }
        return nil
    }
    
    // MARK: AMapNaviWalkManagerDelegate
    
    // 规划成功事件
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        //print("CalculateRouteSuccess")
        
        // 清除之前的规划
        mapView.removeOverlays(mapView.overlays)
        
        let coordinates = walkManager.naviRoute!.routeCoordinates!
        
        var coordinatesSys: [CLLocationCoordinate2D] = []
        
        coordinatesSys = coordinates.map{
            
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
            
            return coordinate
        }
        
        let polyline: MAPolyline = MAPolyline(coordinates: &coordinatesSys, count: UInt(coordinatesSys.count))
        
        mapView.add(polyline)
        
        // 显示 时间和距离
        let timeMinutes = walkManager.naviRoute!.routeTime / 60
        var tipsTitle = "1分钟内到达"
        if timeMinutes > 0{
            tipsTitle = timeMinutes.description + "分钟内到达"
        }
        let subMessage = "距离"+walkManager.naviRoute!.routeLength.description + "m"
        
        // 系统默认提示框
//        let alertController = UIAlertController(title: tipsTitle, message: subMessage, preferredStyle:UIAlertControllerStyle.alert)
//        let alertAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
//        alertController.addAction(alertAction)
//        self.present(alertController, animated: true, completion: nil)
    
        // 第三方提示框
        // 背景样式
        FTIndicator.setIndicatorStyle(UIBlurEffectStyle.dark)
        FTIndicator.showNotification(with: #imageLiteral(resourceName: "clock"), title: tipsTitle, message: subMessage)
    }
    
    // 规划失败事件
    func walkManager(_ walkManager: AMapNaviWalkManager, onCalculateRouteFailure error: Error) {
        print("CalculateRouteFailure",error)
    }
}

