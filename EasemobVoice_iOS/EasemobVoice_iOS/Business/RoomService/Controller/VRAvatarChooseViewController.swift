//
//  VRAvatarChooseViewController.swift
//  EasemobVoice_iOS
//
//  Created by 朱继超 on 2022/9/18.
//

import UIKit
import ZSwiftBaseLib

private let reuseIdentifier = "Cell"

public class VRAvatarChooseViewController: UICollectionViewController {
    
    var datas = [VRAvatar]()
    
    var selectedClosure: ((String) -> ())?
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.width-30-20)/4.0, height: (self.view.frame.width-30-20)/4.0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }()
    
    public override init(collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (ScreenWidth-30-20)/4.0, height: (ScreenWidth-30-20)/4.0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.collectionViewLayout = self.flowLayout
        for i in 0...17 {
            let item = VRAvatar()
            if let id = VoiceRoomUserInfo.shared.user?.portrait,id == "avatar\(i+1)" {
                item.selected = true
            }
            item.portrait = "avatar\(i+1)"
            self.datas.append(item)
        }
        self.collectionView.backgroundColor = .white
        self.collectionView!.registerCell(VRRoomAvatarCell.self, forCellReuseIdentifier: "VRRoomAvatarCell").delegate(self).dataSource(self).showsHorizontalScrollIndicator(false)
        self.collectionView.bounces = false

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.datas.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VRRoomAvatarCell", for: indexPath) as? VRRoomAvatarCell
        cell?.refresh(item: self.datas[safe: indexPath.row])
        return cell ?? VRRoomAvatarCell()
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.datas.forEach { $0.selected = false }
        self.datas[safe: indexPath.row]?.selected = true
        self.collectionView.reloadData()
        if self.selectedClosure != nil {
            self.selectedClosure!(self.datas[safe: indexPath.row]?.portrait ?? "")
        }
    }
    
}
