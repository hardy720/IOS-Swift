//
//  KingfisherViewController.swift
//  IOS-Swift
//
//  Created by hardy on 2024/7/31.
//

import UIKit
import Kingfisher

class KingfisherViewController: FLBaseViewController, ImageDownloaderDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        self.initUI()
    }
    
    func initData()
    {
        headDataArray =
        [
            "一、Kingfisher的使用",
            "二、清理缓存"
        ]
        dataArray =
        [
            [
                "加载图片:Kingfisher提供了简洁的API来加载图片。你可以直接通过URL来加载网络图片，或者通过文件路径来加载本地图片",
                "设置占位图和加载完成回调:Kingfisher允许你设置占位图（placeholder）和加载完成后的回调。以下是一个设置占位图和回调的示例：",
                "图片加载ImageDownloader使用:从名字就可以很清楚的知道，这个类就是用来下载图片的，它为我们提供了一些头的设置（比如说你有些图片是需要认证用户才能下载的）；安全设置：我们在下载图片时哪些Host是可信任的；下载超时设置；下载回调等。",
                "按钮设置图片",
                "设置动态图片"
            ],
            [
                "清理内存缓存",
                "清理磁盘缓存，完成后执行闭包",
                "获取当前缓存"
            ]
        ]
    }
    
    func initUI()
    {
        self.title = "Kingfisher"
        view.addSubview(tableView)
    }
    
    func downLoadImg()
    {
        let downloader = ImageDownloader.default
        // 设置可信任的Host
        let hosts: Set<String> = ["http://img0.baidu.com/","http://img1.baidu.com/"]
        downloader.trustedHosts = hosts
        // 设置sessionConfiguration
        downloader.sessionConfiguration = URLSessionConfiguration.default
        // 设置代理，详情参考 ImageDownloaderDelegate
        downloader.delegate = self
        // 下载超时设置
        downloader.downloadTimeout = 20
        // 下载图片
        let retriveTask = downloader.downloadImage(with: NSURL(string: "http://img1.baidu.com/it/u=464151090,2377346627&fm=253&app=138&f=JPEG?w=800&h=1779")! as URL, options: nil) {result in
            
            switch result {
            case .success(let loadingResult):
                let imageView = UIImageView.init()
                imageView.center = self.view.center;
                imageView.bounds = CGRect(x: 0, y: 0, width: screenW() * 0.75, height: screenH() * 0.75)
                imageView.contentMode = .scaleAspectFit
                imageView.layer.cornerRadius = 10
                imageView.layer.masksToBounds = true
                imageView.isUserInteractionEnabled = true
                imageView.image = loadingResult.image
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.tapClick(_:)))
                imageView.addGestureRecognizer(tapGesture)
                self.view.addSubview(imageView)
            case .failure(let error):
                // 处理错误
                print("Error loading image: \(error)")
            }
            
        }
        // 取消下载
//        retriveTask?.cancel()
    }
}

// MARK: - 一、使用 Kingfisher.
extension KingfisherViewController
{
    // MARK:1.0.101. 加载图片
    @objc func test101()
    {
        let imageView = UIImageView.init()
        imageView.center = view.center;
        imageView.bounds = CGRect(x: 0, y: 0, width: screenW() * 0.75, height: screenH() * 0.75)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.kf.setImage(with: URL(string: String.fl.getRandomImageUrlStr()!))
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapClick(_:)))
        imageView.addGestureRecognizer(tapGesture)
        view.addSubview(imageView)
    }
    
    @objc func tapClick(_ gesture: UITapGestureRecognizer)
    {
        gesture.view?.removeFromSuperview()
    }
    
    @objc func btnClick(_ btn: UIButton)
    {
        btn.removeFromSuperview()
    }
    
    // MARK:1.0.102. 设置占位图和加载完成回调
    @objc func test102()
    {
        let imageView = UIImageView.init()
        imageView.center = view.center;
        imageView.bounds = CGRect(x: 0, y: 0, width: screenW() * 0.75, height: screenH() * 0.75)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.kf.setImage(with: URL(string: String.fl.getRandomImageUrlStr()!), placeholder: UIImage(named: "placeholder.jpg"), options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                // 图片加载成功
                FLPrint("Image loaded successfully: \(value.image)")
            case .failure(let error):
                // 图片加载失败
                FLPrint("Failed to load image: \(error.localizedDescription)")
            }
        }
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapClick(_:)))
        imageView.addGestureRecognizer(tapGesture)
        view.addSubview(imageView)
    }
    
    // MARK:1.0.103. 图片加载ImageDownloader使用
    @objc func test103()
    {
        self.downLoadImg()
    }
    
    // MARK:1.0.104. 按钮设置网络图片
    @objc func test104()
    {
        let btn = UIButton.init(type: .custom)
        btn.center = view.center;
        btn.bounds = CGRect(x: 0, y: 0, width: screenW() * 0.75, height: screenH() * 0.75)
        btn.kf.setImage(with: URL(string: String.fl.getRandomImageUrlStr()!), for: .normal)
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageView?.clipsToBounds = true 
        view.addSubview(btn)
    }
    
    // MARK:1.0.105. 设置动态图片
    @objc func test105()
    {
        let imageView = UIImageView.init()
        imageView.center = view.center;
        imageView.bounds = CGRect(x: 0, y: 0, width: screenW() * 0.75, height: screenH() * 0.75)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.kf.setImage(with: URL(string: String.fl.getDynamicRandomImageUrlStr()!))
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapClick(_:)))
        imageView.addGestureRecognizer(tapGesture)
        view.addSubview(imageView)
    }
}

// MARK: - 二、清理缓存
extension KingfisherViewController
{
    // MARK:2.0.201. 清理内存缓存
    @objc func test201()
    {
        ImageCache.default.clearMemoryCache()
    }
    
    // MARK:2.0.202. 清理磁盘缓存，完成后执行闭包
    @objc func test202()
    {
        ImageCache.default.clearDiskCache {
            
        }
    }
    
    // MARK:2.0.203. 获取当前缓存
    @objc func test203()
    {
        ImageCache.default.calculateDiskStorageSize { (result) in
            switch result {
            case .success(let value):
                let size = Double(value / 1024 / 1024)
                FLPrint("当前缓存大小为\(String(format: "%.1fM", size))")
            case .failure(let error):
                debugPrint(error.localizedDescription)
                FLPrint("获取失败")
            }
        }
    }
}
