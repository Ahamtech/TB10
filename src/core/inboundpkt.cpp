/*
 * Copyright 2013 Vitaly Valtman
 * Copyright 2014 Canonical Ltd.
 * Authors:
 *      Roberto Mier
 *      Tiago Herrmann
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include "inboundpkt.h"

#include <QDebug>
#include "utils.h"
#include "tlvalues.h"



InboundPkt::InboundPkt(char *buffer, qint32 length) {
    this->m_buffer = buffer;
    this->m_length = length;
}

const char *InboundPkt::buffer() const{
    return m_buffer;
}

qint32 InboundPkt::length() const {
    return m_length;
}

void InboundPkt::setInPtr(qint32 *inPtr) {
    this->m_inPtr = inPtr;
}

void InboundPkt::setInEnd(qint32 *inEnd) {
    this->m_inEnd = inEnd;
}

qint32 *InboundPkt::inPtr() {
    return m_inPtr;
}

qint32 *InboundPkt::inEnd() {
    return m_inEnd;
}

void InboundPkt::forwardInPtr(qint32 positions) {
    m_inPtr += positions;
}

qint32 InboundPkt::prefetchStrlen() {
    if (m_inPtr >= m_inEnd) {
        return -1;
    }
    unsigned l = *m_inPtr;
    if ((l & 0xff) < 0xfe) {
        l &= 0xff;
        return (m_inEnd >= m_inPtr + (l >> 2) + 1) ? (qint32)l : -1;
    } else if ((l & 0xff) == 0xfe) {
        l >>= 8;
        return (l >= 254 && m_inEnd >= m_inPtr + ((l + 7) >> 2)) ? (qint32)l : -1;
    } else {
        return -1;
    }
}

qint32 InboundPkt::prefetchInt() {
  Q_ASSERT(m_inPtr < m_inEnd);
  return *(m_inPtr);
}

qint32 InboundPkt::fetchInt() {
    Q_ASSERT(m_inPtr + 1 <= m_inEnd);
//    qDebug() << "fetchInt()" << *m_inPtr << " (" << Utils::toHex(*m_inPtr) << ")";
    return *(m_inPtr ++);
}

bool InboundPkt::fetchBool() {
    Q_ASSERT(m_inPtr + 1 <= m_inEnd);
    ASSERT(*(m_inPtr) == (qint32)TL_BoolTrue || *(m_inPtr) == (qint32)TL_BoolFalse);
//    qCDebug(TG_NET_FETCH) << "fetchBool()" << (*(m_inPtr) == (qint32)TL_BoolTrue) << " (" << Utils::toHex(*m_inPtr) << ")";
    return *(m_inPtr++) == (qint32)TL_BoolTrue;
}

qint64 InboundPkt::fetchLong() {
    Q_ASSERT(m_inPtr + 2 <= m_inEnd);
    qint64 r = *(qint64 *)m_inPtr;
//    qDebug() << "fetchLong()" <<  r ;
    m_inPtr += 2;
    return r;
}

qint32 *InboundPkt::fetchInts(qint32 count) {
    Q_ASSERT(m_inPtr + count <= m_inEnd);
    qint32 *data = (qint32 *)Utils::talloc(4 * count);
    memcpy (data, m_inPtr, 4 * count);
    m_inPtr += count;
    return data;
}

double InboundPkt::fetchDouble() {
    Q_ASSERT(m_inPtr + 2 <= m_inEnd);
    double r = *(double *)m_inPtr;
    m_inPtr += 2;
    return r;
}

char *InboundPkt::fetchStr(qint32 len) {
    Q_ASSERT(len >= 0);

    char *str;
    if (len < 254) {
        str = (char *)m_inPtr + 1;
        m_inPtr += 1 + (len >> 2);
    } else {
        str = (char *)m_inPtr + 4;
        m_inPtr += (len + 7) >> 2;
    }
//    qDebug() << "fetchStr(), str =" << str;
    return str;
}

QString InboundPkt::fetchQString() {
    qint32 l = prefetchStrlen();
//    qDebug() << "Qstring " << QString::fromUtf8(fetchStr(l),l);
    return QString::fromUtf8(fetchStr(l),l);
}

QByteArray InboundPkt::fetchBytes() {
    qint32 l = prefetchStrlen();
    char *bytes = fetchStr(l);
    // http://qt-project.org/doc/qt-4.8/qbytearray.html#fromRawData
    return QByteArray::fromRawData(bytes, l);
}

qint32 InboundPkt::fetchBignum (BIGNUM *x) {
    qint32 l = prefetchStrlen();
    if (l < 0) {
        return l;
    }
    const char *str = fetchStr (l);
    BIGNUM *bn = BN_bin2bn ((uchar *) str, l, x);
    Q_UNUSED(bn);
    Q_ASSERT(bn == x);
    return l;
}

qint32 InboundPkt::fetchDate() {
  qint32 p = fetchInt ();
  // TODO must we take account about last_date ??
  return p;
}

DcOption InboundPkt::fetchDcOption() {
    DcOption dcOption;

    ASSERT(fetchInt() == DcOption::typeDcOption);
    dcOption.setId(fetchInt());
    dcOption.setHostname(fetchQString());
    dcOption.setIpAddress(fetchQString());
    dcOption.setPort(fetchInt());

    return dcOption;
}

User InboundPkt::fetchUser() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)User::typeUserEmpty ||
             x == (qint32)User::typeUserSelf ||
             x == (qint32)User::typeUserContact ||
             x == (qint32)User::typeUserRequest ||
             x == (qint32)User::typeUserForeign ||
             x == (qint32)User::typeUserDeleted);
    User user((User::UserType)x);
    user.setId(fetchInt());
    if (x != (qint32)User::typeUserEmpty) {
        user.setFirstName(fetchQString());
        user.setLastName(fetchQString());
        if (x != (qint32)User::typeUserDeleted) {
            if (x != (qint32)User::typeUserSelf) {
                user.setAccessHash(fetchLong());
            }
            if (x != (qint32)User::typeUserForeign) {
                user.setPhone(fetchQString());
            }
            user.setPhoto(fetchUserProfilePhoto());
            user.setStatus(fetchUserStatus());
            if (x == (qint32)User::typeUserSelf) {
                user.setInactive(fetchBool());
            }
        }
    }
    return user;
}

UserProfilePhoto InboundPkt::fetchUserProfilePhoto() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)UserProfilePhoto::typeUserProfilePhotoEmpty || x == (qint32)UserProfilePhoto::typeUserProfilePhoto);
    UserProfilePhoto upp((UserProfilePhoto::UserProfilePhotoType)x);
    if (x == (qint32)TL_UserProfilePhoto) {
        upp.setPhotoId(fetchLong());
        upp.setPhotoSmall(fetchFileLocation());
        upp.setPhotoBig(fetchFileLocation());
    }
    return upp;
}

FileLocation InboundPkt::fetchFileLocation() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)FileLocation::typeFileLocationUnavailable || x == (qint32)FileLocation::typeFileLocation);
    FileLocation fl((FileLocation::FileLocationType)x);
    if (x == (qint32)FileLocation::typeFileLocation) {
        fl.setDcId(fetchInt());
    }
    fl.setVolumeId(fetchLong());
    fl.setLocalId(fetchInt());
    fl.setSecret(fetchLong());
    return fl;
}

UserStatus InboundPkt::fetchUserStatus() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)UserStatus::typeUserStatusEmpty || x == (qint32)UserStatus::typeUserStatusOnline || x == (qint32)UserStatus::typeUserStatusOffline);
    UserStatus us((UserStatus::UserStatusType)x);
    switch (x) {
    case TL_UserStatusOnline: us.setExpires(fetchInt());
        break;
    case TL_UserStatusOffline: us.setWasOnline(fetchInt());
        break;
    }
    return us;
}

Chat InboundPkt::fetchChat() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)Chat::typeChatEmpty || x == (qint32)Chat::typeChat || x == (qint32)Chat::typeChatForbidden || x == (qint32)Chat::typeGeoChat);
    Chat chat((Chat::ChatType)x);
    chat.setId(fetchInt()); // id
    if (x != (qint32)Chat::typeChatEmpty) {
        if (x == (qint32)Chat::typeGeoChat) {
            chat.setAccessHash(fetchLong()); // access_hash
        }
        chat.setTitle(fetchQString()); // title
        if (x == (qint32)Chat::typeGeoChat) {
            chat.setAddress(fetchQString()); // address
            chat.setVenue(fetchQString()); // venue
            chat.setGeo(fetchGeoPoint()); // geo
        }
        if (x != (qint32)Chat::typeChatForbidden) {
            chat.setPhoto(fetchChatPhoto()); // photo
            chat.setParticipantsCount(fetchInt()); // participants_count
        }
        chat.setDate(fetchInt()); //date
        if (x == (qint32)Chat::typeGeoChat) {
            chat.setCheckedIn(fetchBool()); // checked_in
        } else if (x == (qint32)Chat::typeChat) {
            chat.setLeft(fetchBool()); // left
        }
        if (x != (qint32)Chat::typeChatForbidden) {
            chat.setVersion(fetchInt()); //version
        }
    }
    return chat;
}

GeoPoint InboundPkt::fetchGeoPoint() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)GeoPoint::typeGeoPointEmpty || x == (qint32)GeoPoint::typeGeoPoint);
    GeoPoint geoPoint((GeoPoint::GeoPointType)x);
    if (x == (qint32)GeoPoint::typeGeoPoint) {
        geoPoint.setLongitude(fetchDouble());
        geoPoint.setLat(fetchDouble());
    }
    return geoPoint;
}

ChatPhoto InboundPkt::fetchChatPhoto() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)ChatPhoto::typeChatPhotoEmpty || x == (qint32)ChatPhoto::typeChatPhoto);
    ChatPhoto chatPhoto((ChatPhoto::ChatPhotoType)x);
    if (x == (qint32)ChatPhoto::typeChatPhoto) {
        chatPhoto.setPhotoSmall(fetchFileLocation());
        chatPhoto.setPhotoBig(fetchFileLocation());
    }
    return chatPhoto;
}

Dialog InboundPkt::fetchDialog() {
    ASSERT(fetchInt() == (qint32)Dialog::typeDialog);
    Dialog d;
    d.setPeer(fetchPeer());
    d.setTopMessage(fetchInt());
    d.setUnreadCount(fetchInt());
    d.setNotifySettings(fetchPeerNotifySetting());
    return d;
}

Peer InboundPkt::fetchPeer() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)Peer::typePeerUser || x == (qint32)Peer::typePeerChat);
    Peer peer((Peer::PeerType)x);
    switch (x) {
    case Peer::typePeerUser: peer.setUserId(fetchInt());
        break;
    case Peer::typePeerChat: peer.setChatId(fetchInt());
        break;
    }
    return peer;
}

PeerNotifySettings InboundPkt::fetchPeerNotifySetting() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)PeerNotifySettings::typePeerNotifySettingsEmpty || x == (qint32)PeerNotifySettings::typePeerNotifySettings);
    PeerNotifySettings pns((PeerNotifySettings::PeerNotifySettingsType)x);
    if (x == (qint32)PeerNotifySettings::typePeerNotifySettings) {
        pns.setMuteUntil(fetchInt());
        pns.setSound(fetchQString());
        pns.setShowPreviews(fetchBool());
        pns.setEventsMask(fetchInt());
    }
    return pns;
}

Message InboundPkt::fetchMessage() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)Message::typeMessageEmpty || x == (qint32)Message::typeMessage || x == (qint32)Message::typeMessageForwarded || x == (qint32)Message::typeMessageService);
    Message message((Message::MessageType)x);
    message.setId(fetchInt());
    if (x != (qint32)Message::typeMessageEmpty) {
        if (x == (qint32)Message::typeMessageForwarded) {
            message.setFwdFromId(fetchInt());
            message.setFwdDate(fetchInt());
        }
        message.setFromId(fetchInt());
        message.setToId(fetchPeer());
        message.setOut(fetchBool());
        message.setUnread(fetchBool());
        message.setDate(fetchInt());
        if (x == (qint32)Message::typeMessageService) {
            message.setAction(fetchMessageAction());
        } else {
            message.setMessage(fetchQString());
            message.setMedia(fetchMessageMedia());
        }
    }
    return message;
}

MessageAction InboundPkt::fetchMessageAction() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)MessageAction::typeMessageActionEmpty ||
             x == (qint32)MessageAction::typeMessageActionChatCreate ||
             x == (qint32)MessageAction::typeMessageActionChatEditTitle ||
             x == (qint32)MessageAction::typeMessageActionChatEditPhoto ||
             x == (qint32)MessageAction::typeMessageActionChatDeletePhoto ||
             x == (qint32)MessageAction::typeMessageActionChatAddUser ||
             x == (qint32)MessageAction::typeMessageActionChatDeleteUser ||
             x == (qint32)MessageAction::typeMessageActionGeoChatCreate ||
             x == (qint32)MessageAction::typeMessageActionGeoChatCheckin);
    MessageAction messageAction((MessageAction::MessageActionType)x);
    // first parameter
    if (x == (qint32)MessageAction::typeMessageActionChatCreate ||
            x == (qint32)MessageAction::typeMessageActionChatEditTitle ||
            x == (qint32)MessageAction::typeMessageActionGeoChatCreate) {
        messageAction.setTitle(fetchQString());
    } else if (x == (qint32)MessageAction::typeMessageActionChatAddUser ||
               x == (qint32)MessageAction::typeMessageActionChatDeleteUser) {
        messageAction.setUserId(fetchInt());
    } else if (x == (qint32)MessageAction::typeMessageActionChatEditPhoto) {
        messageAction.setPhoto(fetchPhoto());
    }
    // second parameter
    if (x == (qint32)MessageAction::typeMessageActionChatCreate) {
        // fetch users
        ASSERT(fetchInt() == (qint32)TL_Vector);
        qint32 n = fetchInt();
        QList<qint32> users;
        for (qint32 i = 0; i < n; i++) {
            users.append(fetchInt());
        }
        messageAction.setUsers(users);
    } else if (x == (qint32)MessageAction::typeMessageActionGeoChatCreate) {
        messageAction.setAddress(fetchQString());
    }
    return messageAction;
}

Photo InboundPkt::fetchPhoto() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)Photo::typePhotoEmpty || x == (qint32)Photo::typePhoto);
    Photo photo((Photo::PhotoType)x);
    photo.setId(fetchLong());
    if (x == (qint32)Photo::typePhoto) {
        photo.setAccessHash(fetchLong());
        photo.setUserId(fetchInt());
        photo.setDate(fetchInt());
        photo.setCaption(fetchQString());
        photo.setGeo(fetchGeoPoint());
        ASSERT(fetchInt() == (qint32)TL_Vector);
        qint32 n = fetchInt();
        QList<PhotoSize> sizes;
        for (qint32 i = 0; i < n; i++) {
            sizes.append(fetchPhotoSize());
        }
        photo.setSizes(sizes);
    }
    return photo;
}

PhotoSize InboundPkt::fetchPhotoSize() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)PhotoSize::typePhotoSizeEmpty || x == (qint32)PhotoSize::typePhotoSize || x == (qint32)PhotoSize::typePhotoCachedSize);
    PhotoSize ps((PhotoSize::PhotoSizeType)x);
    ps.setType(fetchQString());
    if (x != (qint32)PhotoSize::typePhotoSizeEmpty) {
        ps.setLocation(fetchFileLocation());
        ps.setW(fetchInt());
        ps.setH(fetchInt());
        if (x == (qint32)PhotoSize::typePhotoSize) {
            ps.setSize(fetchInt());
        } else if (x == (qint32)PhotoSize::typePhotoCachedSize) {
            ps.setBytes(fetchBytes());
        }
    }
    return ps;
}

MessageMedia InboundPkt::fetchMessageMedia() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)MessageMedia::typeMessageMediaEmpty ||
             x == (qint32)MessageMedia::typeMessageMediaPhoto ||
             x == (qint32)MessageMedia::typeMessageMediaVideo ||
             x == (qint32)MessageMedia::typeMessageMediaGeo ||
             x == (qint32)MessageMedia::typeMessageMediaContact ||
             x == (qint32)MessageMedia::typeMessageMediaUnsupported ||
             x == (qint32)MessageMedia::typeMessageMediaDocument ||
             x == (qint32)MessageMedia::typeMessageMediaAudio);
    MessageMedia media((MessageMedia::MessageMediaType)x);
    switch (x) {
    case MessageMedia::typeMessageMediaPhoto:
        media.setPhoto(fetchPhoto());
        break;
    case MessageMedia::typeMessageMediaVideo:
        media.setVideo(fetchVideo());
        break;
    case MessageMedia::typeMessageMediaGeo:
        media.setGeo(fetchGeoPoint());
        break;
    case MessageMedia::typeMessageMediaContact:
        media.setPhoneNumber(fetchQString());
        media.setFirstName(fetchQString());
        media.setLastName(fetchQString());
        media.setUserId(fetchInt());
        break;
    case MessageMedia::typeMessageMediaUnsupported:
        media.setBytes(fetchBytes());
        break;
    case MessageMedia::typeMessageMediaDocument:
        media.setDocument(fetchDocument());
        break;
    case MessageMedia::typeMessageMediaAudio:
        media.setAudio(fetchAudio());
        break;
    }
    return media;
}

Video InboundPkt::fetchVideo() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)Video::typeVideoEmpty || x == (qint32)Video::typeVideo);
    Video video((Video::VideoType)x);
    video.setId(fetchLong());
    if (x == (qint32)Video::typeVideo) {
        video.setAccessHash(fetchLong());
        video.setUserId(fetchInt());
        video.setDate(fetchInt());
        video.setCaption(fetchQString());
        video.setDuration(fetchInt());
        video.setMimeType(fetchQString());
        video.setSize(fetchInt());
        video.setThumb(fetchPhotoSize());
        video.setDcId(fetchInt());
        video.setW(fetchInt());
        video.setH(fetchInt());
    }
    return video;
}

Document InboundPkt::fetchDocument() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)Document::typeDocumentEmpty || x == (qint32)Document::typeDocument);
    Document doc((Document::DocumentType)x);
    doc.setId(fetchLong());
    if (x == (qint32)Document::typeDocument) {
        doc.setAccessHash(fetchLong());
        doc.setUserId(fetchInt());
        doc.setDate(fetchInt());
        doc.setFileName(fetchQString());
        doc.setMimeType(fetchQString());
        doc.setSize(fetchInt());
        doc.setThumb(fetchPhotoSize());
        doc.setDcId(fetchInt());
    }
    return doc;
}

Audio InboundPkt::fetchAudio() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)Audio::typeAudioEmpty || x == (qint32)Audio::typeAudio);
    Audio audio((Audio::AudioType)x);
    audio.setId(fetchLong());
    if (x == (qint32)Audio::typeAudio) {
        audio.setAccessHash(fetchLong());
        audio.setUserId(fetchInt());
        audio.setDate(fetchInt());
        audio.setDuration(fetchInt());
        audio.setMimeType(fetchQString());
        audio.setSize(fetchInt());
        audio.setDcId(fetchInt());
    }
    return audio;
}

ChatParticipant InboundPkt::fetchChatParticipant() {
    ASSERT(fetchInt() == (qint32)ChatParticipant::typeChatParticipant);
    ChatParticipant cp;
    cp.setUserId(fetchInt());
    cp.setInviterId(fetchInt());
    cp.setDate(fetchInt());
    return cp;
}

ChatParticipants InboundPkt::fetchChatParticipants() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)ChatParticipants::typeChatParticipantsForbidden || x == (qint32)ChatParticipants::typeChatParticipants);
    ChatParticipants cps((ChatParticipants::ChatParticipantsType)x);
    cps.setChatId(fetchInt());
    if (x == (qint32)ChatParticipants::typeChatParticipants) {
        cps.setAdminId(fetchInt());
        ASSERT(fetchInt() == (qint32)TL_Vector);
        qint32 n = fetchInt();
        QList<ChatParticipant> participants;
        for (qint32 i = 0; i < n; i++) {
            participants.append(fetchChatParticipant());
        }
        cps.setParticipants(participants);
        cps.setVersion(fetchInt());
    }
    return cps;
}

ContactsMyLink InboundPkt::fetchContactsMyLink() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)ContactsMyLink::typeContactsMyLinkEmpty ||
             x == (qint32)ContactsMyLink::typeContactsMyLinkRequested ||
             x == (qint32)ContactsMyLink::typeContactsMyLinkContact);
    ContactsMyLink myLink((ContactsMyLink::ContactsMyLinkType)x);
    if (x == (qint32)ContactsMyLink::typeContactsMyLinkRequested) {
        myLink.setContact(fetchBool());
    }
    return myLink;
}

ContactsForeignLink InboundPkt::fetchContactsForeignLink() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)ContactsForeignLink::typeContactsForeignLinkUnknown ||
             x == (qint32)ContactsForeignLink::typeContactsForeignLinkRequested ||
             x == (qint32)ContactsForeignLink::typeContactsForeignLinkMutual);
    ContactsForeignLink foreignLink((ContactsForeignLink::ContactsForeignLinkType)x);
    if (x == (qint32)ContactsForeignLink::typeContactsForeignLinkRequested) {
        foreignLink.setHasPhone(fetchBool());
    }
    return foreignLink;
}

GeoChatMessage InboundPkt::fetchGeoChatMessage() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)GeoChatMessage::typeGeoChatMessageEmpty ||
             x == (qint32)GeoChatMessage::typeGeoChatMessage ||
             x == (qint32)GeoChatMessage::typeGeoChatMessageService);
    GeoChatMessage msg((GeoChatMessage::GeoChatMessageType)x);
    msg.setChatId(fetchInt());
    msg.setId(fetchInt());
    if (x != (qint32)GeoChatMessage::typeGeoChatMessageEmpty) {
        msg.setFromId(fetchInt());
        msg.setDate(fetchInt());
        if (x == (qint32)GeoChatMessage::typeGeoChatMessage) {
            msg.setMessage(fetchQString());
            msg.setMedia(fetchMessageMedia());
        } else if (x == (qint32)GeoChatMessage::typeGeoChatMessageService) {
            msg.setAction(fetchMessageAction());
        }
    }
    return msg;
}

Contact InboundPkt::fetchContact() {
    ASSERT(fetchInt() == (qint32)Contact::typeContact);
    Contact c;
    c.setUserId(fetchInt());
    c.setMutual(fetchBool());
    return c;
}

Update InboundPkt::fetchUpdate() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)Update::typeUpdateNewMessage ||
             x == (qint32)Update::typeUpdateMessageID ||
             x == (qint32)Update::typeUpdateReadMessages ||
             x == (qint32)Update::typeUpdateDeleteMessages ||
             x == (qint32)Update::typeUpdateRestoreMessages ||
             x == (qint32)Update::typeUpdateUserTyping ||
             x == (qint32)Update::typeUpdateChatUserTyping ||
             x == (qint32)Update::typeUpdateChatParticipants ||
             x == (qint32)Update::typeUpdateUserStatus ||
             x == (qint32)Update::typeUpdateUserName ||
             x == (qint32)Update::typeUpdateUserPhoto ||
             x == (qint32)Update::typeUpdateContactRegistered ||
             x == (qint32)Update::typeUpdateContactLink ||
             x == (qint32)Update::typeUpdateActivation ||
             x == (qint32)Update::typeUpdateNewAuthorization ||
             x == (qint32)Update::typeUpdateNewGeoChatMessage ||
             x == (qint32)Update::typeUpdateNewEncryptedMessage ||
             x == (qint32)Update::typeUpdateEncryptedChatTyping ||
             x == (qint32)Update::typeUpdateEncryption ||
             x == (qint32)Update::typeUpdateEncryptedMessagesRead ||
             x == (qint32)Update::typeUpdateChatParticipantAdd ||
             x == (qint32)Update::typeUpdateChatParticipantDelete ||
             x == (qint32)Update::typeUpdateDcOptions ||
             x == (qint32)Update::typeUpdateUserBlocked ||
             x == (qint32)Update::typeUpdateNotifySettings);
    Update update((Update::UpdateType)x);
    switch (x) {
    case Update::typeUpdateNewMessage:
        update.setMessage(fetchMessage());
        update.setPts(fetchInt());
        break;
    case Update::typeUpdateMessageID:
        update.setId(fetchInt());
        update.setRandomId(fetchLong());
        break;
    case Update::typeUpdateReadMessages:
    case Update::typeUpdateDeleteMessages:
    case Update::typeUpdateRestoreMessages: {
        ASSERT(fetchInt() == (qint32)TL_Vector);
        qint32 n = fetchInt();
        QList<qint32> messages;
        for (qint32 i = 0; i < n; i++) {
            messages.append(fetchInt());
        }
        update.setMessages(messages);
        update.setPts(fetchInt());
        break;
    }
    case Update::typeUpdateUserTyping:
        update.setUserId(fetchInt());
        break;
    case Update::typeUpdateChatUserTyping:
        update.setChatId(fetchInt());
        update.setUserId(fetchInt());
        break;
    case Update::typeUpdateChatParticipants:
        update.setParticipants(fetchChatParticipants());
        break;
    case Update::typeUpdateUserStatus:
        update.setUserId(fetchInt());
        update.setStatus(fetchUserStatus());
        break;
    case Update::typeUpdateUserName:
        update.setUserId(fetchInt());
        update.setFirstName(fetchQString());
        update.setLastName(fetchQString());
        break;
    case Update::typeUpdateUserPhoto:
        update.setUserId(fetchInt());
        update.setDate(fetchInt());
        update.setPhoto(fetchUserProfilePhoto());
        update.setPrevious(fetchBool());
        break;
    case Update::typeUpdateContactRegistered:
        update.setUserId(fetchInt());
        update.setDate(fetchInt());
        break;
    case Update::typeUpdateContactLink:
        update.setUserId(fetchInt());
        update.setMyLink(fetchContactsMyLink());
        update.setForeignLink(fetchContactsForeignLink());
        break;
    case Update::typeUpdateActivation:
        update.setUserId(fetchInt());
        break;
    case Update::typeUpdateNewAuthorization:
        update.setAuthKeyId(fetchLong());
        update.setDate(fetchInt());
        update.setDevice(fetchQString());
        update.setLocation(fetchQString());
        break;
    case Update::typeUpdateNewGeoChatMessage:
        update.setMessage(fetchGeoChatMessage());
        break;
    case Update::typeUpdateNewEncryptedMessage:
        update.setEncryptedMessage(fetchEncryptedMessage());
        update.setQts(fetchInt());
        break;
    case Update::typeUpdateEncryptedChatTyping:
        update.setChatId(fetchInt());
        break;
    case Update::typeUpdateEncryption:
        update.setChat(fetchEncryptedChat());
        update.setDate(fetchInt());
        break;
    case Update::typeUpdateEncryptedMessagesRead:
        update.setChatId(fetchInt());
        update.setMaxDate(fetchInt());
        update.setDate(fetchInt());
        break;
    case Update::typeUpdateChatParticipantAdd:
        update.setChatId(fetchInt());
        update.setUserId(fetchInt());
        update.setInviterId(fetchInt());
        update.setVersion(fetchInt());
        break;
    case Update::typeUpdateChatParticipantDelete:
        update.setChatId(fetchInt());
        update.setUserId(fetchInt());
        update.setVersion(fetchInt());
        break;
    case Update::typeUpdateDcOptions: {
        ASSERT(fetchInt() == (qint32)TL_Vector);
        qint32 n = fetchInt();
        QList<DcOption> dcOptions;
        for (qint32 i = 0; i < n; i++) {
            dcOptions.append(fetchDcOption());
        }
        update.setDcOptions(dcOptions);
        break;
    }
    case Update::typeUpdateUserBlocked:
        update.setUserId(fetchInt());
        update.setBlocked(fetchBool());
        break;
    case Update::typeUpdateNotifySettings:
        update.setPeer(fetchNotifyPeer());
        update.setNotifySettings(fetchPeerNotifySetting());
        break;
    default:
        qDebug() << "Update received in a not contemplated option";
        break;
    }
    return update;
}

NotifyPeer InboundPkt::fetchNotifyPeer() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)NotifyPeer::typeNotifyPeer ||
             x == (qint32)NotifyPeer::typeNotifyUsers ||
             x == (qint32)NotifyPeer::typeNotifyChats ||
             x == (qint32)NotifyPeer::typeNotifyAll);
    NotifyPeer notifyPeer((NotifyPeer::NotifyPeerType)x);
    if (x == (qint32)NotifyPeer::typeNotifyPeer) {
        notifyPeer.setPeer(fetchPeer());
    }
    return notifyPeer;
}

ContactsLink InboundPkt::fetchContactsLink() {
    ASSERT(fetchInt() == (qint32)ContactsLink::typeContactsLink);
    ContactsLink link;
    link.setMyLink(fetchContactsMyLink());
    link.setForeignLink(fetchContactsForeignLink());
    link.setUser(fetchUser());
    return link;
}

ContactStatus InboundPkt::fetchContactStatus() {
    ASSERT(fetchInt() == (qint32)ContactStatus::typeContactStatus);
    ContactStatus status;
    status.setUserId(fetchInt());
    status.setExpires(fetchInt());
    return status;
}

ImportedContact InboundPkt::fetchImportedContact() {
    ASSERT(fetchInt() == (qint32)ImportedContact::typeImportedContact);
    ImportedContact ic;
    ic.setUserId(fetchInt());
    ic.setClientId(fetchLong());
    return ic;
}

ContactBlocked InboundPkt::fetchContactBlocked() {
    ASSERT(fetchInt() == (qint32)ContactBlocked::typeContactBlocked);
    ContactBlocked cb;
    cb.setUserId(fetchInt());
    cb.setDate(fetchDate());
    return cb;
}

StorageFileType InboundPkt::fetchStorageFileType() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)StorageFileType::typeStorageFileUnknown ||
             x == (qint32)StorageFileType::typeStorageFileJpeg ||
             x == (qint32)StorageFileType::typeStorageFileGif ||
             x == (qint32)StorageFileType::typeStorageFilePng ||
             x == (qint32)StorageFileType::typeStorageFilePdf ||
             x == (qint32)StorageFileType::typeStorageFileMp3 ||
             x == (qint32)StorageFileType::typeStorageFileMov ||
             x == (qint32)StorageFileType::typeStorageFilePartial ||
             x == (qint32)StorageFileType::typeStorageFileMp4 ||
             x == (qint32)StorageFileType::typeStorageFileWebp);
    StorageFileType sft((StorageFileType::StorageFileTypeType)x);
    return sft;
}

ChatFull InboundPkt::fetchChatFull() {
    ASSERT(fetchInt() == (qint32)ChatFull::typeChatFull);
    ChatFull c;
    c.setId(fetchInt());
    c.setParticipants(fetchChatParticipants());
    c.setChatPhoto(fetchPhoto());
    c.setNotifySettings(fetchPeerNotifySetting());
    return c;
}

EncryptedMessage InboundPkt::fetchEncryptedMessage() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)EncryptedMessage::typeEncryptedMessage || x == (qint32)EncryptedMessage::typeEncryptedMessageService);
    EncryptedMessage msg((EncryptedMessage::EncryptedMessageType)x);
    msg.setRandomId(fetchLong());
    msg.setChatId(fetchInt());
    msg.setDate(fetchInt());
    msg.setBytes(fetchBytes());
    if (x == (qint32)EncryptedMessage::typeEncryptedMessage) {
        msg.setFile(fetchEncryptedFile());
    }
    return msg;
}

EncryptedFile InboundPkt::fetchEncryptedFile() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)EncryptedFile::typeEncryptedFileEmpty || x == (qint32)EncryptedFile::typeEncryptedFile);
    EncryptedFile f((EncryptedFile::EncryptedFileType)x);
    if (x == (qint32)EncryptedFile::typeEncryptedFile) {
        f.setId(fetchLong());
        f.setAccessHash(fetchLong());
        f.setSize(fetchInt());
        f.setDcId(fetchInt());
        f.setKeyFingerprint(fetchInt());
    }
    return f;
}



UpdatesState InboundPkt::fetchUpdatesState() {
    ASSERT(fetchInt() == (qint32)TL_UpdatesState);
    UpdatesState us;
    us.setPts(fetchInt());
    us.setQts(fetchInt());
    us.setDate(fetchInt());
    us.setSeq(fetchInt());
    us.setUnreadCount(fetchInt());
    return us;
}

EncryptedChat InboundPkt::fetchEncryptedChat() {
    qint32 x = fetchInt();
    ASSERT(x == (qint32)EncryptedChat::typeEncryptedChatEmpty ||
           x == (qint32)EncryptedChat::typeEncryptedChatWaiting ||
           x == (qint32)EncryptedChat::typeEncryptedChatRequested ||
           x == (qint32)EncryptedChat::typeEncryptedChat ||
           x == (qint32)EncryptedChat::typeEncryptedChatDiscarded);
    EncryptedChat chat((EncryptedChat::EncryptedChatType)x);
    chat.setId(fetchInt());
    if (x == (qint32)EncryptedChat::typeEncryptedChatWaiting ||
            x == (qint32)EncryptedChat::typeEncryptedChatRequested ||
            x == (qint32)EncryptedChat::typeEncryptedChat) {
        chat.setAccessHash(fetchLong());
        chat.setDate(fetchInt());
        chat.setAdminId(fetchInt());
        chat.setParticipantId(fetchInt());
        if (x == (qint32)EncryptedChat::typeEncryptedChatRequested) {
            chat.setGA(fetchBytes());
        } else if (x == (qint32)EncryptedChat::typeEncryptedChat){
            chat.setGAOrB(fetchBytes());
            chat.setKeyFingerprint(fetchLong());
        }
    }
    return chat;
}
