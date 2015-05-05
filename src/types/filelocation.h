/*
 * Copyright 2014 Canonical Ltd.
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
 * Authors:
 *      Roberto Mier
 *      Tiago Herrmann
 */

#ifndef FILELOCATION_H
#define FILELOCATION_H

#include <QObject>

class FileLocation
{
public:
    enum FileLocationType {
       typeFileLocation = 0x53d69076,
       typeFileLocationUnavailable = 0x7c596b46
    };

    FileLocation() :
        m_localId(0),
        m_secret(0),
        m_dcId(0),
        m_volumeId(0),
        m_classType(typeFileLocationUnavailable) {
    }

    FileLocation(FileLocationType classType) :
        m_localId(0),
        m_secret(0),
        m_dcId(0),
        m_volumeId(0) {
        m_classType = classType;
    }

    void setDcId(qint32 dcId) {
        m_dcId = dcId;
    }
    qint32 dcId() const {
        return m_dcId;
    }
    void setVolumeId(qint64 volumeId) {
        m_volumeId = volumeId;
    }
    qint64 volumeId() const {
        return m_volumeId;
    }
    void setLocalId(qint32 localId) {
        m_localId = localId;
    }
    qint32 localId() const {
        return m_localId;
    }
    void setSecret(qint64 secret) {
        m_secret = secret;
    }
    qint64 secret() const {
        return m_secret;
    }
    void setClassType(FileLocationType classType) {
        m_classType = classType;
    }
    FileLocationType classType() const {
        return m_classType;
    }

private:
    qint32 m_localId;
    qint64 m_secret;
    qint32 m_dcId;
    qint64 m_volumeId;
    FileLocationType m_classType;
};
#endif // FILELOCATION_H
