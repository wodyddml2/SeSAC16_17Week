//
//  NumbersView.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//

import UIKit

class NumbersView: UIView {
    let number1: UITextField = {
        let view = UITextField()
        view.backgroundColor = .yellow
        return view
    }()
    
    let number2: UITextField = {
        let view = UITextField()
        view.backgroundColor = .yellow
        return view
    }()
    
    let number3: UITextField = {
        let view = UITextField()
        view.backgroundColor = .yellow
        return view
    }()
    
    let result: UILabel = {
        let view = UILabel()
        
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
        [number1, number2, number3,result].forEach {
            self.addSubview($0)
        }
        
        number1.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(50)
        }
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(50)
        }
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(50)
        }
        result.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(20)
            make.centerX.equalTo(self)
        }
    }
}
