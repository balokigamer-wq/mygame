import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ShifraApp());
}

class ShifraApp extends StatelessWidget {
  const ShifraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'شيفرة - لعبة الألغاز العربية',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Cairo'),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: ShifraHomeScreen(),
      ),
    );
  }
}

class QuestionItem {
  final String q;
  final String a;
  final List<String> s;

  QuestionItem({required this.q, required this.a, required this.s});
}

class GroupData {
  final int id;
  final List<List<QuestionItem>> puzzles;

  GroupData({required this.id, required this.puzzles});
}

class TileItem {
  final String text;
  final int qIdx;
  bool used;

  TileItem({required this.text, required this.qIdx, this.used = false});
}

final List<GroupData> kGroupsData = [
  GroupData(
    id: 1,
    puzzles: [
      [
        QuestionItem(q: "اول سور القران الكريم", a: "الفاتحة", s: ["ال", "فا", "ت", "حة"]),
        QuestionItem(q: "شركة امريكية مطورة لهواتف ايفون", a: "ابل", s: ["اب", "ل"]),
        QuestionItem(q: "اكبر قارات العالم مساحة", a: "اسيا", s: ["اس", "يا"]),
      ],
      [
        QuestionItem(q: "اقرب كوكب الى الشمس", a: "عطارد", s: ["ع", "طا", "رد"]),
        QuestionItem(q: "مطرب سعودي لقب بفنان العرب", a: "محمد عبده", s: ["مح", "مد", "عب", "ده"]),
        QuestionItem(q: "اسرع حيوان بري في العالم", a: "الفهد", s: ["ال", "فه", "د"]),
      ],
      [
        QuestionItem(q: "العضو المسؤول عن ضخ الدم في الجسم", a: "القلب", s: ["ال", "قل", "ب"]),
        QuestionItem(q: "شركة سيارات يابانية تنتج سيارة كامري", a: "تويوتا", s: ["تو", "يو", "تا"]),
        QuestionItem(q: "لون النسر في وسط علم مصر", a: "ذهبي", s: ["ذه", "بي"]),
      ],
      [
        QuestionItem(q: "فاتح بلاد الاندلس", a: "طارق بن زياد", s: ["طا", "رق", "بن", "زي", "اد"]),
        QuestionItem(q: "شكل هندسي له ثلاثة اضلاع", a: "مثلث", s: ["م", "ثل", "ث"]),
        QuestionItem(q: "بطل سلسلة افلام المهمة المستحيلة", a: "توم كروز", s: ["تو", "م", "كر", "وز"]),
      ],
      [
        QuestionItem(q: "شركة كورية شهيرة لصناعة الهواتف", a: "سامسونج", s: ["سا", "مس", "ون", "ج"]),
        QuestionItem(q: "الغاز الذي نتنفسه للبقاء على قيد الحياة", a: "الاكسجين", s: ["ال", "اك", "سج", "ين"]),
        QuestionItem(q: "الكتاب المنزل على نبي الله موسى", a: "التوراة", s: ["ال", "تو", "را", "ة"]),
      ],
      [
        QuestionItem(q: "عاصمة المملكة العربية السعودية", a: "الرياض", s: ["ال", "ري", "اض"]),
        QuestionItem(q: "حيوان ضخم يتميز بخرطوم طويل", a: "الفيل", s: ["ال", "في", "ل"]),
        QuestionItem(q: "مطرب مصري لقب بالعندليب الاسمر", a: "عبد الحليم حافظ", s: ["عب", "د", "ال", "حل", "يم", "حا", "فظ"]),
      ],
      [
        QuestionItem(q: "اشهر محرك بحث عالمي على الانترنت", a: "جوجل", s: ["جو", "جل"]),
        QuestionItem(q: "العضو المسؤول عن تنقية الدم من السموم", a: "الكبد", s: ["ال", "كب", "د"]),
        QuestionItem(q: "شركة سيارات المانية شعارها اربع حلقات", a: "اودي", s: ["او", "دي"]),
      ],
      [
        QuestionItem(q: "رمز يتوسط علم لبنان باللون الاخضر", a: "شجرة الارز", s: ["ش", "جر", "ة", "ال", "ار", "ز"]),
        QuestionItem(q: "قائد معركة حطين ومحرر القدس", a: "صلاح الدين", s: ["ص", "لا", "ح", "ال", "دي", "ن"]),
        QuestionItem(q: "شكل هندسي ليس له اي زوايا او اضلاع", a: "دائرة", s: ["دا", "ئر", "ة"]),
      ],
      [
        QuestionItem(q: "المعدن الوحيد السائل في درجة حرارة الغرفة", a: "الزئبق", s: ["ال", "زئ", "بق"]),
        QuestionItem(q: "ممثل كويتي راحل اشتهر بمسرحية باي باي لندن", a: "عبد الحسين عبد الرضا", s: ["عب", "د", "ال", "حس", "ين", "عب", "د", "ال", "رض", "ا"]),
        QuestionItem(q: "شركة امريكية متخصصة في التجارة الالكترونية", a: "امازون", s: ["ام", "از", "ون"]),
      ],
      [
        QuestionItem(q: "السورة التي تعدل ثلث القران الكريم", a: "الاخلاص", s: ["ال", "اخ", "لا", "ص"]),
        QuestionItem(q: "اطول انهار العالم", a: "نهر النيل", s: ["نه", "ر", "ال", "ني", "ل"]),
        QuestionItem(q: "طائر لا يطير ويعيش في القطب الجنوبي", a: "البطريق", s: ["ال", "بط", "ري", "ق"]),
      ],
    ],
  ),
  GroupData(
    id: 2,
    puzzles: [
      [
        QuestionItem(q: "الكتاب المنزل على نبي الله عيسى", a: "الانجيل", s: ["ال", "ان", "جي", "ل"]),
        QuestionItem(q: "عاصمة الجمهورية السورية", a: "دمشق", s: ["دم", "شق"]),
        QuestionItem(q: "السورة التي تسمى عروس القران", a: "الرحمن", s: ["ال", "رح", "من"]),
      ],
      [
        QuestionItem(q: "عاصمة دولة الكويت", a: "الكويت", s: ["ال", "كو", "يت"]),
        QuestionItem(q: "عاصمة جمهورية السودان", a: "الخرطوم", s: ["ال", "خر", "طو", "م"]),
        QuestionItem(q: "لقب اول الخلفاء الراشدين", a: "ابو بكر الصديق", s: ["اب", "و", "بك", "ر", "ال", "صد", "يق"]),
      ],
      [
        QuestionItem(q: "لون السماء الصافية في النهار", a: "ازرق", s: ["از", "رق"]),
        QuestionItem(q: "شركة سيارات المانية شعارها نجمة ثلاثية", a: "مرسيدس", s: ["مر", "سي", "دس"]),
        QuestionItem(q: "اكبر حيوان على وجه الارض", a: "الحوت الازرق", s: ["ال", "حو", "ت", "ال", "از", "رق"]),
      ],
      [
        QuestionItem(q: "العضو المسؤول عن حاسة البصر", a: "العين", s: ["ال", "عي", "ن"]),
        QuestionItem(q: "عاصمة المملكة الاردنية الهاشمية", a: "عمان", s: ["عم", "ان"]),
        QuestionItem(q: "فصل تتفتح فيه الازهار ويعتدل الجو", a: "الربيع", s: ["ال", "رب", "يع"]),
      ],
      [
        QuestionItem(q: "مؤسس علم الجبر في الرياضيات", a: "الخوارزمي", s: ["ال", "خو", "ار", "زم", "ي"]),
        QuestionItem(q: "شركة سيارات ايطالية شعارها حصان جامح", a: "فيراري", s: ["في", "را", "ري"]),
        QuestionItem(q: "عدد كواكب المجموعة الشمسية", a: "ثمانية", s: ["ث", "ما", "ني", "ة"]),
      ],
      [
        QuestionItem(q: "الصحابي الملقب بسيف الله المسلول", a: "خالد بن الوليد", s: ["خا", "لد", "بن", "ال", "ول", "يد"]),
        QuestionItem(q: "غاز تستخدمه النباتات في البناء الضوئي", a: "ثاني اكسيد الكربون", s: ["ثا", "ني", "اك", "سي", "د", "ال", "كر", "بو", "ن"]),
        QuestionItem(q: "عاصمة اليابان", a: "طوكيو", s: ["طو", "كي", "و"]),
      ],
      [
        QuestionItem(q: "شركة سيارات كورية تنتج سيارة سوناتا", a: "هيونداي", s: ["هي", "ون", "دا", "ي"]),
        QuestionItem(q: "اطول عظمة في جسم الانسان", a: "عظمة الفخذ", s: ["ع", "ظم", "ة", "ال", "فخ", "ذ"]),
        QuestionItem(q: "قصر تاريخي شهير في غرناطة بالاندلس", a: "قصر الحمراء", s: ["قص", "ر", "ال", "حم", "راء"]),
      ],
      [
        QuestionItem(q: "نبي الله الذي ابتلعه الحوت", a: "يونس", s: ["يو", "نس"]),
        QuestionItem(q: "مخترع المصباح الكهربائي", a: "توماس اديسون", s: ["تو", "ما", "س", "اد", "يس", "ون"]),
        QuestionItem(q: "شكل هندسي له اربعة اضلاع متساوية", a: "مربع", s: ["م", "رب", "ع"]),
      ],
      [
        QuestionItem(q: "عاصمة الامارات العربية المتحدة", a: "ابو ظبي", s: ["اب", "و", "ظ", "بي"]),
        QuestionItem(q: "المنصة الاشهر لمشاركة مقاطع الفيديو", a: "يوتيوب", s: ["يو", "تي", "وب"]),
        QuestionItem(q: "لقب ثاني الخلفاء الراشدين عمر بن الخطاب", a: "الفاروق", s: ["ال", "فا", "رو", "ق"]),
      ],
      [
        QuestionItem(q: "كوكب يشتهر بحلقاته الجميلة حوله", a: "زحل", s: ["ز", "حل"]),
        QuestionItem(q: "شركة سيارات امريكية اسسها هنري فورد", a: "فورد", s: ["فو", "رد"]),
        QuestionItem(q: "الاسم الكامل لاول الخلفاء الراشدين", a: "عبد الله بن ابي قحافة", s: ["عب", "د", "ال", "له", "بن", "اب", "ي", "ق", "حا", "فة"]),
      ],
    ],
  ),
];

class AppColors {
  final bool lightMode;
  AppColors(this.lightMode);

  Color get bgMain => lightMode ? const Color(0xFFF8F6F0) : const Color(0xFF0B1120);
  Color get bgCard => lightMode ? const Color(0xFFFFFFFF) : const Color(0xFF1A2436);
  Color get bgCardHover => lightMode ? const Color(0xFFF3F0E8) : const Color(0xFF223047);
  Color get bgSolved => lightMode ? const Color(0xFFF1EFEA) : const Color(0xFF064E3B);
  Color get borderSubtle => lightMode ? const Color(0xFFE5E2D9) : Colors.white.withOpacity(0.08);
  Color get borderSolved => lightMode ? const Color(0xFFCBD5E1) : const Color(0xFF10B981);
  Color get accent => lightMode ? const Color(0xFF0F172A) : const Color(0xFFFACC15);
  Color get accentText => lightMode ? const Color(0xFFFFFFFF) : const Color(0xFF0B1120);
  Color get textMain => lightMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
  Color get textMuted => lightMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
  Color get pillBg => lightMode ? const Color(0xFFE7E4DC) : const Color(0xFF10B981).withOpacity(0.22);
  Color get pillText => lightMode ? const Color(0xFF1E293B) : const Color(0xFFA7F3D0);
  Color get green => const Color(0xFF10B981);
  Color get red => const Color(0xFFEF4444);
}