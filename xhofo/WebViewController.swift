//
//  WebViewController.swift
//  xhofo
//
//  Created by linlin xiao on 2017/8/24.
//  Copyright © 2017年 linlin xiao. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        openAcitveHtml()

        // Do any additional setup after loading the view.
    }
    
    //使用 webkit组件中的 webview打开活动页面
    func openAcitveHtml(){
        webView = WKWebView(frame: self.view.frame)
        
        let activeUrl = "http://m.ofo.so/active.html"
        let acitveURL = URL(string: activeUrl)
        let request = URLRequest(url: acitveURL!)
        self.view.addSubview(webView)
        webView.load(request)
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
