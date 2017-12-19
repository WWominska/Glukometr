#include <QtCore/QLoggingCategory>
#include <QQmlContext>
#include <QGuiApplication>
#include <QQuickView>
#include "glukometr.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    Glukometr glukometr;
    QQuickView *view = new QQuickView;
    view->rootContext()->setContextProperty("glukometr", &glukometr);
    view->setSource(QUrl("qrc:/assets/main.qml"));
    view->setResizeMode(QQuickView::SizeRootObjectToView);
    view->show();
    return app.exec();

}
