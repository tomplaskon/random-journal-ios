//
//  rjAddMomentViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-05.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjAddMomentViewController: UIViewController {

    @IBOutlet weak var txtDetails: UITextView!
    @IBOutlet weak var btnSaveBottomConstraint: NSLayoutConstraint!
    
    var btnSaveBottomConstraintOriginalConstant: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSaveBottomConstraintOriginalConstant = btnSaveBottomConstraint.constant;
        
        self.listenForKeyboardEvents();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtDetails.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // hide the keyboard if the user touched something other than details text
        let touch = event?.allTouches?.first
        if (txtDetails.isFirstResponder && touch != nil && touch?.view != txtDetails) {
            txtDetails.resignFirstResponder();
        }
    }

    func listenForKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            btnSaveBottomConstraint.constant = btnSaveBottomConstraintOriginalConstant + keyboardHeight;
        }
    }

    @objc func keyBoardWillHide(notification: NSNotification) {
        btnSaveBottomConstraint.constant = btnSaveBottomConstraintOriginalConstant;
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        // save the moment
        let moment = rjMoment()
        moment.when = rjCommon.unixTimestamp()
        moment.details = txtDetails.text
        
        let momentMgr = rjMomentMgr()
        momentMgr.addMoment(moment)
        
        // let everyone else know the moments have been updated
        // TODO: change this to a notification
        appDelegate.momentsUpdated = true;

        // send us back to the moments list
        if let tabBarController = appDelegate.window!.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 0
        }
        
        // reset the interface
        resetInterface()
    }
    
    func resetInterface() {
        txtDetails.text = ""
    }
}
