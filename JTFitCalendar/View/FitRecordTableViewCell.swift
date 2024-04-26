//
//  FitTableViewCell.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import SnapKit
import Then
import UIKit

// CalendarView, FitListViewController에서 사용되는 TableView의 Cell에 대한 클래스이다.
class FitRecordTableViewCell: UITableViewCell {
	
	// MARK: - View Properties
	private let activityImageView: UIImageView = UIImageView().then {
		$0.contentMode = .scaleAspectFill
		$0.layer.cornerRadius = 8
		$0.backgroundColor = UIColor.emptyImageBackgroundColor
		$0.tintColor = UIColor.white
		$0.clipsToBounds = true
	}
	private let activityTimeLabel: UILabel = UILabel().then {
		$0.text = "활동 시간"
		$0.font = UIFont.systemFont(ofSize: 14)
	}
	private let activityTimeDisplayLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
	}
	
	private let distanceLabel: UILabel = UILabel().then {
		$0.text = "주행 거리"
		$0.font = UIFont.systemFont(ofSize: 14)
	}
	private let distanceDisplayLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
	}
	private let calorieLabel: UILabel = UILabel().then {
		$0.text = "칼로리"
		$0.font = UIFont.systemFont(ofSize: 14)
	}
	private let calorieDisplayLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
	}
	private let exerciseResultDisplayLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14)
		$0.textColor = UIColor.resultTextColor
	}
	
	// View Properties가 담길 ContainerView이다.
	private let containerView: UIView = UIView().then{
		$0.layer.cornerRadius = 8
		$0.clipsToBounds = true
	}
	
	// MARK: - Properties
	private let maxActivityImageViewWidthHeight: CGFloat = 64
	
	// MARK: - Initializers
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	
	/// 서로 다른 Initializer에서 공통으로 실행되는 함수이다.
	private func commonInit() {
		setupViews()
	}
	
	/// View에 대한 Constraint를 설정하고 View의 배치 및 크기를 조절하는 함수이다.
	private func setupViews() {
		// selectionStyle이 none이 되도록 설정.
		self.selectionStyle = .none
		
		// ContainerView에 대한 설정
		contentView.addSubview(containerView)
		containerView.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(8)
		}
		contentView.backgroundColor = UIColor.jtBackgroundColor
		
		// activityImageView에 대한 설정
		activityImageView.snp.makeConstraints { make in
			make.width.height.equalTo(maxActivityImageViewWidthHeight)
		}
		
		// verticalTextsStackView 생성 및 설정
		let verticalTextsStackView = UIStackView()
		verticalTextsStackView.axis = .vertical
		verticalTextsStackView.spacing = 8
		
		// activityTimeStackView 생성 및 설정
		let activityTimeStackView = UIStackView(arrangedSubviews: [activityTimeLabel, activityTimeDisplayLabel])
		activityTimeStackView.spacing = 12
		activityTimeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		verticalTextsStackView.addArrangedSubview(activityTimeStackView)
		
		// distanceStackView 생성 및 설정
		let distanceStackView = UIStackView(arrangedSubviews: [distanceLabel, distanceDisplayLabel])
		distanceStackView.spacing = 12
		distanceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		distanceDisplayLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		distanceStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		// calorieStackView 생성 및 설정
		let calorieStackView = UIStackView(arrangedSubviews: [calorieLabel, calorieDisplayLabel])
		calorieStackView.spacing = 12
		calorieLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		// horizontalDistanceCalorieStackView 생성 및 설정
		let horizontalDistanceCalorieStackView = UIStackView(arrangedSubviews: [distanceStackView, calorieStackView])
		horizontalDistanceCalorieStackView.spacing = 16
		
		// verticalTextsStackView에 horizontalDistanceCalorieStackView, exerciseResultDisplayLabel 추가
		verticalTextsStackView.addArrangedSubview(horizontalDistanceCalorieStackView)
		verticalTextsStackView.addArrangedSubview(exerciseResultDisplayLabel)
		
		// horizontalImageTextsStackView 생성 및 activityImageView, verticalTextsStackView를 arrangedSubviews로 설정
		let horizontalImageTextsStackView = UIStackView(arrangedSubviews: [activityImageView, verticalTextsStackView])
		horizontalImageTextsStackView.spacing = 8
		
		// horizontalImageTextsStackView를 containerView에 추가
		containerView.addSubview(horizontalImageTextsStackView)
		horizontalImageTextsStackView.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(8)
		}
	}
	
	// MARK: - Functions
	func configure(with fitnessLogEntity: FitnessLogEntity) {
		// fitnessLogEntity에 image가 없을 경우
		if fitnessLogEntity.image == nil {
			// activityImageView 가운데에 running 이미지 출력
			activityImageView.image = UIImage(named: "running")
			activityImageView.contentMode = .center
		} else { // fitnessLogEntity에 이미지가 있을 경우
			// activityImageView에 entity에 저장된 이미지 출력
			activityImageView.image = fitnessLogEntity.image
			activityImageView.contentMode = .scaleAspectFill
		}
		
		if fitnessLogEntity.result?.isEmpty == false {
			exerciseResultDisplayLabel.text = "메모: \(fitnessLogEntity.result ?? "없음")"
		} else {
			exerciseResultDisplayLabel.text = "메모: 없음"
		}
		
		// entity에 저장된 activityTimeText가 비어 있으면 값이 없는 것으로 처리함.
		activityTimeDisplayLabel.text = fitnessLogEntity.activityTimeText?.isEmpty == true ? "없음" : fitnessLogEntity.activityTimeText
		// entity에 저장된 exerciseDistance가 0.0이면 값이 없는 것으로 처리함.
		distanceDisplayLabel.text = fitnessLogEntity.exerciseDistance == 0.0 ? "없음" : "\(fitnessLogEntity.exerciseDistance) km"
		// entity에 저장된 consumedCalorie가 0.0이면 값이 없는 것으로 처리함.
		calorieDisplayLabel.text = fitnessLogEntity.consumedCalorie == 0.0 ? "없음" : "\(fitnessLogEntity.consumedCalorie) kcal"
	}
}
