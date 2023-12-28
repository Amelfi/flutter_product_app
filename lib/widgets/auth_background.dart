import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(children: [_PurpleBox(), _HeaderIcon(), child]));
  }
}

class _HeaderIcon extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        // color: Colors.red,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: _backgroundDecoration(),
      child: const Stack(
        children: [
          Positioned(left: 30.2, bottom: 50, child: _Bubble()),
          Positioned(right: -40, top: 80, child: _Bubble()),
          Positioned(left: 50, top: 100, child: _Bubble()),
          Positioned(right: -70, child: _Bubble()),
          Positioned(left: -50, child: _Bubble()),
          Positioned(left: 200, bottom: 70, child: _Bubble()),
        ],
      ),
    );
  }

  BoxDecoration _backgroundDecoration() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1),
      ]));
}

class _Bubble extends StatelessWidget {
  const _Bubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(250, 250, 250, 0.05),
      ),
    );
  }
}
