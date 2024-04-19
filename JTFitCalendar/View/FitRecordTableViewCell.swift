//
//  FitTableViewCell.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import SnapKit
import Then
import UIKit

class FitRecordTableViewCell: UITableViewCell {
	
	private let activityImageView: UIImageView = UIImageView().then {
		$0.contentMode = .scaleAspectFill
		$0.layer.cornerRadius = 4
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
	
	private let containerView: UIView = UIView().then{
		$0.layer.cornerRadius = 8
		$0.clipsToBounds = true
	}
	
	private let maxActivityImageViewWidthHeight: CGFloat = 64
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	
	private func commonInit() {
		setupViews()
	}
	
	private func setupViews() {
		self.selectionStyle = .none
		contentView.addSubview(containerView)
		containerView.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(8)
		}
		contentView.backgroundColor = UIColor.jtBackgroundColor
		
		let verticalStackView = UIStackView()
		verticalStackView.axis = .vertical
		verticalStackView.spacing = 8
		
		containerView.addSubview(verticalStackView)
		verticalStackView.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(8)
		}
		
		activityImageView.snp.makeConstraints { make in
			make.width.height.equalTo(maxActivityImageViewWidthHeight)
		}
		
		let verticalTextsStackView = UIStackView()
		verticalTextsStackView.axis = .vertical
		verticalTextsStackView.spacing = 8
		
		let activityTimeStackView = UIStackView(arrangedSubviews: [activityTimeLabel, activityTimeDisplayLabel])
		activityTimeStackView.spacing = 12
		activityTimeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		verticalTextsStackView.addArrangedSubview(activityTimeStackView)
		
		let distanceStackView = UIStackView(arrangedSubviews: [distanceLabel, distanceDisplayLabel])
		distanceStackView.spacing = 12
		distanceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		distanceDisplayLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		distanceStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		let calorieStackView = UIStackView(arrangedSubviews: [calorieLabel, calorieDisplayLabel])
		calorieStackView.spacing = 12
		calorieLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		let horizontalDistanceCalorieStackView = UIStackView(arrangedSubviews: [distanceStackView, calorieStackView])
		horizontalDistanceCalorieStackView.spacing = 16
		
		verticalTextsStackView.addArrangedSubview(horizontalDistanceCalorieStackView)
		verticalTextsStackView.addArrangedSubview(exerciseResultDisplayLabel)
		
		let horizontalImageTextsStackView = UIStackView(arrangedSubviews: [activityImageView, verticalTextsStackView])
		horizontalImageTextsStackView.spacing = 8
		verticalStackView.addArrangedSubview(horizontalImageTextsStackView)
	}
	
	func configure(with fitnessLogEntity: FitnessLogEntity) {
		if fitnessLogEntity.image == nil {
			activityImageView.image = UIImage(named: "running")
			activityImageView.contentMode = .center
		} else {
			activityImageView.image = fitnessLogEntity.image
			activityImageView.contentMode = .scaleAspectFill
		}
		if fitnessLogEntity.result?.isEmpty == false {
			exerciseResultDisplayLabel.text = "메모: \(fitnessLogEntity.result ?? "없음")"
		} else {
			exerciseResultDisplayLabel.text = "메모: 없음"
		}
		activityTimeDisplayLabel.text = fitnessLogEntity.activityTimeText?.isEmpty == true ? "없음" : fitnessLogEntity.activityTimeText
		distanceDisplayLabel.text = fitnessLogEntity.exerciseDistance == 0.0 ? "없음" : "\(fitnessLogEntity.exerciseDistance) km"
		calorieDisplayLabel.text = fitnessLogEntity.consumedCalorie == 0.0 ? "없음" : "\(fitnessLogEntity.consumedCalorie) kcal"
	}
}
