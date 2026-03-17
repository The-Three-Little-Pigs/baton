import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(99),
          borderSide: BorderSide(color: Color(0xFFCDD8E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(99),
          borderSide: BorderSide(color: Colors.black),
        ),
        suffixIcon: const Icon(Icons.search),
        suffixIconColor: Color(0xFF1A1A1A),
        hintText: "검색어를 입력해주세요.",
        hintStyle: TextStyle(color: Color(0xFF1A1A1A)),
      ),
    );
  }
}
