//
//  ViewController.swift
//  ToDoApp
//
//  Created by Александра Коснырева on 29.07.2025.
//

import UIKit

protocol ToDoViewControllerProtocol: AnyObject {
    
}

class ToDoViewController: UIViewController, ToDoViewControllerProtocol {
    private let configuratore = ToDoConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

