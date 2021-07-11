import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Authentication/MyPage.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Store/BSTransaction.dart';
import 'package:selling_pictures_platform/Store/like.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';

import '../LEEWAY.dart';
import '../main.dart';
import 'GetLikeItemsModel.dart';
import 'bottom_navigation.dart';

List<String> shipsDays = ["選択してください", "1~2日後", "2~3日後", "4~7日後"];

List<MapEntry<String, Color>> color1 = [
  MapEntry("レッド", Colors.redAccent),
  MapEntry(
    "ブルー",
    Colors.blueAccent,
  ),
  MapEntry(
    "グリーン",
    Colors.green,
  ),
  MapEntry(
    "イエロー",
    Colors.yellowAccent,
  ),
  MapEntry(
    "ホワイト",
    Colors.white,
  ),
  MapEntry(
    "ブラック",
    Colors.black,
  ),
  MapEntry(
    "パープル",
    Colors.deepPurple,
  ),
  MapEntry(
    "グレー",
    Colors.grey,
  ),
  MapEntry(
    "ピンク",
    Colors.pinkAccent,
  ),
  MapEntry(
    "オレンジ",
    Colors.deepOrangeAccent,
  ),
  MapEntry(
    "ブラウン",
    Colors.brown,
  ),
  MapEntry(
    "その他",
    Colors.black54,
  ),
];
List<MapEntry<String, Color>> color2 = [
  MapEntry("レッド", Colors.redAccent),
  MapEntry(
    "ブルー",
    Colors.blueAccent,
  ),
  MapEntry(
    "グリーン",
    Colors.green,
  ),
  MapEntry(
    "イエロー",
    Colors.yellowAccent,
  ),
  MapEntry(
    "ホワイト",
    Colors.white54,
  ),
  MapEntry(
    "ブラック",
    Colors.black,
  ),
  MapEntry(
    "パープル",
    Colors.deepPurple,
  ),
  MapEntry(
    "グレー",
    Colors.grey,
  ),
  MapEntry(
    "ピンク",
    Colors.pinkAccent,
  ),
  MapEntry(
    "オレンジ",
    Colors.deepOrangeAccent,
  ),
  MapEntry(
    "ブラウン",
    Colors.brown,
  ),
  MapEntry(
    "無し",
    Colors.black54,
  ),
];
List<String> frame = ["額縁の有無", "有り", "無し"];

List<String> bankList = [
  "みずほ銀行",
  "三菱UFJ銀行",
  "三井住友銀行",
  "りそな銀行",
  "埼玉りそな銀行",
  "セブン銀行",
  "北海道銀行",
  "青森銀行",
  "みちのく銀行",
  "秋田銀行",
  "北都銀行",
  "荘内銀行",
  "山形銀行",
  "岩手銀行",
  "東北銀行",
  "七十七銀行",
  "東邦銀行",
  "群馬銀行",
  "足利銀行",
  "常陽銀行",
  "筑波銀行",
  "武蔵野銀行",
  "千葉銀行",
  "千葉興業銀行",
  "きらぼし銀行",
  "横浜銀行",
  "第四北越銀行",
  "山梨中央銀行",
  "八十二銀行",
  "北陸銀行",
  "富山銀行",
  "北國銀行",
  "福井銀行",
  "静岡銀行",
  "スルガ銀行",
  "清水銀行",
  "大垣共立銀行",
  "十六銀行",
  "三十三銀行",
  "百五銀行",
  "滋賀銀行",
  "京都銀行",
  "関西みらい銀行",
  "池田泉州銀行",
  "南都銀行",
  "紀陽銀行",
  "但馬銀行",
  "鳥取銀行",
  "山陰合同銀行",
  "中国銀行",
  "広島銀行",
  "山口銀行",
  "阿波銀行",
  "百十四銀行",
  "伊予銀行",
  "四国銀行",
  "福岡銀行",
  "筑邦銀行",
  "佐賀銀行",
  "十八親和銀行",
  "肥後銀行",
  "大分銀行",
  "宮崎銀行",
  "鹿児島銀行",
  "琉球銀行",
  "沖縄銀行",
  "西日本シティ銀行",
  "北九州銀行",
  "三菱ＵＦＪ信託銀行",
  "みずほ信託銀行",
  "三井住友信託銀行",
  "野村信託銀行",
  "新生銀行",
  "あおぞら銀行",
  "シティバンク、エヌ・エイ",
  "ジェー・ピー・モルガン・チェース・バンク・ナショナル・アソシエーション",
  "北洋銀行",
  "きらやか銀行",
  "北日本銀行",
  "仙台銀行",
  "福島銀行",
  "大東銀行",
  "東和銀行",
  "栃木銀行",
  "京葉銀行",
  "東日本銀行",
  "東京スター銀行",
  "神奈川銀行",
  "大光銀行",
  "長野銀行",
  "富山第一銀行",
  "福邦銀行",
  "静岡中央銀行",
  "愛知銀行",
  "名古屋銀行",
  "中京銀行",
  "みなと銀行",
  "島根銀行",
  "トマト銀行",
  "もみじ銀行",
  "西京銀行",
  "徳島大正銀行",
  "香川銀行",
  "愛媛銀行",
  "高知銀行",
  "福岡中央銀行",
  "佐賀共栄銀行",
  "長崎銀行",
  "熊本銀行",
  "豊和銀行",
  "宮崎太陽銀行",
  "南日本銀行",
  "沖縄海邦銀行",
  "農林中央金庫",
  "イオン銀行",
  "ローソン銀行",
  "SMBC信託銀行",
  "ハナ銀行",
  "ブラジル銀行",
  "ユバフーアラブ・フランス連合銀行",
  "SBJ銀行",
  "中国工商銀行",
];
List gender = ["男性", "女性", "その他"];
List<String> year = [
  "1940",
  "1941",
  "1942",
  "1943",
  "1944",
  "1945",
  "1946",
  "1947",
  "1948",
  "1949",
  "1950",
  "1951",
  "1952",
  "1953",
  "1954",
  "1955",
  "1956",
  "1957",
  "1958",
  "1959",
  "1960",
  "1961",
  "1962",
  "1963",
  "1964",
  "1965",
  "1966",
  "1967",
  "1968",
  "1969",
  "1970",
  "1971",
  "1972",
  "1973",
  "1974",
  "1975",
  "1976",
  "1977",
  "1978",
  "1979",
  "1980",
  "1981",
  "1982",
  "1983",
  "1984",
  "1985",
  "1986",
  "1987",
  "1988",
  "1989",
  "1990",
  "1991",
  "1992",
  "1993",
  "1994",
  "1995",
  "1996",
  "1997",
  "1998",
  "1999",
  "2000",
  "2001",
  "2002",
  "2003",
  "2004",
  "2005",
  "2006",
  "2007",
  "2008",
  "2009",
  "2010",
  "2011",
  "2012",
  "2013",
  "2014",
  "2015",
  "2016",
  "2017",
  "2018",
  "2019",
  "2020",
];
List<String> month = [
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "11",
  "12",
];
List<String> day = [
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "11",
  "12",
  "13",
  "14",
  "15",
  "16",
  "17",
  "18",
  "19",
  "20",
  "21",
  "22",
  "23",
  "24",
  "25",
  "26",
  "27",
  "28",
  "29",
  "30",
  "31",
];
List<String> shipsLabel = [
  "1~2日後",
  "3~4日後",
  "5~7日後",
];
List<String> shipsNoStockLabel = [
  "約１週間後",
  "約２週間後",
  "約３週間後",
  "１ヶ月以内",
];
List<String> isFrame = ["有り", "無し"];
List<String> shipsPayment = ["送料込み(出品者負担)", "送料別途(購入者負担)"];
List<String> howToCopy = ["業者への委託", "自己印刷"];
List<String> isStock = ["在庫なし(受注生産)", "在庫あり"];
List<String> cancelReason = [
  "購入者が誤って購入した",
  "出品情報や商品に\n不備が見つかった",
  "購入者からの連絡が無い",
  "上記以外の理由"
];
List<String> items = [
  "北海道",
  "青森県",
  "岩手県",
  "宮城県",
  "秋田県",
  "山形県",
  "福島県",
  "茨城県",
  "栃木県",
  "群馬県",
  "埼玉県",
  "千葉県",
  "東京都",
  "神奈川県",
  "新潟県",
  "富山県",
  "石川県",
  "福井県",
  "山梨県",
  "長野県",
  "岐阜県",
  "静岡県",
  "愛知県",
  "三重県",
  "滋賀県",
  "京都府",
  "大阪府",
  "兵庫県",
  "奈良県",
  "和歌山県",
  "鳥取県",
  "島根県",
  "岡山県",
  "広島県",
  "山口県",
  "徳島県",
  "香川県",
  "愛媛県",
  "高知県",
  "福岡県",
  "佐賀県",
  "長崎県",
  "熊本県",
  "大分県",
  "宮崎県",
  "鹿児島県",
  "沖縄県",
];
List<MapEntry<String, Widget>> storeItems = [
  MapEntry("images/painter1.png", BSTransaction()),
  MapEntry("images/painter2.png", LEEWAY()),
  MapEntry("", null),
  MapEntry("images/painter4.png", MainPage()),
  MapEntry("images/painter5.png", MainPage()),
  MapEntry("", null),
];

List<BottomNavigationEntity> navigationList = [
  BottomNavigationEntity(
      title: "ホーム", icon: Icon(Icons.home_outlined), page: StoreHome()),
  BottomNavigationEntity(
      title: "いいね",
      icon: new Stack(
        children: [
          Icon(
            Icons.favorite_outline_outlined,
          ),
          Positioned(
            //top: 0.1,
            //bottom: 3,
            left: 10,
            child: Stack(
              children: [
                Icon(
                  Icons.brightness_1,
                  size: 15,
                  color: mainColorOfLEEWAY,
                ),
                //todo: アイテムカウントの可視化
                Positioned(
                  //top: 0.1,
                  //bottom: 0.1,
                  left: 5,
                  child: Consumer<GetLikeItemsModel>(
                    builder: (context, model, child) {
                      final item = model.items;
                      return EcommerceApp.sharedPreferences
                                  .getStringList(EcommerceApp.userLikeList) ==
                              null
                          ? Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500),
                            )
                          : Text(
                              (EcommerceApp.sharedPreferences
                                          .getStringList(
                                              EcommerceApp.userLikeList)
                                          .length -
                                      1)
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500),
                            );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      page: LikePage()),
  // BottomNavigationEntity(
  //     title: "検索", icon: Icon(Icons.search), page: SearchProduct()),
  BottomNavigationEntity(
      title: "マイページ", icon: Icon(Icons.perm_identity), page: MyPage()),
];
