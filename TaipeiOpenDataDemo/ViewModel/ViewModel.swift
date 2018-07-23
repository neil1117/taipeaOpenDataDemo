//
//  ViewModel.swift
//  TaipeiOpenDataDemo
//
//  Created by Neil Wu on 2018/7/22.
//  Copyright © 2018年 Neil Wu. All rights reserved.
//

import RxSwift
import RxDataSources
import RxCocoa

class ViewModel {
    
    let disposeBag = DisposeBag()
    var sections = Variable<[SectionModel<String, Spot>]>([SectionModel(model: "", items: [])])
    var spotResult: Driver<[SectionModel<String, Spot>]>
    let urlSession = URLSession.shared
    var offset = 0
    var isLoading = false
    var temp = [Spot]()
    
    init() {
        spotResult = sections.asDriver().asDriver(onErrorJustReturn: [])
    }
    
    func getData() {
        guard !isLoading else {return}
        isLoading = true
        
        if sections.value.count > 0 {
            temp = sections.value[0].items
        }
        
        var urlString = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=36847f3f-deff-4183-a5bb-800737591de5&limit=10"
        if offset != 0 {
            urlString = urlString.appendingFormat("&offset=%d", offset)
        }
        let url = URLRequest(url: URL(string: urlString)!)
        
        urlSession.rx.json(request: url)
            .single()
            .subscribe(onNext: { [weak self] (json) in
                self?.parser(json: json)
            }, onError: { (error) in
                // 錯誤處理
                debugPrint(error)
            }, onCompleted: {
                self.isLoading = false
            }, onDisposed: {
                
            })
            .addDisposableTo(disposeBag)
    }
    
    func parser(json: Any) {
        if let data = json as? [String: Any] {
            guard let result = data["result"] as? [String: Any],
                let list = result["results"] as? Array<[String: Any]>
                else {return}
            offset = offset + list.count
            var spots = [Spot]()
            list.forEach({ (spotData) in
                guard let name = spotData["stitle"] as? String,
                    let describetion = spotData["xbody"] as? String,
                    var photoString = spotData["file"] as? String
                    else {return}
                photoString = photoString.lowercased().replacingOccurrences(of: ".jpg", with: ".jpg ")
                var photos = photoString.components(separatedBy: " ")
                photos.removeLast()
                let spot = Spot(name: name, describetion: describetion, photos: photos)
                spots.append(spot)
            })
            temp.append(contentsOf: spots)
            let sec = SectionModel(model: "", items: temp)
            sections.value = [sec]
        }
    }
}
