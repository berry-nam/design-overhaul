import 'dart:ui';

class Company {
  final String name;
  final String industry;
  final String category;
  final String region;
  final double revenue;
  final double revenueGrowth;
  final double profit;
  final double profitGrowth;
  final int employees;
  final int foundedYear;
  final Color color;
  final String ceo;
  final String address;
  final String bizNo;
  final String products;

  const Company({
    required this.name,
    required this.industry,
    required this.category,
    required this.region,
    required this.revenue,
    required this.revenueGrowth,
    required this.profit,
    required this.profitGrowth,
    required this.employees,
    required this.foundedYear,
    required this.color,
    required this.ceo,
    required this.address,
    required this.bizNo,
    required this.products,
  });

  String get initials {
    if (name.length >= 2) return name.substring(0, 2);
    return name;
  }

  String get revenueFormatted => '${revenue.toStringAsFixed(0)}억';
  String get profitFormatted => '${profit.toStringAsFixed(0)}억';

  String get revenueGrowthFormatted {
    if (revenueGrowth == -999) return 'N/A';
    final sign = revenueGrowth >= 0 ? '+' : '';
    return '$sign${revenueGrowth.toStringAsFixed(1)}%';
  }

  String get profitGrowthFormatted {
    if (profitGrowth == -999) return '적자전환';
    final sign = profitGrowth >= 0 ? '+' : '';
    return '$sign${profitGrowth.toStringAsFixed(1)}%';
  }

  bool get isProfitable => profit > 0;
}

// Sample data matching the HTML prototype
final List<Company> sampleCompanies = [
  Company(name: '에이치비테크놀로지', industry: '반도체 장비', category: '제조업', region: '서울 강남', revenue: 342, revenueGrowth: 4.3, profit: 28, profitGrowth: 12.5, employees: 187, foundedYear: 2011, color: const Color(0xFF0549CC), ceo: '김현우', address: '서울 강남구 테헤란로 127', bizNo: '123-45-67890', products: '반도체 검사장비, 웨이퍼 프로버'),
  Company(name: '넥스트인포시스템즈', industry: 'SW 개발', category: '정보통신업', region: '성남 분당', revenue: 128, revenueGrowth: 8.5, profit: 15, profitGrowth: 18.2, employees: 95, foundedYear: 2015, color: const Color(0xFF059669), ceo: '박성민', address: '성남시 분당구 판교로 242', bizNo: '234-56-78901', products: 'ERP 솔루션, 클라우드 플랫폼'),
  Company(name: '그린에너텍', industry: '신재생에너지', category: '제조업', region: '부산 해운대', revenue: 567, revenueGrowth: 7.0, profit: 42, profitGrowth: 8.3, employees: 312, foundedYear: 2008, color: const Color(0xFFD97706), ceo: '이정호', address: '부산 해운대구 센텀중앙로 48', bizNo: '345-67-89012', products: '태양광 모듈, ESS'),
  Company(name: '코리아푸드텍', industry: '식품 제조', category: '제조업', region: '인천 남동', revenue: 89, revenueGrowth: 4.7, profit: 7, profitGrowth: 4.1, employees: 64, foundedYear: 2018, color: const Color(0xFFDC2626), ceo: '최영수', address: '인천 남동구 남동대로 123', bizNo: '456-78-90123', products: '건강기능식품, HMR'),
  Company(name: '스마트로지스', industry: '물류 IT', category: '정보통신업', region: '서울 영등포', revenue: 213, revenueGrowth: 7.6, profit: 18, profitGrowth: 14.7, employees: 142, foundedYear: 2013, color: const Color(0xFF8B5CF6), ceo: '정현우', address: '서울 영등포구 여의나루로 76', bizNo: '567-89-01234', products: '물류관리 플랫폼, WMS'),
  Company(name: '바이오싸이언스코리아', industry: '바이오 연구', category: '전문서비스업', region: '대전 유성', revenue: 76, revenueGrowth: 18.8, profit: -5, profitGrowth: -999, employees: 53, foundedYear: 2019, color: const Color(0xFF0D9488), ceo: '한미영', address: '대전 유성구 과학로 169', bizNo: '678-90-12345', products: '항체 치료제, 진단키트'),
  Company(name: '대한정밀공업', industry: '기계부품', category: '제조업', region: '경기 안산', revenue: 445, revenueGrowth: 1.6, profit: 31, profitGrowth: 3.2, employees: 267, foundedYear: 1995, color: const Color(0xFF64748B), ceo: '오태환', address: '경기 안산시 단원구 산단로 89', bizNo: '789-01-23456', products: '정밀 절삭공구, CNC 부품'),
  Company(name: '인피닉스AI', industry: 'AI 솔루션', category: '정보통신업', region: '서울 서초', revenue: 52, revenueGrowth: 23.8, profit: -12, profitGrowth: -999, employees: 38, foundedYear: 2020, color: const Color(0xFF6366F1), ceo: '김태준', address: '서울 서초구 반포대로 201', bizNo: '890-12-34567', products: 'AI 영상분석, MLOps 플랫폼'),
  Company(name: '한일화학', industry: '화학 소재', category: '제조업', region: '울산 울주', revenue: 678, revenueGrowth: 1.5, profit: 55, profitGrowth: 5.8, employees: 423, foundedYear: 1987, color: const Color(0xFFB45309), ceo: '박광일', address: '울산 울주군 온산읍 화학로 45', bizNo: '901-23-45678', products: '특수 코팅제, 접착소재'),
  Company(name: '퓨처모빌리티', industry: '자동차부품', category: '제조업', region: '경기 화성', revenue: 891, revenueGrowth: 4.2, profit: 67, profitGrowth: 9.1, employees: 534, foundedYear: 2003, color: const Color(0xFF0549CC), ceo: '윤재현', address: '경기 화성시 동탄대로 512', bizNo: '012-34-56789', products: '전장부품, 배터리 모듈'),
  Company(name: '동아엘텍', industry: '전자부품', category: '제조업', region: '경기 수원', revenue: 234, revenueGrowth: 4.0, profit: 19, profitGrowth: 7.4, employees: 156, foundedYear: 2009, color: const Color(0xFF059669), ceo: '이동훈', address: '경기 수원시 영통구 신원로 88', bizNo: '112-23-34567', products: 'PCB, 센서 모듈'),
  Company(name: '미래산업', industry: '산업용 로봇', category: '제조업', region: '경남 창원', revenue: 321, revenueGrowth: 3.5, profit: 25, profitGrowth: 10.6, employees: 198, foundedYear: 2001, color: const Color(0xFFDC2626), ceo: '서진우', address: '경남 창원시 성산구 공단로 234', bizNo: '223-34-45678', products: '협동 로봇, 자동화 라인'),
  Company(name: '클라우드브릿지', industry: '클라우드', category: '정보통신업', region: '서울 강남', revenue: 167, revenueGrowth: 12.8, profit: 8, profitGrowth: 25.3, employees: 112, foundedYear: 2017, color: const Color(0xFF8B5CF6), ceo: '강민서', address: '서울 강남구 역삼로 165', bizNo: '334-45-56789', products: 'MSP, 클라우드 마이그레이션'),
  Company(name: '성우메디칼', industry: '의료기기', category: '제조업', region: '서울 금천', revenue: 198, revenueGrowth: 5.3, profit: 22, profitGrowth: 11.3, employees: 134, foundedYear: 2012, color: const Color(0xFF0D9488), ceo: '남기철', address: '서울 금천구 가산디지털로 100', bizNo: '445-56-67890', products: '초음파 진단기, 수술 로봇'),
  Company(name: '케이솔라에너지', industry: '태양광', category: '제조업', region: '충남 아산', revenue: 412, revenueGrowth: 5.6, profit: 34, profitGrowth: 6.7, employees: 245, foundedYear: 2010, color: const Color(0xFFD97706), ceo: '백승현', address: '충남 아산시 음봉면 산업로 567', bizNo: '556-67-78901', products: '태양광 셀, 인버터'),
];
