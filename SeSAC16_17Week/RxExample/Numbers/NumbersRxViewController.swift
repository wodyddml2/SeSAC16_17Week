//
//  NumbersRxViewController.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//

import UIKit

import RxSwift
import RxCocoa

class NumbersRxViewController: UIViewController {

    let mainView = NumbersView()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.combineLatest(mainView.number1.rx.text.orEmpty, mainView.number2.rx.text.orEmpty, mainView.number3.rx.text.orEmpty) { (value1, value2, value3) -> Int in
            return (Int(value1) ?? 0) + (Int(value2) ?? 0) + (Int(value3) ?? 0)
        }
        .map { $0.description }
        .bind(to: mainView.result.rx.text)
        .disposed(by: disposeBag)

//        Observable.combineLatest(mainView.number1.rx.text.orEmpty, mainView.number2.rx.text.orEmpty, mainView.number3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
//                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
//            }
//            .map { $0.description }
//            .bind(to: mainView.result.rx.text)
//            .disposed(by: disposeBag)
    }
    


}
