//
//  VRRoomAvatarAlert.swift
//  AgoraScene_iOS
//
//  Created by 朱继超 on 2022/9/18.
//

import UIKit
import ZSwiftBaseLib

public class VRRoomAvatarAlert: UIView {
    
    var datas = [VRAvatar]()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.frame.width-20)/4.0, height: (self.frame.width-20)/4.0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    lazy var avatarList: UICollectionView = {
        UICollectionView(frame: CGRect(x: 10, y: 10, width: self.frame.width-20, height: self.frame.height-10), collectionViewLayout: self.flowLayout).registerCell(VRRoomAvatarCell.self, forCellReuseIdentifier: "VRRoomAvatarCell").delegate(self).dataSource(self).showsHorizontalScrollIndicator(false)
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        for i in 0...17 {
            let item = VRAvatar()
            if let id = VoiceRoomUserInfo.shared.user?.portrait,id == "avatar\(i+1)" {
                item.selected = true
            }
            item.portrait = "avatar\(i+1)"
            self.datas.append(item)
        }
        self.addSubViews([self.avatarList])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension VRRoomAvatarAlert: UICollectionViewDelegate,UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.datas.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VRRoomAvatarCell", for: indexPath) as? VRRoomAvatarCell
        cell?.item = self.datas[safe: indexPath.row]
        return cell ?? VRRoomAvatarCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.datas.forEach { $0.selected = false }
        self.datas[safe: indexPath.row]?.selected = true
        self.avatarList.reloadData()
    }
}
