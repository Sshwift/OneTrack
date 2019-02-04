import UIKit

class TableViewCell: UITableViewCell {

    var step: Step? {
        didSet {
            guard let date = step?.date, let aerobic = step?.aerobic, let run = step?.run, let walk = step?.walk  else { return }
            dateLabel.text = convertDate(date: date)
            aerobicNumbers.text = "\(aerobic)"
            runNumbers.text = "\(run)"
            walkNumbers.text = "\(walk)"
            let totalStep = walk + aerobic + run
            let target = UserDefaults.standard.integer(forKey: "target")
            totalLabel.text = "\(totalStep) / \(target) steps"
            progressBar.walk = walk
            progressBar.aerobic = aerobic
            progressBar.run = run

            // Check when Goal reached
            if totalStep >= target && targetStackView.isHidden == true{
                self.btnConstraint?.isActive = false
                self.btnTargetConstraint?.isActive = true

                UIView.transition(with: self.contentView, duration: 0.5, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
                    self.targetStackView.isHidden = false
                }, completion: { (_) in
                    // animate image
                    self.targetImage.center.x -= 110
                    self.targetImage.center.y -= 110
                    self.targetImage.transform = CGAffineTransform(scaleX: 3, y: 3)
                    
                    UIView.animateKeyframes(withDuration: 1, delay: 0.0, animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                            self.targetImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                            self.targetImage.center.x += 110
                            self.targetImage.center.y += 110
                            self.targetImage.alpha = 1
                        })
                    }, completion: nil )
                    
                } )
                
            } else if totalStep < target  {
                self.btnConstraint?.isActive = true
                self.btnTargetConstraint?.isActive = false

                self.targetStackView.isHidden = true
                self.targetImage.alpha = 0
                
            }
            
        }
    }
    
    private func convertDate(date: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(date / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
    
    private let totalLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    
    private let aerobicView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let aerobicLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "aerobic"
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.textColor = UIColor(hex: "6b6b6b")
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let aerobicNumbers: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let runView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let runLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "run"
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.textColor = UIColor(hex: "6b6b6b")
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let runNumbers: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let walkView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let walkLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "walk"
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.textColor = UIColor(hex: "6b6b6b")
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let walkNumbers: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    private var progressBar: ModifyProgress = {
        let bar = ModifyProgress()
        return bar
    }()
    
    private let topStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        return stack
    }()
    
    private let botStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    private let targetLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "eaeaea")
        return view
    }()
    
    private let targetStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.isHidden = true
        return stack
    }()
    
    private let targetLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Goal reached"
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.textColor = UIColor(hex: "378599")
        return lbl
    }()
    
    private let targetImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "star"))
        imageView.alpha = 0
        return imageView
    }()
    
    private var btnTargetConstraint: NSLayoutConstraint?
    private var btnConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor(hex: "f9f9f9")

        // Add top border in cell
        let border = CALayer()
        border.frame = CGRect(x: 0, y: 0, width: frame.width, height: 2)
        border.backgroundColor = UIColor(hex: "eaeaea").cgColor
        contentView.layer.addSublayer(border)
        
        
        walkView.addSubview(walkNumbers)
        walkView.addSubview(walkLabel)
        walkNumbers.anchor(top: walkView.topAnchor, left: walkView.leftAnchor, bottom: nil, right: walkView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        walkLabel.anchor(top: walkNumbers.bottomAnchor, left: walkView.leftAnchor, bottom: walkView.bottomAnchor, right: walkView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        runView.addSubview(runNumbers)
        runView.addSubview(runLabel)
        runNumbers.anchor(top: runView.topAnchor, left: runView.leftAnchor, bottom: nil, right: runView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        runLabel.anchor(top: runNumbers.bottomAnchor, left: runView.leftAnchor, bottom: runView.bottomAnchor, right: runView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        aerobicView.addSubview(aerobicNumbers)
        aerobicView.addSubview(aerobicLabel)
        aerobicNumbers.anchor(top: aerobicView.topAnchor, left: aerobicView.leftAnchor, bottom: nil, right: aerobicView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        aerobicLabel.anchor(top: aerobicNumbers.bottomAnchor, left: aerobicView.leftAnchor, bottom: aerobicView.bottomAnchor, right: aerobicView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        topStackView.addArrangedSubview(dateLabel)
        topStackView.addArrangedSubview(totalLabel)
        contentView.addSubview(topStackView)
        
        contentView.addSubview(progressBar)
        
        botStackView.addArrangedSubview(walkView)
        botStackView.addArrangedSubview(aerobicView)
        botStackView.addArrangedSubview(runView)
        contentView.addSubview(botStackView)
        
        targetStackView.addArrangedSubview(targetLabel)
        targetStackView.addArrangedSubview(targetImage)
        contentView.addSubview(targetLine)
        contentView.addSubview(targetStackView)
        
        topStackView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        progressBar.anchor(top: topStackView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 5)
        botStackView.anchor(top: progressBar.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        btnConstraint = botStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        targetLine.anchor(top: botStackView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 2)
        targetStackView.anchor(top: targetLine.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        btnTargetConstraint = targetStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
