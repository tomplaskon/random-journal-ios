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
    @IBOutlet weak var colTips: UICollectionView!
    @IBOutlet weak var lblWritingTips: UILabel!
    @IBOutlet weak var lblSwipeForMoreTips: UILabel!
    
    var tips = rjFixedStack<String>(10)
    var maxTipsIndex : Int?
    
    var btnSaveBottomConstraintOriginalConstant: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTipsCollectionView()
        
        btnSaveBottomConstraintOriginalConstant = btnSaveBottomConstraint.constant;
        
        txtDetails.inputAccessoryView = makeAccessoryView()
        
        self.listenForKeyboardEvents();
        
        setTipsVisible(false)
    }
    
    func configureTipsCollectionView() {
        colTips.dataSource = self
        colTips.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtDetails.becomeFirstResponder()
    }
    
    func makeAccessoryView() -> UIToolbar {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 35))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnKeyboardSave = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(btnSavePressed(_:)))
        let btnKeyboardTips = UIBarButtonItem(title: "Tips", style: .plain, target: self, action: #selector(btnTipsPressed))
        
        bar.items = [flexSpace, btnKeyboardTips, btnKeyboardSave]
        
        return bar
        
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
        /*
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            btnSaveBottomConstraint.constant = btnSaveBottomConstraintOriginalConstant + keyboardHeight;
        }
        */
    }

    @objc func keyBoardWillHide(notification: NSNotification) {
        //btnSaveBottomConstraint.constant = btnSaveBottomConstraintOriginalConstant;
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
    
    @objc func btnTipsPressed() {
        toggleTipsVisibile()
        
        // hide keyboard
        txtDetails.resignFirstResponder()
    }
    
    func resetInterface() {
        txtDetails.text = ""
        setTipsVisible(false)
    }
    
    func setTipsVisible(_ visible : Bool) {
        let isHidden = !visible
        
        lblWritingTips.isHidden = isHidden
        colTips.isHidden = isHidden
        lblSwipeForMoreTips.isHidden = isHidden
    }

    func toggleTipsVisibile() {
        setTipsVisible(lblWritingTips.isHidden)
    }
}

extension rjAddMomentViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "tip", for: indexPath) as! rjTipCollectionViewCell
        cell.lblTip.text = rjTipsMgr.getRandomTip()
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let swipeForMoreTipsHeight : CGFloat  = 30
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height-swipeForMoreTipsHeight)
    }
}
