//
//  ViewController.swift
//  TaipeiOpenDataDemo
//
//  Created by Neil Wu on 2018/7/19.
//  Copyright © 2018年 Neil Wu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let viemMdoel = ViewModel()
    let disposeBag = DisposeBag()
    var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Spot>>()
    var isScroll = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setNavigation()
        setTableView()
        bindRx()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setView() {
        view.backgroundColor = UIColor.darkGray
    }
    
    func setNavigation() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 100/255.0, green: 191/255.0, blue: 232/255.0, alpha: 1)
        title = "台北市熱門景點"
    }
    
    func setTableView() {
        guard  navigationController != nil else {
            return
        }
        if let table = self.tableView {
            table.register(UINib.init(nibName: "SpotCell", bundle: nil), forCellReuseIdentifier: "spotTableViewCell")
            table.backgroundColor = .white
            table.separatorStyle = .none
            table.rowHeight = UITableViewAutomaticDimension
            view.addSubview(table)
        }
        
        dataSource.configureCell = { _, tableView, indexPath, spot in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "spotTableViewCell", for: indexPath) as? SpotCell else {
                fatalError("")
            }
            cell.tag = indexPath.row + 1
            cell.nameLabel.text = spot.name
            cell.describtionLabel.text = spot.describetion
            cell.photos = spot.photos
            return cell
        }
        
        tableView?.rx.willBeginDecelerating
            .subscribe(onNext: { [weak self] Void in
                let cells = self?.tableView?.visibleCells
                let cell = cells?.last
                if cell?.tag == self?.viemMdoel.offset {
                    self?.viemMdoel.getData()
                }
                
            })
            .addDisposableTo(disposeBag)
        
        
    }
    
    func bindRx() {
        
        guard let tableView = self.tableView else {return}
        viemMdoel.spotResult
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        viemMdoel.getData()
    }
    
    func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName : font], context: nil).size
    }

}

class SpotCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var describtionLabel: UILabel!
    @IBOutlet var photoCollectionView: UICollectionView!
    var photos = [String]() {
        didSet {
            viewModel.sections.value = [SectionModel(model: "", items: photos)]
        }
    }
    let disposeBag = DisposeBag()
    var dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>()
    var viewModel = SpotCellViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
        bindRx()
    }
    
    func setCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = CGSize(width: 149, height: 110)
        photoCollectionView.collectionViewLayout = collectionViewLayout
        photoCollectionView.register(UINib.init(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
    }
    
    func bindRx() {
        
        let controlEvent = photoCollectionView.rx.itemSelected
        controlEvent.asControlEvent()
            .subscribe(onNext: { event in
                let detailVC = DetailViewController()
                let nav = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
                nav.show(detailVC, sender: nil)
                detailVC.viewModel.url.onNext(self.dataSource[event.section].items[event.item])
            })
            .addDisposableTo(disposeBag)
        
        dataSource.configureCell = { _, collectionView, indexPath, string in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else {
                fatalError("")
            }
            cell.imageView.sd_setImage(with: URL(string: string), completed: nil)
            return cell
        }
        
        viewModel.photoResult
            .drive(photoCollectionView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
    
}

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
