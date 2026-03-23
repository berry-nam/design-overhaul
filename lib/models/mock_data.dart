import 'dart:ui';

// ── Shareholder (도넛차트) ──
class Shareholder {
  final String label;
  final double pct;
  final Color color;
  const Shareholder({required this.label, required this.pct, required this.color});
}

const shareholders = [
  Shareholder(label: '김현우', pct: 42, color: Color(0xFF0549CC)),
  Shareholder(label: '미래에셋벤처투자', pct: 25, color: Color(0xFF3A7ADF)),
  Shareholder(label: '박진영', pct: 15, color: Color(0xFF6D9DE7)),
  Shareholder(label: '기타 주주', pct: 10, color: Color(0xFF9BBBEE)),
  Shareholder(label: '자사주', pct: 8, color: Color(0xFFC8D9F5)),
];

// ── Executive (인물탭) ──
class Executive {
  final String name;
  final String role;
  final String dept;
  final String since;
  final Color color;
  const Executive({required this.name, required this.role, required this.dept, required this.since, required this.color});
}

const executives = [
  Executive(name: '김현우', role: '대표이사', dept: '경영', since: '2011', color: Color(0xFF0549CC)),
  Executive(name: '박진영', role: 'CTO', dept: 'R&D', since: '2012', color: Color(0xFF059669)),
  Executive(name: '이수연', role: 'CFO', dept: '재무', since: '2018', color: Color(0xFFD97706)),
  Executive(name: '정한수', role: 'COO', dept: '운영', since: '2019', color: Color(0xFF8B5CF6)),
];

// ── Competitor (경쟁사탭) ──
class Competitor {
  final String name;
  final double revenue;
  final double profit;
  final double profitRate;
  final int employees;
  final double growth;
  final double debt;
  final int year;
  final Color color;
  final bool isTarget;
  const Competitor({required this.name, required this.revenue, required this.profit, required this.profitRate, required this.employees, required this.growth, required this.debt, required this.year, required this.color, this.isTarget = false});
}

const competitors = [
  Competitor(name: '에이치비테크놀로지', revenue: 342, profit: 28, profitRate: 8.2, employees: 187, growth: 4.3, debt: 65, year: 2011, color: Color(0xFF6395FF), isTarget: true),
  Competitor(name: '세미텍인스트루먼트', revenue: 287, profit: 22, profitRate: 7.7, employees: 145, growth: 5.2, debt: 72, year: 2008, color: Color(0xFF34D399)),
  Competitor(name: '프로브앤텍', revenue: 198, profit: 15, profitRate: 7.6, employees: 92, growth: 12.4, debt: 85, year: 2015, color: Color(0xFFFBBF24)),
  Competitor(name: '케이반도체장비', revenue: 456, profit: 38, profitRate: 8.3, employees: 310, growth: 3.2, debt: 58, year: 2003, color: Color(0xFFF87171)),
  Competitor(name: '테크윈시스템즈', revenue: 312, profit: 26, profitRate: 8.3, employees: 178, growth: 5.4, debt: 68, year: 2006, color: Color(0xFFA78BFA)),
];

// ── SimilarCompany (유사기업탭) ──
class SimilarCompany {
  final String name;
  final String desc;
  final double revenue;
  final double profit;
  final double profitGrowth;
  final Color color;
  final List<String> chips;
  const SimilarCompany({required this.name, required this.desc, required this.revenue, required this.profit, required this.profitGrowth, required this.color, required this.chips});
}

const similarCompanies = [
  SimilarCompany(name: '세미텍인스트루먼트', desc: '반도체 테스트 솔루션', revenue: 287, profit: 22, profitGrowth: 6.8, color: Color(0xFF059669), chips: ['동일 업종', '유사 규모']),
  SimilarCompany(name: '프로브앤텍', desc: '프로브카드·소켓 제조', revenue: 198, profit: 15, profitGrowth: 8.7, color: Color(0xFFD97706), chips: ['동일 업종', '같은 지역']),
  SimilarCompany(name: '케이반도체장비', desc: '반도체 후공정 장비', revenue: 456, profit: 38, profitGrowth: 3.2, color: Color(0xFF0549CC), chips: ['동일 업종', '유사 매출']),
  SimilarCompany(name: '테크윈시스템즈', desc: '전자부품 검사장비', revenue: 312, profit: 26, profitGrowth: 5.4, color: Color(0xFF8B5CF6), chips: ['유사 규모', '같은 지역']),
  SimilarCompany(name: '나노프리시전', desc: '웨이퍼 정밀측정장비', revenue: 234, profit: 19, profitGrowth: 11.2, color: Color(0xFFDC2626), chips: ['동일 업종', '유사 규모']),
  SimilarCompany(name: '에이엠테크놀로지', desc: '반도체 패키징 장비', revenue: 380, profit: 32, profitGrowth: 4.1, color: Color(0xFF0549CC), chips: ['동일 업종', '유사 매출']),
  SimilarCompany(name: '한일정밀기기', desc: '정밀 검사·측정장비', revenue: 165, profit: 12, profitGrowth: 7.3, color: Color(0xFF14B8A6), chips: ['동일 업종', '유사 규모']),
  SimilarCompany(name: '디에스이', desc: '반도체 디스플레이 검사', revenue: 290, profit: 24, profitGrowth: 6.1, color: Color(0xFFEA580C), chips: ['동일 업종', '같은 지역']),
];

// ── NewsItem (뉴스탭) ──
class NewsItem {
  final String title;
  final String summary;
  final String source;
  final String time;
  final String emoji;
  const NewsItem({required this.title, required this.summary, required this.source, required this.time, required this.emoji});
}

const newsItems = [
  NewsItem(title: '에이치비테크놀로지, AI 검사장비 HB-Vision 2.0 출시', summary: '딥러닝 기반 불량 검출율 기존 대비 30% 향상... 반도체 후공정 시장 점유율 확대 기대', source: '전자신문', time: '2시간 전', emoji: '🔬'),
  NewsItem(title: '반도체 장비 국산화율 70% 돌파... 에이치비테크 등 선도', summary: '정부 반도체 소부장 육성 정책과 맞물려 국내 장비 업체 실적 호조세', source: '매일경제', time: '5시간 전', emoji: '📈'),
  NewsItem(title: '에이치비테크, Series B 투자 200억원 유치', summary: '미래에셋벤처투자 주도, 기업가치 1,200억원 평가... 해외 진출 가속화', source: '한국경제', time: '1일 전', emoji: '💰'),
  NewsItem(title: '삼성전자, 반도체 검사장비 국산화 확대... 에이치비테크 수혜', summary: '삼성전자 파운드리 사업부, 국내 장비 업체 납품 비율 30%→45% 목표', source: '조선비즈', time: '2일 전', emoji: '🏭'),
  NewsItem(title: '에이치비테크놀로지, 일본 세미콘 재팬 참가', summary: '웨이퍼 프로버 신제품 전시... 일본 고객사 미팅 10건 이상', source: '디일렉', time: '3일 전', emoji: '🌏'),
];

// ── CommunityPost (커뮤니티탭) ──
class CommunityPost {
  final String username;
  final String avatar;
  final Color avatarColor;
  final String? badge;
  final String title;
  final String body;
  final int likes;
  final int comments;
  final String time;
  const CommunityPost({required this.username, required this.avatar, required this.avatarColor, this.badge, required this.title, required this.body, required this.likes, required this.comments, required this.time});
}

const communityPosts = [
  CommunityPost(username: '김영호', avatar: '김', avatarColor: Color(0xFF0549CC), badge: '주주', title: '에이치비테크 장비 실사용 후기', body: '에이치비테크 장비 실제로 써봤는데 퀄리티가 상당합니다. 일본 경쟁사 대비 가성비가 훨씬 좋고 A/S도 빠릅니다.', likes: 24, comments: 8, time: '3시간 전'),
  CommunityPost(username: '박지현', avatar: '박', avatarColor: Color(0xFF059669), title: 'HB-Vision 데모 인상적이었습니다', body: 'AI 검사 솔루션 HB-Vision 데모를 봤는데 인상적이었어요. 정확도가 기존 룰 베이스 대비 확실히 높더라고요.', likes: 12, comments: 3, time: '6시간 전'),
  CommunityPost(username: '이준서', avatar: '이', avatarColor: Color(0xFFF59E0B), badge: '주주', title: 'Series B 이후 성장세 분석', body: 'Series B 받고 나서 성장세가 더 가팔라진 것 같습니다. 반도체 장비 국산화 트렌드에 잘 올라탄 기업이라고 생각해요.', likes: 18, comments: 5, time: '1일 전'),
  CommunityPost(username: '최서윤', avatar: '최', avatarColor: Color(0xFF8B5CF6), title: '반도체 후공정 장비 시장 전망', body: '에이치비테크를 포함해 국내 반도체 후공정 장비 업체들의 전망이 밝아 보입니다. AI 반도체 수요 증가로 테스트/검사 장비 수요 증가.', likes: 9, comments: 4, time: '2일 전'),
];

// ── Waterfall Data ──
class WaterfallSegment {
  final String label;
  final double value;
  final bool isTotal;
  const WaterfallSegment({required this.label, required this.value, this.isTotal = false});
}

const waterfallData = {
  '2024': [
    WaterfallSegment(label: '상품매출', value: 142),
    WaterfallSegment(label: '제품매출', value: 118),
    WaterfallSegment(label: '용역매출', value: 52),
    WaterfallSegment(label: '수출매출', value: 22),
    WaterfallSegment(label: '기타', value: 8),
    WaterfallSegment(label: '총 매출', value: 342, isTotal: true),
  ],
  '2023': [
    WaterfallSegment(label: '상품매출', value: 128),
    WaterfallSegment(label: '제품매출', value: 112),
    WaterfallSegment(label: '용역매출', value: 46),
    WaterfallSegment(label: '수출매출', value: 18),
    WaterfallSegment(label: '기타', value: 6),
    WaterfallSegment(label: '총 매출', value: 310, isTotal: true),
  ],
  '2022': [
    WaterfallSegment(label: '상품매출', value: 118),
    WaterfallSegment(label: '제품매출', value: 105),
    WaterfallSegment(label: '용역매출', value: 42),
    WaterfallSegment(label: '수출매출', value: 15),
    WaterfallSegment(label: '기타', value: 15),
    WaterfallSegment(label: '총 매출', value: 295, isTotal: true),
  ],
};

// ── Financial Time Series ──
const years = ['2021', '2022', '2023', '2024', '2025'];
const revenueHistory = [280.0, 295.0, 310.0, 328.0, 342.0];
const profitHistory = [18.0, 20.0, 22.0, 25.0, 28.0];
const netProfitHistory = [12.0, 14.0, 15.0, 18.0, 20.0];
const employeeHistory = [120.0, 138.0, 155.0, 172.0, 187.0];
const debtRatioHistory = [85.0, 78.0, 72.0, 68.0, 65.0];

// ── Valuation Data ──
class ValuationMetric {
  final String label;
  final String unit;
  final List<String> years;
  final List<double> values;
  final double maxScale;
  final bool trendUp;
  final String insight;
  const ValuationMetric({required this.label, required this.unit, required this.years, required this.values, required this.maxScale, required this.trendUp, required this.insight});
}

const valuationMetrics = {
  'OPM': ValuationMetric(label: '영업이익률', unit: '%', years: ['2023', '2024', '2025'], values: [7.1, 7.6, 8.2], maxScale: 15, trendUp: true, insight: '영업이익률이 3년 연속 상승 추세이며, 최근 결산년 8.2%를 기록했습니다'),
  'NPM': ValuationMetric(label: '순이익률', unit: '%', years: ['2023', '2024', '2025'], values: [4.8, 5.5, 5.8], maxScale: 10, trendUp: true, insight: '순이익률이 안정적으로 개선 중이며, 최근 5.8%를 기록했습니다'),
  'DEBT': ValuationMetric(label: '부채비율', unit: '%', years: ['2023', '2024', '2025'], values: [72, 68, 65], maxScale: 100, trendUp: false, insight: '부채비율이 꾸준히 감소하여 재무 안정성이 개선되고 있습니다'),
  'ROE': ValuationMetric(label: 'ROE', unit: '%', years: ['2023', '2024', '2025'], values: [8.5, 10.2, 11.1], maxScale: 20, trendUp: true, insight: '자기자본이익률(ROE)이 11.1%로 높은 수익성을 보여줍니다'),
};

// ── Industry Filter Tree ──
class FilterNode {
  final String code;
  final String name;
  final int? count;
  final List<FilterNode> children;
  const FilterNode({required this.code, required this.name, this.count, this.children = const []});
}

const industryTree = [
  FilterNode(code: 'C', name: '제조업', children: [
    FilterNode(code: '26', name: '전자부품·컴퓨터·통신장비', children: [
      FilterNode(code: '261', name: '반도체 제조업', count: 12),
      FilterNode(code: '262', name: '전자부품 제조업', count: 15),
      FilterNode(code: '263', name: '컴퓨터 및 주변장치', count: 8),
      FilterNode(code: '264', name: '통신·방송장비', count: 6),
    ]),
    FilterNode(code: '27', name: '의료·정밀·광학기기', children: [
      FilterNode(code: '271', name: '의료용 기기', count: 5),
      FilterNode(code: '272', name: '측정·시험·항해기기', count: 4),
    ]),
    FilterNode(code: '28', name: '전기장비', children: [
      FilterNode(code: '281', name: '전동기·발전기', count: 3),
      FilterNode(code: '282', name: '전지 및 축전지', count: 9),
      FilterNode(code: '289', name: '기타 전기장비', count: 2),
    ]),
    FilterNode(code: '29', name: '기타 기계·장비', children: [
      FilterNode(code: '291', name: '일반목적용 기계', count: 7),
      FilterNode(code: '292', name: '특수목적용 기계', count: 5),
    ]),
    FilterNode(code: '20', name: '화학물질·화학제품', children: [
      FilterNode(code: '201', name: '기초화학물질', count: 6),
      FilterNode(code: '202', name: '합성고무·플라스틱', count: 4),
      FilterNode(code: '203', name: '비료·농약·의약', count: 3),
    ]),
    FilterNode(code: '21', name: '의약품', children: [
      FilterNode(code: '211', name: '의약품 제조업', count: 5),
      FilterNode(code: '212', name: '의약 원료 제조업', count: 3),
    ]),
    FilterNode(code: '10', name: '식료품', children: [
      FilterNode(code: '101', name: '도축·육류가공', count: 2),
      FilterNode(code: '102', name: '수산물 가공', count: 1),
      FilterNode(code: '107', name: '기타 식품', count: 3),
    ]),
    FilterNode(code: '30', name: '자동차·트레일러', children: [
      FilterNode(code: '301', name: '자동차용 엔진·부품', count: 11),
      FilterNode(code: '302', name: '자동차 차체·트레일러', count: 4),
    ]),
  ]),
  FilterNode(code: 'J', name: '정보통신업', children: [
    FilterNode(code: '58', name: '출판업', children: [
      FilterNode(code: '581', name: '서적·잡지 출판', count: 2),
      FilterNode(code: '582', name: '소프트웨어 출판', count: 4),
    ]),
    FilterNode(code: '61', name: '통신업', children: [
      FilterNode(code: '611', name: '유선통신업', count: 3),
      FilterNode(code: '612', name: '무선통신업', count: 2),
    ]),
    FilterNode(code: '62', name: '소프트웨어 개발·공급', children: [
      FilterNode(code: '620', name: '소프트웨어 개발·공급', count: 14),
    ]),
    FilterNode(code: '63', name: '정보서비스업', children: [
      FilterNode(code: '631', name: '자료처리·호스팅', count: 8),
      FilterNode(code: '632', name: '포털·기타 인터넷', count: 6),
    ]),
  ]),
  FilterNode(code: 'M', name: '전문·과학·기술 서비스업', children: [
    FilterNode(code: '70', name: '연구개발업', children: [
      FilterNode(code: '701', name: '자연과학 연구개발', count: 7),
      FilterNode(code: '702', name: '인문·사회과학 연구개발', count: 2),
    ]),
    FilterNode(code: '71', name: '전문 서비스업', children: [
      FilterNode(code: '711', name: '법무 서비스', count: 1),
      FilterNode(code: '713', name: '엔지니어링 서비스', count: 6),
    ]),
  ]),
  FilterNode(code: 'D', name: '전기·가스·수도', children: [
    FilterNode(code: '35', name: '전기·가스·증기업', children: [
      FilterNode(code: '351', name: '전기업', count: 4),
      FilterNode(code: '352', name: '가스업', count: 2),
    ]),
  ]),
];

// ── Product Filter Tree ──
const productTree = [
  FilterNode(code: 'SE', name: '반도체/전자', children: [
    FilterNode(code: 'SE1', name: '반도체 장비', children: [
      FilterNode(code: 'SE11', name: '검사장비', count: 8),
      FilterNode(code: 'SE12', name: '프로버', count: 5),
      FilterNode(code: 'SE13', name: '웨이퍼 가공장비', count: 6),
      FilterNode(code: 'SE14', name: '식각/증착장비', count: 4),
    ]),
    FilterNode(code: 'SE2', name: '반도체 소재', children: [
      FilterNode(code: 'SE21', name: '웨이퍼', count: 7),
      FilterNode(code: 'SE22', name: '메모리칩', count: 9),
      FilterNode(code: 'SE23', name: 'SiC/GaN', count: 3),
    ]),
    FilterNode(code: 'SE3', name: '전자부품', children: [
      FilterNode(code: 'SE31', name: 'PCB', count: 6),
      FilterNode(code: 'SE32', name: 'MLCC/커넥터', count: 5),
      FilterNode(code: 'SE33', name: '센서 모듈', count: 4),
    ]),
  ]),
  FilterNode(code: 'SW', name: '소프트웨어/IT', children: [
    FilterNode(code: 'SW1', name: '엔터프라이즈 SW', children: [
      FilterNode(code: 'SW11', name: 'ERP 솔루션', count: 4),
      FilterNode(code: 'SW12', name: 'CRM/SFA', count: 3),
      FilterNode(code: 'SW13', name: '물류관리 플랫폼', count: 2),
    ]),
    FilterNode(code: 'SW2', name: 'AI/데이터', children: [
      FilterNode(code: 'SW21', name: 'AI 영상분석', count: 5),
      FilterNode(code: 'SW22', name: '빅데이터 분석', count: 4),
      FilterNode(code: 'SW23', name: '자연어처리', count: 3),
    ]),
    FilterNode(code: 'SW3', name: '클라우드/인프라', children: [
      FilterNode(code: 'SW31', name: 'MSP/클라우드', count: 6),
      FilterNode(code: 'SW32', name: '보안 솔루션', count: 4),
    ]),
  ]),
  FilterNode(code: 'EN', name: '에너지', children: [
    FilterNode(code: 'EN1', name: '신재생에너지', children: [
      FilterNode(code: 'EN11', name: '태양광 모듈', count: 5),
      FilterNode(code: 'EN12', name: 'ESS', count: 4),
      FilterNode(code: 'EN13', name: '태양광 셀/인버터', count: 3),
    ]),
    FilterNode(code: 'EN2', name: '2차전지', children: [
      FilterNode(code: 'EN21', name: '배터리 셀', count: 7),
      FilterNode(code: 'EN22', name: '양극재/음극재', count: 5),
      FilterNode(code: 'EN23', name: '전해질/분리막', count: 3),
    ]),
  ]),
  FilterNode(code: 'ME', name: '기계/자동차', children: [
    FilterNode(code: 'ME1', name: '산업기계', children: [
      FilterNode(code: 'ME11', name: '정밀 절삭공구', count: 4),
      FilterNode(code: 'ME12', name: '협동 로봇', count: 3),
      FilterNode(code: 'ME13', name: '산업용 펌프/밸브', count: 2),
    ]),
    FilterNode(code: 'ME2', name: '자동차부품', children: [
      FilterNode(code: 'ME21', name: '전장부품', count: 6),
      FilterNode(code: 'ME22', name: '구동계 부품', count: 4),
      FilterNode(code: 'ME23', name: '차체 부품', count: 3),
    ]),
  ]),
  FilterNode(code: 'BM', name: '바이오/의료', children: [
    FilterNode(code: 'BM1', name: '바이오의약', children: [
      FilterNode(code: 'BM11', name: '항체 치료제', count: 5),
      FilterNode(code: 'BM12', name: '세포 치료제', count: 3),
    ]),
    FilterNode(code: 'BM2', name: '의료기기', children: [
      FilterNode(code: 'BM21', name: '초음파 진단기', count: 4),
      FilterNode(code: 'BM22', name: '수술 로봇', count: 2),
    ]),
  ]),
  FilterNode(code: 'CH', name: '화학/소재', children: [
    FilterNode(code: 'CH1', name: '정밀화학', children: [
      FilterNode(code: 'CH11', name: '코팅제', count: 3),
      FilterNode(code: 'CH12', name: '접착소재', count: 2),
      FilterNode(code: 'CH13', name: '전자재료', count: 5),
    ]),
  ]),
  FilterNode(code: 'FD', name: '식품/음료', children: [
    FilterNode(code: 'FD1', name: '식품', children: [
      FilterNode(code: 'FD11', name: '건강기능식품', count: 3),
      FilterNode(code: 'FD12', name: 'HMR', count: 2),
    ]),
  ]),
];

// ── Region Filter List ──
class RegionItem {
  final String code;
  final String name;
  final int count;
  const RegionItem({required this.code, required this.name, required this.count});
}

const regionList = [
  RegionItem(code: 'seoul', name: '서울', count: 42),
  RegionItem(code: 'gyeonggi', name: '경기', count: 35),
  RegionItem(code: 'incheon', name: '인천', count: 8),
  RegionItem(code: 'busan', name: '부산', count: 7),
  RegionItem(code: 'daejeon', name: '대전', count: 6),
  RegionItem(code: 'chungnam', name: '충남', count: 6),
  RegionItem(code: 'gyeongnam', name: '경남', count: 6),
  RegionItem(code: 'daegu', name: '대구', count: 5),
  RegionItem(code: 'gyeongbuk', name: '경북', count: 5),
  RegionItem(code: 'chungbuk', name: '충북', count: 4),
  RegionItem(code: 'gwangju', name: '광주', count: 4),
  RegionItem(code: 'jeonbuk', name: '전북', count: 3),
  RegionItem(code: 'ulsan', name: '울산', count: 3),
  RegionItem(code: 'jeonnam', name: '전남', count: 2),
  RegionItem(code: 'gangwon', name: '강원', count: 2),
  RegionItem(code: 'sejong', name: '세종', count: 1),
  RegionItem(code: 'jeju', name: '제주', count: 1),
];
