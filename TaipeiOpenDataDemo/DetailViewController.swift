//
//  DetailViewController.swift
//  TaipeiOpenDataDemo
//
//  Created by Neil Wu on 2018/7/23.
//  Copyright © 2018年 Neil Wu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    var viewModel = DetailViewModel()
    var disposeBag = DisposeBag()
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bindRx()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    func setView() {
        
        view.backgroundColor = .white
        let width = view.bounds.width
        let height = width / 3 * 4
        imageView.frame = CGRect(x: 0, y: (view.bounds.height - height) / 2, width: width, height: height)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
    
    func bindRx() {
        viewModel.url
            .subscribe(onNext: {urlString in
                self.imageView.sd_setImage(with: URL(string: urlString), completed: nil)
            })
            .addDisposableTo(disposeBag)
    }

}
