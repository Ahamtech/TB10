import bb.cascades 1.3

Page {
    titleBar: TitleBar {
        title: qsTr("Privacy & Security") + Retranslate.onLanguageChanged

    }
    ScrollView {
        Container {
            Header {
                title: qsTr("Privacy") + Retranslate.onLanguageChanged
            }
            Container {

                leftPadding: ui.du(3)
                topPadding: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
                bottomPadding: 10
                Label {
                    horizontalAlignment: HorizontalAlignment.Fill
                    text: qsTr("<html><body><p>Blocked Users</p><span style='font-size:5;'>View Blocked users</span></body></html>") + Retranslate.onLanguageChanged
                    textFormat: TextFormat.Html
                    multiline: true
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                chatviewnav.push( blockedcontacts.createObject())
                            }
                        }
                    ]
                }

                /*Divider {
                    horizontalAlignment: HorizontalAlignment.Center
                }
                DropDown {
                title: qsTr("Last seen") + Retranslate.onLanguageChanged
                    selectedOption: 
                    Option {
                    text: qsTr("To Everybody") + Retranslate.onLanguageChanged
                        value: "all"
                        description: qsTr("") + Retranslate.onLanguageChanged
                    }
                    Option {
                    text: qsTr("To My Contacts") + Retranslate.onLanguageChanged
                        value: "contact"
                        selected: true
                        description: qsTr("") + Retranslate.onLanguageChanged
                    }
                    Option {
                    text: qsTr("To Nobody") + Retranslate.onLanguageChanged
                        value: "none"
                        description: qsTr("") + Retranslate.onLanguageChanged
                    }
                }*/
            }
            /*Header {
             title: qsTr("Security") + Retranslate.onLanguageChanged
            }
            Container {

                leftPadding: ui.du(3)
                topPadding: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
                bottomPadding: 10
                Label {
                text: qsTr("<html><body><p>Terminate All Other Sessions</p><span style='font-size:5;'>Not sure of other logins? Terminate the rest now.</span></body></html>") + Retranslate.onLanguageChanged
                    textFormat: TextFormat.Html
                    multiline: true
                }

                Divider {
                    horizontalAlignment: HorizontalAlignment.Center
                }

            }*/
           /* Header {
            title: qsTr("Account Auto Self-Destruct") + Retranslate.onLanguageChanged
            }
            Container {

                leftPadding: ui.du(3)
                topPadding: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
                bottomPadding: 10
                Label {
                text: qsTr("<html><body><span style='font-size:5;'>Are you in a hurry? Let us help you auto delete your account.</span></body></html>") + Retranslate.onLanguageChanged
                    textFormat: TextFormat.Html
                    multiline: true
                }
                DropDown {
                title: qsTr("How long?") + Retranslate.onLanguageChanged
                    selectedOption: Option {
                        text: "1 Months"
                        value: "three"
                    }
                    Option {
                        text: "3 Months"
                        value: "six"
                    }
                    Option {
                        text: "6 Months"
                        value: "nine"
                    }
                    Option {
                        text: "1 Year"
                        value: "one"
                    }
                }

            }*/
            Divider {

            }
        }
    }
    attachedObjects: [
        ComponentDefinition {
            id:blockedcontacts
            source: "blocklist_add.qml"
        }
    ]
}
