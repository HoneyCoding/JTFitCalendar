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

/// ComposeFitRecordViewController에 대한 Delegate이다.
protocol ComposeFitRecordViewControllerDelegate: AnyObject {
	
	/// ComposeFitRecordViewController에서 save button을 탭하면 실행되는 함수이다.
	func composeFitRecordViewController(
		_ viewController: ComposeFitRecordViewController, didTapSaveButton: UIBarButtonItem
	)
}


/// FitnessLog를 추가하는 화면에 대한 ViewController이다.
class ComposeFitRecordViewController: UIViewController {
	
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
	// Scroll View의 Content View이다.
	private let fitRecordScrollContentView: UIView = UIView()
	
	// 값이 nil이면 추가 모드, 값이 있으면 수정 모드이다.
	var fitnessLogEntity: FitnessLogEntity?
	weak var delegate: ComposeFitRecordViewControllerDelegate?
	
	// MARK: - Properties
	var hour: Int = 0
	var minutes: Int = 0
	var seconds: Int = 0
	let activityResultTextViewPlaceholder: String = "운동 결과를 입력해보세요"
	let date: Date
	
	// MARK: - Initializer
	init(date: Date) {
		self.date = date
		super.init(nibName: nil, bundle: nil)
	}
	
	// 해당 Initializer는 스토리보드에서 해당 클래스를 사용할 때 실행된다. Storyboard를 사용한 경우를 배제하였으므로 fatalError를 발생시켰다.
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		
		// fitnessLogEntity에 값이 있으면 각 View에 초기값을 설정해주는 코드이다.
		if let fitnessLogEntity {
			let exerciseDistanceText = fitnessLogEntity.exerciseDistance != 0.0 ? String(fitnessLogEntity.exerciseDistance) : nil
			let consumedCalorieText = fitnessLogEntity.consumedCalorie != 0.0 ? String(fitnessLogEntity.consumedCalorie) : nil
			if fitnessLogEntity.image != nil {
				fitImageView.image = fitnessLogEntity.image
				addPhotoLabel.isHidden = true
			}
			self.hour = Int(fitnessLogEntity.hour)
			self.minutes = Int(fitnessLogEntity.minutes)
			self.seconds = Int(fitnessLogEntity.seconds)
			activityTimeTextField.text = fitnessLogEntity.activityTimeText
			activityDistanceTextField.text = exerciseDistanceText
			consumedCalorieTextField.text = consumedCalorieText
			activityResultTextView.text = fitnessLogEntity.result
			activityResultTextView.textColor = UIColor.label
			
			activityTimePickerView.selectRow(hour, inComponent: 0, animated: false)
			activityTimePickerView.selectRow(minutes, inComponent: 1, animated: false)
			activityTimePickerView.selectRow(seconds, inComponent: 2, animated: false)
		}
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
		view.backgroundColor = UIColor.jtBackgroundColor
		
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
		
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy년 MM월 dd일"
		navigationItem.title = formatter.string(from: date)
	}
	
	// MARK: - Touch Action
	@objc func doneButtonTapped(_ sender: UIBarButtonItem) {
		if activityTimeTextField.isFirstResponder {
			activityTimeTextField.resignFirstResponder()
		}
	}
	
	@objc func saveButtonTapped(_ sender: UIBarButtonItem) {
		// 값을 Save 가능한 상태인지 검증하는 if문이다.
		if fitImageView.image == nil,
		   activityTimeTextField.text?.isEmpty == true,
		   activityDistanceTextField.text?.isEmpty == true,
		   consumedCalorieTextField.text?.isEmpty == true,
		   (
			activityResultTextView.text == activityResultTextViewPlaceholder
			|| activityResultTextView.text.isEmpty == true
		   ) {
			self.showAlert(message: "내용을 입력해주세요")
			return
		}
		
		let fitnessResult = (activityResultTextView.text == activityResultTextViewPlaceholder) ? nil : activityResultTextView.text
		
		// fitnessLogEntity의 존재 여부에 따라 (수정 모드, 추가 모드) 코드를 분기하였다.
		if let fitnessLogEntity {
			DatabaseManager.shared.updateFitnessLog(
				entity: fitnessLogEntity,
				date: date,
				imageData: fitImageView.image?.pngData(),
				activityTimeHour: hour,
				activityTimeMinutes: minutes,
				activityTimeSeconds: seconds,
				exerciseDistance: Double(activityDistanceTextField.text ?? "0.0"),
				consumedCalorie: Double(consumedCalorieTextField.text ?? "0.0"),
				fitnessResult: fitnessResult
			)
		} else {
			DatabaseManager.shared.insertFitnessLog(
				date: date,
				imageData: fitImageView.image?.pngData(),
				activityTimeHour: hour,
				activityTimeMinutes: minutes,
				activityTimeSeconds: seconds,
				exerciseDistance: Double(activityDistanceTextField.text ?? "0.0"),
				consumedCalorie: Double(consumedCalorieTextField.text ?? "0.0"),
				fitnessResult: fitnessResult
			)
		}
		// save Button이 눌렸을 때 delegate에서 composeFitRecordViewController(_, didTapSaveButton:)이 실행되도록 작성하였다.
		delegate?.composeFitRecordViewController(self, didTapSaveButton: sender)
		// save 버튼이 눌렸으므로 Navigation 화면이 pop 된다.
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
extension ComposeFitRecordViewController: UIPickerViewDelegate, UIPickerViewDataSource {

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
extension ComposeFitRecordViewController: UITextViewDelegate {
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
extension ComposeFitRecordViewController: PHPickerViewControllerDelegate {
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
