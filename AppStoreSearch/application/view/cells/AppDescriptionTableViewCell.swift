//
//  AppDecscriptionTableViewCell.swift
//  AppStoreSearch
//
//  Created by Peter hornsby on 3/10/22.
//

import UIKit

class AppDescriptionTableViewCell: UITableViewCell {

    var developer: String {
        set { developerLabel.text = "Developer:    \(newValue)" }
        get { developerLabel.text ?? "" }
    }
    
    var appDescription: String {
        set {
        
            textView.text = newValue
            
        }
        get { textView.text ?? "" }
    }
    
    private let developerLabel = UILabel(frame: CGRect.zero)
    private let descriptionLabel = UILabel(frame: CGRect.zero)
    var textView = UITextView(frame: CGRect.zero, textContainer: nil)
    private var shouldApplyConstraints = true

    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Update
    func load(dataSource: AppEntity) {
        developer = dataSource.developer
        appDescription = dataSource.appDescription
    }
    
    
    
    // MARK: - Reuse
    override public func prepareForReuse() {
        super.prepareForReuse()
        developer = ""
        appDescription = ""
    }
    
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = UIColor.white
        clipsToBounds = true
        setupSubviews()
    }
    
    private func setupSubviews() {
        setupDeveloperLabel()
        setupDescriptionLabel()
        setupAppDescriptionView()

        setNeedsUpdateConstraints()
    }
    
    private func setupDeveloperLabel() {
        developerLabel.font = UIFont.boldSystemFont(ofSize: 19)
        developerLabel.backgroundColor = UIColor.clear
        developerLabel.clipsToBounds = true
        developerLabel.lineBreakMode = .byTruncatingTail
        developerLabel.numberOfLines = 2
        developerLabel.preferredMaxLayoutWidth = 240.0
        developerLabel.translatesAutoresizingMaskIntoConstraints = false
        developerLabel.adjustsFontSizeToFitWidth = true
        developerLabel.minimumScaleFactor = 0.7
        
        contentView.addSubview(developerLabel)
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 19)
        descriptionLabel.backgroundColor = UIColor.clear
        descriptionLabel.clipsToBounds = true
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.numberOfLines = 1
        descriptionLabel.preferredMaxLayoutWidth = 240.0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.7
        descriptionLabel.text = "Description:"
        
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupAppDescriptionView() {
        textView.isEditable = false
        textView.isSelectable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.clipsToBounds = true
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.white
        contentView.addSubview(textView)
        textView.text = "LOOK HERE!!"
    }
    

    
    
    
    // MARK: - Constraints
    override public func updateConstraints() {
        if shouldApplyConstraints {
            developerLabelContraints()
            descriptionLabelContraints()
            textViewContraints()
            shouldApplyConstraints = false
        }
        
        super.updateConstraints()
    }
    
    private func developerLabelContraints() {
        var constraints = [NSLayoutConstraint]()
        var constraint = NSLayoutConstraint(item: developerLabel,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: contentView,
                                            attribute: .top,
                                            multiplier: 1,
                                            constant: 8)
        
        constraints.append(constraint)
        constraint = NSLayoutConstraint(item: developerLabel,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: contentView,
                                            attribute: .leading,
                                            multiplier: 1,
                                            constant: 20)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: developerLabel,
                                        attribute: .trailing,
                                        relatedBy: .equal,
                                        toItem: contentView,
                                        attribute: .trailing,
                                        multiplier: 1,
                                        constant: -8)
        
        constraints.append(constraint)
        addConstraints(constraints)
    }
    
    private func descriptionLabelContraints() {
        var constraints = [NSLayoutConstraint]()
        
        var constraint = NSLayoutConstraint(item: descriptionLabel,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: developerLabel,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: 8)
        
        constraints.append(constraint)
        constraint = NSLayoutConstraint(item: descriptionLabel,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: contentView,
                                            attribute: .leading,
                                            multiplier: 1,
                                            constant: 20)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: descriptionLabel,
                                        attribute: .trailing,
                                        relatedBy: .equal,
                                        toItem: contentView,
                                        attribute: .trailing,
                                        multiplier: 1,
                                        constant: -8)
        
        constraints.append(constraint)
        addConstraints(constraints)
    }
    
    private func textViewContraints() {
        var constraints = [NSLayoutConstraint]()
        var constraint = NSLayoutConstraint(item: textView,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: contentView,
                                            attribute: .leading,
                                            multiplier: 1,
                                            constant: 20)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: textView,
                                        attribute: .width,
                                        relatedBy: .equal,
                                        toItem: contentView,
                                        attribute: .width,
                                        multiplier: 1,
                                        constant: -20)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: textView,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: descriptionLabel,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: 0)
        
        constraints.append(constraint)
        
        constraint = NSLayoutConstraint(item: textView,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: contentView,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: 0)
        
        constraints.append(constraint)
        
        
        addConstraints(constraints)
    }
    


}
