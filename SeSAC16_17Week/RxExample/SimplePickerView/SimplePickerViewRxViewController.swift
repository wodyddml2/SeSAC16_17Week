//
//  SimplePickerViewRxViewController.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SimplePickerViewRxViewController: ViewController {
    
    let mainView = SimplePickerView()
    override func loadView() {
        self.view = mainView
    }
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        
        Observable.just(["J", "A", "E"])
            .bind(to: mainView.pickerView1.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        mainView.pickerView1.rx.modelSelected(String.self)
            .withUnretained(self)
            .subscribe(onNext: { model in
                print("select1: \(model)")
            })
            .disposed(by: disposeBag)
        
        
        Observable.just(["LEE", "JAE", "YONG"])
            .bind(to: mainView.pickerView2.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: item, attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternDot.rawValue
                ])
            }
            .disposed(by: disposeBag)
        
        mainView.pickerView2.rx.modelSelected(String.self)
            .withUnretained(self)
            .subscribe(onNext: { model in
                print("select2: \(model)")
            })
            .disposed(by: disposeBag)
        
        
        Observable.just([UIColor.darkGray, UIColor.red, UIColor.blue])
            .bind(to: mainView.pickerView3.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)
        
  
        mainView.pickerView3.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { model in
                print("select3: \(model)")
            })
            .disposed(by: disposeBag)

    }
}
