//
//  drwline.swift
//  CircularDesigns
//
//  Created by Kiranbabu Rajanala  on 10/28/16.
//  Copyright © 2016 Kiranbabu Rajanala. All rights reserved.
//

import Foundation
import UIKit
class drawLine: UIView
{
    var comittedSegments: Int = 0
    var points = [CGPoint]()
    var committedPath = UIBezierPath()
    
    var drawPath = UIBezierPath()
    var incrementalImage: UIImage?
    
    var strokeColor:UIColor?
    
    override func draw(_ rect: CGRect) {
        autoreleasepool {
            incrementalImage?.draw(in: rect)
            strokeColor = SelectedColor
            strokeColor?.setStroke()
            drawPath.lineWidth = 10
            drawPath.lineJoinStyle = .round
            drawPath.lineCapStyle = CGLineCap.round
            drawPath.stroke()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        comittedSegments = 0
        committedPath.removeAllPoints()
        points.removeAll()
            let location = (touch as! UITouch).location(in: self)
             points.append(location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        let point = touch!.location(in:self)
        
        points.append( point )
        if points.count == 5
        {
            points[3] = CGPoint(x:(points[2].x + points[4].x)/2.0, y:(points[2].y + points[4].y)/2.0)
            
            committedPath.move(to: points[0])
            committedPath.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
            comittedSegments = comittedSegments + 1
            
            self.setNeedsDisplay()
            
            points[0] = points[3]
            points[1] = points[4]
            
            points.removeSubrange(2...4)
            
            drawPath = committedPath
        }
        else if points.count > 1
        {
            
            drawPath = committedPath.copy() as! UIBezierPath
            
          drawPath.cgPath = committedPath.cgPath
            
            drawPath.move( to: points[0] )
            for point in points[1..<points.count] {
                drawPath.addLine(to: point)
            }
            
            self.setNeedsDisplay()
        }
}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.drawBitmap()
        self.setNeedsDisplay()
        
        committedPath.removeAllPoints()
        points.removeAll()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        self.touchesEnded(touches!, with: event)
    }
    
    func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        strokeColor?.setStroke()
        if(incrementalImage == nil) {
            let rectPath:UIBezierPath = UIBezierPath(rect: self.bounds)
            UIColor.white.setFill()
            rectPath.fill()
        }
        
        incrementalImage?.draw(at: CGPoint.zero)
        committedPath.stroke()
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
