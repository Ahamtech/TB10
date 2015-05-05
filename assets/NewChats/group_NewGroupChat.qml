import bb.cascades 1.3
import bb.system 1.2
import bb.cascades.pickers 1.0

Page {
    id: newgrouppage
    property alias title: newgroupname.text
    onCreationCompleted: {
        usernames.dataModel = app.getContactsNamesModel("contact")
        app.chatgroupcreated.connect(created)
    }
    titleBar: TitleBar {
        title: qsTr("New Group") + Retranslate.onLanguageChanged
   }
    function created() {
        newgroupcreatd.show()
        chatviewnav.pop()
    }
    Container {
        
    
    Container {
        topPadding: ui.du(2)
        ImageView {
            imageSource: "asset:///images/thumbnails/Placeholders/group_placeholder_green.png"
            horizontalAlignment: HorizontalAlignment.Center
            rightMargin : ui.du(4)
//            gestureHandlers: [
//                TapHandler {
//                    onTapped: {
//                        filePicker.open()
//                    }
//                }
//            ]
//            attachedObjects: [
//                FilePicker {
//                    id: filePicker
//                    type: FileType.Picture
//                    title: "Select Picture"
//                    directories: [ "/accounts/1000/shared" ]
//                    onFileSelected: {
//                        console.log("FileSelected signal received : " + selectedFiles);
//                        userprofileimage.imageSource = "file://" + selectedFiles[0];
//                    
//                    }
//                }
//            ]

        }
        horizontalAlignment: HorizontalAlignment.Center
            
            verticalAlignment: VerticalAlignment.Center
            TextField {
            id: newgroupname
            hintText: qsTr("Enter Group Name") + Retranslate.onLanguageChanged
            preferredWidth: ui.du(50)
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            leftPadding: ui.du(10)
        }
            bottomPadding: ui.du(5)
            layout: GridLayout {

            }
        }
        Container {
            
        
        
        Header {
            title: qsTr("Select Friends Of The Group") + Retranslate.onLanguageChanged
            subtitle: qsTr("(Atleast One)") + Retranslate.onLanguageChanged

        }
        ListView {
            id: usernames
            dataModel: GroupDataModel {
                grouping: ItemGrouping.None
            }
            function addtogroup(id) {
                selectedid = id
            }
            multiSelectAction: MultiSelectActionItem {

            }
            onTriggered: {
                if(newgroupname.text.length > 0 ){
                    usernames.multiSelectHandler.active = true
                    usernames.select(indexPath)
                }
                else{
                    newgrouptoast.body = qsTr("Enter Group Name") + Retranslate.onLanguageChanged
                    newgrouptoast.show()
                }
                
            }
            multiSelectHandler {
                status: qsTr("") + Retranslate.onLanguageChanged
                // The actions that can be performed in a multi-select sessions are set up in the actions list.
                actions: [
                    ActionItem {
                        title: qsTr("Save Group") + Retranslate.onLanguageChanged
                        imageSource: "asset:///images/icons/ic_done.png"
                        enabled: if(newgroupname.text.length > 0) {true} else{false}
                        onTriggered: {
                            chatviewnav.pop(newgrouppage)
                            
                            var selectionList = usernames.selectionList();
                            var items = new Array();
                            for (var i = 0; i < selectionList.length ; i ++) {
                                items.push(usernames.dataModel.data(selectionList[i]).id)
                            }
                            app.createGroup(newgroupname.text, items)
                        }
                    }
                ]
            }
            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    StandardListItem {
                        id: favcontactslist
                        title: ListItemData.firstname
                    }
                }
            ]
        }
    }
}
    attachedObjects: [
        SystemToast {
            id: newgrouptoast
            body: ""
        },
        SystemToast {
                    id: newgroupcreatd
                    body: qsTr("Group Created") + Retranslate.onLanguageChanged
            autoUpdateEnabled: false
            button.enabled: false
        }
       
    ]
    actionBarVisibility: ChromeVisibility.Compact
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.Default
}
