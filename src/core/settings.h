/*
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

#ifndef SETTINGS_H
#define SETTINGS_H

#define PROG_NAME "libqtelegram"
#define CONFIG_DIRECTORY "." PROG_NAME
#define CONFIG_FILE "config"
#define AUTH_KEY_FILE "auth"
#define STATE_FILE "state"
#define SECRET_CHAT_FILE "secret"
#define DEFAULT_CONFIG_CONTENTS     \
  "# This is an empty config file\n" \
  "# Feel free to put something here\n"
#define ST_DC_NUM "dcNum"
#define ST_AUTH_FILE "authFile"
#define ST_SECRET "secret"
#define ST_DOWNLOADS "downloads"
#define ST_STATE_FILE "stateFile"
#define ST_TEST_MODE "testMode"
#define ST_MANAGED_DOWNLOADS "managedDownloads"
#define ST_LANG_CODE "lang"
#define ST_RESEND_QUERIES "resendQueries"

#define ST_WORKING_DC_NUM "workingDcNum"
#define ST_DC_STATE "state"
#define ST_OUR_ID "ourId"
#define ST_DCS_ARRAY "dcs"
#define ST_HOST "host"
#define ST_PORT "port"
#define ST_AUTH_KEY_ID "authKeyId"
#define ST_AUTH_KEY "authKey"
#define ST_SERVER_SALT "serverSalt"
#define ST_EXPIRES "expires"
#define ST_PRODUCTION "production"
#define ST_TEST "test"

#define ST_VERSION "version"
#define ST_G "g"
#define ST_P "p"
#define ST_SECRET_CHATS_ARRAY "secretChats"
#define ST_CHAT_ID "chatId"
#define ST_ACCESS_HASH "accessHash"
#define ST_ADMIN_ID "adminId"
#define ST_PARTICIPANT_ID "participantId"
#define ST_DATE "date"
#define ST_SHARED_KEY "sharedKey"
#define ST_LAYER "layer"
#define ST_IN_SEQ_NO "inSeqNo"
#define ST_OUT_SEQ_NO "outSeqNo"
#define ST_LAST_IN_SEQ_NO "lastInSeqNo"

#define DEFAULT_CONFIG_PATH "libqtelegram"
#define DEFAULT_PUBLIC_KEY_FILE "app/native/assets/tg.pub"

#include <QObject>
#include <QList>

#include <openssl/rsa.h>




class DC;

class Settings : public QObject
{
    Q_OBJECT
public:
    static Settings *getInstance();
    bool loadSettings();
    void writeAuthFile();
    void writeSecretFile();

    qint64 pkFingerprint() const { return m_pkFingerprint; }
    RSA* pubKey() { return m_pubKey; }
    qint32 workingDcNum() const { return m_workingDcNum; }
    qint32 ourId() const { return m_ourId; }
    QList<DC *> &dcsList() { return m_dcsList; }
    QString phoneNumber() const { return m_phoneNumber; }
    bool testMode() const { return m_testMode; }
    bool managedDownloads() const { return m_managedDownloads; }

    bool resendQueries() const { return mResendQueries; }
    qint32 version() const { return mVersion; }
    qint32 g() const { return mG; }
    QByteArray p() const { return mP; }

    void setWorkingDcNum(qint32 workingDcNum) { m_workingDcNum = workingDcNum; }
    void setOurId(qint32 ourId) { m_ourId = ourId; }
    void setDcsList(const QList<DC *> &dcsList) { m_dcsList = dcsList; }
//    void setVersion(qint32 version) { mVersion = version; }
    void setG(qint32 g) { mG = g; }
    void setP(const QByteArray &p) { mP = p; }


    bool removeAuthFile();
    void writeCrashFile();
    void readAuthFile();
private:
    Settings();
    ~Settings();
    Settings(const Settings &); // hide copy constructor
    Settings& operator=(const Settings &); // hide asignment


    void readSecretFile();

    qint64 m_pkFingerprint;
    RSA *m_pubKey;
    QString m_authFilename;
    QString m_secretChatFilename;
    QString m_stateFilename;
    qint32 m_workingDcNum;
    qint32 m_ourId;
    QList<DC *> m_dcsList;
    QString m_phoneNumber;
    QString m_baseConfigDirectory;
    // if true, all operations are performed against telegram test servers
    bool m_testMode;
    // if true, downloading a big file will be stored in byte array until completion and only one signal is emited when download finish
    // if false, every downloaded part is notified as a signal with the partial data. Default is false
    bool m_managedDownloads;

    QString m_langCode;
    // default is false. If true, queries not acked after 30 seconds will be re-sent
    bool mResendQueries;

    qint32 mVersion;
    qint32 mG;
    QByteArray mP;


};

#endif // SETTINGS_H
