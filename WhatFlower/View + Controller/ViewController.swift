//
//  ViewController.swift
//  WhatFlower
//
//  Created by Ekaterina Khudzhamkulova on 27.10.2020.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate { //maybe add UINavigationControllDelegate
	let baseURL = "https://en.wikipedia.org/w/api.php?"
	let image = UIImage(systemName: "camera")
	let imagePicker = UIImagePickerController()
	let imageView = UIImageView()
	lazy var extract = String()
	var textField = UITextField()

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cameraTapped))

		imagePicker.delegate = self
		setupImagePicker()
		setupUIImageView()
		//TODO: - setupTextField
	}

	func setupUIImageView() {
		view.addSubview(imageView)
		imageView.backgroundColor = .blue
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
		imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true

	}

	func setupImagePicker() {
		imagePicker.sourceType = .photoLibrary
		imagePicker.allowsEditing = true
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
		imageView.image = userPickedImage

			guard let ciimage = CIImage(image: userPickedImage) else {fatalError("Couldn't convert to CIImage.")}

			detect(image: ciimage)
		}

		imagePicker.dismiss(animated: true, completion: nil)
	}

	func detect(image: CIImage) {
		guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {fatalError("Loading CoreML model failed.")}

		let request = VNCoreMLRequest(model: model) { (request, error) in
			guard let results = request.results as? [VNClassificationObservation] else {fatalError("Model failed to proccess image")}
			if let firstResult = results.first?.identifier {
				self.navigationItem.title = firstResult.capitalized

				let flowerName = firstResult.capitalized
			}
		}
		let handler = VNImageRequestHandler(ciImage: image)
		do {
			try handler.perform([request])
		} catch {
			print(error)
		}
	}

	@objc func cameraTapped() {
		present(imagePicker, animated: true, completion: nil)

	}


}
///https://en.wikipedia.org/w/api.php?action=query&titles=Barberton%20daisy&prop=info&formatversion=2&format=json&redirects&prop=extracts

