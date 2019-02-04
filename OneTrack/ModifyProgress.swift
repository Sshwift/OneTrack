import UIKit

class ModifyProgress: UIView {
   
    var walk = 1
    var aerobic = 1
    var run = 1
    
    private let runProgress: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "338398")
        return view
    }()
    
    private let walkProgress: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "b0e3f2")
        return view
    }()
    
    private let aerobicProgress: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "51c7e5")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
        let width = self.frame.width
        
        let total = walk + aerobic + run
        
        var walkWidth = Int(width) * walk / total - 2
        walkWidth = walkWidth == 0 ? 1 : walkWidth // check that view does not disappear due to its small size
        var aerobicWidth = Int(width) * aerobic / total - 4
        aerobicWidth = aerobicWidth <= 2 ? 3 : aerobicWidth
        
        walkProgress.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: CGFloat(walkWidth), height: 0)
        aerobicProgress.anchor(top: self.topAnchor, left: self.walkProgress.rightAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: CGFloat(aerobicWidth), height: 0)
        runProgress.anchor(top: self.topAnchor, left: self.aerobicProgress.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func commonInit() {
        clipsToBounds = true
        addSubview(walkProgress)
        addSubview(aerobicProgress)
        addSubview(runProgress)
    }

}
