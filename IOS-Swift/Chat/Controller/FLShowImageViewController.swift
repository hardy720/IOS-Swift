//
//  FLShowImageViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/12/2.
//

import UIKit

class FLShowImageViewController: UIViewController {

    var imagePathString : String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentImg)
        let imgaPath = BASE_URL_IMAGE + (imagePathString ?? "")
        contentImg.kf.setImage(with: URL(string: imgaPath), placeholder: UIImage(named: "placeholder.jpg"), options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                // 图片加载成功
                FLPrint("Image loaded successfully: \(value.image)")
            case .failure(let error):
                // 图片加载失败
                FLPrint("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
    
    lazy var contentImg: UIImageView =
    {
        let imageView = UIImageView.init()
        imageView.frame = CGRectMake(0, 0, screenW(), screenH())
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(cellImageTap))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    @objc func cellImageTap()
    {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) 
    {
        self.dismiss(animated: false)
    }
}
