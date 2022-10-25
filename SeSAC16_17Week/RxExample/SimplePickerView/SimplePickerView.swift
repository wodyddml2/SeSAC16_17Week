//
//  Simple.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/25.
//

import UIKit

import SnapKit

class SimplePickerView : UIView {
    let pickerView1: UIPickerView = {
        let view = UIPickerView()
        
        return view
    }()
    
    let pickerView2: UIPickerView = {
        let view = UIPickerView()
        
        return view
    }()
    
    let pickerView3: UIPickerView = {
        let view = UIPickerView()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [pickerView1, pickerView2, pickerView3].forEach {
            self.addSubview($0)
        }
        
        pickerView1.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(162)
        }
        pickerView2.snp.makeConstraints { make in
            make.top.equalTo(pickerView1.snp.bottom)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(162)
        }
        pickerView3.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(pickerView2.snp.bottom)
        }
    }
}
