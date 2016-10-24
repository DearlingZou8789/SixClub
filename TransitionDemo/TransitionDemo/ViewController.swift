//
//  ViewController.swift
//  TransitionDemo
//
//  Created by zmj27404 on 23/10/2016.
//  Copyright © 2016 zmj27404. All rights reserved.
//

import UIKit
import CoreGraphics

let useCache = true;
let RowHeight:CGFloat = 30.0;
class ViewController: UIViewController {
    var colorLayer = CALayer.init();
    var tbView : UITableView!
    let systemVersion = Float(UIDevice.current.systemVersion);
    let cache = NSCache<AnyObject, AnyObject>.init();
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        tbView = UITableView.init(frame: self.view.bounds, style: .plain);
        tbView.delegate = self;
        tbView.dataSource = self;
        tbView.rowHeight = RowHeight;
        tbView.separatorEffect = UIVibrancyEffect.init(blurEffect: UIBlurEffect.init(style: .extraLight));
        tbView.separatorStyle = .singleLine;
        tbView.separatorColor = UIColor.init(colorLiteralRed: 33.0/255.0, green: 125.0/255.0, blue: 231.0/255.0, alpha: 1.0);
        self.view.addSubview(tbView);
        tbView.reloadData();
        refreshTableView();
    }
    
    func addTransitionLayer() {
        self.colorLayer.frame = CGRect.init(x: 50.0, y: 50.0, width: 100.0, height: 100.0);
        /// 过度动画，模式为push，从左往右，CATransition
        let transition = CATransition.init();
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromLeft;
        self.colorLayer.actions = ["backgroundColor" : transition];
        self.view.layer .addSublayer(self.colorLayer);
        self.colorLayer.backgroundColor = UIColor.red.cgColor;
        self.colorLayer.contentsCenter = CGRect.init(x: 0.5, y: 0.5, width: 0, height: 0);
        self.colorLayer.contentsScale = UIScreen.main.scale;
        
        
        //        CATransaction 提交一组动画效果，隐式动画，可以没有动画，只有变化。
        //        CAAnimation   显示动画，有动画效果
        
        let btn = UIButton.init(type: .custom);
        btn.addTarget(self, action: #selector(self.changeColor(btn:)), for: .touchUpInside);
        btn.frame = CGRect.init(x: 50.0, y: 160.0, width: 60.0, height: 40.0);
        btn.setTitle("修改颜色", for: .normal);
        btn.setTitleColor(UIColor.black, for: .normal);
        self.view.addSubview(btn);
    }
    
    func changeColor(btn: UIButton) {
        self.colorLayer.backgroundColor = UIColor.init(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255)  / 255.0, alpha: 1.0).cgColor;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100000;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !useCache {
            return defaultCellForIndex(indexPath: indexPath, tableView: tableView);
        }
        return cacheCellForIndex(indexPath: indexPath, tableView: tableView);
    }
    
    func defaultCellForIndex(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell");
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "tableViewCell");
            cell?.imageView?.layer.masksToBounds = true;
            cell?.imageView?.layer.cornerRadius = RowHeight / 2;
            cell?.imageView?.backgroundColor = UIColor.white;
            cell?.backgroundColor = UIColor.white;
        }
        
        let cacheIndex = indexPath.row % 20;
        let nameString = "siberian\(cacheIndex)";
        let image = UIImage.init(named: nameString);
        cell?.imageView?.image = image;
        return cell!;
    }

    func cacheCellForIndex(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell");
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "tableViewCell");
            cell?.imageView?.backgroundColor = UIColor.white;
            cell?.backgroundColor = UIColor.white;
        }
        return cell!;
    }
    
    /// 从缓存中获取图片。
    func getImage(indexPath: IndexPath, forCell cell: UITableViewCell) {
        let cacheIndex = indexPath.row % 20;
        let nameString = "siberian\(cacheIndex)";
        let image = UIImage.init(named: nameString);
        cell.imageView?.image = image;
        let cacheImage = cache.object(forKey: String(cacheIndex) as AnyObject);
        if let lastCacheImage = cacheImage {
            cell.imageView?.image = lastCacheImage as? UIImage;
        }
        else {
            //  绘制圆角图片，没有离屏渲染，但是有图层混合。
            DispatchQueue.global(qos: .background).async(execute: {
                let rect = CGRect.init(x: 0, y: 0, width: RowHeight, height: RowHeight);
                UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale);
                let path = UIBezierPath.init(roundedRect: rect, cornerRadius: rect.height / 2.0);
                path.addClip();
                image?.draw(in: rect);
                let lastImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                self.cache.setObject(_ :lastImage!, forKey: String(cacheIndex) as AnyObject, cost:Int((lastImage?.size.width)!) * Int((lastImage?.size.height)!) * Int(UIScreen.main.scale));
                DispatchQueue.main.async(execute: {
                    cell.imageView?.image = lastImage;
                });
            });
        }
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            //  在这里设置占位图片
//        refreshTableView();
        print(#function);
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print(#function);
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(#function);
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print(#function);
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        refreshTableView();
        print(#function);
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshTableView();
        print(#function);
    }
    
    func refreshTableView() {
        let arr:[IndexPath]? = self.tbView.indexPathsForVisibleRows;
        if let visibleIndexArr = arr {
            visibleIndexArr.forEach({ (indexPath) in
                let cell = self.tbView.cellForRow(at: indexPath);
                getImage(indexPath: indexPath, forCell: cell!);
            });
        }
    }
}

