import 'package:bitcoin_ticker/crypto-card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'const.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String cryptoSelected = 'DOGE';
  String selectedCurrency = 'USD';
  List<String> values = ['?', '?', '?'];

  List<Widget> getCards() {
    List<Widget> cards = [];
    for (int i = 0; i < cryptoList.length; i++) {
      cryptoSelected = cryptoList[i];
      cards.add(cryptoCard(
          coinName: cryptoList[i],
          selectedCurrency: selectedCurrency,
          bitcoinValueInCurrency: values[i]));
    }
    return cards;
  }

  void getData() async {
    for (int i = 0; i < 3; i++) {
      try {
        double data = await coinData.getCoinData(
            selectedCurrency: selectedCurrency, crypto: cryptoList[i]);
        setState(() {
          values[i] = data.toStringAsFixed(3);
          print('Got data succesfully');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  DropdownButton<String> androidPicker() {
    List<DropdownMenuItem<String>> currencies = [];
    for (String currency in currenciesList) {
      var item = DropdownMenuItem(child: Text(currency), value: currency);
      currencies.add(item);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
      items: currencies,
    );
  }

  CupertinoTheme IOSpicker() {
    List<Widget> currencies = [];
    for (String currency in currenciesList) {
      var item = Text(currency);
      currencies.add(item);
    }

    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          pickerTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      child: CupertinoPicker(
        itemExtent: 32,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];
            getData();
          });
        },
        children: currencies,
      ),
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return IOSpicker();
    } else if (Platform.isAndroid) {
      return androidPicker();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Crypto prices'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            //padding: EdgeInsets.only(bottom: 30.0),
            color: mainColor,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
