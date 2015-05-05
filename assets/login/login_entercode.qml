import bb.cascades 1.3
import bb.system 1.2
import bb.device 1.4

Page {
    property int singin
    property alias phone: phonetab.text
    titleBar: TitleBar {
        title: qsTr("Enter Your Code") + Retranslate.onLanguageChanged
    }
    function showquittoast(){
        settingsDilog.show()
        
    }
    onCreationCompleted: {
        app.showerror.connect(codeinvalide)
        app.quitapp.connect(showquittoast)
        loginSmsCode.requestFocus()
    }
    Container {
        leftPadding: 50.0
        rightPadding: 50.0
        topPadding: 50.0
        
        Label { //add the phone number at last of the label
            id: tab
            text: qsTr("We've sent an SMS with an activation code to ") + Retranslate.onLanguageChanged
            multiline: true
            autoSize.maxLineCount: 3
            textStyle.textAlign: TextAlign.Center
            leftMargin: 50.0
            rightMargin: 500.0
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
        }
        Label { //add the phone number at last of the label
            id: phonetab
            multiline: true
            autoSize.maxLineCount: 3
            textStyle.textAlign: TextAlign.Center
            leftMargin: 50.0
            rightMargin: 500.0
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
        }
        TextField {
            id: loginSmsCode
            hintText: qsTr("Code") + Retranslate.onLanguageChanged
            focusHighlightEnabled: false
            maximumLength: 5
            textStyle.textAlign: TextAlign.Center
            topMargin: 50.0
            preferredWidth: ui.du(40)
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            input.keyLayout: KeyLayout.Number
            textFormat: TextFormat.Auto
            inputMode: TextFieldInputMode.PhoneNumber

        }
        Button {
            id: loginCodeNext
            text: qsTr("Hurray") + Retranslate.onLanguageChanged
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            topMargin: 50.0
            preferredWidth: ui.du(25)
            onClicked: {
                        app.authUser(loginSmsCode.text);
                 }
        }
    }
    attachedObjects: [
        SystemToast {
            id: codeinvalide
            body: "Invalid Code"
        },
        VibrationController {
            id: vibrate
        },
        SystemDialog {
            id: settingsDilog
            body: qsTr("Your Settings has been saved .Please open the app again..") + Retranslate.onLanguageChanged
            includeRememberMe: false
            rememberMeChecked: false
            customButton.enabled: false
            cancelButton.enabled: false
            confirmButton.enabled: true
            onFinished: {
                Application.quit()
            }
        }
    ]
    function errorcode(code) {
        codeinvalide.body = code
        codeinvalide.show()
    }
}
