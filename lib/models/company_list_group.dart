import 'dart:ui';

class CompanyListGroup {
  String name;
  String desc;
  Color color;
  List<String> companyNames;

  CompanyListGroup({
    required this.name,
    required this.desc,
    required this.color,
    required this.companyNames,
  });
}

final defaultGroups = [
  CompanyListGroup(
    name: '잠재 고객 리스트',
    desc: 'B2B 영업 타겟 리스트',
    color: const Color(0xFF0549CC),
    companyNames: [
      '에이치비테크놀로지', '넥스트인포시스템즈', '그린에너텍', '대한정밀공업',
      '퓨처모빌리티', '동아엘텍', '미래산업', '케이솔라에너지',
      '한일화학', '스마트로지스', '성우메디칼', '클라우드브릿지',
    ],
  ),
  CompanyListGroup(
    name: 'M&A 후보',
    desc: '인수합병 검토 대상',
    color: const Color(0xFFD97706),
    companyNames: ['코리아푸드텍', '바이오싸이언스코리아', '인피닉스AI'],
  ),
  CompanyListGroup(
    name: '투자 관심 기업',
    desc: '중장기 투자 리서치',
    color: const Color(0xFF059669),
    companyNames: [
      '에이치비테크놀로지', '그린에너텍', '퓨처모빌리티', '한일화학',
      '대한정밀공업', '동아엘텍', '케이솔라에너지', '성우메디칼',
    ],
  ),
  CompanyListGroup(
    name: '경쟁사 모니터링',
    desc: '에이치비테크놀로지 경쟁사',
    color: const Color(0xFF8B5CF6),
    companyNames: ['대한정밀공업', '미래산업', '퓨처모빌리티'],
  ),
];
