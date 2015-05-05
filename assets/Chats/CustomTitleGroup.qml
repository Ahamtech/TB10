import bb.cascades 1.3

TitleBar {
    property alias username: userNameLabel.text
    property alias status: userStatusLabel.text
    property alias avatar: userAvatar.imageSource
    kind: TitleBarKind.FreeForm
    kindProperties: FreeFormTitleBarKindProperties {
        
        Container {
            maxHeight: ui.px(100)
            layout: StackLayout {
                orientation: LayoutOrientation.RightToLeft
            
            }
            Container {
                id: contactImage
                layoutProperties: StackLayoutProperties {
                    spaceQuota: -1
                }
                ImageView {
                    maxHeight: 100
                    id: userAvatar
                    imageSource: "asset:///images/thumbnails/Placeholders/group_placeholder_green.png"
                    
                    gestureHandlers: TapHandler {
                        onTapped: {
                            chatviewnav.push(groupprofile.createObject())
                        }
                    }
                    scalingMethod: ScalingMethod.AspectFit
                }
            }
            Container {
                gestureHandlers: TapHandler {
                    onTapped: {
                        chatviewnav.push(groupprofile.createObject())
                    }
                }
                id: nameStatus
                topPadding: 0
                topMargin: 0
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                leftPadding: ui.du(3)
                Container {
                    Container {
                        Label {
                            id: userNameLabel
                            text: ""
                            textStyle.fontSize: FontSize.Medium
                        }
                    
                    }
                    Container {
                        Label {
                            id: userStatusLabel
                            text: ""
                            textStyle.fontStyle: FontStyle.Italic
                        
                        }
                    }
                
                }
            }
        
        }
    }
}