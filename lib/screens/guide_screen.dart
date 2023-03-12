import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    QuillController controller = QuillController.basic();
    final decodeJson = jsonDecode(utf8.decode(base64Url.decode(
        'W3siaW5zZXJ0IjoiRGVsZXRpbmcgYSBub3RlIHBlcm1hbmVudGx5OiIsImF0dHJpYnV0ZXMiOnsiY29sb3IiOiIjMDNhOWY0IiwidW5kZXJsaW5lIjp0cnVlfX0seyJpbnNlcnQiOiJcbkZpcnN0LCBkZWxldGUgdGhlIG5vdGUgYnkgY2xpY2tpbmcgZGVsZXRlIGJ1dHRvbiBwbGFjZWQgdG9wLXJpZ2h0IGNvcm5lciB3aGlsZSBlZGl0aW5nLyB2aWV3aW5nIHRoZSBub3RlLiBJdCB3aWxsIG1vdmUgdGhlIG5vdGUgdG8gcmVjeWNsZSBiaW4uIn0seyJpbnNlcnQiOiJcbiIsImF0dHJpYnV0ZXMiOnsibGlzdCI6ImJ1bGxldCJ9fSx7Imluc2VydCI6IlRoZW4sIGRlbGV0ZSB0aGUgc2FtZSBpbiByZWN5Y2xlIGJpbiBmb2xsb3dpbmcgdGhlIHNhbWUuIn0seyJpbnNlcnQiOiJcbiIsImF0dHJpYnV0ZXMiOnsibGlzdCI6ImJ1bGxldCJ9fSx7Imluc2VydCI6IlRoaXMgd2lsbCBkZWxldGUgdGhlIG5vdGUgcGVybWFuZW50bHksIGV2ZW4gaW4gdGhlIGRhdGFiYXNlLiBZb3UgY2Fubm90IGdldCB0aGF0IG5vdGUgYmFjay4ifSx7Imluc2VydCI6IlxuIiwiYXR0cmlidXRlcyI6eyJsaXN0IjoiYnVsbGV0In19LHsiaW5zZXJ0IjoiRGVsZXRpbmcgYWxsIG5vdGVzIGFuZCB0aGUgYWNjb3VudDoiLCJhdHRyaWJ1dGVzIjp7InVuZGVybGluZSI6dHJ1ZSwiY29sb3IiOiIjMjliNmY2In19LHsiaW5zZXJ0IjoiXG5Zb3UgY2FuIGRlbGV0ZSBhbGwgdGhlIG5vdGVzIG9uZSBieSBvbmUuIn0seyJpbnNlcnQiOiJcbiIsImF0dHJpYnV0ZXMiOnsibGlzdCI6ImJ1bGxldCJ9fSx7Imluc2VydCI6IiAgKE9SKSJ9LHsiaW5zZXJ0IjoiXG4iLCJhdHRyaWJ1dGVzIjp7ImluZGVudCI6NX19LHsiaW5zZXJ0IjoiU2VuZGluZyBhbiBlbWFpbCB0byBkaGVlcmFqcmVkZHk5NjNAZ21haWwuY29tIHJlcXVlc3RpbmcgdGhlIGFjY291bnQgZGVsZXRpb24uIE9uY2UsIHdlIHByb2Nlc3MgdGhlIHJlcXVlc3QsIHdlIHdpbGwgc2VuZCB5b3UgYSByZXBseSBlbWFpbCByZWdhcmRpbmcgdGhlIHNhbWUuIn0seyJpbnNlcnQiOiJcbiIsImF0dHJpYnV0ZXMiOnsibGlzdCI6ImJ1bGxldCJ9fSx7Imluc2VydCI6Ik5vdGU6IFRoaXMgd2lsbCBkZWxldGUgYWxsIHRoZSBub3RlcyBwZXJtYW5lbnRseS4gQnV0LCB5b3UgY2FuIHVzZSB0aGUgYXBwIGFnYWluIHVzaW5nIHNhbWUgYWNjb3VudC4ifSx7Imluc2VydCI6IlxuIiwiYXR0cmlidXRlcyI6eyJsaXN0IjoiYnVsbGV0In19LHsiaW5zZXJ0IjoiU2F2aW5nIGEgbm90ZToiLCJhdHRyaWJ1dGVzIjp7InVuZGVybGluZSI6dHJ1ZSwiY29sb3IiOiIjMDNhOWY0In19LHsiaW5zZXJ0IjoiXG5XaGlsZSBjcmVhdGluZyBhIG5ldyBub3RlIG9yIGVkaXRpbmcgYSBub3RlLCB0aGUgdGV4dCB3aWxsIG5vdCBiZSBzYXZlZCBhdXRvbWF0aWNhbGx5LiJ9LHsiaW5zZXJ0IjoiXG4iLCJhdHRyaWJ1dGVzIjp7Imxpc3QiOiJidWxsZXQifX0seyJpbnNlcnQiOiJPbmx5LCB3aGVuIHlvdSBwcmVzcyB0aGUgc2F2ZSBidXR0b24gd2lsbCBzYXZlIHRoZSBub3RlLiJ9LHsiaW5zZXJ0IjoiXG4iLCJhdHRyaWJ1dGVzIjp7Imxpc3QiOiJidWxsZXQifX0seyJpbnNlcnQiOiJcbiJ9LHsiaW5zZXJ0IjoiUHJpdmFjeSBQb2xpY3k6IiwiYXR0cmlidXRlcyI6eyJ1bmRlcmxpbmUiOnRydWUsImNvbG9yIjoiIzAzYTlmNCJ9fSx7Imluc2VydCI6IlxuIn0seyJpbnNlcnQiOiJodHRwczovL2dpdGh1Yi5jb20vRGhlZXJhai1SZWRkeS1NYWxsYXB1L05vdGUtVGFraW5nL2Jsb2IvbWFzdGVyL3ByaXZhY3ktcG9saWN5Lm1kIiwiYXR0cmlidXRlcyI6eyJsaW5rIjoiaHR0cHM6Ly9naXRodWIuY29tL0RoZWVyYWotUmVkZHktTWFsbGFwdS9Ob3RlLVRha2luZy9ibG9iL21hc3Rlci9wcml2YWN5LXBvbGljeS5tZCJ9fSx7Imluc2VydCI6IlxuXG4ifSx7Imluc2VydCI6IkFjY2VzcyBzYW1lIG5vdGVzIGZyb20gd2Vic2l0ZToiLCJhdHRyaWJ1dGVzIjp7ImNvbG9yIjoiIzAzYTlmNCIsInVuZGVybGluZSI6dHJ1ZX19LHsiaW5zZXJ0IjoiXG4ifSx7Imluc2VydCI6Imh0dHBzOi8vbm90ZS10YWtpbmctZGUyYWYud2ViLmFwcCIsImF0dHJpYnV0ZXMiOnsibGluayI6Imh0dHBzOi8vbm90ZS10YWtpbmctZGUyYWYud2ViLmFwcCJ9fSx7Imluc2VydCI6IlxuXG5UaGFuayB5b3UgZm9yIHVzaW5nIHRoZSBhcHAuIn0seyJpbnNlcnQiOiJcbiIsImF0dHJpYnV0ZXMiOnsiaGVhZGVyIjoyfX0seyJpbnNlcnQiOiIgICJ9LHsiaW5zZXJ0IjoiRW5qb3khIiwiYXR0cmlidXRlcyI6eyJjb2xvciI6IiNmNDQzMzYifX0seyJpbnNlcnQiOiJcbiIsImF0dHJpYnV0ZXMiOnsiaGVhZGVyIjoyLCJpbmRlbnQiOjh9fV0=')));
    controller = QuillController(
      document: Document.fromJson(decodeJson),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide to use the App'),
      ),
      body: QuillEditor(
        controller: controller,
        focusNode: FocusNode(),
        scrollController: ScrollController(),
        scrollable: true,
        padding: const EdgeInsets.all(3),
        autoFocus: false,
        readOnly: true,
        showCursor: false,
        expands: true,
      ),
    );
  }
}
