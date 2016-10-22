//
//  ViewController.swift
//  SixClub
//
//  Created by zmj27404 on 22/10/2016.
//  Copyright © 2016 zmj27404. All rights reserved.
//

import UIKit
import GLKit

class ViewController: UIViewController {
    var faces:[UIView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let width : CGFloat = 100.0;
        self.view.backgroundColor = UIColor.brownColor();
        
        let containerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: width));
        containerView.backgroundColor = UIColor.clearColor();
        self.view.addSubview(containerView);
        containerView.center = self.view.center;
        
        var perspective = CATransform3DIdentity;
        //  透视度
        perspective.m34 = -1.0/500.0;
        //
        perspective = CATransform3DRotate(perspective, CGFloat(-M_PI_4), 1, 0, 0);
        perspective = CATransform3DRotate(perspective, CGFloat(-M_PI_4), 0, 1, 0);
        containerView.layer.sublayerTransform = perspective;
        
        for _ in 1...6 {
            let view = UIView.init(frame: containerView.bounds);
            view.backgroundColor = UIColor.whiteColor();
            containerView.addSubview(view);
            
            faces.append(view);
        }
        
        let offset = width / 2.0;
        // 1. club face 1, Top
        var transform = CATransform3DMakeTranslation(0, 0, offset);
        addFace(0, transform: transform);
        
        // 2. Club face 2 , right x---(width)-->x1, agree y---M_PI_2--->y1
        transform = CATransform3DMakeTranslation(offset, 0, 0);
        transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 0, 1, 0);
        addFace(1, transform: transform);
        
        // 3. Club face 3, Top y---(-width)---y1, agree z---M_PI_2-->z1
        transform = CATransform3DMakeTranslation(0, -offset, 0);
        transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 1, 0, 0);
        addFace(2, transform: transform);
        
        // 4. Club face 4
        transform = CATransform3DMakeTranslation(0, offset, 0);
        transform = CATransform3DRotate(transform, CGFloat(-M_PI_2), 1, 0, 0);
        addFace(3, transform: transform);
        
        // 5. Club face 5
        transform = CATransform3DMakeTranslation(-offset, 0, 0);
        transform = CATransform3DRotate(transform, CGFloat(-M_PI_2), 0, 1, 0);
        addFace(4, transform: transform);
        
        // 6. Club face 6
        transform = CATransform3DMakeTranslation(0, 0, -offset);
        transform = CATransform3DRotate(transform, CGFloat(M_PI), 0, 1, 0);
        addFace(5, transform: transform);
    }
    
    func addFace(index:NSInteger, transform:CATransform3D) {
        let view = faces[index];
        
        let lab = UILabel.init(frame: view.bounds);
        lab.text = String(index + 1);
        lab.textAlignment = .Center;
        lab.textColor = UIColor.blackColor();
        lab.font = UIFont.systemFontOfSize(17.0);
        view.addSubview(lab);
        
        view.layer.doubleSided = false;
        view.layer.transform = transform;
        
        Matrix4Issue.applyLightingToFace(view.layer);
    }
    
    func applyLightingToFace(face: CALayer) {
        let layer = CALayer.init();
        layer.frame = face.bounds;
        face.addSublayer(layer);
        
        let transform = face.transform;
        // !!! 不知道swift中transform转GLKMatrix4
//        let matrix4 = GLKMatrix4(m: transform);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

