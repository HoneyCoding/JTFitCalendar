//
//  AddFitItemViewController.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import PhotosUI
import SnapKit
import Then
import UIKit

class AddFitRecordViewController: UIViewController {
	
	// MARK: - View Properties
	private let fitImageLabel: UILabel = UILabel().then {
		$0.text = "운동 사진"
		$0.font = UIFont.systemFont(ofSize: 14)
		$0.textColor = UIColor.secondaryLabel
	}
	
	private let fitImageView: UIImageView = UIImageView().then {
		$0.contentMode = .scaleAspectFill
		$0.backgroundColor = UIColor.jtGray
		$0.layer.cornerRadius = 8
		$0.clipsToBounds = true
	}
	
	private let addPhotoLabel: UILabel = UILabel().then {
		$0.text = "사진 추가하기"
		$0.textColor = UIColor.secondaryLabel
		$0.font = UIFont.systemFont(ofSize: 14)
	}
	
	private let activityTimeLabel: UILabel = UILabel().then {
		$0.text = "활동 시간"
		$0.font = UIFont.systemFont(ofSize: 14)
		$0.textColor = UIColor.secondaryLabel
	}
	
	private lazy var activityTimeTextField: UITextField = UITextField().then {
		$0.tintColor = UIColor.clear
		$0.placeholder = "활동 시간을 선택해주세요"
		$0.font = UIFont.systemFont(ofSize: 14)
		$0.layer.cornerRadius = 8
		$0.clipsToBounds = true
		$0.inputView = activityTimePickerView
		$0.inputAccessoryView = activityTimeToolBar
		$0.backgroundColor = UIColor.jtGray
		
		// Left Padding
		$0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1))
		$0.leftViewMode = .always
	}
	
	private lazy var activityTimePickerView: UIPickerView = UIPickerView().then {
		$0.delegate = self
		$0.dataSource = self
	}
	
	private lazy var activityTimeToolBar: UIToolbar = UIToolbar().then {
		let doneButton = UIBarButtonItem(
			barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped)
		)
		$0.setItems(
			[
				UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
				doneButton
			],
			animated: false
		)
		$0.sizeToFit()
	}
	
	private let activityDistanceLabel: UILabel = UILabel().then {
		$0.text = "주행 거리"
		$0.font = UIFont.systemFont(ofSize: 14)
		$0.textColor = UIColor.secondaryLabel
	}
	
	private lazy var activityDistanceTextField: UITextField = UITextField().then {
		$0.placeholder = "0"
		$0.font = UIFont.systemFont(ofSize: 14)
		$0.layer.cornerRadius = 8
		$0.clipsToBounds = true
		$0.backgroundColor = UIColor.jtGray
		$0.keyboardType = .decimalPad
		
		// Left Padding
		$0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1))
		$0.leftViewMode = .always
		
		let rightLabel = UILabel().then {
			$0.text = "km"
			$0.font = UIFont.systemFont(ofSize: 14)
			$0.textColor = UIColor.secondaryLabel
			$0.textAlignment = .left
		}
		rightLabel.snp.makeConstraints { make in
			make.width.equalTo(32)
		}
		$0.rightView = rightLabel
		$0.rightViewMode = .always
	}
	
	private let consumedCalorieLabel: UILabel = UILabel().then {
		$0.text = "소비 칼로리"
		$0.font = UIFont.systemFont(ofSize: 14)
		$0.textColor = UIColor.secondaryLabel
	}
	
	private lazy var consumedCalorieTextField: UITextField = UITextField().then {
		$0.placeholder = "0"
		$0.font = UIFont.systemFont(ofSize: 14)
		$0.layer.cornerRadius = 8
		$0.clipsToBounds = true
		$0.backgroundColor = UIColor.jtGray
		$0.keyboardType = .decimalPad
		
		// Left Padding
		$0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1))
		$0.leftViewMode = .always
		
		let rightLabel = UILabel().then {
			$0.text = "kcal"
			$0.font = UIFont.systemFont(ofSize: 14)
			$0.textColor = UIColor.secondaryLabel
			$0.textAlignment = .left
		}
		rightLabel.snp.makeConstraints { make in
			make.width.equalTo(40)
		}
		$0.rightView = rightLabel
		$0.rightViewMode = .always
	}
	
	private let activityResultLabel: UILabel = UILabel().then {
		$0.text = "운동 결과"
		$0.font = UIFont.systemFont(ofSize: 14)
		$0.textColor = UIColor.secondaryLabel
	}
	
	private lazy var activityResultTextView: UITextView = UITextView().then {
		$0.font = UIFont.systemFont(ofSize: 14)
		$0.textColor = UIColor.secondaryLabel
		$0.text = activityResultTextViewPlaceholder
		$0.layer.cornerRadius = 8
		$0.clipsToBounds = true
		$0.backgroundColor = UIColor.jtGray
		$0.delegate = self
	}
	
	private let fitRecordScrollView: UIScrollView = UIScrollView()
	private let fitRecordScrollContentView: UIView = UIView()
	
	// MARK: - Properties
	var hour: Int = 0
	var minutes: Int = 0
	var seconds: Int = 0
	let activityResultTextViewPlaceholder: String = "운동 결과를 입력해보세요"
	
	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = false
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.isNavigationBarHidden = true
	}
	
	// MARK: - SetupViews
	private func setupViews() {
		view.backgroundColor = UIColor.systemBackground
		
		let closeKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
		view.addGestureRecognizer(closeKeyboardGestureRecognizer)
		
		let fitImageViewTapGestureRecognizer = UITapGestureRecognizer(
			target: self, action: #selector(fitImageViewTapped)
		)
		fitImageView.addGestureRecognizer(fitImageViewTapGestureRecognizer)
		fitImageView.isUserInteractionEnabled = true
		
		setupFitRecordScrollView()
		setupFitRecordScrollContentView()
		setupNavigationBar()
	}
	
	private func setupFitRecordScrollView() {
		view.addSubview(fitRecordScrollView)
		fitRecordScrollView.snp.makeConstraints { make in
			make.edges.equalTo(view)
		}
		fitRecordScrollView.addSubview(fitRecordScrollContentView)
		fitRecordScrollContentView.snp.makeConstraints { make in
			make.edges.equalTo(fitRecordScrollView.contentLayoutGuide)
			make.width.equalTo(fitRecordScrollView.frameLayoutGuide)
			make.height.greaterThanOrEqualTo(view).priority(.low)
		}
	}
	
	private func setupFitRecordScrollContentView() {
		// activityImageLabel 설정
		fitRecordScrollContentView.addSubview(fitImageLabel)
		fitImageLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(16)
			make.horizontalEdges.equalToSuperview().inset(12)
		}
		
		// activityImageView 설정
		fitRecordScrollContentView.addSubview(fitImageView)
		fitImageView.snp.makeConstraints { make in
			make.horizontalEdges.equalTo(fitImageLabel)
			make.top.equalTo(fitImageLabel.snp.bottom).offset(8)
			make.height.equalTo(200)
		}
		
		// activityAddPhotoLabel 설정
		fitImageView.addSubview(addPhotoLabel)
		addPhotoLabel.isHidden = (fitImageView.image != nil)
		addPhotoLabel.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
		
		// activityTimeLabel 설정
		fitRecordScrollContentView.addSubview(activityTimeLabel)
		activityTimeLabel.snp.makeConstraints { make in
			make.top.equalTo(fitImageView.snp.bottom).offset(12)
			make.horizontalEdges.equalTo(fitImageView)
		}
		
		fitRecordScrollContentView.addSubview(activityTimeTextField)
		activityTimeTextField.snp.makeConstraints { make in
			make.top.equalTo(activityTimeLabel.snp.bottom).offset(8)
			make.horizontalEdges.equalTo(activityTimeLabel)
			make.height.greaterThanOrEqualTo(40)
		}
		
		fitRecordScrollContentView.addSubview(activityDistanceLabel)
		activityDistanceLabel.snp.makeConstraints { make in
			make.top.equalTo(activityTimeTextField.snp.bottom).offset(12)
			make.horizontalEdges.equalTo(activityTimeLabel)
		}
		
		fitRecordScrollContentView.addSubview(activityDistanceTextField)
		activityDistanceTextField.snp.makeConstraints { make in
			make.top.equalTo(activityDistanceLabel.snp.bottom).offset(8)
			make.horizontalEdges.equalTo(activityDistanceLabel)
			make.height.greaterThanOrEqualTo(40)
		}
		
		fitRecordScrollContentView.addSubview(consumedCalorieLabel)
		consumedCalorieLabel.snp.makeConstraints { make in
			make.top.equalTo(activityDistanceTextField.snp.bottom).offset(12)
			make.horizontalEdges.equalTo(activityDistanceLabel)
		}
		
		fitRecordScrollView.addSubview(consumedCalorieTextField)
		consumedCalorieTextField.snp.makeConstraints { make in
			make.top.equalTo(consumedCalorieLabel.snp.bottom).offset(8)
			make.horizontalEdges.equalTo(consumedCalorieLabel)
			make.height.greaterThanOrEqualTo(40)
		}
		
		fitRecordScrollContentView.addSubview(activityResultLabel)
		activityResultLabel.snp.makeConstraints { make in
			make.top.equalTo(consumedCalorieTextField.snp.bottom).offset(12)
			make.horizontalEdges.equalTo(consumedCalorieTextField)
		}
		
		fitRecordScrollContentView.addSubview(activityResultTextView)
		activityResultTextView.snp.makeConstraints { make in
			make.top.equalTo(activityResultLabel.snp.bottom).offset(8)
			make.horizontalEdges.equalTo(activityResultLabel)
			make.height.equalTo(160)
			make.bottom.equalToSuperview().inset(16)
		}
	}
	
	private func setupNavigationBar() {
		let saveButton = UIBarButtonItem(
			barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped)
		)
		navigationItem.rightBarButtonItem = saveButton
	}
	
	// MARK: - Touch Action
	@objc func doneButtonTapped(_ sender: UIBarButtonItem) {
		if activityTimeTextField.isFirstResponder {
			activityTimeTextField.resignFirstResponder()
		}
	}
	
	@objc func saveButtonTapped(_ sender: UIBarButtonItem) {
		print("Save Button Tapped")
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func fitImageViewTapped(_ sender: UITapGestureRecognizer) {
		var configuration = PHPickerConfiguration()
		configuration.filter = .images
		configuration.selectionLimit = 1
		let pickerViewController = PHPickerViewController(configuration: configuration)
		pickerViewController.delegate = self
		self.present(pickerViewController, animated: true)
	}
	
	@objc func closeKeyboard(_ sender: UITapGestureRecognizer) {
		view.endEditing(true)
	}
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddFitRecordViewController: UIPickerViewDelegate, UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 3
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch component {
		case 0:
			return 24
		case 1, 2:
			return 60
		default:
			return 0
		}
	}

	func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		return pickerView.frame.size.width / 3
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		switch component {
		case 0:
			return "\(row) 시간"
		case 1:
			return "\(row) 분"
		case 2:
			return "\(row) 초"
		default:
			return ""
		}
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		switch component {
		case 0:
			hour = row
		case 1:
			minutes = row
		case 2:
			seconds = row
		default:
			break
		}
		
		var activityTimeText = ""
		
		if hour != 0 {
			activityTimeText += "\(hour)시간 "
		}
		if minutes != 0 {
			activityTimeText += "\(minutes)분 "
		}
		if seconds != 0 {
			activityTimeText += "\(seconds)초 "
		}
		
		activityTimeTextField.text = activityTimeText.trimmingCharacters(in: .whitespacesAndNewlines)
	}
}

// MARK: - UITextViewDelegate
// UITextView에 placeholder를 추가하기 위해 작성한 코드이다.
extension AddFitRecordViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		guard textView.textColor == UIColor.secondaryLabel else { return }
		textView.textColor = UIColor.label
		textView.text = nil
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			textView.text = activityResultTextViewPlaceholder
			textView.textColor = UIColor.secondaryLabel
		}
	}
}

// MARK: - PHPickerViewControllerDelegate
extension AddFitRecordViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)
		
		guard let itemProvider = results.first?.itemProvider else { return }
		guard itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
		itemProvider.loadObject(ofClass: UIImage.self) { image, error in
			if let error {
				DispatchQueue.main.async {
					self.showAlert(message: "이미지를 선택하는 도중 에러가 발생했습니다. \(error.localizedDescription)")
				}
				return
			}
			DispatchQueue.main.async { [weak self] in
				guard let self else { return }
				guard let selectedImage = image as? UIImage else { return }
				self.fitImageView.image = selectedImage
				self.addPhotoLabel.isHidden = true
			}
		}
	}
}
