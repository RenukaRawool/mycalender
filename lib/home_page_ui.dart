import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mycalender/controller/in_app_calender_controller.dart';
import 'package:mycalender/controller/my_calender_controller.dart';
import 'package:mycalender/utils/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePageUi extends StatefulWidget {
  const HomePageUi({super.key});

  @override
  State<HomePageUi> createState() => _HomePageUiState();
}

class _HomePageUiState extends State<HomePageUi> {
  MyCalenderController myCalenderController = Get.put(MyCalenderController());
  InAppCalenderController inAppCalenderController =
      Get.put(InAppCalenderController());

  bool isBottomSheetOn = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: grey,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white, // Container background color
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 3, // Blur radius
                    offset: const Offset(0, 2), // Offset in the y direction
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isBottomSheetOn) {
                        Get.back();
                      }
                    },
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: darkgrey,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Obx(() {
                    return Text(
                      myCalenderController.isDaySelected.value
                          ? "In App Calender"
                          : "My Calender",
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    );
                  })),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(width: 1, color: blue)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (isBottomSheetOn) {
                              Get.back();
                              isBottomSheetOn = false;
                            }
                            myCalenderController.toggleDayWeek();
                            myCalenderController.resetCalender(false);
                          },
                          child: Obx(() {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  color:
                                      myCalenderController.isDaySelected.value
                                          ? darkblue
                                          : Colors.white),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 16),
                              child: Center(
                                  child: Text(
                                'Day',
                                style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        myCalenderController.isDaySelected.value
                                            ? Colors.white
                                            : blue),
                              )),
                            );
                          }),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isBottomSheetOn) {
                              Get.back();
                              isBottomSheetOn = false;
                            }
                            myCalenderController.toggleDayWeek();
                            myCalenderController.resetCalender(true);
                          },
                          child: Obx(() {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  color:
                                      myCalenderController.isDaySelected.value
                                          ? Colors.white
                                          : darkblue),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              child: Center(
                                  child: Text(
                                'Week',
                                style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        myCalenderController.isDaySelected.value
                                            ? blue
                                            : Colors.white),
                              )),
                            );
                          }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Obx(() {
              return TableCalendar(
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false, // Hide the format button
                  titleCentered: true,
                ),
                calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                    selectedDecoration: BoxDecoration(
                      color: darkblue,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ) // Change the focus color here
                    ),
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                  CalendarFormat.week: 'Week',
                },
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay:
                    myCalenderController.focusedDay.value ?? DateTime.now(),
                selectedDayPredicate: (day) =>
                    isSameDay(myCalenderController.selectedDay.value, day),
                rangeStartDay: myCalenderController.rangeStart.value,
                rangeEndDay: myCalenderController.rangeEnd.value,
                calendarFormat: myCalenderController.calendarFormat.value,
                rangeSelectionMode:
                    myCalenderController.rangeSelectionMode.value,
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(
                      myCalenderController.selectedDay.value, selectedDay)) {
                    myCalenderController.setSelectedDate(
                        selectedDay, focusedDay);
                    inAppCalenderController.setInAppEventList(selectedDay);
                    showBottomSheet(
                      elevation: 6,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                            height: height * 0.6,
                            color: Colors.white,
                            child: DefaultTabController(
                              length: 4, // specify the number of tabs
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                        color: grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                  ),
                                  const TabBar(
                                    indicatorColor: blue,
                                    indicatorWeight: 4,
                                    unselectedLabelColor: darkgrey,
                                    unselectedLabelStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                    labelColor: Colors.black,
                                    labelStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    tabs: [
                                      Tab(text: 'All'),
                                      Tab(text: 'HRD'),
                                      Tab(text: 'Tech 1'),
                                      Tab(text: 'Follow up'),
                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        Obx(() {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: ListView.builder(
                                                itemCount:
                                                    inAppCalenderController
                                                        .inAppEventList.length,
                                                itemBuilder: (context, index) {
                                                  var item =
                                                      inAppCalenderController
                                                              .inAppEventList[
                                                          index];
                                                  return Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 20),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 15,
                                                        horizontal: 20),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  8)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          spreadRadius: 1,
                                                          blurRadius: 2,
                                                          offset: const Offset(
                                                              0, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  item.name,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.6),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                const Text(
                                                                  "Id: 1234567890",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          darkgrey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ],
                                                            )),
                                                            GestureDetector(
                                                              onTap: () {
                                                                inAppCalenderController
                                                                    .makePhoneCall(
                                                                        "+911234567890");
                                                              },
                                                              child: Container(
                                                                width: 30,
                                                                height: 30,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.2),
                                                                      // Shadow color
                                                                      spreadRadius:
                                                                          1,
                                                                      // Spread radius
                                                                      blurRadius:
                                                                          2,
                                                                      // Blur radius
                                                                      offset: const Offset(
                                                                          0,
                                                                          1), // Offset in the y direction
                                                                    ),
                                                                  ],
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons.call,
                                                                  color: blue,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const Row(
                                                          children: [
                                                            Text(
                                                              "Offered:",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                      darkgrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                            Text(
                                                              " X,XX,XXX",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        const Row(
                                                          children: [
                                                            Text(
                                                              "Current:",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                      darkgrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                            Text(
                                                              " X,XX,XXX",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.circle,
                                                              size: 10,
                                                              color:
                                                                  item.prioritySatus ==
                                                                          "High"
                                                                      ? red
                                                                      : yellow,
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              "${item.prioritySatus} Priority",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: item.prioritySatus ==
                                                                          "High"
                                                                      ? red
                                                                      : yellow,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const Divider(
                                                          thickness: 2,
                                                          color: grey,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                  "Due Date:",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          darkgrey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                Text(
                                                                  DateFormat(
                                                                          "d MMM yy")
                                                                      .format(DateTime
                                                                          .parse(
                                                                              item.DueDate))
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ],
                                                            ),
                                                            const Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Level",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          darkgrey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                Text(
                                                                  "10",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ],
                                                            ),
                                                            const Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Days Left",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          darkgrey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                Text(
                                                                  " 23",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          );
                                        }),
                                        const Center(
                                            child: Text('In Development')),
                                        const Center(
                                            child: Text('In Development')),
                                        const Center(
                                            child: Text('In Development')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                    );

                    isBottomSheetOn = true;
                  }
                },
                onRangeSelected: (start, end, focusedDay) {
                  myCalenderController.setDateRange(start, end, focusedDay);

                  if (myCalenderController.rangeStart.value != null &&
                      myCalenderController.rangeEnd.value != null) {
                    myCalenderController.assignDates(start, end);
                    showBottomSheet(
                      elevation: 6,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                            height: height * 0.6,
                            color: Colors.white,
                            child: DefaultTabController(
                              length: 4, // specify the number of tabs
                              child: Column(
                                children: [
                                  const TabBar(
                                    indicatorColor: darkgrey,
                                    indicatorWeight: 4,
                                    unselectedLabelColor: darkgrey,
                                    unselectedLabelStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                    labelColor: darkgrey,
                                    labelStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    tabs: [
                                      Tab(
                                        text: 'All',
                                      ),
                                      Tab(text: 'HRD'),
                                      Tab(text: 'Tech 1 '),
                                      Tab(text: 'Follow up'),
                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        Obx(() {
                                          if (myCalenderController
                                              .selectedDatesEventList.isEmpty) {
                                            return Container(
                                                child: const Center(
                                                    child: Text(
                                                        'No Record Found')));
                                          } else {
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: ListView.builder(
                                                  itemCount: myCalenderController
                                                      .selectedDatesEventList
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var item = myCalenderController
                                                            .selectedDatesEventList[
                                                        index];
                                                    return Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8,
                                                          horizontal: 20),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    8)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 2,
                                                            offset: const Offset(
                                                                0,
                                                                1), // Offset in the y direction
                                                          ),
                                                        ],
                                                      ),
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 3,
                                                              color: red,
                                                              height: 60,
                                                            ),
                                                            Expanded(
                                                                child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child:
                                                                        Container(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        DateTime.parse(item.date)
                                                                            .day
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: darkgrey),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      Text(
                                                                          DateFormat.MMM()
                                                                              .format(DateTime.parse(item
                                                                                  .date))
                                                                              .toString()
                                                                              .toUpperCase(),
                                                                          style: const TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: darkgrey))
                                                                    ],
                                                                  ),
                                                                )),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Container(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(width: 2, color: grey)),
                                                                          padding: const EdgeInsets.all(10),
                                                                          child: Text(
                                                                            '${item.hrd}',
                                                                            style: const TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: darkgrey),
                                                                          )),
                                                                      const SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      const Text(
                                                                          'HRD',
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: darkgrey))
                                                                    ],
                                                                  ),
                                                                )),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Container(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(width: 2, color: grey)),
                                                                          padding: const EdgeInsets.all(10),
                                                                          child: Text(
                                                                            '${item.tech1}',
                                                                            style: const TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: darkgrey),
                                                                          )),
                                                                      const SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      const Text(
                                                                          'Tech 1',
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: darkgrey))
                                                                    ],
                                                                  ),
                                                                )),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Container(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              border: Border.all(width: 2, color: grey)),
                                                                          padding: const EdgeInsets.all(10),
                                                                          child: Text(
                                                                            '${item.followup}',
                                                                            style: const TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: darkgrey),
                                                                          )),
                                                                      const SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      const Text(
                                                                          'Follow up',
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: darkgrey))
                                                                    ],
                                                                  ),
                                                                )),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Container(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                          decoration: const BoxDecoration(
                                                                              shape: BoxShape
                                                                                  .circle,
                                                                              color:
                                                                                  darkgrey),
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              10),
                                                                          child:
                                                                              Text(
                                                                            '${item.total}',
                                                                            style: const TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Colors.white),
                                                                          )),
                                                                      const SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      const Text(
                                                                          'Total',
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: darkgrey))
                                                                    ],
                                                                  ),
                                                                )),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                              ],
                                                            ))
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            );
                                          }
                                        }),
                                        const Center(
                                            child: Text('In Development')),
                                        const Center(
                                            child: Text('In Development')),
                                        const Center(
                                            child: Text('In Development')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                    isBottomSheetOn = true;
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
