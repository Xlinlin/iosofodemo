//
//  ScanUseViewController.swift
//  xhofo
//
//  Created by linlin xiao on 2017/8/27.
//  Copyright © 2017年 linlin xiao. All rights reserved.
//

import UIKit
import swiftScan
import FTIndicator


/// 扫码用车
class ScanUseViewController: LBXScanViewController {
    
    @IBOutlet weak var pannerView: UIView!
    @IBOutlet weak var panelView: UIView!
    //手电筒开光状态
    var onoff = false
    
    @IBOutlet weak var torchBtn: UIButton!
    // 手电筒
    @IBAction func torch(_ sender: UIButton) {
        onoff = !onoff
        
        self.scanObj?.changeTorch()
        
        //开关图片切换
        if onoff {
            torchBtn.setImage(#imageLiteral(resourceName: "btn_enableTorch_w"), for: .normal)
        } else {
            torchBtn.setImage(#imageLiteral(resourceName: "btn_unenableTorch_w"), for: .normal)
        }
    }
    
    
    //处理扫描结果
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        if let result = arrayResult.first {
            let scanContet = result.strScanned
            FTIndicator.setIndicatorStyle(.light)
            FTIndicator.showToastMessage(scanContet)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 更改导航条头部颜色 //亮黑
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.title = "扫码用车"
        // Do any additional setup after loading the view.
        
        var style = LBXScanViewStyle()
        // 网格样式
        style.anmiationStyle = .NetGrid
        // 设置图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        self.scanStyle = style
    }
    
    
    
    
    // UI加载完后设置 按钮到页面顶层
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 设置指定页面到顶层
        view.bringSubview(toFront: panelView)
    }
    
    // 将要销毁的时候 将导航条设置默认颜色
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        //设置的导航条的title为空
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
