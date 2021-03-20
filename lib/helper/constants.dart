import 'package:flutter/material.dart';

class Constants {
  static String appName = "အိမ်ထောင်သည် ကျန်းမာရေး";
  // https://mmsoftware100.com/content-100
  static String appPackage = "com.mmsoftware100.marriedhealth2";

  //OTP Setup
  static String msg91AuthKey="264945AeCxvjPPygN5c756de7";

  static String appAbout =
      "<h3>အိမ်ထောင်ရေး သာယာစေဖို့အတွက်</h3>"
      "<p>သင့်အနေနဲ့ အခုချိန် ကြင်စဦး အိမ်ထောင်ရှင်ဘဝကို တည်ထောင်ထားသူပဲ ဖြစ်ဖြစ်၊ ငွေရတု၊ ရွှေရတု ပေါင်းများစွာ အိမ်ထောင်သက် ကြာညောင်းနေသူပဲ ဖြစ်ဖြစ် သင့်အနေနဲ့ သံယောဇဉ်ကြိုးခိုင်မြဲပြီး ချစ်ခင်ကြင်နာမှု အပြည့်နဲ့ သစ္စာတရားပြည့်ဝနေတဲ့ အိမ်ထောင်ရေးကိုသာ လိုချင်ကြမှာ အမှန်ပါပဲ။ ဒီလို အိမ်ထောင်တစ်ခုလည်း ပိုင်ဆိုင်ချင်တယ်၊ ဒီလို ဖြစ်လာဖို့အတွက်လည်း ဘယ်လိုနည်းလမ်းတွေကို လုပ်ဆောင်ရမှန်း မသိဘူးဆိုရင် ကျွန်တော်တို့  မှ ခိုင်မာတဲ့ Relationship တစ်ခု တည်ဆောက်ချင်တယ်ဆိုရင် မမေ့သင့်တဲ့ အချက်လေးတွေကို ဖော်ပြသွားမှာ ဖြစ်ပါတယ်။</p>";

  static String appPrivacy = "<h3>Privacy Policy</h3>"
      "This Privacy Policy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in mmsoftware100. This policy is not applicable to any information collected offline or via channels other than this website. Our Privacy Policy was created with the help of the Privacy Policy Generator and the Free Privacy Policy Generator.";

  static Color lightPrimary = Colors.white;
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Color(0xff06d6a7);
  static Color darkAccent = Color(0xff06d6a7);
  static Color lightBG = Color(0xFFFAFAFA);
  static Color darkBG = Color(0xFF2C2C2C);

  static ThemeData lightTheme = ThemeData(
    fontFamily: "Poppins",
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontFamily: "Poppins",
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: "Poppins",
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontFamily: "Poppins",
          color: lightBG,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }
}
