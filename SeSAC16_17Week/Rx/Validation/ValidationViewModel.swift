//
//  ValidationViewModel.swift
//  SeSAC16_17Week
//
//  Created by J on 2022/10/27.
//

import Foundation

import RxSwift
import RxCocoa

class ValidationViewModel {
    // Validation 문구
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상 필요해요")
}
