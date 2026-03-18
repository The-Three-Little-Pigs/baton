import 'package:flutter/material.dart';

class AppointmentBottomSheet extends StatefulWidget {
  const AppointmentBottomSheet({super.key});

  @override
  State<AppointmentBottomSheet> createState() => _AppointmentBottomSheetState();

  static Future<Map<String, dynamic>?> showAppointmentDialog(
    BuildContext context,
  ) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppointmentBottomSheet(),
    );
  }
}

class _AppointmentBottomSheetState extends State<AppointmentBottomSheet> {
  static const int _kInfiniteOffset = 1000;
  final int _currentYear = DateTime.now().year;
  final int _yearRange = 5;
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;
  late int _selectedHour;
  late int _selectedMinute;
  bool _isAm = true;
  String _selectedMethod = '직거래';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
    _selectedDay = now.day;
    _selectedHour = now.hour > 12
        ? now.hour - 12
        : (now.hour == 0 ? 12 : now.hour);
    _selectedMinute = now.minute;
    _isAm = now.hour < 12;
  }

  DateTime get _selectedDateTime {
    int hour = _selectedHour;
    if (!_isAm && hour < 12) hour += 12;
    if (_isAm && hour == 12) hour = 0;

    return DateTime(
      _selectedYear,
      _selectedMonth,
      _selectedDay,
      hour,
      _selectedMinute,
    );
  }

  String get _summaryText {
    final amPm = _isAm ? '오전' : '오후';
    final min = _selectedMinute.toString().padLeft(2, '0');
    return '$_selectedYear년 $_selectedMonth월 $_selectedDay일 $amPm $_selectedHour시 $min분 - $_selectedMethod';
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.7;
    return SizedBox(
      height: sheetHeight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.5, right: 20.5, top: 14),
              child: BottomSheetHeader(),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // --- 날짜 섹션 ---
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 4),
                      child: _buildExpansionSection(
                        title: '날짜',
                        displayValue:
                            '$_selectedYear년 $_selectedMonth월 $_selectedDay일',
                        expandedChild: Padding(
                          // TODO: 휠 좌우 간격 임의 조정
                          padding: const EdgeInsets.only(left: 0, right: 30),
                          child: SizedBox(
                            height: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildWheel(
                                  count: _yearRange,
                                  initialItem: _selectedYear - _currentYear,
                                  onChanged: (value) => setState(
                                    () => _selectedYear = _currentYear + value,
                                  ),
                                  suffix: '년',
                                  isInfinite: false,
                                ),
                                const SizedBox(width: 58),
                                _buildWheel(
                                  count: 12,
                                  initialItem: _selectedMonth - 1,
                                  onChanged: (value) => setState(
                                    () => _selectedMonth = (value % 12) + 1,
                                  ),
                                  suffix: '월',
                                ),
                                const SizedBox(width: 42),
                                _buildWheel(
                                  count: 31,
                                  initialItem: _selectedDay - 1,
                                  onChanged: (value) => setState(
                                    () => _selectedDay = (value % 31) + 1,
                                  ),
                                  suffix: '일',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // --- 시간 섹션 ---
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 4),
                      child: _buildExpansionSection(
                        title: '시간',
                        displayValue:
                            '${_isAm ? "오전" : "오후"} $_selectedHour시 ${_selectedMinute.toString().padLeft(2, "0")}분',
                        expandedChild: Padding(
                          // TODO:휠 좌우 간격 임의 조정
                          padding: const EdgeInsets.only(left: 0, right: 10),
                          child: SizedBox(
                            height: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildWheel(
                                  count: 2,
                                  initialItem: _isAm ? 0 : 1,
                                  onChanged: (value) =>
                                      setState(() => _isAm = (value % 2) == 0),
                                  items: ['오전', '오후'],
                                  isInfinite: false,
                                ),
                                const SizedBox(width: 58),
                                _buildWheel(
                                  count: 12,
                                  initialItem: _selectedHour - 1,
                                  onChanged: (value) => setState(
                                    () => _selectedHour = (value % 12) + 1,
                                  ),
                                  suffix: '시',
                                ),
                                const SizedBox(width: 42),
                                _buildWheel(
                                  count: 60,
                                  initialItem: _selectedMinute,
                                  onChanged: (value) => setState(
                                    () => _selectedMinute = value % 60,
                                  ),
                                  suffix: '분',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // --- 거래 방법 ---
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 28,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '거래 방법',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          height: 46,
                          width: 74,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Center(
                            child: Text(
                              '직거래',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32),
            // --- 하단 요약 및 버튼 ---
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    _summaryText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 30,
              ),
              child: SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final result = {
                      'dateTime': _selectedDateTime,
                      'method': _selectedMethod,
                    };
                    Navigator.pop(context, result);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    '약속 신청',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionSection({
    required String title,
    required String displayValue,
    required Widget expandedChild,
  }) {
    return Column(
      children: [
        ExpansionTile(
          shape: const Border(),
          title: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                displayValue,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          children: [expandedChild],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16), // 구분선 좌우 여백
          child: Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildWheel({
    required int count,
    required int initialItem,
    required ValueChanged<int> onChanged,
    List<String>? items,
    String suffix = '',
    bool isInfinite = true,
  }) {
    final int finalInitialItem = isInfinite
        ? initialItem + (count * _kInfiniteOffset)
        : initialItem;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: suffix == '년' ? 50 : (items != null ? 50 : 35),
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            physics: FixedExtentScrollPhysics(),
            controller: FixedExtentScrollController(
              initialItem: finalInitialItem,
            ),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: isInfinite ? null : count,
              builder: (context, index) {
                final actualIndex = index % count;
                final isSelected = actualIndex == initialItem;
                final text = items != null
                    ? items[actualIndex]
                    : '${actualIndex + (suffix == '분' ? 0 : (suffix == '년' ? _currentYear : 1))}';
                return Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (suffix.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              suffix,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            '약속하기',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, size: 24),
        ),
      ],
    );
  }
}
