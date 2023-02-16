
import 'dart:convert';

import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:tg_bot/tg_bot.dart' as tg_bot;

Future<void> main() async {

  var BOT_TOKEN = '5956688136:AAEY69kYZgkrwq5HvnpDQ88a4yCuPLXMIsY';
  final username = (await Telegram(BOT_TOKEN).getMe()).username;
  var teledart = TeleDart(BOT_TOKEN, Event(username!));
  final replyMarkup = ReplyKeyboardMarkup(
    keyboard: [
      [KeyboardButton(text: 'Каталог')],
      [KeyboardButton(text: 'Корзина')],
      [KeyboardButton(text: 'Мои заказы')],
    ],
    resizeKeyboard: true,
    oneTimeKeyboard: false,
    selective: false,
  );
  final replyMarkup2 = InlineKeyboardMarkup(inlineKeyboard: [
    [
      InlineKeyboardButton(text: 'Футболки', callbackData: 'shirts'),
      InlineKeyboardButton(text: 'Куртки', callbackData: 'jackets'),
    ],
    [
      InlineKeyboardButton(text: 'Штаны', callbackData: 'pants'),
      InlineKeyboardButton(text: 'Носки', callbackData: 'socks'),
    ],
  ]);
  List products = [
    {'name': 'Футболка Nike', 'type': 'shirt', 'img': 'https://ir.ozone.ru/s3/multimedia-9/c1000/6378841833.jpg', 'price': 100},
    {'name': 'Футболка Supreme', 'type': 'shirt', 'img': 'https://myinstalook.ru/5390-thickbox_default/futbolka-supreme-rozovaya.jpg', 'price': 100},
    {'name': 'Джинсы Balmain', 'type': 'pants', 'img': 'https://demiart.ru/forum/uploads20/post-2969703-1538912593-5bb9f1515179e.jpg', 'price': 100},
    {'name': 'Носки Abibas', 'type': 'socks', 'img': 'https://rskrf.ru/upload/iblock/d93/d9352bf38b5818186f5a214936c171e7.jpg', 'price': 100},
    {'name': 'Носки Nike', 'type': 'socks', 'img': 'https://main-cdn.sbermegamarket.ru/big1/hlr-system/-19/036/246/041/122/144/600009518065b0.webp', 'price': 100},
    {'name': 'Куртка Burberry', 'type': 'jacket', 'img': 'https://st.tsum.com/btrx/i/11/49/93/48/01_434.jpg?u=1603921263', 'price': 100},
  ];
  Map<int, List<Map<String, dynamic>>> carts = {};
  void addProductToCart(int userId, Map<String, dynamic> product) {
    if (carts.containsKey(userId)) {
      carts[userId]!.add(product);
    } else {
      carts[userId] = [product];
    }
  }

  void showCart(int userId) {
    if (carts.containsKey(userId)) {
      List<Map<String, dynamic>> productsInCart = carts[userId]!;
      Map<Map<String, dynamic>, int> count = {};
      String message = "Ваша корзина:\n";
      for (Map<String, dynamic> item in productsInCart){
        if (count.containsKey(item)){
          count[item] = count[item]! + 1;
          print(count);
        }else{
          count[item] = 1;
          print(count);
        }
      }
      int i = 0;
      int bill = 0;
      for(Map<String, dynamic> item in count.keys){

        message += "${i + 1}. ${item['name']} (${count[item]} шт.) - ${item['price'] * count[item]} руб.\n";
        bill += int.parse(item['price'].toString()) * count[item]!.toInt();
        i++;
      }
      message += 'Итого к оплате: $bill руб.';

      teledart.sendMessage(userId, message, replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
        [InlineKeyboardButton(text: 'Оплатить ${bill} рублей', callbackData: 'payment'),],
        [InlineKeyboardButton(text: 'Очистить корзину', callbackData: 'clean'),]
      ]));
    } else {
      teledart.sendMessage(userId, "Ваша корзина пуста");
    }
  }
  teledart.start();




  teledart.onCallbackQuery().listen((callbackQuery) {
    switch (callbackQuery.data) {
      case 'jackets':
        for (int i = 0; i < products.length; i++){
          if(products[i]['type'] == 'jacket'){
            teledart.sendPhoto(callbackQuery.message!.chat.id, '${products[i]['img']}', caption: '<b>${products[i]['name']}</b>\n\n Цена: ${products[i]['price']} руб.', parseMode: 'html',
            replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
              [InlineKeyboardButton(text: 'Добавить в корзину', callbackData: 'add_to_cart_$i'),]
            ])
            );
          }
        }
        break;

      case 'shirts':
        for (int i = 0; i < products.length; i++){
          if(products[i]['type'] == 'shirt'){
            teledart.sendPhoto(callbackQuery.message!.chat.id, '${products[i]['img']}', caption: '<b>${products[i]['name']}</b>\n\n Цена: ${products[i]['price']} руб.', parseMode: 'html',
                replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
                  [InlineKeyboardButton(text: 'Добавить в корзину', callbackData: 'add_to_cart_$i'),]
                ])
            );
          }
        }
        break;

      case 'pants':
        for (int i = 0; i < products.length; i++){
          if(products[i]['type'] == 'pants'){
            teledart.sendPhoto(callbackQuery.message!.chat.id, '${products[i]['img']}', caption: '<b>${products[i]['name']}</b>\n\n Цена: ${products[i]['price']} руб.', parseMode: 'html',
                replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
                  [InlineKeyboardButton(text: 'Добавить в корзину', callbackData: 'add_to_cart_$i'),]
                ])
            );
          }
        }
        break;

      case 'socks':
        for (int i = 0; i < products.length; i++){
          if(products[i]['type'] == 'socks'){
            teledart.sendPhoto(callbackQuery.message!.chat.id, '${products[i]['img']}', caption: '<b>${products[i]['name']}</b>\n\n Цена: ${products[i]['price']} руб.', parseMode: 'html',
                replyMarkup: InlineKeyboardMarkup(inlineKeyboard: [
                  [InlineKeyboardButton(text: 'Добавить в корзину', callbackData: 'add_to_cart_$i'),]
                ])
            );
          }
        }
        break;



      default:

        break;
    }
    if (callbackQuery.data!.startsWith('add_to_cart_')) {
      print(callbackQuery.data);
  
      int productId = int.parse(callbackQuery.data!.split('_')[3]);
      Map<String, dynamic> product = products[productId];
      try {
        addProductToCart(callbackQuery.message!.chat.id, product);
        teledart.sendMessage(callbackQuery.message!.chat.id, 'Продукт <b>${product['name']}</b> добавлен в корзину!', parseMode: 'html');
 
      } catch (e) {
        print(e);
        teledart.sendMessage(callbackQuery.message!.chat.id, 'Ошибка при добавлении продукта в корзину');
      }
    }
  });


  teledart.onCommand('start').listen((message) => teledart.sendMessage(message.chat.id, 'Привет, ${message.chat.firstName}\nДобро пожаловать в наш онлайн магазин, где тебя ждет множество вариантов для выбора. У нас всегда много интересного, так что давай начнем шопинг!', replyMarkup: replyMarkup, parseMode: 'html'));

  teledart.onMessage(keyword: 'Каталог').listen((message) => teledart.sendMessage(message.chat.id, 'Выберете категорию', replyMarkup: replyMarkup2));
  teledart.onMessage(keyword: 'Корзина').listen((message) => showCart(message.chat.id));

}

