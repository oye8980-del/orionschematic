import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* --------------------------------------------------
PRODUCT MODEL
-------------------------------------------------- */
class Product {
  final String name;
  final String image;
  final int price;

  Product({required this.name, required this.image, required this.price});
}

/* --------------------------------------------------
PRODUK LIST
-------------------------------------------------- */
final List<Product> products = [
  Product(name: "DJI", image: "assets/brands/DJI.png", price: 5000),
  Product(name: "IC Power MT6328", image: "assets/products/icpower.png", price: 45000),
  Product(name: "Transistor SMD", image: "assets/products/transistor.png", price: 2000),
  Product(name: "Resistor Pack", image: "assets/products/resistor.png", price: 1500),
  Product(name: "Capacitor Pack", image: "assets/products/capacitor.png", price: 2000),
  Product(name: "USB Tester", image: "assets/products/usbtester.png", price: 30000),
];

/* --------------------------------------------------
SHOP PAGE
-------------------------------------------------- */
class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Product> cart = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> names = cart.map((e) => e.name).toList();
    prefs.setStringList("cart_items", names);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? names = prefs.getStringList("cart_items");

    if (names != null) {
      cart = products.where((e) => names.contains(e.name)).toList();
      setState(() {});
    }

  }

  void addToCart(Product p) {
    cart.add(p);
    saveCart();
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${p.name} ditambahkan"),
        backgroundColor: Colors.greenAccent.shade400,
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1528),
      appBar: AppBar(
        title: const Text("Orion Shop",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A1528),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CartPage(cart: cart, onUpdate: saveCart),
                    ),
                  );
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.redAccent,
                    child: Text(
                      cart.length.toString(),
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                )
            ],
          )
        ],
      ),

      /* --------------------------------------------------
      GRID PRODUK UPGRADED
  -------------------------------------------------- */
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (_, i) {
          final p = products[i];

          return Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF132A45), Color(0xFF0D2238)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),

                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      p.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
                  child: Text(
                    p.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Text(
                  "Rp ${p.price}",
                  style: const TextStyle(color: Colors.cyanAccent, fontSize: 15),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => addToCart(p),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Tambah",
                      style: TextStyle(color: Colors.black),
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
}

/* --------------------------------------------------
CART PAGE — DELETE + CHECKOUT
-------------------------------------------------- */
class CartPage extends StatefulWidget {
  final List<Product> cart;
  final Function onUpdate;

  const CartPage({super.key, required this.cart, required this.onUpdate});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void deleteItem(int index) async {
    widget.cart.removeAt(index);
    await widget.onUpdate();
    setState(() {});
  }

  Future<void> checkout() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          total: widget.cart.fold(0, (s, p) => s + p.price),
          items: List.from(widget.cart),
          onSuccess: () async {
            widget.cart.clear();
            await widget.onUpdate();
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int total = widget.cart.fold(0, (sum, p) => sum + p.price);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1528),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1528),
        title: const Text("Keranjang Anda"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (_, i) {
                final p = widget.cart[i];
                return Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B3552), Color(0xFF152B44)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        p.image,
                        width: 62,
                        height: 62,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image,
                            color: Colors.white),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          p.name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Rp ${p.price}",
                              style: const TextStyle(
                                  color: Colors.cyanAccent)),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => deleteItem(i),
                            child: const Icon(Icons.delete,
                                color: Colors.redAccent),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          /* TOTAL & CHECKOUT */
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF11273F), Color(0xFF0D1F34)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Column(
              children: [
                Text(
                  "Total: Rp $total",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.cart.isEmpty ? null : checkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      "Bayar Sekarang",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

  }
}

/* --------------------------------------------------
PAYMENT PAGE
-------------------------------------------------- */
class PaymentPage extends StatelessWidget {
  final int total;
  final List<Product> items;
  final Function onSuccess;

  const PaymentPage(
      {super.key,
        required this.total,
        required this.items,
        required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1528),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1528),
        title: const Text("Pilih Metode Pembayaran"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          paymentButton(context, "QRIS", Icons.qr_code, "qris"),
          paymentButton(context, "Transfer Bank", Icons.account_balance, "bank"),
          paymentButton(context, "E-Wallet (DANA/OVO/Gopay)", Icons.wallet, "ewallet"),
        ],
      ),
    );
  }

  Widget paymentButton(
      BuildContext ctx, String title, IconData icon, String method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(18),
          backgroundColor: const Color(0xFF11273F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () {
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (_) => PaymentProcessingPage(
                method: method,
                total: total,
                items: items,
                onSuccess: onSuccess,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Icon(icon, color: Colors.cyanAccent),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 17, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

/* --------------------------------------------------
PROCESSING PAGE
-------------------------------------------------- */
class PaymentProcessingPage extends StatefulWidget {
  final String method;
  final int total;
  final List<Product> items;
  final Function onSuccess;

  const PaymentProcessingPage(
      {super.key,
        required this.method,
        required this.total,
        required this.items,
        required this.onSuccess});

  @override
  State<PaymentProcessingPage> createState() => _PaymentProcessingPageState();
}

class _PaymentProcessingPageState extends State<PaymentProcessingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      saveTransaction();
    });
  }

  Future<void> saveTransaction() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> names = widget.items.map((e) => e.name).toList();
    List<String> history = prefs.getStringList("purchase_history") ?? [];
    history.add("${DateTime.now()} | ${names.join(", ")} | ${widget.total}");

    prefs.setStringList("purchase_history", history);
    widget.onSuccess();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessPage(total: widget.total),
      ),
    );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1528),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: Colors.cyanAccent),
            SizedBox(height: 20),
            Text("Memproses Pembayaran...",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

/* --------------------------------------------------
PAYMENT SUCCESS PAGE
-------------------------------------------------- */
class PaymentSuccessPage extends StatelessWidget {
  final int total;

  const PaymentSuccessPage({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1528),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle,
                color: Colors.greenAccent, size: 90),
            const SizedBox(height: 20),

            const Text("Pembayaran Berhasil!",
                style: TextStyle(color: Colors.white, fontSize: 24)),

            const SizedBox(height: 10),

            Text("Total: Rp $total",
                style: const TextStyle(
                    color: Colors.cyanAccent, fontSize: 20)),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text("Kembali ke Toko",
                  style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );

  }
}