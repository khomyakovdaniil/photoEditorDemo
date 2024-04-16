//
//  ViewController.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 15.04.2024.
//

import UIKit
import PencilKit

class MainViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    
    var state: EditorState! {
        didSet {
            setupToolsView()
        }
    }
    
    let canvasView = PKCanvasView()
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var statePickerSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var toolsView: UIView!
    
    @IBAction func didTapAddImage(_ sender: Any) {
        addImage()
    }
    @IBAction func didTapShareImage(_ sender: Any) {
        shareImage()
    }
    
    @IBAction func didSelectTool(_ sender: UISegmentedControl) {
        state = EditorState(rawValue: sender.selectedSegmentIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        state = EditorState(rawValue: statePickerSegmentedControl.selectedSegmentIndex)
    }
    
    override func viewDidLayoutSubviews() {
        canvasView.becomeFirstResponder()
    }
    
    // MARK: - Private Functions
    
    private func setupToolsView() {
        switch state {
        case .crop:
            print("changed state to crop")
            let rotateToolView = RotateToolView.instanceFromNib()
            rotateToolView.delegate = self
            if !toolsView.subviews.isEmpty {
                toolsView.subviews[0].removeFromSuperview()
            }
            toolsView.addSubview(rotateToolView)
        case .filter:
            print("changed state to filter")
            let filterToolView = FilterToolView.instanceFromNib()
            filterToolView.delegate = self
            if !toolsView.subviews.isEmpty {
                toolsView.subviews[0].removeFromSuperview()
            }
            toolsView.addSubview(filterToolView)
        case .draw:
            print("changed state to draw")
            canvasView.backgroundColor = .clear
            //            canvasView.isOpaque = false
            canvasView.frame = imageView.bounds
            canvasView.drawingPolicy = .anyInput
            canvasView.delegate = self
            baseView.addSubview(canvasView)
            canvasView.becomeFirstResponder()
            if let window = view.window, let toolPicker = PKToolPicker.shared(for: window) {
                // As soon as user start integrating with the CanvasView, toolPicker will be visible
                toolPicker.setVisible(true, forFirstResponder: canvasView)
                toolPicker.addObserver(canvasView)
            }
            
        case .text:
            print("changed state to text")
            let textToolView = TextToolView.instanceFromNib()
            textToolView.delegate = self
            if !toolsView.subviews.isEmpty {
                toolsView.subviews[0].removeFromSuperview()
            }
            toolsView.addSubview(textToolView)
            let textView = UITextView()
            textView.frame = CGRect(x: 30, y: 30, width: 100, height: 100)
            textView.backgroundColor = UIColor.red
            textView.keyboardDismissMode = .interactive
            baseView.addSubview(textView)
        default:
            return
        }
        
    }
    
    private func addImage() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (button) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (button) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func shareImage() {
        let image = baseView.snapshotImage()
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imageView.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
}

extension MainViewController: RotationToolDelegate {
    func didRotate(to degrees: Float) {
        let image = imageView.image
        let newImage = image?.rotate(radians: .pi / (180/CGFloat(degrees)))
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = newImage
        }
    }
}

extension MainViewController: FilterToolDelegate {
    func didChangeFilter(to filter: CIFilter) {
        guard let image = imageView.image else {
            return
        }
        // Convert UIImage to CIImage
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        // Set the input image for the filter
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        // Apply the filter
        guard let outputCIImage = filter.outputImage else {
            return
        }
        
        // Convert CIImage to UIImage
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return
        }
        
        let filteredImage = UIImage(cgImage: cgImage)
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = filteredImage
        }
    }
}

extension MainViewController: TextToolDelegate {
    func didApply(text: String) {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 120)!

        let scale = UIScreen.main.scale
        let image = imageView.image!
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let point = CGPointZero
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = newImage
        }
    }
}

extension MainViewController: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print("drawing")
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        canvasView.resignFirstResponder()
    }
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        print("Completed the UI Event")
    }
}

enum EditorState: Int {
    case crop
    case filter
    case draw
    case text
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}

extension UIView {
    var asImg: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultingImage!
    }
}

