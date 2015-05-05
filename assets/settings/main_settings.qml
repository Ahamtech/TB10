import bb.cascades 1.3
import bb.system 1.2

Page {
    onCreationCompleted: {
        app.quitapp.connect(quitapp)
    }
    function quitapp(){
        Application.quit()
    }
    titleBar: TitleBar {
        title: qsTr("Settings") + Retranslate.onLanguageChanged
    }
    
    ScrollView {

        Container {
            Header {
                title: qsTr("General") + Retranslate.onLanguageChanged
            }
            Container {

                leftPadding: ui.du(3)
                topPadding: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
                bottomPadding: 10

                Label {

                    text: qsTr("<html><body><p>Notifications &amp; Sounds</p><span style='font-size:5;'>What sounds good?</span></body></html>") + Retranslate.onLanguageChanged
                    textFormat: TextFormat.Html
                    multiline: true
                    attachedObjects: [
                        Invocation {
                            id: invoke
                            query: InvokeQuery {
                                invokeTargetId: "sys.settings.target"
                                uri: "settings://notification/application?id=com.example.TB10"
                            }
                        }
                    ]

                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                invoke.trigger("bb.action.OPEN")
                            }
                        }
                    ]
                    textStyle.fontStyle: FontStyle.Italic
                    textStyle.fontSize: FontSize.Medium
                    textStyle.textAlign: TextAlign.Default
                    horizontalAlignment: HorizontalAlignment.Fill
                }

                Divider {
                    horizontalAlignment: HorizontalAlignment.Center
                }
                Label {
                    text: qsTr("<html><body><p >Privacy &amp; Security</p><span style='font-size:5;'>What belongs only to you? </span></body></html>") + Retranslate.onLanguageChanged
                    textFormat: TextFormat.Html
                    multiline: true
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                chatviewnav.push(privacypage.createObject())
                            }
                        }
                    ]
                    textStyle.fontSize: FontSize.Medium
                    textStyle.fontStyle: FontStyle.Italic
                    horizontalAlignment: HorizontalAlignment.Fill

                }
                Divider {

                }
            }

            Header {
                title: qsTr("Display") + Retranslate.onLanguageChanged
            }
            Container {
                leftPadding: ui.du(3)
                topPadding: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
                bottomPadding: 10
                Label {
                    text: qsTr("<html><body><p >Themes &amp; Fonts</p><span style='font-size:5;'>What looks good </span></body></html>") + Retranslate.onLanguageChanged
                    textFormat: TextFormat.Html
                    multiline: true
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                chatviewnav.push(display.createObject())
                            }
                        }
                    ]
                    textStyle.fontSize: FontSize.Medium
                    textStyle.fontStyle: FontStyle.Italic
                    horizontalAlignment: HorizontalAlignment.Fill
                
                }
                Divider {
                    
                }
                
            }
            Header {
                title: qsTr("Language") + Retranslate.onLanguageChanged

            }
            Container {

                leftPadding: ui.du(3)
                rightPadding: ui.du(3)
                topPadding: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
                bottomPadding: 10
                
                Label {
                    text: qsTr("We are using an API for translation, please feel free to send us corrected translation of any mismatches.") + Retranslate.onLanguageChanged
                    multiline: true
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center

                }
                Button {
                    text: qsTr("Send Translation") + Retranslate.onLanguageChanged
                    horizontalAlignment: HorizontalAlignment.Center
                    onClicked: {
                        translate.trigger("bb.action.SENDEMAIL") + Retranslate.onLanguageChanged
                    }

                }
            }
            Header {
                title: qsTr("Support") + Retranslate.onLanguageChanged

            }
            Container {

                leftPadding: ui.du(3)
                topPadding: 20.0
                horizontalAlignment: HorizontalAlignment.Fill
                bottomPadding: 10
                Label {
                    text: qsTr("<html><body ><a href='https://telegram.org/faq'><p>FAQ</p><span style='font-size:5;'>Have a question?</span></a></body></html>") + Retranslate.onLanguageChanged
                    textFormat: TextFormat.Html
                    multiline: true
                    horizontalAlignment: HorizontalAlignment.Fill
                    textStyle.fontStyle: FontStyle.Italic
                    textStyle.fontSize: FontSize.Medium

                }

                Divider {
                    horizontalAlignment: HorizontalAlignment.Center
                }
                Label {
                    text: qsTr("<html><body><p>Send Feedback</p><span style='font-size:5;'>Share your experience with us.</span></body></html>") + Retranslate.onLanguageChanged
                    textFormat: TextFormat.Html
                    multiline: true
                    horizontalAlignment: HorizontalAlignment.Fill
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                emailShare.trigger("bb.action.SENDEMAIL")
                            }
                        }
                    ]
                    textStyle.fontStyle: FontStyle.Italic
                    textStyle.fontSize: FontSize.Medium

                }

                Divider {

                }
                
                
            }
            Divider {
                
            }
            Container {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                bottomPadding: 70
                topPadding: 50
                Button {
                    text: qsTr("LOGOUT") + Retranslate.onLanguageChanged
                    bottomPadding: ui.du(20)
                    
                    appearance: ControlAppearance.Primary
                    
                    onClicked: {
                        logoutDialog.show()
                    
                    }
                }
            }
            Divider {

            }
        }

    }
    attachedObjects: [
        SystemDialog {
            id: logoutDialog
            title: qsTr("Do you really want to Logout") + Retranslate.onLanguageChanged
            customButton.enabled: false
            confirmButton.label: qsTr("Ok") + Retranslate.onLanguageChanged
            cancelButton.label: qsTr("Cancel") + Retranslate.onLanguageChanged

            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    app.logout()
                    logoutToast.show()
                }

            }
        },
        Invocation {
            id: translate
            query.mimeType: "text/plain"
            query.invokeTargetId: "sys.pim.uib.email.hybridcomposer"
            query.uri: "mailto:translate@ahamtech.in?subject=TB10-Translation"
        },
        Invocation {
            id: emailShare
            query.mimeType: "text/plain"
            query.invokeTargetId: "sys.pim.uib.email.hybridcomposer"
            query.uri: "mailto:contact@ahamtech.in?subject=TB10-Feedback"
        },
        SystemToast {
            id: logoutToast
            body: qsTr("Logging Out") + Retranslate.onLanguageChanged
        },
        ComponentDefinition {
            id: privacypage
            source: "privacy_security.qml"
        },
        ComponentDefinition {
            id: display
            source: "display.qml"
        }
    ]
}
