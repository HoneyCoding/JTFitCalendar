//
//  FitTableViewCell.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import SnapKit
import Then
import UIKit

class FitRecordCollectionViewCell: UITableViewCell {
	
	private let activityImageView: UIImageView = UIImageView().then {
		$0.contentMode = .scaleAspectFill
		$0.layer.cornerRadius = 4
		$0.backgroundColor = UIColor.systemGray3
		$0.tintColor = UIColor.white
		$0.clipsToBounds = true
	}
	private let activityTimeLabel: UILabel = UILabel().then {
		$0.text = "활동 시간"
		$0.font = UIFont.systemFont(ofSize: 12)
	}
	private let activityTimeDisplayLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
	}
	
	private let exerciseResultDisplayLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14)
	}
	
	private let distanceLabel: UILabel = UILabel().then {
		$0.text = "주행 거리"
		$0.font = UIFont.systemFont(ofSize: 12)
	}
	private let distanceDisplayLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
	}
	private let calorieLabel: UILabel = UILabel().then {
		$0.text = "칼로리"
		$0.font = UIFont.systemFont(ofSize: 12)
	}
	private let calorieDisplayLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
	}
	private let dateLabel: UILabel = UILabel().then {
		$0.font = UIFont.systemFont(ofSize: 14)
	}
	
	private let containerView: UIView = UIView().then{
		$0.layer.cornerRadius = 8
		$0.clipsToBounds = true
		$0.backgroundColor = UIColor.jtGray
	}
	
	private let maxActivityImageViewWidthHeight: CGFloat = 64
	
	var exerciseResultDisplayLabelZeroHeightConstraint: Constraint?
	
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
		
		let verticalStackView = UIStackView()
		verticalStackView.axis = .vertical
		verticalStackView.spacing = 8
		
		containerView.addSubview(verticalStackView)
		verticalStackView.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(8)
		}
		
		verticalStackView.addArrangedSubview(exerciseResultDisplayLabel)
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
		verticalTextsStackView.addArrangedSubview(distanceStackView)
		
		let calorieStackView = UIStackView(arrangedSubviews: [calorieLabel, calorieDisplayLabel])
		calorieStackView.spacing = 12
		calorieLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		verticalTextsStackView.addArrangedSubview(calorieStackView)
		
		let horizontalImageTextsStackView = UIStackView(arrangedSubviews: [activityImageView, verticalTextsStackView])
		horizontalImageTextsStackView.spacing = 8
		verticalStackView.addArrangedSubview(horizontalImageTextsStackView)
		
		verticalStackView.addArrangedSubview(dateLabel)
	}
	
	func configure(with fitnessLogEntity: FitnessLogEntity) {
		if fitnessLogEntity.image == nil {
			activityImageView.image = nil
			activityImageView.isHidden = true
		} else {
			activityImageView.image = fitnessLogEntity.image
			activityImageView.isHidden = false
		}
		if fitnessLogEntity.result?.isEmpty == false {
			exerciseResultDisplayLabel.text = fitnessLogEntity.result
			exerciseResultDisplayLabel.isHidden = false
		} else {
			exerciseResultDisplayLabel.text = nil
			exerciseResultDisplayLabel.isHidden = true
		}
		activityTimeDisplayLabel.text = fitnessLogEntity.activityTimeText?.isEmpty == true ? "없음" : fitnessLogEntity.activityTimeText
		distanceDisplayLabel.text = fitnessLogEntity.exerciseDistance == 0.0 ? "없음" : "\(fitnessLogEntity.exerciseDistance) km"
		calorieDisplayLabel.text = fitnessLogEntity.consumedCalorie == 0.0 ? "없음" : "\(fitnessLogEntity.consumedCalorie) kcal"
		dateLabel.text = fitnessLogEntity.date?.formatted(date: .numeric, time: .omitted)
		dateLabel.isHidden = true
	}
}
