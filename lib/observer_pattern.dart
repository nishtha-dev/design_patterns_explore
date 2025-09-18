import 'dart:async';

import 'package:flutter/material.dart';

abstract class Subject {
  int _temp = 0;
  List<Observer> observers = [];
  void addObserver(Observer observer) {
    observers.add(observer);
  }

  void removeObserver(Observer observer) {
    observers.remove(observer);
  }

  void notifyObservers() {
    for (Observer observer in observers) {
      observer.update(_temp);
    }
  }
}

class WeatherClass extends Subject {
  void setTemp(int temp) {
    _temp = temp;
    notifyObservers();
  }
}

abstract class Observer {
  void update(int temp);
}

class Phone implements Observer {
  int _temp = 0;
  @override
  void update(int temp) {
    _temp = temp;
    print("update Phone temp $temp");
  }
}

class Television implements Observer {
  int _temp = 0;
  @override
  void update(int temp) {
    _temp = temp;
    print("update Television temp $temp");
  }
}

void main() {
  Phone phone1 = Phone();
  Phone phone2 = Phone();
  Television television = Television();

  WeatherClass weatherClass = WeatherClass();

  weatherClass.addObserver(phone1);
  weatherClass.addObserver(phone2);
  weatherClass.addObserver(television);

  weatherClass.setTemp(23);
  weatherClass.setTemp(25);

  weatherClass.removeObserver(phone2);

  weatherClass.setTemp(16);
}

enum ChangeDirection { positve, negative }

enum StockTickerSymbol {
  GME,
  GOOGL,
  TSLA,
}

abstract class StockSubscriber {
  late final String title;
  final id = 2;
  void update(Stock stock);

  // more functions needed
  @protected
  final StreamController<Stock> stockStreamController =
      StreamController.broadcast();

  Stream<Stock> get stockStream => stockStreamController.stream;
}

class DefaultStockSubscriber extends StockSubscriber {
  DefaultStockSubscriber() {
    title = 'All stocks';
  }

  @override
  void update(Stock stock) {
    stockStreamController.add(stock);
  }
}

class Stock {
  final double price;
  final StockTickerSymbol name;
  final ChangeDirection changeDirection;
  final double changePrice;

  const Stock(
      {required this.changeDirection,
      required this.changePrice,
      required this.name,
      required this.price});
}

base class StockTicker {
  late final String title;
  late final Timer stockTimer;

  @protected
  Stock? stock;

  List<StockSubscriber> stockSubscriber = [];
  void addObserver(StockSubscriber observer) {
    stockSubscriber.add(observer);
  }

  void removeObserver(StockSubscriber observer) {
    stockSubscriber.removeWhere((obs) => obs.id == observer.id);
  }

  void notifyObservers() {
    for (StockSubscriber obs in stockSubscriber) {
      obs.update(stock!);
    }
  }

  // more functions
  void stopTicker() => stockTimer.cancel();
  void setStock(StockTickerSymbol symbol, int min, int max) {
    final lastStock = stock;
    // final newPrice = faker.randomGenerator.integer(max, min: min) / 100;
    const newPrice = 1000 / 100;
    final changeAmount = lastStock != null ? newPrice - lastStock.price : 100;

    stock = Stock(
        changeDirection: changeAmount > 0
            ? ChangeDirection.positve
            : ChangeDirection.negative,
        changePrice: changeAmount.toDouble(),
        name: symbol,
        price: newPrice);
  }
}

final class GoogleStockTicker extends StockTicker {
  GoogleStockTicker() {
    title = StockTickerSymbol.GME.name;
    stockTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      setStock(StockTickerSymbol.GME, 100, 1000);
      notifyObservers();
    });
  }
}
