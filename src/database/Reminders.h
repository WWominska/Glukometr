#ifndef REMINDERS_H
#define REMINDERS_H

#include <QObject>
#include <QDateTime>
#include <QProcess>
#include "BaseListManager.h"


class Reminders : public BaseListManager
{
    Q_OBJECT
public:
    explicit Reminders(DatabaseWorker* db, QObject *parent = nullptr);

    QString getTableName() const override;
    QString getCreateQuery() const override;

public slots:
    Q_INVOKABLE void cancel(int cookie);
    Q_INVOKABLE void cancelInvalidEvents();
    Q_INVOKABLE void clearExpiredReminders();
    Q_INVOKABLE void remind(
            QString title, int reminderType,
            QDateTime when, bool repeating=false);
    Q_INVOKABLE void remind(
            QString title, int reminderType,
            bool repeating=false);
    Q_INVOKABLE void remindInTwoHours();

private:
    QStringList callTimedClient(const QStringList &args);

};

#endif // REMINDERS_H
