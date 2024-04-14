//
//  FitTableViewCell.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import SnapKit
import Then
import UIKit

class FitRecordCollectionViewCell: UICollectionViewCell {
	
	private let activityImageView: UIImageView = UIImageView().then {
		$0.contentMode = .scaleAspectFill
		$0.layer.cornerRadius = 4
		$0.clipsToBounds = true
	}
	private let activityTimeLabel: UILabel = UILabel().then {
		$0.text = "활동 시간"
		$0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
	}
	private let activityTimeDisplayLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14)
	}
	
	private let exerciseResultDisplayLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14)
	}
	
	private let distanceLabel: UILabel = UILabel().then {
		$0.text = "주행 거리"
		$0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
	}
	private let distanceDisplayLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14)
	}
	private let calorieLabel: UILabel = UILabel().then {
		$0.text = "칼로리"
		$0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
	}
	private let calorieDisplayLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14)
	}
	private let dateLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14)
	}
	
	private let maxActivityImageViewHeight: CGFloat = 200
	
	var exerciseResultDisplayLabelZeroHeightConstraint: Constraint?
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	private func commonInit() {
		setupViews()
	}
	
	private func setupViews() {
		contentView.layer.cornerRadius = 8
		contentView.clipsToBounds = true
		contentView.backgroundColor = UIColor.jtGray
		
		contentView.addSubview(activityImageView)
		let activityImageViewHeight: CGFloat = activityImageView.image != nil ? maxActivityImageViewHeight : 0
		activityImageView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(12)
			make.leading.trailing.equalToSuperview().inset(24)
			make.height.equalTo(activityImageViewHeight)
		}
		
		contentView.addSubview(exerciseResultDisplayLabel)
		exerciseResultDisplayLabel.snp.makeConstraints { make in
			make.top.equalTo(activityImageView.snp.bottom).offset(12)
			make.leading.trailing.equalTo(activityImageView)
			exerciseResultDisplayLabelZeroHeightConstraint = make.height.equalTo(0).constraint
		}
		exerciseResultDisplayLabelZeroHeightConstraint?.isActive = false
		
		contentView.addSubview(activityTimeLabel)
		activityTimeLabel.snp.makeConstraints { make in
			make.top.equalTo(exerciseResultDisplayLabel.snp.bottom).offset(12)
			make.leading.equalTo(activityImageView)
		}
		activityTimeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		contentView.addSubview(activityTimeDisplayLabel)
		activityTimeDisplayLabel.snp.makeConstraints { make in
			make.top.equalTo(activityTimeLabel)
			make.leading.equalTo(activityTimeLabel.snp.trailing).offset(24)
			make.trailing.equalTo(activityImageView)
		}
		
		contentView.addSubview(distanceLabel)
		distanceLabel.snp.makeConstraints { make in
			make.top.equalTo(activityTimeLabel.snp.bottom).offset(12)
			make.leading.equalTo(activityTimeLabel)
		}
		distanceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		contentView.addSubview(distanceDisplayLabel)
		distanceDisplayLabel.snp.makeConstraints { make in
			make.top.equalTo(distanceLabel)
			make.leading.equalTo(activityTimeDisplayLabel)
			make.trailing.equalTo(activityTimeDisplayLabel)
		}
		
		contentView.addSubview(calorieLabel)
		calorieLabel.snp.makeConstraints { make in
			make.top.equalTo(distanceLabel.snp.bottom).offset(12)
			make.leading.equalTo(distanceLabel)
		}
		calorieLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		contentView.addSubview(calorieDisplayLabel)
		calorieDisplayLabel.snp.makeConstraints { make in
			make.top.equalTo(calorieLabel)
			make.leading.equalTo(distanceDisplayLabel)
			make.trailing.equalTo(distanceDisplayLabel)
		}
		
		contentView.addSubview(dateLabel)
		dateLabel.snp.makeConstraints { make in
			make.top.equalTo(calorieLabel.snp.bottom).offset(16)
			make.leading.trailing.equalTo(activityImageView)
			make.bottom.equalToSuperview().offset(-12)
		}
	}
	
	func configure(with fitnessLogEntity: FitnessLogEntity) {
		if fitnessLogEntity.image == nil {
			activityImageView.image = nil
			activityImageView.snp.updateConstraints { make in
				make.height.equalTo(0)
			}
		} else {
			activityImageView.image = fitnessLogEntity.image
			activityImageView.snp.updateConstraints { make in
				make.height.equalTo(maxActivityImageViewHeight)
			}
		}
		if fitnessLogEntity.result?.isEmpty == false {
			exerciseResultDisplayLabel.text = fitnessLogEntity.result
			exerciseResultDisplayLabelZeroHeightConstraint?.isActive = false
		} else {
			exerciseResultDisplayLabel.text = nil
			exerciseResultDisplayLabelZeroHeightConstraint?.isActive = true
		}
		activityTimeDisplayLabel.text = fitnessLogEntity.activityTimeText?.isEmpty == true ? "없음" : fitnessLogEntity.activityTimeText
		distanceDisplayLabel.text = fitnessLogEntity.exerciseDistance == 0.0 ? "없음" : "\(fitnessLogEntity.exerciseDistance) km"
		calorieDisplayLabel.text = fitnessLogEntity.consumedCalorie == 0.0 ? "없음" : "\(fitnessLogEntity.consumedCalorie) kcal"
		dateLabel.text = fitnessLogEntity.date?.formatted()
	}
}
