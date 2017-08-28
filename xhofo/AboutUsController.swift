//
//  AboutUsController.swift
//  xhofo
//
//  Created by linlin xiao on 2017/8/25.
//  Copyright © 2017年 linlin xiao. All rights reserved.
//

import UIKit
import SWRevealViewController

class AboutUsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadsidebar()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
