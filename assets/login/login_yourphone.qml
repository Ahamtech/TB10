import bb.cascades 1.3
import bb.system 1.2
import bb.device 1.4
//import "asset:///js/CountryCodes.js" as Phcode

Page {

    function validatePhone(phone, reg) {
        vib(0.3)
        var cha = chat.createObject()
        cha.phone = "+"+loginCountryCode.text + loginPhoneNumber.text
        navigationPane.push(cha)
    }
    function invphone(text) {
        vib(0.3)
        if("PHONE_NUMBER_UNOCCUPIED"){
            
        }
        else{
            phoneinval.show()
        }
    }
    onCreationCompleted: {
 
        var dc = app.workingdc();
        app.changeServer(dc - 1);
        app.qmlgethashpane.connect(validatePhone);
        app.showerror.connect(showtoast)
        app.invalidphone.connect(invphone)
        app.movingdcinit.connect(dcChangeSend);
        loginCountryCode.requestFocus()
    }
    function dcChangeSend() {
        dcswitch.show()
//        app.authSendCode(loginCountryCode.text + loginPhoneNumber.text)
    }
    function onReadyView() {
        numberSection.visible = true;
        loader.visible = false;
    }
    function getCountryname(code)
    {
        var info =  Phcode.data.code
        return info.name
    }
    function getPhoneCode(code){
        
        var info =  Phcode.data[code]["code"]
        return info
    }
    titleBar: TitleBar {
        id: yourNumber
        title: qsTr("Your Number") + Retranslate.onLanguageChanged
        //add color to background
    }

    Container {
        leftPadding: 20.0
        rightPadding: 20.0
        topPadding: 50.0
        bottomPadding: 20.0
//        Container {
//            bottomPadding: 25
//            DropDown {
//                id: countrycodes
//                title: qsTr("Select Country") + Retranslate.onLanguageChanged
//                onSelectedOptionChanged: {
//                loginCountryCode.text = getPhoneCode(countrycodes.selectedValue)
//                }
//            
//            }
//        }
        Container {
            bottomPadding: 50.0
            horizontalAlignment: HorizontalAlignment.Left
            verticalAlignment: VerticalAlignment.Center
            leftPadding: ui.du(5)
            Label {
                text: "If you don't have Telegram account. Please SignUp with iOS/Android And then login here"
                multiline: true
                horizontalAlignment: HorizontalAlignment.Center
            }
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            
            TextArea {
                editable: false
                preferredWidth: ui.du(6)
                text: qsTr("+")
                maximumLength: 1
                horizontalAlignment: HorizontalAlignment.Right
                verticalAlignment: VerticalAlignment.Center

            }
            TextField {
                id: loginCountryCode
                inputMode: TextFieldInputMode.PhoneNumber
                hintText: qsTr("Code") + Retranslate.onLanguageChanged
                preferredWidth: ui.du(15)
                textStyle.textAlign: TextAlign.Right
                input.keyLayout: KeyLayout.Number
                maximumLength: 4

            }
            TextField {
                id: loginPhoneNumber
                text: qsTr("")
                hintText: qsTr("Enter Number") + Retranslate.onLanguageChanged
                input.keyLayout: KeyLayout.Number
                maximumLength: 15
                textFormat: TextFormat.Auto
                inputMode: TextFieldInputMode.PhoneNumber
                input.submitKey: SubmitKey.Next
            }
        }
        Label {
            text: qsTr("We will send you an SMS to your phone with activation code.") + Retranslate.onLanguageChanged
            multiline: true
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
        }
        Button {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            text: qsTr("Get SMS") + Retranslate.onLanguageChanged
            onClicked: {
                app.authSendCode(loginCountryCode.text + loginPhoneNumber.text)
            }
        }
    }

    attachedObjects: [
        ComponentDefinition {
            id: chat
            source: "login_entercode.qml"
        },
        SystemToast {
            id: phoneinval
            body: qsTr("Invalid Phone Number") + Retranslate.onLanguageChanged
        },
        SystemToast {
            id: dcswitch
            body: qsTr("Switching DataCenter Please try Again") + Retranslate.onLanguageChanged
        },
        VibrationController {
            id: vibrate
        },
        SystemToast {
            id: errorshow
        },
        ComponentDefinition {
            id: addoption
            Option {
                property string t_text
                property string v_value
                property string i_id
                text: t_text
                value: v_value
                id: i_id
            }
        }
    ]
    function showtoast(error) {
        errorshow.body = error
        errorshow.show()
    }

    function vib(intensity) {
        if (intensity) {
            vibrate.start(intensity, 300)

        } else {
            intensity = 1
            vibrate.start(intensity, 300)
        }
    }

}