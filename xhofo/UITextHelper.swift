//
//  UITextHelper.swift
//  xhofo
//
//  Created by linlin xiao on 2017/8/28.
//  Copyright © 2017年 linlin xiao. All rights reserved.
//


// MARK: - 扩张UI属性，可在storyboard上展示
extension UIView{
    
    
    /// 边框大小
    @IBInspectable var bordWith: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var bordColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
}
