import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const DetailApp());

const ink = Color(0xFF0B0D10);
const blue = Color(0xFF123C69);
const mist = Color(0xFFF4F5F7);
const green = Color(0xFF20B15A);

class DetailApp extends StatelessWidget {
  const DetailApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Super Segar · Cuci Kusyen Kereta',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: blue,
        brightness: Brightness.light,
      ),
      fontFamily: 'Arial',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 72,
          height: .98,
          fontWeight: FontWeight.w700,
          letterSpacing: -3.2,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 52,
          height: 1.02,
          fontWeight: FontWeight.w700,
          letterSpacing: -2,
          color: ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          height: 1.1,
          fontWeight: FontWeight.w700,
          letterSpacing: -.8,
          color: ink,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          height: 1.55,
          color: Color(0xFF5B616B),
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Color(0xFF666C75),
        ),
      ),
    ),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool bm = true;
  final homeKey = GlobalKey();
  final servicesKey = GlobalKey();
  final packagesKey = GlobalKey();

  void go(GlobalKey key) => Scrollable.ensureVisible(
    key.currentContext!,
    duration: const Duration(milliseconds: 750),
    curve: Curves.easeInOutCubic,
  );
  void booking([int? selectedPackage]) => showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .72),
    builder: (_) => BookingDialog(bm: bm, initialPackage: selectedPackage ?? 0),
  );
  Future<void> whatsapp() => launchUrl(
    Uri.parse(
      bm
          ? 'https://wa.me/60139281004?text=Hai%20Super%20Segar%2C%20saya%20ingin%20menempah%20servis%20cuci%20kusyen%20kereta.'
          : 'https://wa.me/60139281004?text=Hi%20Super%20Segar%2C%20I%27d%20like%20to%20book%20a%20mobile%20seat-cleaning%20service.',
    ),
    mode: LaunchMode.externalApplication,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        SelectionArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeroSection(
                  key: homeKey,
                  bm: bm,
                  onLanguage: (value) => setState(() => bm = value),
                  onNav: (name) => go(
                    name == 'Services'
                        ? servicesKey
                        : name == 'Packages'
                        ? packagesKey
                        : homeKey,
                  ),
                  onBook: () => booking(),
                ),
                ServicesSection(key: servicesKey, bm: bm),
                ComparisonSection(bm: bm),
                PackagesSection(key: packagesKey, bm: bm, onBook: booking),
                TestimonialsSection(bm: bm),
                FaqSection(bm: bm),
                SiteFooter(bm: bm),
              ],
            ),
          ),
        ),
        Positioned(
          right: 18,
          bottom: 20 + MediaQuery.paddingOf(context).bottom,
          child: FloatingActions(
            bm: bm,
            onBook: () => booking(),
            onWhatsApp: whatsapp,
          ),
        ),
      ],
    ),
  );
}

class Brand extends StatelessWidget {
  final bool light;
  const Brand({super.key, this.light = true});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ClipOval(
        child: Image.asset(
          'assets/images/super-segar-logo.png',
          width: 36,
          height: 36,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(width: 11),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUPER SEGAR',
            style: TextStyle(
              color: light ? Colors.white : ink,
              fontWeight: FontWeight.w800,
              fontSize: 15,
              letterSpacing: 2.2,
            ),
          ),
          Text(
            'CUCI KUSYEN KERETA',
            style: TextStyle(
              color: (light ? Colors.white : ink).withValues(alpha: .62),
              fontWeight: FontWeight.w600,
              fontSize: 7,
              letterSpacing: 1.35,
            ),
          ),
        ],
      ),
    ],
  );
}

class MarkPainter extends CustomPainter {
  final Color color;
  MarkPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(7, 22)
        ..lineTo(7, 9)
        ..lineTo(22, 22)
        ..lineTo(22, 8),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeroSection extends StatelessWidget {
  final bool bm;
  final ValueChanged<bool> onLanguage;
  final void Function(String) onNav;
  final VoidCallback onBook;
  const HeroSection({
    super.key,
    required this.bm,
    required this.onLanguage,
    required this.onNav,
    required this.onBook,
  });
  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 720;
    return Container(
      constraints: const BoxConstraints(minHeight: 720),
      height: MediaQuery.sizeOf(context).height.clamp(720, 980),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/hero-detailing.png'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: mobile ? .82 : .68),
              Colors.black.withValues(alpha: .18),
              Colors.black.withValues(alpha: .08),
            ],
            stops: const [0, .54, 1],
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          mobile ? 22 : 64,
          24,
          mobile ? 22 : 64,
          46,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Brand(),
                  const Spacer(),
                  if (!mobile)
                    ...[
                      ('Home', 'Home', 'Utama'),
                      ('Services', 'Services', 'Servis'),
                      ('Packages', 'Vehicles', 'Kenderaan'),
                    ].map(
                      (e) => TextButton(
                        onPressed: () => onNav(e.$1),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        child: Text(bm ? e.$3 : e.$2),
                      ),
                    ),
                  const SizedBox(width: 8),
                  LanguageToggle(bm: bm, onChanged: onLanguage),
                  if (!mobile) const SizedBox(width: 10),
                  if (!mobile)
                    OutlinedButton(
                      onPressed: onBook,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 17,
                        ),
                      ),
                      child: Text(bm ? 'Tempah servis' : 'Book a detail'),
                    ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  bm
                      ? 'LEMBAH KLANG  •  KAMI DATANG KE LOKASI ANDA'
                      : 'KLANG VALLEY  •  WE COME TO YOU',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 710),
                child: Text(
                  bm
                      ? 'Dalaman kereta anda. Kembali sempurna.'
                      : 'Your car’s best interior. Recovered.',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: mobile ? 46 : 72,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Text(
                  bm
                      ? 'Cucian dalaman premium untuk tempat duduk, karpet dan setiap permukaan — di rumah atau pejabat anda.'
                      : 'Premium mobile deep cleaning for seats, carpets and every surface in between — at your home or office.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: .8),
                    fontSize: mobile ? 16 : 18,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FilledButton.icon(
                onPressed: onBook,
                icon: const Icon(Icons.arrow_forward_rounded, size: 19),
                iconAlignment: IconAlignment.end,
                label: Text(
                  bm ? 'Pulihkan dalaman anda' : 'Restore your interior',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: ink,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 26,
                runSpacing: 12,
                children: [
                  MiniProof(
                    icon: Icons.home_outlined,
                    text: bm ? 'Rumah atau pejabat' : 'Home or office',
                  ),
                  MiniProof(
                    icon: Icons.water_drop_outlined,
                    text: bm
                        ? 'Ekstraksi profesional'
                        : 'Professional extraction',
                  ),
                  MiniProof(
                    icon: Icons.verified_outlined,
                    text: bm ? 'Diperiksa pakar' : 'Detailer inspected',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageToggle extends StatelessWidget {
  final bool bm;
  final ValueChanged<bool> onChanged;
  const LanguageToggle({super.key, required this.bm, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: .28),
      border: Border.all(color: Colors.white30),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [_option('BM', true), _option('BI', false)],
    ),
  );

  Widget _option(String label, bool value) => InkWell(
    onTap: () => onChanged(value),
    borderRadius: BorderRadius.circular(18),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bm == value ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: bm == value ? ink : Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

class MiniProof extends StatelessWidget {
  final IconData icon;
  final String text;
  const MiniProof({super.key, required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: Colors.white70, size: 17),
      const SizedBox(width: 7),
      Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13)),
    ],
  );
}

class SectionHead extends StatelessWidget {
  final String eyebrow, title, copy;
  final bool dark;
  const SectionHead({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.copy,
    this.dark = false,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eyebrow.toUpperCase(),
        style: TextStyle(
          color: dark ? Colors.white60 : blue,
          fontWeight: FontWeight.w800,
          fontSize: 11,
          letterSpacing: 2,
        ),
      ),
      const SizedBox(height: 16),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(color: dark ? Colors.white : ink),
        ),
      ),
      const SizedBox(height: 16),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Text(
          copy,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: dark ? Colors.white60 : null),
        ),
      ),
    ],
  );
}

const servicesEn = [
  (
    'Interior Deep Clean',
    'A meticulous reset for consoles, trims, crevices and every touchpoint.',
    'assets/images/interior.jpg',
  ),
  (
    'Seat Shampoo',
    'Fabric-safe shampoo and hot-water extraction that lifts embedded spills.',
    'assets/images/detail.jpg',
  ),
  (
    'Carpet Extraction',
    'Deep vacuuming and controlled extraction for fibres, mats and boot lining.',
    'assets/images/carpet.jpg',
  ),
  (
    'Leather Care',
    'pH-balanced cleaning and conditioning for a soft, natural matte finish.',
    'assets/images/leather.jpg',
  ),
  (
    'Odour Treatment',
    'Source-focused treatment for smoke, food, pet and musty cabin odours.',
    'assets/images/interior.jpg',
  ),
  (
    'Exterior Detail',
    'A careful hand wash, decontamination and gloss-enhancing protection.',
    'assets/images/exterior.jpg',
  ),
];
const servicesBm = [
  (
    'Cucian Dalaman Menyeluruh',
    'Pembersihan teliti untuk konsol, trim, celah dan setiap titik sentuhan.',
    'assets/images/interior.jpg',
  ),
  (
    'Syampu Tempat Duduk',
    'Syampu selamat fabrik dan ekstraksi air panas mengangkat tumpahan yang tertanam.',
    'assets/images/detail.jpg',
  ),
  (
    'Ekstraksi Karpet',
    'Vakum mendalam dan ekstraksi terkawal untuk karpet, alas kaki dan ruang but.',
    'assets/images/carpet.jpg',
  ),
  (
    'Penjagaan Kulit',
    'Pembersihan pH seimbang dan perapi untuk kemasan lembut serta semula jadi.',
    'assets/images/leather.jpg',
  ),
  (
    'Rawatan Bau',
    'Rawatan terus pada punca bau asap, makanan, haiwan dan kelembapan.',
    'assets/images/interior.jpg',
  ),
  (
    'Perincian Luaran',
    'Cucian tangan, dekontaminasi dan perlindungan yang meningkatkan kilauan.',
    'assets/images/exterior.jpg',
  ),
];

class ServicesSection extends StatelessWidget {
  final bool bm;
  const ServicesSection({super.key, required this.bm});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final cols = w > 1000
        ? 3
        : w > 620
        ? 2
        : 1;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: w < 700 ? 20 : 56,
        vertical: w < 700 ? 82 : 124,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHead(
                eyebrow: bm ? 'Apa yang kami pulihkan' : 'What we restore',
                title: bm
                    ? 'Penjagaan mendalam. Tepat pada tempatnya.'
                    : 'Deep care. Precisely where it matters.',
                copy: bm
                    ? 'Daripada kesan harian hingga kotoran bertahun-tahun, setiap rawatan dipilih mengikut bahan dan keadaan kabin anda.'
                    : 'From daily wear to years of build-up, each treatment is selected for your cabin’s materials and condition.',
              ),
              const SizedBox(height: 52),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: servicesEn.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: cols == 1 ? 1.08 : .82,
                ),
                itemBuilder: (_, i) =>
                    ServiceCard(data: (bm ? servicesBm : servicesEn)[i]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final (String, String, String) data;
  const ServiceCard({super.key, required this.data});
  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => hover = true),
    onExit: (_) => setState(() => hover = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      transform: Matrix4.translationValues(0, hover ? -7 : 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: hover ? .12 : .06),
            blurRadius: hover ? 30 : 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: AnimatedScale(
                scale: hover ? 1.035 : 1,
                duration: const Duration(milliseconds: 350),
                child: Image.asset(widget.data.$3, fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.$1,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 9),
                Text(widget.data.$2),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class ComparisonSection extends StatelessWidget {
  final bool bm;
  const ComparisonSection({super.key, required this.bm});
  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 760;
    return Container(
      color: ink,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 20 : 56,
        vertical: mobile ? 82 : 124,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHead(
                eyebrow: bm ? 'Sebelum / Selepas' : 'Before / After',
                title: bm
                    ? 'Perbezaannya terletak pada perincian.'
                    : 'The difference is in the detail.',
                copy: bm
                    ? 'Seret pada setiap imej untuk melihat hasil ekstraksi terkawal, cucian teliti dan bahan kimia yang selamat.'
                    : 'Drag across each image to reveal what controlled extraction, patient agitation and material-safe chemistry can achieve.',
                dark: true,
              ),
              const SizedBox(height: 48),
              Flex(
                direction: mobile ? Axis.vertical : Axis.horizontal,
                children: [
                  ExpandedOrBox(
                    child: BeforeAfter(
                      image: 'assets/images/interior.jpg',
                      title: bm
                          ? 'Tempat duduk fabrik · kopi & kesan harian'
                          : 'Fabric seats · coffee & daily wear',
                    ),
                  ),
                  SizedBox(width: mobile ? 0 : 20, height: mobile ? 20 : 0),
                  ExpandedOrBox(
                    child: BeforeAfter(
                      image: 'assets/images/detail.jpg',
                      title: bm
                          ? 'Pemulihan kabin · SUV keluarga'
                          : 'Cabin reset · family SUV',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandedOrBox extends StatelessWidget {
  final Widget child;
  const ExpandedOrBox({super.key, required this.child});
  @override
  Widget build(BuildContext context) => MediaQuery.sizeOf(context).width < 760
      ? SizedBox(height: 390, width: double.infinity, child: child)
      : Expanded(child: SizedBox(height: 480, child: child));
}

class BeforeAfter extends StatefulWidget {
  final String image, title;
  const BeforeAfter({super.key, required this.image, required this.title});
  @override
  State<BeforeAfter> createState() => _BeforeAfterState();
}

class _BeforeAfterState extends State<BeforeAfter> {
  double value = .56;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: LayoutBuilder(
      builder: (context, c) {
        return GestureDetector(
          onHorizontalDragUpdate: (d) => setState(
            () => value = (d.localPosition.dx / c.maxWidth).clamp(.05, .95),
          ),
          onTapDown: (d) => setState(
            () => value = (d.localPosition.dx / c.maxWidth).clamp(.05, .95),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  .7,
                  .1,
                  0,
                  0,
                  28,
                  .12,
                  .62,
                  .05,
                  0,
                  12,
                  0,
                  .12,
                  .42,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
                child: Image.asset(widget.image, fit: BoxFit.cover),
              ),
              ClipRect(
                clipper: SliderClip(value),
                child: Image.asset(
                  widget.image,
                  fit: BoxFit.cover,
                  color: Colors.white.withValues(alpha: .04),
                  colorBlendMode: BlendMode.screen,
                ),
              ),
              Positioned(left: 16, top: 16, child: Tag('BEFORE')),
              Positioned(right: 16, top: 16, child: Tag('AFTER')),
              Positioned(
                left: c.maxWidth * value - 1,
                bottom: 0,
                top: 0,
                child: Container(width: 2, color: Colors.white),
              ),
              Positioned(
                left: c.maxWidth * value - 22,
                top: c.maxHeight / 2 - 22,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.unfold_more_rounded, color: ink),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 18,
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class SliderClip extends CustomClipper<Rect> {
  final double v;
  SliderClip(this.v);
  @override
  Rect getClip(Size s) =>
      Rect.fromLTWH(s.width * v, 0, s.width * (1 - v), s.height);
  @override
  bool shouldReclip(SliderClip old) => old.v != v;
}

class Tag extends StatelessWidget {
  final String t;
  const Tag(this.t, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      t,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
      ),
    ),
  );
}

const packages = [
  (
    'SEDAN',
    'RM 115',
    'Promo · was RM 140',
    [
      'Complete seat cleaning',
      'City, Vios, Persona, Civic',
      'All seat surfaces treated',
    ],
  ),
  (
    'HATCHBACK / COMPACT',
    'RM 95',
    'Promo · was RM 120',
    [
      'Complete seat cleaning',
      'Axia, Myvi, Saga, Viva',
      'All seat surfaces treated',
    ],
  ),
  (
    'SUV',
    'RM 135',
    'Promo · was RM 160',
    [
      'Complete seat cleaning',
      'Five or seven-seat SUV',
      'All seat surfaces treated',
    ],
  ),
  (
    'MPV / 7-SEATER',
    'RM 165',
    'Promo · was RM 190',
    [
      'Complete seat cleaning',
      'Alza, Innova, Vellfire',
      'Up to three seat rows',
    ],
  ),
  (
    'PICKUP / 4×4',
    'RM 135',
    'Promo · was RM 160',
    ['Complete seat cleaning', 'Hilux, Ranger, Navara', 'Front and rear seats'],
  ),
];
const packagesBm = [
  (
    'SEDAN',
    'RM 115',
    'Promosi · asal RM 140',
    [
      'Cuci semua tempat duduk',
      'City, Vios, Persona, Civic',
      'Semua permukaan tempat duduk',
    ],
  ),
  (
    'HATCHBACK / KOMPAK',
    'RM 95',
    'Promosi · asal RM 120',
    [
      'Cuci semua tempat duduk',
      'Axia, Myvi, Saga, Viva',
      'Semua permukaan tempat duduk',
    ],
  ),
  (
    'SUV',
    'RM 135',
    'Promosi · asal RM 160',
    [
      'Cuci semua tempat duduk',
      'SUV lima atau tujuh tempat duduk',
      'Semua permukaan tempat duduk',
    ],
  ),
  (
    'MPV / 7 TEMPAT DUDUK',
    'RM 165',
    'Promosi · asal RM 190',
    [
      'Cuci semua tempat duduk',
      'Alza, Innova, Vellfire',
      'Sehingga tiga baris tempat duduk',
    ],
  ),
  (
    'PICKUP / 4×4',
    'RM 135',
    'Promosi · asal RM 160',
    [
      'Cuci semua tempat duduk',
      'Hilux, Ranger, Navara',
      'Tempat duduk depan dan belakang',
    ],
  ),
];

class PackagesSection extends StatelessWidget {
  final bool bm;
  final ValueChanged<int> onBook;
  const PackagesSection({super.key, required this.bm, required this.onBook});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final mobile = w < 820;
    return Container(
      color: mist,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 20 : 56,
        vertical: mobile ? 82 : 124,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHead(
                eyebrow: bm ? 'Jenis kenderaan' : 'Vehicle type',
                title: bm ? 'Pilih kenderaan anda.' : 'Choose your vehicle.',
                copy: bm
                    ? 'Harga promosi untuk cucian semua tempat duduk. Tambah servis lain selepas memilih kenderaan.'
                    : 'Promotional pricing for complete seat cleaning. Add other services after choosing your vehicle.',
              ),
              const SizedBox(height: 50),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: w >= 1040
                      ? 3
                      : w >= 650
                      ? 2
                      : 1,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: w >= 1040
                      ? .80
                      : w >= 650
                      ? .70
                      : .60,
                ),
                itemBuilder: (_, i) => PackageCard(
                  data: (bm ? packagesBm : packages)[i],
                  bm: bm,
                  featured: i == 2,
                  onBook: () => onBook(i),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandedOrNatural extends StatelessWidget {
  final Widget child;
  const ExpandedOrNatural({super.key, required this.child});
  @override
  Widget build(BuildContext context) => MediaQuery.sizeOf(context).width < 820
      ? Padding(padding: const EdgeInsets.only(bottom: 16), child: child)
      : Expanded(child: child);
}

class PackageCard extends StatelessWidget {
  final bool bm;
  final (String, String, String, List<String>) data;
  final bool featured;
  final VoidCallback onBook;
  const PackageCard({
    super.key,
    required this.data,
    required this.bm,
    required this.featured,
    required this.onBook,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
      color: featured ? ink : Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: featured ? ink : const Color(0xFFE4E6E9)),
      boxShadow: featured
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: .18),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ]
          : null,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                data.$1,
                maxLines: 2,
                style: TextStyle(
                  color: featured ? Colors.white60 : blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            if (featured) const SizedBox(width: 8),
            if (featured) Tag(bm ? 'PALING DIPILIH' : 'MOST CHOSEN'),
          ],
        ),
        const SizedBox(height: 26),
        Text(
          data.$2,
          style: TextStyle(
            color: featured ? Colors.white : ink,
            fontSize: 40,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.8,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          data.$3,
          style: TextStyle(color: featured ? Colors.white54 : Colors.black54),
        ),
        const SizedBox(height: 28),
        ...data.$4.map(
          (x) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Icon(
                  Icons.check_rounded,
                  size: 19,
                  color: featured ? Colors.white : blue,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    x,
                    style: TextStyle(
                      color: featured
                          ? Colors.white70
                          : const Color(0xFF4F555F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onBook,
            style: FilledButton.styleFrom(
              backgroundColor: featured ? Colors.white : blue,
              foregroundColor: featured ? ink : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: Text(bm ? 'Pilih kenderaan' : 'Choose vehicle'),
          ),
        ),
      ],
    ),
  );
}

class TestimonialsSection extends StatelessWidget {
  final bool bm;
  const TestimonialsSection({super.key, required this.bm});
  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 760;
    final reviews = bm
        ? [
            (
              '“Kesan kopi dan bau hapak hilang sepenuhnya. Rasanya seperti menerima kereta baharu semula.”',
              'Aina R.',
              'Mazda CX-5 · Mont Kiara',
            ),
            (
              '“Mereka bekerja dengan tenang di parkir pejabat kami dan hasil ekstraksi memang luar biasa. Betul-betul pakar.”',
              'Daniel T.',
              'BMW 3 Series · Bangsar',
            ),
            (
              '“Dengan dua orang anak, saya fikir tempat duduk belakang tidak boleh diselamatkan. Super Segar membuktikan sebaliknya.”',
              'Farah H.',
              'Toyota Vellfire · Shah Alam',
            ),
          ]
        : [
            (
              '“The coffee marks and musty smell are completely gone. It feels like I collected the car new again.”',
              'Aina R.',
              'Mazda CX-5 · Mont Kiara',
            ),
            (
              '“They worked quietly in our office basement and the extraction result was exceptional. Proper specialists.”',
              'Daniel T.',
              'BMW 3 Series · Bangsar',
            ),
            (
              '“With two children, I thought the rear seats were beyond saving. Super Segar proved me wrong.”',
              'Farah H.',
              'Toyota Vellfire · Shah Alam',
            ),
          ];
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 20 : 56,
        vertical: mobile ? 82 : 118,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHead(
                eyebrow: bm ? 'Kata pelanggan' : 'Client notes',
                title: bm
                    ? 'Kereta bersih. Kesan yang jelas.'
                    : 'Clean cars. Clear impressions.',
                copy: bm
                    ? 'Maklum balas sebenar daripada pemandu di seluruh Lembah Klang.'
                    : 'Real feedback from drivers across the Klang Valley.',
              ),
              const SizedBox(height: 45),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children: reviews
                    .map(
                      (r) => Container(
                        width: mobile ? double.infinity : 390,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: mist,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.star_rounded, color: blue, size: 17),
                                Icon(Icons.star_rounded, color: blue, size: 17),
                                Icon(Icons.star_rounded, color: blue, size: 17),
                                Icon(Icons.star_rounded, color: blue, size: 17),
                                Icon(Icons.star_rounded, color: blue, size: 17),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              r.$1,
                              style: const TextStyle(
                                color: ink,
                                fontSize: 17,
                                height: 1.55,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              r.$2,
                              style: const TextStyle(
                                color: ink,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(r.$3),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FaqSection extends StatelessWidget {
  final bool bm;
  const FaqSection({super.key, required this.bm});
  @override
  Widget build(BuildContext context) {
    final q = bm
        ? [
            (
              'Apa yang diperlukan di lokasi saya?',
              'Ruang parkir yang selamat, soket elektrik standard dan sumber air dalam jarak 20 meter. Beritahu kami jika salah satu tiada—kami boleh merancang untuk kebanyakan lokasi.',
            ),
            (
              'Berapa lama tempat duduk akan kering?',
              'Kebanyakan tempat duduk fabrik kering disentuh dalam 3–5 jam dengan pengudaraan. Cuaca, ketebalan fabrik dan tahap ekstraksi boleh mempengaruhi masa.',
            ),
            (
              'Bolehkah semua kotoran dan bau dihilangkan?',
              'Kebanyakan tumpahan dan bau harian bertambah baik dengan ketara. Pemindahan warna kekal, kerosakan bahan atau pencemaran mendalam mungkin tidak hilang sepenuhnya; kami akan menjelaskan jangkaan sebelum bermula.',
            ),
            (
              'Adakah anda servis kondominium dan pejabat?',
              'Ya. Kami kerap bekerja di kediaman berpengurusan dan parkir pejabat sekitar Kuala Lumpur dan Selangor, tertakluk kepada kelulusan bangunan dan akses yang sesuai.',
            ),
          ]
        : [
            (
              'What do you need at my location?',
              'A safe parking bay, access to a standard power outlet and a water point within 20 metres. Let us know if either is unavailable—we can plan around many locations.',
            ),
            (
              'How long until my seats are dry?',
              'Most fabric seats are touch-dry in 3–5 hours with doors or windows ventilated. Weather, fabric thickness and the level of extraction can affect this.',
            ),
            (
              'Can every stain and odour be removed?',
              'Most everyday spills and odours improve dramatically. Permanent dye transfer, material damage or deeply set contamination may not disappear completely; we set expectations before starting.',
            ),
            (
              'Do you service condos and offices?',
              'Yes. We regularly work in managed residences and office car parks around Kuala Lumpur and Selangor, subject to building approval and suitable access.',
            ),
          ];
    return Container(
      color: mist,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width < 700 ? 20 : 56,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHead(
                eyebrow: bm ? 'Baik untuk diketahui' : 'Good to know',
                title: bm ? 'Soalan anda, dijawab.' : 'Questions, answered.',
                copy: bm
                    ? 'Semua yang perlu anda tahu sebelum kami tiba.'
                    : 'Everything you need before we arrive.',
              ),
              const SizedBox(height: 35),
              ...q.map(
                (e) => ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(vertical: 8),
                  childrenPadding: const EdgeInsets.only(bottom: 22),
                  shape: const Border(),
                  collapsedShape: const Border(
                    bottom: BorderSide(color: Color(0xFFDADDE1)),
                  ),
                  title: Text(
                    e.$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: ink,
                    ),
                  ),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e.$2,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SiteFooter extends StatelessWidget {
  final bool bm;
  const SiteFooter({super.key, required this.bm});
  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 760;
    return Container(
      color: ink,
      padding: EdgeInsets.fromLTRB(mobile ? 22 : 60, 70, mobile ? 22 : 60, 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            children: [
              Flex(
                direction: mobile ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpandedOrNatural(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Brand(),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: 340,
                          child: Text(
                            bm
                                ? 'Pakar cuci kusyen kereta — tanpa perlu keluar rumah.'
                                : 'Professional car-seat cleaning, delivered to your doorstep.',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpandedOrNatural(
                    child: FooterCol(
                      title: bm ? 'HUBUNGI' : 'CONTACT',
                      lines: const [
                        'Saad Amir',
                        '+60 13-928 1004',
                        'abqoriglobal@gmail.com',
                        'FB / IG · Super Segar',
                      ],
                    ),
                  ),
                  ExpandedOrNatural(
                    child: FooterCol(
                      title: bm ? 'WAKTU OPERASI' : 'HOURS',
                      lines: [
                        bm
                            ? 'Isnin–Sabtu  8:00pg–6:00ptg'
                            : 'Mon–Sat  8:00am–6:00pm',
                        bm ? 'Ahad dengan tempahan' : 'Sunday by appointment',
                      ],
                    ),
                  ),
                  ExpandedOrNatural(
                    child: FooterCol(
                      title: bm ? 'KAWASAN SERVIS' : 'SERVICE AREAS',
                      lines: const [
                        'Kuala Lumpur · Petaling Jaya',
                        'Subang Jaya · Shah Alam',
                        'Mont Kiara · Bangsar · TTDI',
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 54),
              const Divider(color: Colors.white12),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    '© 2026 Super Segar',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const Spacer(),
                  if (!mobile)
                    const Text(
                      'Anda call, kami sampai.',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FooterCol extends StatelessWidget {
  final String title;
  final List<String> lines;
  const FooterCol({super.key, required this.title, required this.lines});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: mobilePad),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 17),
        ...lines.map(
          (x) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              x,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ),
      ],
    ),
  );
  static const mobilePad = 12.0;
}

class FloatingActions extends StatelessWidget {
  final bool bm;
  final VoidCallback onBook, onWhatsApp;
  const FloatingActions({
    super.key,
    required this.bm,
    required this.onBook,
    required this.onWhatsApp,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      FloatingActionButton.small(
        heroTag: 'wa',
        onPressed: onWhatsApp,
        backgroundColor: green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.chat_bubble_outline_rounded),
      ),
      const SizedBox(height: 10),
      FloatingActionButton.extended(
        heroTag: 'book',
        onPressed: onBook,
        backgroundColor: blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.calendar_month_outlined, size: 19),
        label: Text(
          bm ? 'Tempah sekarang' : 'Book now',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    ],
  );
}

class BookingDialog extends StatefulWidget {
  final bool bm;
  final int initialPackage;
  const BookingDialog({
    super.key,
    required this.bm,
    required this.initialPackage,
  });
  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final phone = TextEditingController();
  final carModel = TextEditingController();
  final location = TextEditingController();
  final date = TextEditingController();
  final notes = TextEditingController();
  late int selectedPackage;
  late String selectedTime;
  final Set<int> selectedAddOns = {};
  int step = 0;
  bool sent = false;

  List<String> get packageOptions => widget.bm
      ? [
          'Sedan · RM 115',
          'Hatchback / Kompak · RM 95',
          'SUV · RM 135',
          'MPV / 7 tempat duduk · RM 165',
          'Pickup / 4×4 · RM 135',
        ]
      : [
          'Sedan · RM 115',
          'Hatchback / Compact · RM 95',
          'SUV · RM 135',
          'MPV / 7-seater · RM 165',
          'Pickup / 4×4 · RM 135',
        ];

  int get cabinAddOnPrice => selectedPackage == 3 ? 67 : 47;
  List<(String, int)> get addOnOptions => widget.bm
      ? [
          ('Cuci bumbung', cabinAddOnPrice),
          ('Cuci karpet lantai badan', cabinAddOnPrice),
          ('Cuci 4 pintu', 20),
          ('Cuci dashboard', 15),
          ('Cuci bonet', 10),
          ('Polish 2 lampu depan', 30),
        ]
      : [
          ('Roof lining clean', cabinAddOnPrice),
          ('Body floor carpet clean', cabinAddOnPrice),
          ('Four-door cleaning', 20),
          ('Dashboard cleaning', 15),
          ('Bonnet cleaning', 10),
          ('Polish two headlights', 30),
        ];

  static const vehiclePrices = [115, 95, 135, 165, 135];
  bool get freeBodyWash => selectedAddOns.length >= 2;
  int get total =>
      vehiclePrices[selectedPackage] +
      selectedAddOns.fold(0, (sum, i) => sum + addOnOptions[i].$2);

  List<String> get timeOptions => widget.bm
      ? ['Pagi · 8pg–12tgh', 'Tengah hari · 12tgh–4ptg', 'Petang · 4ptg–6ptg']
      : ['Morning · 8am–12pm', 'Afternoon · 12pm–4pm', 'Evening · 4pm–6pm'];

  @override
  void initState() {
    super.initState();
    selectedPackage = widget.initialPackage.clamp(0, 4);
    selectedTime = timeOptions.first;
  }

  InputDecoration deco(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: mist,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
  );

  String? req(String? value) => value == null || value.trim().isEmpty
      ? (widget.bm ? 'Wajib diisi' : 'Required')
      : null;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    carModel.dispose();
    location.dispose();
    date.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    final message = widget.bm
        ? '''*TEMPAHAN SUPER SEGAR*

Nama: ${name.text.trim()}
Telefon: ${phone.text.trim()}
Model kereta: ${carModel.text.trim()}
Lokasi: ${location.text.trim()}
Tarikh pilihan: ${date.text.trim()}
Masa pilihan: $selectedTime
Jenis kenderaan: ${packageOptions[selectedPackage]}
Servis tambahan: ${selectedAddOns.isEmpty ? 'Tiada' : selectedAddOns.map((i) => '${addOnOptions[i].$1} (+RM ${addOnOptions[i].$2})').join(', ')}
Cucian badan kereta percuma: ${freeBodyWash ? 'YA — PROMOSI 2 ADD-ON' : 'Tidak'}
Jumlah anggaran: RM $total
Nota tambahan: ${notes.text.trim().isEmpty ? 'Tiada' : notes.text.trim()}'''
        : '''*SUPER SEGAR BOOKING*

Name: ${name.text.trim()}
Phone: ${phone.text.trim()}
Car model: ${carModel.text.trim()}
Location: ${location.text.trim()}
Preferred date: ${date.text.trim()}
Preferred time: $selectedTime
Vehicle type: ${packageOptions[selectedPackage]}
Optional add-ons: ${selectedAddOns.isEmpty ? 'None' : selectedAddOns.map((i) => '${addOnOptions[i].$1} (+RM ${addOnOptions[i].$2})').join(', ')}
Free body car wash: ${freeBodyWash ? 'YES — 2 ADD-ON REWARD' : 'No'}
Estimated total: RM $total
Additional notes: ${notes.text.trim().isEmpty ? 'None' : notes.text.trim()}''';
    final opened = await launchUrl(
      Uri.parse(
        'https://wa.me/60139281004?text=${Uri.encodeComponent(message)}',
      ),
      mode: LaunchMode.externalApplication,
    );
    if (opened && mounted) setState(() => sent = true);
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 650;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: mobile ? 12 : 32,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 850),
        child: sent
            ? Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: green,
                      size: 58,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.bm
                          ? 'WhatsApp sedia dihantar'
                          : 'WhatsApp is ready',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.bm
                          ? 'Semak butiran anda di WhatsApp, kemudian tekan Hantar.'
                          : 'Review your details in WhatsApp, then tap Send.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(widget.bm ? 'Selesai' : 'Done'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(mobile ? 22 : 34),
                child: Form(
                  key: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.bm
                                      ? 'Tempah servis anda'
                                      : 'Book your detail',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.bm
                                      ? 'Beritahu kami tentang kereta dan masa pilihan anda.'
                                      : 'Tell us about your car and preferred time.',
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _StepDot(
                            number: 1,
                            active: true,
                            complete: step > 0,
                            label: widget.bm ? 'Butiran' : 'Details',
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              color: step > 0 ? blue : const Color(0xFFD9DDE3),
                            ),
                          ),
                          _StepDot(
                            number: 2,
                            active: step > 0,
                            complete: false,
                            label: widget.bm ? 'Servis' : 'Services',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (step == 0) ...[
                        FieldGrid(
                          mobile: mobile,
                          children: [
                            TextFormField(
                              controller: name,
                              decoration: deco(
                                widget.bm ? 'Nama penuh' : 'Full name',
                              ),
                              validator: req,
                            ),
                            TextFormField(
                              controller: phone,
                              decoration: deco(
                                widget.bm ? 'Nombor telefon' : 'Phone number',
                              ),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9+ -]'),
                                ),
                              ],
                              validator: req,
                            ),
                            TextFormField(
                              controller: carModel,
                              decoration: deco(
                                widget.bm ? 'Model kereta' : 'Car model',
                              ),
                              validator: req,
                            ),
                            TextFormField(
                              controller: location,
                              decoration: deco(
                                widget.bm ? 'Lokasi' : 'Location',
                              ),
                              validator: req,
                            ),
                            TextFormField(
                              controller: date,
                              readOnly: true,
                              decoration:
                                  deco(
                                    widget.bm
                                        ? 'Tarikh pilihan'
                                        : 'Preferred date',
                                  ).copyWith(
                                    suffixIcon: const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 18,
                                    ),
                                  ),
                              onTap: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 90),
                                  ),
                                );
                                if (d != null) {
                                  date.text = '${d.day}/${d.month}/${d.year}';
                                }
                              },
                              validator: req,
                            ),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: selectedTime,
                              decoration: deco(
                                widget.bm ? 'Masa pilihan' : 'Preferred time',
                              ),
                              items: timeOptions
                                  .map(
                                    (x) => DropdownMenuItem(
                                      value: x,
                                      child: Text(x),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => selectedTime = value!),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              if (form.currentState!.validate()) {
                                setState(() => step = 1);
                              }
                            },
                            iconAlignment: IconAlignment.end,
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 19,
                            ),
                            label: Text(
                              widget.bm
                                  ? 'Seterusnya: Pilih servis'
                                  : 'Next: Choose services',
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: blue,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                            ),
                          ),
                        ),
                      ] else ...[
                        DropdownButtonFormField<int>(
                          isExpanded: true,
                          initialValue: selectedPackage,
                          decoration: deco(
                            widget.bm ? 'Jenis kenderaan' : 'Vehicle type',
                          ),
                          items: List.generate(
                            packageOptions.length,
                            (i) => DropdownMenuItem(
                              value: i,
                              child: Text(packageOptions[i]),
                            ),
                          ),
                          onChanged: (value) =>
                              setState(() => selectedPackage = value!),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: mist,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.bm
                                    ? 'Servis tambahan (pilihan)'
                                    : 'Optional add-on services',
                                style: const TextStyle(
                                  color: ink,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.bm
                                    ? 'Pilih mana-mana servis yang anda perlukan.'
                                    : 'Select any extra services you need.',
                              ),
                              const SizedBox(height: 14),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: freeBodyWash
                                      ? green
                                      : const Color(0xFFE8F5EC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: freeBodyWash
                                        ? green
                                        : const Color(0xFFB8DFC5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: freeBodyWash
                                            ? Colors.white
                                            : green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        freeBodyWash
                                            ? Icons.check_rounded
                                            : Icons.local_car_wash_outlined,
                                        color: freeBodyWash
                                            ? green
                                            : Colors.white,
                                        size: 21,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            freeBodyWash
                                                ? (widget.bm
                                                      ? 'TAHNIAH! CUCI BADAN KERETA PERCUMA'
                                                      : 'UNLOCKED! FREE BODY CAR WASH')
                                                : (widget.bm
                                                      ? 'PILIH 2 ADD-ON, DAPAT CUCI BADAN PERCUMA'
                                                      : 'CHOOSE 2 ADD-ONS, GET A FREE BODY CAR WASH'),
                                            style: TextStyle(
                                              color: freeBodyWash
                                                  ? Colors.white
                                                  : const Color(0xFF126234),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 12,
                                              letterSpacing: .25,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            freeBodyWash
                                                ? (widget.bm
                                                      ? 'Hadiah anda telah dimasukkan dalam tempahan.'
                                                      : 'Your free wash is included in this booking.')
                                                : (widget.bm
                                                      ? 'Pilih ${2 - selectedAddOns.length} lagi untuk buka ganjaran.'
                                                      : 'Select ${2 - selectedAddOns.length} more to unlock.'),
                                            style: TextStyle(
                                              color: freeBodyWash
                                                  ? Colors.white.withValues(
                                                      alpha: .85,
                                                    )
                                                  : const Color(0xFF39714D),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(addOnOptions.length, (
                                  i,
                                ) {
                                  final addOn = addOnOptions[i];
                                  return FilterChip(
                                    selected: selectedAddOns.contains(i),
                                    onSelected: (selected) => setState(
                                      () => selected
                                          ? selectedAddOns.add(i)
                                          : selectedAddOns.remove(i),
                                    ),
                                    label: Text('${addOn.$1}  +RM ${addOn.$2}'),
                                    checkmarkColor: Colors.white,
                                    selectedColor: blue,
                                    labelStyle: TextStyle(
                                      color: selectedAddOns.contains(i)
                                          ? Colors.white
                                          : ink,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    backgroundColor: Colors.white,
                                    side: BorderSide(
                                      color: selectedAddOns.contains(i)
                                          ? blue
                                          : const Color(0xFFDDE0E4),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 9,
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 18),
                              const Divider(height: 1),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.bm
                                          ? 'Jumlah anggaran'
                                          : 'Estimated total',
                                      style: const TextStyle(
                                        color: ink,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'RM $total',
                                    style: const TextStyle(
                                      color: blue,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 24,
                                      letterSpacing: -.8,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: notes,
                          maxLines: 3,
                          decoration: deco(
                            widget.bm
                                ? 'Nota tambahan (pilihan)'
                                : 'Additional notes (optional)',
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              OutlinedButton(
                                onPressed: () => setState(() => step = 0),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: ink,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 22,
                                    vertical: 18,
                                  ),
                                ),
                                child: Text(widget.bm ? 'Kembali' : 'Back'),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton(
                                  onPressed: submit,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: blue,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 19,
                                    ),
                                  ),
                                  child: Text(
                                    widget.bm
                                        ? 'Hantar ke WhatsApp'
                                        : 'Send to WhatsApp',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class FieldGrid extends StatelessWidget {
  final bool mobile;
  final List<Widget> children;
  const FieldGrid({super.key, required this.mobile, required this.children});
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 14,
    runSpacing: 14,
    children: children
        .map((x) => SizedBox(width: mobile ? double.infinity : 319, child: x))
        .toList(),
  );
}

class _StepDot extends StatelessWidget {
  final int number;
  final bool active, complete;
  final String label;
  const _StepDot({
    required this.number,
    required this.active,
    required this.complete,
    required this.label,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: active ? blue : const Color(0xFFE2E5E9),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: complete
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
            : Text(
                '$number',
                style: TextStyle(
                  color: active ? Colors.white : const Color(0xFF737983),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          color: active ? ink : const Color(0xFF858B94),
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    ],
  );
}
