import 'package:get/get.dart';
import 'package:mycalender/model/my_calender_model_class.dart';
import 'package:mycalender/utils/static_data.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class MyCalenderController extends GetxController{

  RxBool isDaySelected = true.obs;
  var calendarFormat = CalendarFormat.month.obs;
  var rangeSelectionMode = RangeSelectionMode.toggledOff.obs;
  Rx<DateTime?> focusedDay = Rx<DateTime?>(null);
  Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  Rx<DateTime?> rangeStart = Rx<DateTime?>(null);
  Rx<DateTime?> rangeEnd =  Rx<DateTime?>(null);
  RxList<MyCalenderModelClass> selectedDatesEventList = <MyCalenderModelClass>[].obs ;

  @override
  void onInit() {
    focusedDay.value = DateTime.now();
    selectedDay.value = DateTime.now();
    super.onInit();
  }




  toggleDayWeek(){
    isDaySelected.value = !isDaySelected.value;
    if(isDaySelected.value){
      calendarFormat.value = CalendarFormat.month;
      rangeSelectionMode.value = RangeSelectionMode.toggledOff;
    }else{
      calendarFormat.value = CalendarFormat.week;
      rangeSelectionMode.value = RangeSelectionMode.toggledOn;
    }
  }



  setSelectedDate(DateTime mSelectedDay, DateTime mFocusedDay){
    selectedDay.value = mSelectedDay;
    focusedDay.value = mFocusedDay;
    rangeStart.value = null;
    rangeEnd.value = null;
    rangeSelectionMode.value = RangeSelectionMode.toggledOff;
  }

  setDateRange(DateTime? startDate, DateTime? endDate, DateTime mFocusedDay){
    selectedDay.value = null;
    focusedDay.value = mFocusedDay;
    rangeStart.value = startDate;
    rangeEnd.value = endDate;
    rangeSelectionMode.value = RangeSelectionMode.toggledOn;
  }

  resetCalender(bool rangeEnable){
    selectedDay.value = DateTime.now();
    focusedDay.value = DateTime.now();
    rangeStart.value = null;
    rangeEnd.value = null;
    if(rangeEnable){
      rangeSelectionMode.value = RangeSelectionMode.toggledOn;
    }else{
      rangeSelectionMode.value = RangeSelectionMode.toggledOff;
    }

  }

  assignDates(DateTime? startDate, DateTime? endDate){
    List<MyCalenderModelClass> selectedDatesList = myCalenderModelClassList.where((item) => getDatesBetween(startDate!, endDate!).contains(item.date)).toList();
    selectedDatesList.sort((a, b) => b.total.compareTo(a.total));
    selectedDatesEventList.assignAll(selectedDatesList);

  }

  List<String> getDatesBetween(DateTime startDate, DateTime endDate) {
    List<String> dates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      dates.add( DateFormat('yyyy-MM-dd').format(currentDate.toLocal()));
      currentDate = currentDate.add(Duration(days: 1));
    }

    return dates;
  }


}