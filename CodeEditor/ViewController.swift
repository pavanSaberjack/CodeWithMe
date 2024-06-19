//
//  ViewController.swift
//  CodeEditor
//
//  Created by Pavan Itagi on 04/06/23.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func addTwoNumbers(a: Int, b: Int) -> Int {
        return a+b
    }

}

