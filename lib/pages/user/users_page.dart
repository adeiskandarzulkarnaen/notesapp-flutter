// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Application User",
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0), // Mengatur tinggi dari TextField
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "masukan nama pengguna disini",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.normal
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(16)
                ),
                suffixIcon: const Icon(Icons.search_rounded),
              ),
              onSubmitted: (String value) {
                // todo: search user
                log(value); // print nilai ketika sudah selesai mengetik
              },
            ),
          ),
        ),
      ),

      // todo: dapatkan data users dari API
      /* gunakan ListView.builder() dan/atau FutureBuilder() */
      body: Center(
        child: Text("list of user"),
      ),
    );
  }
}
