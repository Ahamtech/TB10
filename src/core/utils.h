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

#ifndef UTILS_H
#define UTILS_H

#ifdef DEBUG
#define RES_PRE 8
#define RES_AFTER 8
#define MAX_BLOCKS 1000000
void *blocks[MAX_BLOCKS];
void *free_blocks[MAX_BLOCKS];
qint32 usedBlocks;
qint32 freeBlocksCnt;
#endif

#include <QObject>
#include <openssl/bn.h>
#include "constants.h"
#include <bb/device/HardwareInfo>
using namespace bb::device;
class bb::device::HardwareInfo;
class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = 0);

    static qint32 randomBytes(void *buffer, qint32 count);
    static qint32 serializeBignum(BIGNUM *b, char *buffer, qint32 maxlen);
    static double getUTime(qint32 clockId);
    static quint64 gcd (quint64 a, quint64 b);

    static RSA *rsaLoadPublicKey ();
    static qint64 computeRSAFingerprint(RSA *key);

    static qint32 check_g (uchar p[256], BIGNUM *g);
    static qint32 check_g_bn (BIGNUM *p, BIGNUM *g);

    static void ensure(qint32 r);
    static void ensurePtr(void *p);
    static void freeSecure (void *ptr, qint32 size);

    static void *talloc(size_t size);
    static qint32 tinflate (void *input, qint32 ilen, void *output, qint32 olen);

    static QString toHex(qint32 x);
    static QString toHex(void *buffer, qint32 size);

    static BIGNUM *padBytesAndGetBignum(const QByteArray &bytes);
    static BIGNUM *bytesToBignum(const QByteArray &bytes);
    static QByteArray bignumToBytes(BIGNUM *bignum);
    static qint64 getKeyFingerprint(uchar *sharedKey);

    static QString getDeviceModel();
    static QString getSystemVersion();
    static QString getAppVersion();

    static qint64 getMediaDuration(const QString &resource, const QString &type);
    static QString createThumbnail(const QString &resource);

    static QString parsePhoneNumberDigits(const QString &phoneNumber);
};

#endif // UTILS_H
