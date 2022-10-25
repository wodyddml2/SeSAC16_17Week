//
//  SimpleValidationView.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//

import UIKit

class SimpleValidationView: UIView {
    let usernameTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let passwordTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let usernameLabel: UILabel = {
        let view = UILabel()

        return view
    }()
    
    let passwordLabel: UILabel = {
        let view = UILabel()
        
        return view
    }()
    
    let okButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .green
        view.setTitle("확인", for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [usernameTextField, usernameLabel, passwordTextField, passwordLabel, okButton].forEach {
            self.addSubview($0)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(50)
        }
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(10)
            make.centerX.equalTo(self)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(50)
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.centerX.equalTo(self)
        }
        
        okButton.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(50)
        }
    }
}
