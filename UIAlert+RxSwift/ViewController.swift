//
//  ViewController.swift
//  UIAlert+RxSwift
//
//  Created by cano on 2019/05/01.
//  Copyright © 2019 wings. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.bind()
    }

    func bind() {
        self.button.rx.tap.asDriver().drive(onNext: {
            
            self.showAlert(title: "Alert Title", message: "message", style: .alert,
                           actions: [AlertAction.action(title: "no", style: .destructive), AlertAction.action(title: "yes")]
                ).subscribe(onNext: { selectedIndex in
                    print(selectedIndex)
                }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
    }

}

struct AlertAction {
    var title: String
    var style: UIAlertAction.Style
    
    static func action(title: String, style: UIAlertAction.Style = .default) -> AlertAction {
        return AlertAction(title: title, style: style)
    }
}

extension UIViewController {
    
    func showAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [AlertAction]) -> Observable<Int>
    {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            
            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }
            
            self.present(alertController, animated: true, completion: nil)
            
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
}
