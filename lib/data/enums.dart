enum DayType {
  BIRTHDAY("생일"),
ANNIVERSARY("기념일"),
MONTH_PERIOD("월 반복"),
WEEK_PERIOD("주 반복"),
DAY_PERIOD("일 반복");

final String text;
const DayType(this.text);

bool get isPeriod => this == MONTH_PERIOD || this == WEEK_PERIOD || this == DAY_PERIOD;
}

enum DayMore {
  EDIT("수정"), DELETE("삭제");

final String text;
const DayMore(this.text);
}