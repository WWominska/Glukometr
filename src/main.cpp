#include <QtCore/QLoggingCategory>
#include <QScopedPointer>
#include <QQmlContext>
#include <QGuiApplication>
#include <QQuickView>
#include <QThread>
#include <QDebug>
#include <QSqlDatabase>
#include "Glucometer.h"
#include "BleDiscovery.h"
#include "database/DatabaseWorker.h"
#include "database/Settings.h"
#include "database/MeasurementsListManager.h"
#include <QDir>

#ifdef Q_OS_SAILFISH
#include <sailfishapp.h>
#else
#include <QQuickStyle>
#endif

int main(int argc, char *argv[])
{
#ifdef Q_OS_SAILFISH
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
#else
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QScopedPointer<QGuiApplication> app(new QGuiApplication(argc, argv));
#endif

#ifdef Q_OS_ANDROID
    QQuickStyle::setStyle("Material");
#endif
#ifdef Q_OS_WIN
    QQuickStyle::setStyle("Universal");
#endif
    qmlRegisterType<BleDiscovery>("glukometr", 1, 0, "BleDiscovery");
    qmlRegisterType<Glucometer>("glukometr", 1, 0, "Glucometer");
    qmlRegisterUncreatableType<SqlQueryModel>("glukometr", 1, 0, "SqlQuery", "");

    // Initialize DB
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", "Database");
    db.setDatabaseName("com.glukometr.db");
    qDebug() << QDir::currentPath();
    db.open();

    // Initialize Settings and a Worker
    Settings* settings = new Settings();
    DatabaseWorker* worker = new DatabaseWorker();

    // Move DatabaseWorker to a thread
    QThread* dbThread = new QThread();
    worker->moveToThread(dbThread);
    dbThread->start(QThread::LowestPriority);

    // Initialize and register managers
    MeasurementsListManager *measurements = new MeasurementsListManager(worker, 0);

    QQuickView *view = new QQuickView;

    // register context properties
    view->rootContext()->setContextProperty("appSettings", settings);
    view->rootContext()->setContextProperty("measurements", measurements);

    // load QML file and start the app
    view->setSource(QUrl("qrc:/assets/main.qml"));
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->show();

    // start app
    const int retVal = app->exec();

    // handle quit gracefully
    delete measurements;
    delete settings;
    delete worker;
    dbThread->exit();
    // dbThread->requestInterruption();
    // dbThread->wait();
    delete dbThread;

    // return value
    return retVal;
}
