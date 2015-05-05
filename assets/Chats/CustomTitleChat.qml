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
                    gestureHandlers: TapHandler {
                        onTapped: {
                            chatviewnav.push(chatprofile.createObject())
                        }
                    }
                    scalingMethod: ScalingMethod.AspectFit
                }
            }
            Container {
                gestureHandlers: TapHandler {
                    onTapped: {
                        chatviewnav.push(chatprofile.createObject())
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
                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom
                    }
                    Container {
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: + 1
                        }
                        Label {
                            id: userNameLabel
                            text: "Username"
                            textStyle.fontSize: FontSize.Large
                        }

                    }
                    Container {
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: -1
                        }
                        bottomPadding: 2
                        Label {
                            id: userStatusLabel
                            text: "loading"
                            textStyle.fontStyle: FontStyle.Italic

                        }
                    }

                }
            }

        }
    }
}