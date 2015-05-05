import bb.cascades 1.3

Container {
    signal refreshTriggered
    property bool touchActive: false
    
//    SegmentedControl {
//        id: selectChats
//        selectedIndex: 0
//        Option {
    //            text: qsTr("All") + Retranslate.onLanguageChanged
//            value: "all"
    //            description: qsTr("") + Retranslate.onLanguageChanged
//        }
//        Option {
    //            text: qsTr("Contacts") + Retranslate.onLanguageChanged
//            value: "contact"
    //            description: qsTr("") + Retranslate.onLanguageChanged
//        }
//        Option {
    //            text: qsTr("Group") + Retranslate.onLanguageChanged
//            value: "group"
//
//        }
//        Option {
    //            text: qsTr("Broadcast") + Retranslate.onLanguageChanged
//            value: "broadcast"
    //            description: qsTr("") + Retranslate.onLanguageChanged
//        }
//        onSelectedIndexChanged : {
//              switch (selectedValue ) {
//              case 'all':
//                  contactslist.dataModel = app.getContactsmodal("");
//                  break;
//              case 'contact' : 
//                  contactslist.dataModel = app.getContactsmodal("contact");
//                  break;
//              case 'group' : 
//                  contactslist.dataModel = app.getContactsmodal("chat");
//                  break;
//              case 'broadcast' : 
//                  contactslist.dataModel = app.getContactsmodal("broadcast");
//                  break;
//            }
//        }
//    }
    Divider {
        
    }
    attachedObjects: [
        LayoutUpdateHandler {
            id: refreshHandler
            onLayoutFrameChanged: {
                   if (layoutFrame.y >= 0.0) {
                       if (layoutFrame.y == 0 && touchActive != true) {
                            refreshTriggered();
                    }
                }
               
            }
        }
    ]
    leftPadding: ui.du(2)
    bottomPadding: ui.du(2)
    topPadding: ui.du(2)
    rightPadding: ui.du(2)

}