//
//  SimpleValidationRxViewController.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//

import UIKit

import RxSwift
import RxCocoa

class SimpleValidationRxViewController: UIViewController {
    
    let minimalUsernameLength = 5
    let minimalPasswordLength = 5

    let mainView = SimpleValidationView()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.usernameLabel.text = "이름은 최소 \(minimalUsernameLength)개 이상"
        mainView.passwordLabel.text = "비밀번호는 최소 \(minimalPasswordLength)개 이상"
        
        // share: Observable은 subscribe 할 때마다 새로운 Observable 시퀀스가 생성되기에 한 번 생성한 시퀀스를 공유할 수 있게 해주는 함수
        let username = mainView.usernameTextField.rx.text.orEmpty
            .map {$0.count >= self.minimalUsernameLength}
            .share(replay: 1)
        
        let password = mainView.passwordTextField.rx.text.orEmpty
            .map {$0.count >= self.minimalPasswordLength}
            .share(replay: 1)
        
        let allTextField = Observable.combineLatest(username, password) {
            $0 && $1
        }
            .share(replay: 1)
        
        username
            .bind(to: mainView.passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        username
            .bind(to: mainView.usernameLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        password
            .bind(to: mainView.passwordLabel.rx.isHidden)
            .disposed(by: disposeBag)
        allTextField
            .bind(to: mainView.okButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        mainView.okButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { [weak self] _ in
                self?.showAlert()
            })
            .disposed(by: disposeBag)
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "버튼 클릭", message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
