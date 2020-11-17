//
//  SimpleTipViewController.swift
//  HBRTips
//
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

class SimpleTipViewController: UIViewController {

    var service: TodosService = TodosService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var textView: UITextView!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        service.retrieveRemote { (tip) in
            self.articleTitle.text = tip.title
            self.textView.text = tip.content
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
