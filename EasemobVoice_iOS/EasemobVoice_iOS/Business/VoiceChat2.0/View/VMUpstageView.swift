//
//  VMUpstageView.swift
//  EasemobVoice_iOS
//
//  Created by CP on 2022/9/7.
//

import UIKit
import ZSwiftBaseLib
class VMUpstageView: UIView {
    
    private var lineImgView: UIImageView = UIImageView()
    private var canBtn: UIButton = UIButton()
    private var subBtn: UIButton = UIButton()
    private var titleLabel: UILabel = UILabel()
    
    var resBlock: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        let path: UIBezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
        let layer: CAShapeLayer = CAShapeLayer()
        layer.path = path.cgPath
        self.layer.mask = layer
        
        lineImgView.frame = CGRect(x: ScreenWidth / 2.0 - 20~, y: 8~, width: 40~, height: 4~)
        lineImgView.image = UIImage(named: "pop_indicator")
        self.addSubview(lineImgView)
        
        titleLabel.frame = CGRect(x: ScreenWidth / 2.0 - 60~, y: 50~, width: 120~, height: 30~)
        titleLabel.textAlignment = .center
        titleLabel.text = "Ask Upstage?"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(titleLabel)

        canBtn.frame = CGRect(x: 30~, y: 115~, width: 150~, height: 40~)
        canBtn.setTitle("Cancel", for: .normal)
        canBtn.setTitleColor(.black, for: .normal)
        canBtn.backgroundColor = UIColor(red: 239/255.0, green: 244/255.0, blue: 1, alpha: 1)
        canBtn.addTargetFor(self, action: #selector(can), for: .touchUpInside)
        canBtn.layer.cornerRadius = 20~
        canBtn.layer.masksToBounds = true
        self.addSubview(canBtn)

        subBtn.frame = CGRect(x: ScreenWidth - 180~, y: 115~, width: 150~, height: 40~)
        subBtn.setTitle("Submit", for: .normal)
        subBtn.addTargetFor(self, action: #selector(sub), for: .touchUpInside)
        subBtn.setTitleColor(.white, for: .normal)
        self.addSubview(subBtn)
        
        // gradient
        let gl: CAGradientLayer = CAGradientLayer()
        gl.startPoint = CGPoint(x: 0.18, y: 0)
        gl.endPoint = CGPoint(x: 0.66, y: 1)
        gl.colors = [UIColor(red: 33/255.0, green: 155/255.0, blue: 1, alpha: 1).cgColor, UIColor(red: 52/255.0, green: 93/255.0, blue: 1, alpha: 1).cgColor]
        gl.locations = [0, 1.0]
        subBtn.layer.cornerRadius = 20~;
        subBtn.layer.masksToBounds = true;
        gl.frame = subBtn.bounds;
        subBtn.layer.addSublayer(gl)
    }
    
    @objc private func can() {
         guard let block = resBlock else {return}
         block(false)
     }
     
    @objc private func sub() {
         guard let block = resBlock else {return}
         block(true)
     }

}
