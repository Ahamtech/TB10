import bb.cascades 1.3
import bb.cascades.multimedia 1.0
import bb.system 1.0
import bb.cascades.datamanager 1.2
import bb.platform 1.2
import "js/moment.js" as Moment

NavigationPane {
    id: chatviewnav
    property variant listdata: []
    property variant curuerid
    property variant photospath: filepathname.photos
    Menu.definition: MenuDefinition {
        id: menu
        actions: [
            ActionItem {
                title: qsTr("About Us") + Retranslate.onLanguageChanged
                imageSource: "asset:///images/icons/ic_help.png"
                onTriggered: {
                    chatviewnav.push(aboutpane.createObject())
                    //                        app.dumpTable('broadCast')
                }
            },
            ActionItem {
                ActionBar.placement: ActionBarPlacement.Default
                title: qsTr("Review") + Retranslate.onLanguageChanged
                imageSource: "asset:///images/icons/ic_compose.png"
                attachedObjects: [
                    Invocation {
                        id: invoke
                        query: InvokeQuery {
                            invokeTargetId: "sys.appworld"
                            uri: "appworld://content/59949612"
                        }
                    }
                ]
                onTriggered: {
                    invoke.trigger("bb.action.OPEN")
                }
            },
            ActionItem {
                title: qsTr("Send Feedback") + Retranslate.onLanguageChanged
                imageSource: "asset:///images/icons/ic_feedback.png"
                onTriggered: {
                    emailShare.trigger("bb.action.SENDEMAIL")
                }
            }
        ]
        settingsAction: SettingsActionItem {
            onTriggered: {
                chatviewnav.push(settingsmain.createObject())
            }
        }
    }
    onCreationCompleted: {
        selectChats.resetSelectedOption()
        selectChats.selectedIndex=0
        var da = app.getMessageContacts(app.getPopUserId())
        var fontsize = app.getSettings("font")
        var info = app.getSettings("theme")
        if (info[0]) {
            Application.themeSupport.setVisualStyle(info[0]["value"])
            var clr1 = app.getSettings("color1")
            var clr2 = app.getSettings("color2")
            Application.themeSupport.setPrimaryColor(Color.create(clr1[0]["value"]), Color.create(clr2[0]["value"]))
        }
        app.checkserver.connect(loaddataserver)
        app.reloadContacts.connect(loadcontacts)
        app.accountUserInfo.connect(renderTitleBar)
        app.liveupatemessage.connect(newincomingmessage)
        app.deleteliveuser.connect(deleteuser)
        app.accountcreated.connect(accountnew)
        app.loadGroupInfo.connect(rendergroupinfo)
        app.profileimage.connect(profileimageupdate)
        app.userprofile.connect(userprofileimaegupdate)
        app.importContacts()
        Qt.  photospath = photospath
//        profileimageupdate()
    }
    function loaddataserver(){
        var dc = app.workingdc();
        app.changeServer(dc - 1); 
    }
    function userprofileimaegupdate(id,photoid){
        var size = contactslist.dataModel.size()
        for (var i = 0; i < size; i ++) {
            if (id == contactslist.dataModel.value(i).id) {
                var temp = contactslist.dataModel.value(i)
                temp.photoid  = photoid
                contactslist.dataModel.replace(i, temp)
            }
        }
    }
    function profileimageupdate(line){
    headerbar.currentuserimage   = "asset:///images/thumbnails/Placeholders/user_placeholder_blue.png"
    }
    function rendergroupinfo(title,count,id){
        var size = contactslist.dataModel.size()
        for (var i = 0; i < size; i ++) {
            if (id == contactslist.dataModel.value(i).id) {
                var temp = contactslist.dataModel.value(i)
                temp.firstname = title
                contactslist.dataModel.replace(i, temp)
            }
        }
    }
    function loadcontacts() {
        listdata = app.getContactsmodal("");
        contactslist.dataModel.clear()
        contactslist.dataModel.append(listdata);
        selectChats.setSelectedIndex(0);
       
    }
    function addaccount(data) {
        var info = data[0]
        listdata.push(info)
    }
    function removeaccount(type, id) {
        for (var i = 0; i < listdata.length; i ++) {
            if (listdata[i].type == type && listdata[i].id == id) {
                listdata.splice(i, 1)
            }
        }
        renderaccounts()
    }
    function renderaccounts() {
        var type = selectChats.selectedValue
        contactslist.dataModel.clear()
        var temp = [];
        if (type == null) {
            contactslist.dataModel.append(listdata)
        } else {
            for (var i = 0; i < listdata.length; i ++) {
                if (listdata[i].type == type) {
                    temp.push(listdata[i])
                }
            }
            contactslist.dataModel.append(temp)
        }
    }
    function classifycontacts(type) {
        listdata = app.getContactsmodal(type);
        contactslist.dataModel.clear()
        contactslist.dataModel.append(listdata);
    }

    function renderTitleBar(first, last, ph, user, id) {
        headerbar.username = first + " " + last
        curuerid = id
    }

    function notify(data, msg) {

    }
    function selectedindexchange() {
        var se = searchpane.createObject();
        se.query = "this is the query";
        chatviewnav.push(se)
        searchitems.setSelectedIndex(0)
    }
    function newincomingmessage(id, msg, read, mdate, inc) {
        var size = contactslist.dataModel.size()
        for (var i = 0; i < size; i ++) {
            var temp = contactslist.dataModel.value(i)
            if (id == temp.id && temp.messagetime  < mdate && id != curuerid) {
                temp.latestmessage = msg
                temp.read = read
                temp.messagetime = mdate
                var popuser = app.getPopUserId()
                var popgrp = app.getPopGroupId()
                if ((id == popuser || id == popgrp || id != curuerid) && inc == false)
                    temp.messagemode = true
                contactslist.dataModel.replace(i, temp)
                contactslist.dataModel.move(i, 0)
                contactslist.scrollToItem(0)
                contactslist.scrollToPosition([ ScrollPosition.Beginning ], ScrollAnimation.Smooth)
            }
        }
        alert.clearEffects();
        alert.deleteFromInbox();
        if (chatviewnav.count() == 1 &&  id != curuerid && inc == false && app.getPopBroadCastId() !=0 ) {
            alert.body = msg
            alert.notify();
        } else if (chatviewnav.count() > 1) {
            var popuser = app.getPopUserId()
            var popgrp = app.getPopGroupId()
            if (id == popuser || id == popgrp || id == curuerid ) {
//                console.log( "Out Ward Message"+" " + inc +" " + id + " " + curuerid + " " + app.getPopUserId()+ " " + msg)
            } else {
//                console.log( "In Ward Message" +" " + inc +" " + id + " " + curuerid + " " + app.getPopUserId()+ " " + msg)
                alert.body = msg
                alert.notify();
            }
        }
    }
    function deleteuser(id) {
        var size = contactslist.dataModel.size()
        var delacc;
        for (var i = 0; i < size; i ++) {
            var temp = contactslist.dataModel.value(i)
            if (id == temp.id) {
                delacc = i
            }
        }
        contactslist.dataModel.removeAt(delacc)
    }
    function accountnew(data) {
        var info = data[0]
        contactslist.dataModel.insert(0, info)
    }
    Page {

        id: contactstab
        builtInShortcutsEnabled: false
        onCreationCompleted: {
            loadcontacts()
        }
        titleBar: CustomTitleBar {
            id: headerbar
            
        }
        Container {
            shortcuts: [
                Shortcut {
                    key: "s"
                    onTriggered: {
                        presenceHeaderPane.visible = false
                        searchHeader.visible = true
                        searchitemcont.visible = true
                        selectChats.visible = false
                        searchbox.requestFocus()
                    }
                }
            ]
            topPadding: ui.du(1)
            bottomPadding: ui.du(2)
            Container {
                visible: false
                id: searchitemcont
                horizontalAlignment: HorizontalAlignment.Center
                SegmentedControl {
                    id: searchitems
                    visible: false
                    Option {
                        id: "searchcontactssegment"
                        text: qsTr("Contacts") + Retranslate.onLanguageChanged
                        value: "c"
                    }
//                    Option {
//                        id: "searchmessagessegment"
//                        text: qsTr("Messages") + Retranslate.onLanguageChanged
//                        value: "m"
//                    }
//                    onSelectedIndexChanged: {
//                        switch (selectedValue) {
//                            case 'c':
//                                break
//                            case 'm':
//                                selectedindexchange()
//
//                                break;
//                        }
//                    }
                }
            }
            Container {
                horizontalAlignment: HorizontalAlignment.Fill

                verticalAlignment: VerticalAlignment.Fill
               margin.bottomOffset: 10
                SegmentedControl {
                    
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    id: selectChats
                    selectedIndex: 0
                    Option {
                        text: qsTr("All") + Retranslate.onLanguageChanged
                        value: "all"
                    }
                    Option {
                        text: qsTr("Chats") + Retranslate.onLanguageChanged
                        value: "contact"
                    }
                    Option {
                        text: qsTr("Groups") + Retranslate.onLanguageChanged
                        value: "group"
                    }
                    Option {
                        text: qsTr("Broadcast") + Retranslate.onLanguageChanged
                        value: "broadcast"
                    }
                    onSelectedIndexChanged: {
                        switch (selectedValue) {
                            case 'all':
                                classifycontacts()
                                break;
                            case 'contact':
                                classifycontacts("contact")
                                break;
                            case 'group':
                                classifycontacts("chat")
                                break;
                            case 'broadcast':
                                classifycontacts("broadcast")
                                break;
                        }
                    }
                }
            
          
            }//segmented control end
            Container {
            
                layout: AbsoluteLayout {
                    
                }
            ListView {
                id: contactslist
                dataModel: ArrayDataModel {
                }
                
                onTriggered: {
                    var activetab = contactslist.dataModel.value(indexPath)
                    var usid = activetab.id
                    var type = activetab.type
                    var tempm =  contactslist.dataModel.value(indexPath)
                    tempm.messagemode = false
                    contactslist.dataModel.replace(indexPath, tempm)
                    if (type == "contact") {
                        app.setPopUserId(usid);
                        chatviewnav.push(chatcontactpane.createObject());
                    } else if (type == "chat") {
                        app.setPopGroupId(usid);
                        chatviewnav.push(chatgrouppane.createObject());
                    } else if (type == "broadcast") {
                        app.setPopBroadCastId(usid)
                        chatviewnav.push(chatbroadcastpane.createObject());
                    }
                }
                function deletechathistory(id) {
                    chatdelete.show()
                    //                    app.clearContactHistory(id);
                }
                function addtofav(id) {
                    app.addToFavourites(id)
                }
                layout: FlowListLayout {
                    headerMode: ListHeaderMode.None
                }
                listItemComponents: [
                    ListItemComponent {
                        type: ""
                        CustomListItem {
                            maxHeight: 100
                            id: listofmessagesincontact
                            horizontalAlignment: HorizontalAlignment.Fill
                            highlightAppearance: HighlightAppearance.Full
                            ControlDelegate {
                                sourceComponent: chatbubble
                                attachedObjects: [
                                    ComponentDefinition {
                                        id: chatbubble
                                        ConversationListItem {
                                            username: ListItemData.firstname
                                            msg: ListItemData.latestmessage
//                                            time:ListItemData.messagetime
                                            time: if(ListItemData.messagetime != null || ListItemData.messagetime != 0 || ListItemData.messagetime != ""){Moment.moment.unix(ListItemData.messagetime).calendar()}
                                            type: ListItemData.type
                                            photoid : ListItemData.photoid
                                            incoming: ListItemData.messagemode
                                            path: Qt.photospath
                                        }
                                    }
                                ]
                            }
                        }
                    }
                ]
                topPadding: 20.0
            }
        }
            
        }
        
        actions: [
//            ActionItem {
//                title: qsTr("Import Contacts") + Retranslate.onLanguageChanged
//                imageSource:"asset:///images/icons/ic_add_to_contacts.png"
//                onTriggered: {
//                    app.importContacts()
//                }
//            },
            ActionItem {
                ActionBar.placement: ActionBarPlacement.Default
                title: qsTr("New Chat") + Retranslate.onLanguageChanged
                imageSource: "asset:///images/icons/ic_bbm.png"
                onTriggered: {
                    chatviewnav.push(newchatcontact.createObject())
                }
                shortcuts: [
                    Shortcut {
                        key: "c"
                        onTriggered: {
                            chatviewnav.push(newchatcontact.createObject())
                        }
                    }
                ]
            },
            ActionItem {
                ActionBar.placement: ActionBarPlacement.Default
                title: qsTr("New Group Chat") + Retranslate.onLanguageChanged
                imageSource: "asset:///images/thumbnails/menu_group.png"
                onTriggered: {
                    chatviewnav.push(newgroupchat.createObject())
                }
                shortcuts: [
                    Shortcut {
                        key: "g"
                        onTriggered: {
                            chatviewnav.push(newgroupchat.createObject())
                        }
                    }
                ]
                builtInShortcutsEnabled: false
            },
            ActionItem {
                ActionBar.placement: ActionBarPlacement.Default
                title: qsTr("New Broadcast List") + Retranslate.onLanguageChanged
                imageSource: "asset:///images/thumbnails/menu_broadcast.png"
                onTriggered: {
                    chatviewnav.push(newbroadcast.createObject())
                }
            }

        ]
        actionBarVisibility: ChromeVisibility.Compact
    }

    attachedObjects: [
        ComponentDefinition {
            id: chatcontactpane
            source: "asset:///Chats/chat_contact.qml"
        },
        ComponentDefinition {
            id: chatgrouppane
            source: "Chats/chat_group.qml"
        },
        ComponentDefinition {
            id: chatbroadcastpane
            source: "Chats/chat_broadcast.qml"
        },
        ComponentDefinition {
            id: aboutpane
            source: "settings/aboutus.qml"
        },
        ComponentDefinition {
            id: settingsmain
            source: "settings/main_settings.qml"
        },
        ComponentDefinition {
            id: newchatcontact
            source: "NewChats/new_chat.qml"
        },
        ComponentDefinition {
            id: newgroupchat
            source: "NewChats/group_NewGroupChat.qml"
        },
        ComponentDefinition {
            id: newbroadcast
            source: "NewChats/new_broadcast.qml"
        },
        ComponentDefinition {
            id: searchpane
            source: "search.qml"
        },
        SystemToast {
            id: myQmlToast
            body: "So long! Thanks for coming, see you next time!"
        },
        ComponentDefinition {
            id: accountpage
            source: "profiles/user_edit_profile.qml"
        },
        SystemToast {
            id: toastnewsecret
            body: "Coming Soon"
        },
        Invocation {
            id: emailShare
            query.mimeType: "text/plain"
            query.invokeTargetId: "sys.pim.uib.email.hybridcomposer"
            query.uri: "mailto:contact@ahamtech.in?subject="
        },
        Notification {
            id: alert
        }
    ]
    onPopTransitionEnded: {
        page.destroy()
        selectChats.setSelectedIndex(0)
    }
    
}
