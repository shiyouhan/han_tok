class BirthUtil {
  static String getAge(DateTime brt) {
    int age = 0;
    DateTime dateTime = DateTime.now();

    // if (dateTime.isAfter(brt)) {
    //   //出生日期晚于当前时间，无法计算
    //   return '出生日期不正確';
    // }
    int yearNow = dateTime.year; //当前年份
    int monthNow = dateTime.month; //当前月份
    int dayOfMonthNow = dateTime.day; //当前日期

    int yearBirth = brt.year;
    int monthBirth = brt.month;
    int dayOfMonthBirth = brt.day;
    age = yearNow - yearBirth; //计算整岁数
    if (monthNow <= monthBirth) {
      if (monthNow == monthBirth) {
        if (dayOfMonthNow < dayOfMonthBirth) age--; //当前日期在生日之前，年龄减一
      } else {
        age--; //当前月份在生日之前，年龄减一
      }
    }
    return age.toString();
  }
}
