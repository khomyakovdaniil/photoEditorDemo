//
//  ViewController.swift
//  PhotoEditorDemo
//
//  Created by  Даниил Хомяков on 15.04.2024.
//

import UIKit
import PencilKit
import YandexMobileAds

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    var state: EditorState! { // Defines which editing functions are in use right now
        didSet {
            setupToolsView() // Sets the tools view accordingly
        }
    }
    
    enum EditorState: Int { // We got four editing states
        case crop
        case filter
        case draw
        case text
    }
    
    // Canvas view for drawing functions
    let canvasView = PKCanvasView()
    // ImagePicker to get images from gallery or camera
    let imagePicker = UIImagePickerController()
    // The unedited image
    var image = UIImage()
    
    
    // Demo ad view, just to show off cause Mark asked me to
    private lazy var adView: AdView = {
        let adSize = BannerAdSize.inlineSize(withWidth: 320, maxHeight: 100)

        let adView = AdView(adUnitID: "demo-banner-yandex", adSize: adSize)
        adView.delegate = self
        adView.translatesAutoresizingMaskIntoConstraints = false
        return adView
    }()
    
    // MARK: - Outlets
    
    // The view which stores all the editable layers
    @IBOutlet weak var baseView: UIView!
    // The view which stores the image itself
    @IBOutlet weak var imageView: UIImageView!
    // Picker to choose functions
    @IBOutlet weak var statePickerSegmentedControl: UISegmentedControl!
    // The view which stores editing tools, reconfigured after each state change
    @IBOutlet weak var toolsView: UIView!
    
    // MARK: - Actions
    
    // Top left button action, adds image for editing
    @IBAction func didTapAddImage(_ sender: Any) {
        addImage()
    }
    // Top right button action, used to save or share the result image
    @IBAction func didTapShareImage(_ sender: Any) {
        shareImage()
    }
    // State picker action, used to choose tools
    @IBAction func didSelectTool(_ sender: UISegmentedControl) {
        state = EditorState(rawValue: sender.selectedSegmentIndex)
    }
    
    // Basic configuration
    override func viewDidLoad() {
        super.viewDidLoad()
        // Image picker to get image
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // Editing state
        state = EditorState(rawValue: statePickerSegmentedControl.selectedSegmentIndex)
        
        // Canvas view configuration
        canvasView.backgroundColor = .clear
        canvasView.frame = imageView.bounds
        canvasView.drawingPolicy = .anyInput
        canvasView.isUserInteractionEnabled = false
        baseView.addSubview(canvasView)
        
        // Loading demo ad
        adView.loadAd()
    }
    
    // MARK: - Private Functions (basic)
    
    private func setupToolsView() { // Called on state change, sets up tools
        clearToolViewIfNeeded()
        switch state {
        case .crop:
            print("changed state to crop")
            prepareCropTools()
        case .filter:
            print("changed state to filter")
            prepareFilterTools()
        case .draw:
            print("changed state to draw")
            prepareDrawTools()
        case .text:
            print("changed state to text")
            prepareTextTools()
        default:
            return
        }
        
    }
    
    private func addImage() {
        // Create an aler to choose image source. Camera or gallery
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: Constants.ButtonTitles.photoGallery.localized(), style: .default, handler: { (button) in
            // Show image picker for gallery
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: Constants.ButtonTitles.camera.localized(), style: .default, handler: { (button) in
            // Show image picker for camera
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: Constants.ButtonTitles.cancel.localized(), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func shareImage() { // Sharing the result image
        // Getting the result by rendering all the layers in one UIImage
        let image = baseView.snapshotImage()
        // Presenting native share view controller for the result image
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func clearToolViewIfNeeded() {
        if !toolsView.subviews.isEmpty { // Removing previous tools
            toolsView.subviews[0].removeFromSuperview()
        }
        if let window = view.window, let toolPicker = PKToolPicker.shared(for: window), toolPicker.isVisible { // Removing drawing tools, different logic for PencilKit
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
        // Clearing all the previous progress
        if !baseView.subviews.isEmpty {
            for subview in baseView.subviews {
                if subview as? UITextView != nil {
                    // Removing all the added text
                    subview.removeFromSuperview()
                }
                if let canvas = subview as? PKCanvasView {
                    // Removing all the PencilKit drawings
                    canvas.drawing = PKDrawing()
                }
            }
        }
        
        // Setting picked image to proprtie and imageView
        image = pickedImage
        imageView.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
}

    // MARK: - Crop functions

extension MainViewController: RotationToolDelegate {
    func prepareCropTools() { // Setting the crop tools view
        let rotateToolView = RotateToolView.instanceFromNib()
        rotateToolView.delegate = self
        toolsView.addSubview(rotateToolView)
    }
    
    func didFlipHorizontal() { // Flipping the image view horizontally
        self.imageView.transform = self.imageView.transform.scaledBy(x: -1, y: 1)
    }
    
    func didFlipVertical() { // Flipping the image view vertically
        self.imageView.transform = self.imageView.transform.scaledBy(x: 1, y: -1)
    }
    
    func didRotate() { // Rotating the image view 90 degrees to the right
            self.imageView.transform = self.imageView.transform.rotated(by: .pi / 2)
    }
}

    // MARK: - Filter functions

extension MainViewController: FilterToolDelegate {
    
    func prepareFilterTools() { // Setting the filter tools view
        let filterToolView = FilterToolView.instanceFromNib()
        filterToolView.delegate = self
        toolsView.addSubview(filterToolView)
    }
    
    func didChangeFilter(to filter: CIFilter?) {
        // Convert UIImage to CIImage
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        guard let filter else { // If the user chooses "None" we return the unedited picture
            imageView.image = image
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
        
        // Show the filtered image
        self.imageView.image = filteredImage
    }
}

    // MARK: - Text functions

extension MainViewController: UITextViewDelegate {
    
    func prepareTextTools() { // Setting the filter tools view
        let textToolView = TextToolView.instanceFromNib()
        toolsView.addSubview(textToolView)
        
        // Adding gesture recognizer which will create textViews on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        baseView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        // Getting the tap location to place textView there
        let tapLocation = gestureRecognizer.location(in: gestureRecognizer.view)
        // Getting the view to add subviews
        let view = gestureRecognizer.view!
        // Getting the textToolView to get all the needed text properies, don't judge me
        let textToolView = toolsView.subviews.filter( {($0 as? TextToolView) != nil } )[0] as! TextToolView
        // Checking if the user already created a TextView
        let textViews = view.subviews.compactMap( { ($0 as? UITextView)?.isFirstResponder } )
        // If created TextView is in editing mode the tap should end it
        if textViews.contains(where: { $0 }) {
            view.subviews.forEach( {$0.endEditing(true)} )
        } else { // If none of the TextViews are being edited right now we create a new one
            // Creating a TextView in the place of user tap, size will be changed later
            let textView = UITextView(frame: CGRect(x: tapLocation.x, y: tapLocation.y, width: 1, height: 1))
            // No background
            textView.backgroundColor = UIColor.clear
            // Font accordding to user input in textToolView
            textView.font = UIFont(name: textToolView.font, size: textToolView.size)
            textView.textColor = textToolView.color
            
            // Adjust text view size to fit the text
            textView.isScrollEnabled = false
            textView.delegate = self
            let newSize = textView.sizeThatFits(CGSize(width: baseView.frame.width - tapLocation.x, height: .infinity))
            textView.frame.size = newSize
            
            // Add the TextView as a subview and start editing it
            view.addSubview(textView)
            textView.becomeFirstResponder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Adjust text view size to fit the text
        let newSize = textView.sizeThatFits(CGSize(width: baseView.frame.width - textView.frame.minX, height: .infinity))
        textView.frame.size = newSize
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // Making the TextView non interactable after the editing ends. You only get one shot, do not miss your chance to blow
        textView.isUserInteractionEnabled = false
    }
}

    // MARK: - Draw functions

extension MainViewController: PKCanvasViewDelegate {
    func prepareDrawTools() {
        // Making the canvas view interactable
        canvasView.isUserInteractionEnabled = true
        
        // Calling the PKToolPicker. God knows what is happening here with the firstResponder but it only works this way
        canvasView.becomeFirstResponder()
        if let window = view.window, let toolPicker = PKToolPicker.shared(for: window) {
            canvasView.resignFirstResponder()
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            canvasView.becomeFirstResponder()
        }
    }
}

    // MARK: - Demo ad

extension MainViewController: AdViewDelegate {
    func adViewDidLoad(_ adView: AdView) {
        // Showing the ad once it's loaded
        view.addSubview(adView)
        NSLayoutConstraint.activate([
            adView.bottomAnchor.constraint(equalTo: statePickerSegmentedControl.topAnchor, constant: -24),
            adView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func adViewDidFailLoading(_ adView: AdView, error: Error) {
        print("Failed to load ad, error: \(error.localizedDescription)")
    }
}
