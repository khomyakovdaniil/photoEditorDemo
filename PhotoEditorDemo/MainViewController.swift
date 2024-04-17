//
//  ViewController.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 15.04.2024.
//

import UIKit
import PencilKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    var state: EditorState! {
        didSet {
            setupToolsView()
        }
    }
    
    enum EditorState: Int {
        case crop
        case filter
        case draw
        case text
    }
    
    let canvasView = PKCanvasView()
    let imagePicker = UIImagePickerController()
    
    // MARK: - Outlets
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var statePickerSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var toolsView: UIView!
    
    // MARK: - Actions
    
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
        canvasView.backgroundColor = .clear
        canvasView.frame = imageView.bounds
        canvasView.drawingPolicy = .anyInput
        canvasView.isUserInteractionEnabled = false
        baseView.addSubview(canvasView)
    }
    
    // MARK: - Private Functions (basic)
    
    private func setupToolsView() {
        switch state {
        case .crop:
            print("changed state to crop")
            clearToolViewIfNeeded()
            prepareCropTools()
        case .filter:
            print("changed state to filter")
            clearToolViewIfNeeded()
            prepareFilterTools()
        case .draw:
            print("changed state to draw")
            clearToolViewIfNeeded()
            prepareDrawTools()
        case .text:
            print("changed state to text")
            clearToolViewIfNeeded()
            prepareTextTools()
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
    
    private func clearToolViewIfNeeded() {
        if !toolsView.subviews.isEmpty {
            toolsView.subviews[0].removeFromSuperview()
        }
        if let window = view.window, let toolPicker = PKToolPicker.shared(for: window), toolPicker.isVisible {
            toolPicker.setVisible(false, forFirstResponder: canvasView)
            canvasView.resignFirstResponder()
            canvasView.isUserInteractionEnabled = false
        }
    }
}

    // MARK: - Image Picker functions

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        if !baseView.subviews.isEmpty {
            for subview in baseView.subviews {
                if subview as? UITextView != nil {
                    subview.removeFromSuperview()
                }
                if let canvas = subview as? PKCanvasView {
                    canvas.drawing = PKDrawing()
                }
            }
        }
        imageView.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
}

    // MARK: - Crop functions

extension MainViewController: RotationToolDelegate {
    func prepareCropTools() {
        let rotateToolView = RotateToolView.instanceFromNib()
        rotateToolView.delegate = self
        toolsView.addSubview(rotateToolView)
    }
    
    func didRotate(to degrees: Float) {
        let image = imageView.image
        let newImage = image?.rotate(radians: .pi / (180/CGFloat(degrees)))
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = newImage
        }
    }
}

    // MARK: - Filter functions

extension MainViewController: FilterToolDelegate {
    
    func prepareFilterTools() {
        let filterToolView = FilterToolView.instanceFromNib()
        filterToolView.delegate = self
        toolsView.addSubview(filterToolView)
    }
    
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

    // MARK: - Text functions

extension MainViewController: TextToolDelegate, UITextViewDelegate {
    
    func prepareTextTools() {
        let textToolView = TextToolView.instanceFromNib()
        toolsView.addSubview(textToolView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        baseView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tapLocation = gestureRecognizer.location(in: gestureRecognizer.view)
        let view = gestureRecognizer.view!
        let textToolView = toolsView.subviews.filter( {($0 as? TextToolView) != nil })[0] as! TextToolView
        
        let textView = UITextView(frame: CGRect(x: tapLocation.x, y: tapLocation.y, width: 200, height: 100))
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont(name: textToolView.font, size: 25)
        textView.textColor = textToolView.color
        textView.text = "Tap to edit"
        textView.isScrollEnabled = false
        textView.delegate = self
        let newSize = textView.sizeThatFits(CGSize(width: baseView.frame.width - tapLocation.x, height: .infinity))
        textView.frame.size = newSize
        
        view.addSubview(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize(width: baseView.frame.width - textView.frame.minX, height: .infinity))
        textView.frame.size = newSize
    }
    
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

    // MARK: - Draw functions

extension MainViewController: PKCanvasViewDelegate {
    func prepareDrawTools() {
        canvasView.isUserInteractionEnabled = true
        canvasView.becomeFirstResponder()
        if let window = view.window, let toolPicker = PKToolPicker.shared(for: window) {
            // As soon as user start integrating with the CanvasView, toolPicker will be visible
            canvasView.resignFirstResponder()
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            canvasView.becomeFirstResponder()
        }
    }
}
