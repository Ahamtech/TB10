import bb.cascades 1.3
import bb.system 1.2
import bb.cascades.pickers 1.0
Page {
    titleBar: TitleBar {
        title: qsTr("My Info") + Retranslate.onLanguageChanged
    }
    onCreationCompleted: {

        app.accountUserInfo.connect(savedetails)
        app.fetchUserDetails()
    }
    function savedetails(first, last, ph, usrname, id) {
        fname = first
        lname = last
        phone = "+"+ph
        username = usrname
    }

    property alias fname: firstname.text
    property alias lname: lastname.text
    property alias phone: phonenumber.text
    property alias username: username.text
    property  alias avatar:userprofileimage.imageSource

    Container {
        ImageView {
            imageSource: "asset:///images/thumbnails/Placeholders/user_placeholder_blue.png"
            id: "userprofileimage"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            /*gestureHandlers: [
                TapHandler {
                    onTapped: {
                        filePicker.open()
                    }
                }
            ]
            attachedObjects: [
                FilePicker {
                    id: filePicker
                    type: FileType.Picture
                    title: qsTr("Select Picture") + Retranslate.onLanguageChanged
                    directories: [ "/accounts/1000/shared" ]
                    onFileSelected: {
                        console.log("FileSelected signal received : " + selectedFiles);
                        userprofileimage.imageSource = "file://" + selectedFiles[0];

                    }
                }
            ]*/

        }
        horizontalAlignment: HorizontalAlignment.Center

        topPadding: 40.0
        bottomMargin: 20.0
        Container {
            horizontalAlignment: HorizontalAlignment.Center
            topPadding: ui.du(5)
            Container {
                horizontalAlignment: HorizontalAlignment.Center
                preferredWidth: ui.du(60)
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                TextArea {

                    id: firstname
                    preferredWidth: ui.du(60)
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    text: qsTr("") + Retranslate.onLanguageChanged
                    hintText: qsTr("First name") + Retranslate.onLanguageChanged
                    textFormat: TextFormat.Auto
                    input.keyLayout: KeyLayout.Default
                    input.submitKey: SubmitKey.Next

                } // either first name or last name is compulsory
                TextArea {
                    id: lastname
                    preferredWidth: ui.du(60)
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    text: qsTr("") + Retranslate.onLanguageChanged
                    hintText: qsTr("Last name") + Retranslate.onLanguageChanged
                    textFormat: TextFormat.Auto
                    editable: true
                    input.submitKey: SubmitKey.Next
                    enabled: true
                    input {
                        onSubmitted: {
                            savedetails()
                        }
                    }
                } // either  name or last name is compulsory

            }
            Container {
                topPadding: ui.du(2)
                Header {
                    title: qsTr("Phone Number") + Retranslate.onLanguageChanged
                    preferredWidth: ui.du(60)
                }
            }
            

            TextArea {
                id: phonenumber
                preferredWidth: ui.du(50)
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                text: ""
                hintText: qsTr("Phone Number") + Retranslate.onLanguageChanged
                editable: false
                input.submitKey: SubmitKey.Submit
                input {
                    onSubmitted: {
                        savedetails()
                    }
                }
                textFormat: TextFormat.Auto
                maximumLength: 13
                input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Keep

            }

            // Username shhould be  updated later

            TextArea {
                id: username
                hintText: qsTr("@Username") + Retranslate.onLanguageChanged
                preferredWidth: ui.du(60)
                editable: false
                input.submitKey: SubmitKey.Submit
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                input {
                    onSubmitted: {
                        savedetails()
                    }
                }
            }

        }

    }
    actions: [

        ActionItem {
            title: qsTr("Save") + Retranslate.onLanguageChanged
            onTriggered: {
                app.AccountupdateProfile(fname, lname)
                savetoast.show()
            }
            ActionBar.placement: ActionBarPlacement.Signature
            imageSource: "asset:///images/icons/ic_done.png"
            attachedObjects: [
                SystemToast {
                    id: savetoast
                    body: qsTr("Your Info Has Been Saved") + Retranslate.onLanguageChanged
                    position: SystemUiPosition.BottomCenter
                }
            ]

        }
    ]

}
