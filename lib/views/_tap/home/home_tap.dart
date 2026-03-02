import 'package:baton/models/enum/category.dart';
import 'package:baton/views/_tap/home/widgets/category_chip.dart';
import 'package:baton/views/_tap/home/widgets/product_item.dart';
import 'package:flutter/material.dart';

class HomeTap extends StatelessWidget {
  const HomeTap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text("Home", style: TextStyle(fontSize: 22)),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actions: [
          const Icon(Icons.notifications),
          const SizedBox(width: 10),
          const Icon(Icons.more_vert),
        ],
        actionsPadding: const EdgeInsets.only(right: 20),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: Category.values.length,
                itemBuilder: (context, index) {
                  return CategoryChip(label: Category.values[index].name);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.7,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return const ProductItem(postId: '1');
                },
                itemCount: 10,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 100,
        height: 40,
        child: FloatingActionButton.extended(
          icon: const Icon(Icons.add, size: 16),
          foregroundColor: Colors.white,
          extendedPadding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 12,
            right: 16,
          ),
          onPressed: () {},
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          backgroundColor: Colors.blue,
          label: const Text(
            "상품 등록",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
