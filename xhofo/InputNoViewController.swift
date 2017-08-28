//
//  InputNoViewController.swift
//  xhofo
//
//  Created by linlin xiao on 2017/8/27.
//  Copyright © 2017年 linlin xiao. All rights reserved.
//

import UIKit
import APNumberPad

class InputNoViewController: UIViewController,APNumberPadDelegate,UITextFieldDelegate {
    
    var torchFlag = false
    var voiceFlag = true
    
    @IBOutlet weak var panelView: UIView!
    // 手电筒
    @IBOutlet weak var torch: UIButton!
    @IBOutlet weak var inpuText: UITextField!
    
    @IBOutlet weak var submit: UIButton!
    //声音开关
    @IBOutlet weak var voice: UIButton!
    
    @IBAction func inputSubmit(_ sender: UIButton) {
        
    }
    
    @IBAction func onoffVoice(_ sender: UIButton) {
        voiceFlag = !voiceFlag
        
        if voiceFlag {
            voice.setImage(#imageLiteral(resourceName: "voiceopen"), for: .normal)
        } else {
            voice.setImage(#imageLiteral(resourceName: "voiceclose"), for: .normal)
        }
    }
    
    
    @IBAction func onoffTorch(_ sender: UIButton) {
        torchFlag = !torchFlag
        
        if torchFlag {
            torch.setImage(#imageLiteral(resourceName: "btn_enableTorch"), for: .normal)
        } else {
            torch.setImage(#imageLiteral(resourceName: "btn_unenableTorch"), for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "输入车牌号解锁"
        
        inpuText.layer.borderWidth = 1.5
        inpuText.layer.borderColor = UIColor.ofoColor.cgColor
        
        // 监听输入框事件
        inpuText.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫码用车", style: .plain, target: self, action: #selector(returnScan))
        
        let numberPad = APNumberPad(delegate: self)
        numberPad.leftFunctionButton.setTitle("确定", for: .normal)
        //键盘指定
        inpuText.inputView = numberPad
    }
    
    func returnScan(){
        //返回上一级控制器
        navigationController?.popViewController(animated: true)
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
    
    // MARK: APNumberPad delegate
    
    // 键盘确定按钮事件
    func numberPad(_ numberPad: APNumberPad, functionButtonAction functionButton: UIButton, textInput: UIResponder) {
        print("\(textInput)")
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let countLength = text.characters.count + string.characters.count - range.length
        
        if countLength > 0 {
            submit.setImage(#imageLiteral(resourceName: "nextArrow_enable"), for: .normal)
            submit.backgroundColor = UIColor.ofoColor
        } else {
            submit.setImage(#imageLiteral(resourceName: "nextArrow_unenable"), for: .normal)
            submit.backgroundColor = UIColor.groupTableViewBackground
        }
        
        return countLength <= 8
    }

}
