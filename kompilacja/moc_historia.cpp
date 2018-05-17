/****************************************************************************
** Meta object code from reading C++ file 'historia.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.7.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../Glukometr/historia.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'historia.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.7.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_Historia_t {
    QByteArrayData data[9];
    char stringdata0[92];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Historia_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Historia_t qt_meta_stringdata_Historia = {
    {
QT_MOC_LITERAL(0, 0, 8), // "Historia"
QT_MOC_LITERAL(1, 9, 13), // "cukierChanged"
QT_MOC_LITERAL(2, 23, 0), // ""
QT_MOC_LITERAL(3, 24, 18), // "dataPomiaruChanged"
QT_MOC_LITERAL(4, 43, 12), // "kiedyChanged"
QT_MOC_LITERAL(5, 56, 10), // "kiedyTekst"
QT_MOC_LITERAL(6, 67, 6), // "cukier"
QT_MOC_LITERAL(7, 74, 11), // "dataPomiaru"
QT_MOC_LITERAL(8, 86, 5) // "kiedy"

    },
    "Historia\0cukierChanged\0\0dataPomiaruChanged\0"
    "kiedyChanged\0kiedyTekst\0cukier\0"
    "dataPomiaru\0kiedy"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Historia[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       4,   14, // methods
       3,   38, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   34,    2, 0x06 /* Public */,
       3,    0,   35,    2, 0x06 /* Public */,
       4,    0,   36,    2, 0x06 /* Public */,

 // methods: name, argc, parameters, tag, flags
       5,    0,   37,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // methods: parameters
    QMetaType::QString,

 // properties: name, type, flags
       6, QMetaType::Float, 0x00495103,
       7, QMetaType::QDateTime, 0x00495103,
       8, QMetaType::QString, 0x00495001,

 // properties: notify_signal_id
       0,
       1,
       2,

       0        // eod
};

void Historia::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Historia *_t = static_cast<Historia *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->cukierChanged(); break;
        case 1: _t->dataPomiaruChanged(); break;
        case 2: _t->kiedyChanged(); break;
        case 3: { QString _r = _t->kiedyTekst();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = _r; }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (Historia::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&Historia::cukierChanged)) {
                *result = 0;
                return;
            }
        }
        {
            typedef void (Historia::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&Historia::dataPomiaruChanged)) {
                *result = 1;
                return;
            }
        }
        {
            typedef void (Historia::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&Historia::kiedyChanged)) {
                *result = 2;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        Historia *_t = static_cast<Historia *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< float*>(_v) = _t->getCukier(); break;
        case 1: *reinterpret_cast< QDateTime*>(_v) = _t->getDataPomiaru(); break;
        case 2: *reinterpret_cast< QString*>(_v) = _t->kiedyTekst(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        Historia *_t = static_cast<Historia *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setCukier(*reinterpret_cast< float*>(_v)); break;
        case 1: _t->setDataPomiaru(*reinterpret_cast< QDateTime*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

const QMetaObject Historia::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_Historia.data,
      qt_meta_data_Historia,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *Historia::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Historia::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_Historia.stringdata0))
        return static_cast<void*>(const_cast< Historia*>(this));
    return QObject::qt_metacast(_clname);
}

int Historia::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 4)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 4;
    }
#ifndef QT_NO_PROPERTIES
   else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 3;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void Historia::cukierChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, Q_NULLPTR);
}

// SIGNAL 1
void Historia::dataPomiaruChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, Q_NULLPTR);
}

// SIGNAL 2
void Historia::kiedyChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, Q_NULLPTR);
}
QT_END_MOC_NAMESPACE
