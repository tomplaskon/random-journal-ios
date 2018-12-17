//
//  rjImportMomentsViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-18.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjImportMomentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func importPressed(_ sender: Any) {
        let momentImporter = rjMomentImporter()
        
        if let pasteboardContent = UIPasteboard.general.string {
            do {
                let importResults = try momentImporter.importMoments(pasteboardContent)
                if (importResults.numMomentsImported > 0) {
                    rjMomentEntityModelRepository.shared.notifyMomentsUpdated()
                }
                self.showResults(importResults)
            } catch {
                self.showInvalidImportFormat()
            }
        } else {
            self.showEmptyPasteboardMsg()
        }
    }
    
    func showEmptyPasteboardMsg() {
        let alert = UIAlertController(title: "Pasteboard Empty", message: "Your pasteboard is empty. You need to hold and copy the CSV file from your email first.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showInvalidImportFormat() {
        let alert = UIAlertController(title: "Invalid Import Format", message: "The content in your pasteboard has an invalid format. Try copying the file from your email again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showResults(_ importResults : rjMomentImporterResults) {
        // show the results of the import
        let alert = UIAlertController(title: "Import Results", message: "Number moments imported: \(importResults.numMomentsImported)\nNumber moments skipped: \(importResults.numMomentsSkipped)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
