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

#ifndef CONTACTSTATUS_H
#define CONTACTSTATUS_H

#include <QtGlobal>

class ContactStatus
{
public:

    enum ContactStatusType {
       typeContactStatus = 0xaa77b873
    };

    ContactStatus() :
        m_userId(0),
        m_expires(0),
        m_classType(typeContactStatus) {}

    void setUserId(qint32 userId) {
        m_userId = userId;
    }
    qint32 userId() const {
        return m_userId;
    }
    void setExpires(qint32 expires) {
        m_expires = expires;
    }
    qint32 expires() const {
        return m_expires;
    }
    void setClassType(ContactStatusType classType) {
        m_classType = classType;
    }
    ContactStatusType classType() const {
        return m_classType;
    }

private:
    qint32 m_userId;
    qint32 m_expires;
    ContactStatusType m_classType;
};
#endif // CONTACTSTATUS_H
