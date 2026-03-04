import 'package:baton/views/write/widgets/bottom_complete_bar.dart';
import 'package:baton/views/write/widgets/category_section.dart';
import 'package:baton/views/write/widgets/content_section.dart';
import 'package:baton/views/write/widgets/image_select_section.dart';
import 'package:baton/views/write/widgets/price_section.dart';
import 'package:baton/views/write/widgets/title_section.dart';
import 'package:baton/views/write/widgets/trade_type_section.dart';
import 'package:flutter/material.dart';

class WritePage extends StatelessWidget {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "물건 팔기",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 20,
              children: [
                ImageSelectSection(),
                TitleSection(),
                CategorySection(),
                TradeTypeSection(),
                ContentSection(),
                PriceSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: MediaQuery.of(context).padding.bottom + 20,
        ),
        child: BottomCompleteBar(),
      ),
    );
  }
}
