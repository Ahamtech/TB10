import bb.cascades 1.3

NavigationPane {
    id: navigationPane
    Page {
        onCreationCompleted: {
            app.onDcProviderReady.connect(keysgenerated)
        }
        function keysgenerated(){
            console.log("Keys generated")
            keys.enabled = true
            keys.text = "Start Messaging"
        }
        Container {
            
            layout: GridLayout {
                columnCount: 1

            }
            leftPadding: ui.du(2)
            rightPadding: ui.du(2)

            background: Color.Black
            Container {
                layout: GridLayout {
                    columnCount: 3
                }
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                topPadding: 50.0

                clipContentToBounds: true
                enabled: true
                Container {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    ImageView {
                        imageSource: "asset:///images/intro/rocket.png"
                        horizontalAlignment: HorizontalAlignment.Center
                        scalingMethod: ScalingMethod.AspectFill
                    }
                    Label {
                        text: qsTr("Fast") + Retranslate.onLanguageChanged
                        textStyle.fontStyle: FontStyle.Normal
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Top
                        textStyle.color: Color.White
                    }
                }
                Container {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    ImageView {
                        imageSource: "asset:///images/intro/bdays.png"
                        horizontalAlignment: HorizontalAlignment.Center
                        scalingMethod: ScalingMethod.AspectFit
                    }
                    Label {
                        text: qsTr("Free") + Retranslate.onLanguageChanged
                        textStyle.fontStyle: FontStyle.Normal
                        horizontalAlignment: HorizontalAlignment.Center
                        textStyle.color: Color.White
                    }
                }
                Container {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    ImageView {
                        imageSource: "asset:///images/intro/lock.png"
                        horizontalAlignment: HorizontalAlignment.Center
                        scalingMethod: ScalingMethod.AspectFit
                        loadEffect: ImageViewLoadEffect.None
                    }
                    Label {
                        text: qsTr("Secure") + Retranslate.onLanguageChanged
                        textStyle.fontStyle: FontStyle.Normal
                        horizontalAlignment: HorizontalAlignment.Center
                        textStyle.color: Color.White
                    }
                }
                Container {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    ImageView {
                        imageSource: "asset:///images/intro/purple.png"
                        horizontalAlignment: HorizontalAlignment.Center
                        scalingMethod: ScalingMethod.AspectFit
                    }
                    Label {
                        text: qsTr("Powerful") + Retranslate.onLanguageChanged
                        textStyle.fontStyle: FontStyle.Normal
                        horizontalAlignment: HorizontalAlignment.Center
                        textStyle.color: Color.White
                    }
                }
                Container {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    ImageView {
                        imageSource: "asset:///images/intro/cloud.png"
                        horizontalAlignment: HorizontalAlignment.Center
                        scalingMethod: ScalingMethod.AspectFit
                    }
                    Label {
                        text: qsTr("Cloud") + Retranslate.onLanguageChanged
                        textStyle.fontStyle: FontStyle.Normal
                        horizontalAlignment: HorizontalAlignment.Center
                        textStyle.color: Color.White
                    }
                }

                Container {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    ImageView {
                        imageSource: "asset:///images/intro/timer.png"
                        horizontalAlignment: HorizontalAlignment.Center
                        scalingMethod: ScalingMethod.AspectFit
                    }
                    Label {
                        text: qsTr("Private") + Retranslate.onLanguageChanged
                        textStyle.fontStyle: FontStyle.Normal
                        horizontalAlignment: HorizontalAlignment.Center
                        textStyle.color: Color.White

                    }
                }

            }
            Button {
                text: qsTr("Generating Keys Please wait") + Retranslate.onLanguageChanged
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                color: Color.White
                accessibilityMode: A11yMode.Default
                enabled: false
                id:keys
                onClicked: {
                    navigationPane.push(chat.createObject())
                }
            }
        }
    }
    attachedObjects: [
        ComponentDefinition {
            id: chat
            source: "../login/login_yourphone.qml"
        }
    ]
}