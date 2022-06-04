//
//  UIViewController+Extensions.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation
import UIKit

extension UIViewController {

    func fadeBetween(inView: UIView, outView: UIView, completion: (() -> Void)? = nil) -> UIViewPropertyAnimator {
        fadeBetween(inViews: [inView], outViews: [outView], completion: completion)
    }

    func fadeBetween(inViews: [UIView], outViews: [UIView], completion: (() -> Void)? = nil) -> UIViewPropertyAnimator {

        inViews.forEach {
            $0.alpha = 0
            $0.isHidden = false
        }

        let animation = UIViewPropertyAnimator(duration: Constants.animationDuration, curve: .easeInOut)
        animation.addAnimations {
            inViews.forEach {
                $0.alpha = 1
            }
            outViews.forEach {
                $0.alpha = 0
            }
        }
        animation.addCompletion { _ in
            outViews.forEach {
                $0.isHidden = true
                $0.alpha = 1
            }
            completion?()
        }
        animation.startAnimation()

        return animation
    }
}
