import bb.cascades 1.3

Page {titleBar: TitleBar {
        title: qsTr("Send Feedback") + Retranslate.onLanguageChanged

    }
    Container {
        topPadding: ui.du(5)
        leftPadding: ui.du(5)
        rightPadding: ui.du(5)
        TextArea {
            maximumLength: 2000
            hintText: qsTr("Send us  your problems") + Retranslate.onLanguageChanged
            scrollMode: TextAreaScrollMode.Elastic
            inputMode: TextAreaInputMode.Text
            textStyle.textAlign: TextAlign.Left
            autoSize.maxLineCount: 7
            opacity: 1.0
            visible: true
            text: ""
            input.keyLayout: KeyLayout.Text
            enabled: true


        }
        Container {
            topPadding: ui.du(5)
            horizontalAlignment: HorizontalAlignment.Center
            Button {
                text: qsTr("Send") + Retranslate.onLanguageChanged
                horizontalAlignment: HorizontalAlignment.Center
                appearance: ControlAppearance.Primary
            }
        }
    }
}
