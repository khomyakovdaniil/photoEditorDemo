//
//  Constants.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 17.04.2024.
//

import Foundation
import UIKit

struct Constants {
    struct ButtonTitles {
        // Most of the buttons are configured in Storyboard
        static let photoGallery = "Photo Gallery"
        static let camera = "Camera"
        static let cancel = "Cancel"
    }
    
    struct Alerts {
        static let error = "Error"
        static let ok = "OK"
        static let verificationEmailSent = "Verification link sent. Please verify your e-mail and sign in again"
        static let wrongPasswordTitle = "Password Incorrect"
        static let wrongPasswordMessage = "Please re-type password"
        static let verificationSentOnSignUp = "Verification link sent. Please verify your e-mail to be able to sign in"
        static let passwordRecoverySent = "Password recovery email sent"
    }
    
    struct Tools { // Add values to expand the app's possibilities
        static let fonts = ["Helvetica Bold", "Impact", "Papyrus", "Futura", "Kefa", "Menlo"]
        static let colors: [UIColor] = [.red, .green, .white, .blue, .yellow, .black]
        static let filters = ["None", "CISepiaTone", "CIPixellate", "CIGaussianBlur", "CIComicEffect", "CIEdgeWork"]
    }
}
