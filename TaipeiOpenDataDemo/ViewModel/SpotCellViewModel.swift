//
//  SpotCellViewModel.swift
//  TaipeiOpenDataDemo
//
//  Created by Neil Wu on 2018/7/23.
//  Copyright © 2018年 Neil Wu. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class SpotCellViewModel {
    
    let disposeBag = DisposeBag()
    var sections = Variable<[SectionModel<String, String>]>([SectionModel(model: "", items: [])])
    var photoResult: Driver<[SectionModel<String, String>]>
    
    init() {
        photoResult = sections.asDriver().asDriver(onErrorJustReturn: [])
    }
    
    func setPhotos(_ photos: [String]) {
        sections.value = [SectionModel(model: "", items: photos)]
    }
    
}
