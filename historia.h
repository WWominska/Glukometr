#ifndef HISTORIA_H
#define HISTORIA_H

#include <QDateTime>
#include <QObject>

class Historia : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float cukier READ getCukier WRITE setCukier NOTIFY cukierChanged)
    Q_PROPERTY(QDateTime dataPomiaru READ getDataPomiaru WRITE setDataPomiaru NOTIFY dataPomiaruChanged)
    Q_PROPERTY(QString kiedy READ kiedyTekst NOTIFY kiedyChanged)

public:
    explicit Historia(float _cukier, QDateTime _dataPomiaru, QObject * parent = 0):
        QObject(parent), dataPomiaru(_dataPomiaru), cukier(_cukier)
    {
        kiedy = 0;
    }

    Q_INVOKABLE QString kiedyTekst()
    {
        switch (this->kiedy)
        {
            case 0: return "Nie określono";
            case 1: return "Przed posiłkiem";
            case 2: return "Po posiłku";
            case 3: return "Na czczo";
        }
    }

    void setCukier(float cukier)
    {
        this->cukier = cukier;
        emit cukierChanged();
    }

    void setDataPomiaru(QDateTime dataPomiaru)
    {
        this->dataPomiaru = dataPomiaru;
        emit dataPomiaruChanged();
    }

    void setKiedy (int kiedy)
    {
        this->kiedy = kiedy;
        emit kiedyChanged();
    }

    const float getCukier()
    {
        return this->cukier;
    }

    const QDateTime getDataPomiaru()
    {
        return this->dataPomiaru;
    }

    const int getKiedy()
    {
        return this->kiedy;
    }
signals:
    void cukierChanged();
    void dataPomiaruChanged();
    void kiedyChanged();

public slots:

private:
    float cukier;
    QDateTime dataPomiaru;
    int kiedy;
};

#endif // HISTORIA_H
