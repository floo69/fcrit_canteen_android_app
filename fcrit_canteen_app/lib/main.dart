import 'package:flutter/material.dart';

void main() {
  runApp(FCRITCanteenApp());
}

class FCRITCanteenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCRIT Canteen',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Models
class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'student' or 'admin'

  User({required this.id, required this.name, required this.email, required this.role});
}

class MenuItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final String image;
  final bool available;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    this.available = true,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});
}

class Order {
  final String id;
  final String userId;
  final String userName;
  final List<CartItem> items;
  final double total;
  final DateTime timestamp;
  String status; // 'pending', 'preparing', 'ready', 'completed'

  Order({
    required this.id,
    required this.userId,
    required this.userName,
    required this.items,
    required this.total,
    required this.timestamp,
    this.status = 'pending',
  });
}

// Data Store
class AppData {
  static User? currentUser;
  static List<MenuItem> menuItems = [
    MenuItem(id: '1', name: 'Veg Sandwich', category: 'Snacks', price: 30, image: '🥪'),
    MenuItem(id: '2', name: 'Masala Dosa', category: 'South Indian', price: 50, image: '🫓'),
    MenuItem(id: '3', name: 'Pav Bhaji', category: 'Main Course', price: 60, image: '🍛'),
    MenuItem(id: '4', name: 'Chai', category: 'Beverages', price: 10, image: '☕'),
    MenuItem(id: '5', name: 'Cold Coffee', category: 'Beverages', price: 40, image: '🥤'),
    MenuItem(id: '6', name: 'Samosa', category: 'Snacks', price: 15, image: '🥟'),
    MenuItem(id: '7', name: 'Idli Sambhar', category: 'South Indian', price: 40, image: '🍚'),
    MenuItem(id: '8', name: 'Vada Pav', category: 'Snacks', price: 20, image: '🍔'),
    MenuItem(id: '9', name: 'Paneer Paratha', category: 'Main Course', price: 70, image: '🫓'),
    MenuItem(id: '10', name: 'Fruit Juice', category: 'Beverages', price: 35, image: '🧃'),
  ];
  static List<Order> orders = [];
  static List<CartItem> cart = [];
}

// Login/Signup Page
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isStudent = true;
  bool _isSignupMode = false;

  void _login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter all fields')),
      );
      return;
    }

    if (_isSignupMode && _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    AppData.currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _isSignupMode ? _nameController.text : (_isStudent ? 'Student User' : 'Admin User'),
      email: _emailController.text,
      role: _isStudent ? 'student' : 'admin',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => _isStudent ? StudentHomePage() : AdminDashboard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '🍽️',
                        style: TextStyle(fontSize: 64),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'FCRIT Canteen',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      Text(
                        _isSignupMode ? 'Create Account' : 'Order Food Online',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 32),
                      if (_isSignupMode)
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: Text('Student'),
                              value: true,
                              groupValue: _isStudent,
                              onChanged: (val) => setState(() => _isStudent = val!),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: Text('Admin'),
                              value: false,
                              groupValue: _isStudent,
                              onChanged: (val) => setState(() => _isStudent = val!),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _isSignupMode ? 'Sign Up' : 'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isSignupMode = !_isSignupMode;
                            _nameController.clear();
                          });
                        },
                        child: Text(
                          _isSignupMode
                              ? 'Already have an account? Login'
                              : "Don't have an account? Sign Up",
                          style: TextStyle(color: Colors.orange.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Student Home Page
class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All';

  List<String> get categories {
    final cats = AppData.menuItems.map((e) => e.category).toSet().toList();
    return ['All', ...cats];
  }

  List<MenuItem> get filteredItems {
    if (_selectedCategory == 'All') return AppData.menuItems;
    return AppData.menuItems.where((item) => item.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildMenuPage(),
      CartPage(),
      OrderHistoryPage(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('FCRIT Canteen'),
        backgroundColor: Colors.orange,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  setState(() => _selectedIndex = 1);
                },
              ),
              if (AppData.cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${AppData.cart.length}',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildMenuPage() {
    return Column(
      children: [
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == _selectedCategory;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = category);
                  },
                  selectedColor: Colors.orange,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return _buildMenuItemCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItemCard(MenuItem item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Text(item.image, style: TextStyle(fontSize: 64)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  item.category,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${item.price}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _addToCart(item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: Size(0, 0),
                      ),
                      child: Text('Add', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(MenuItem item) {
    setState(() {
      final existingIndex = AppData.cart.indexWhere(
            (cartItem) => cartItem.item.id == item.id,
      );

      if (existingIndex != -1) {
        // Item already exists, increment quantity
        AppData.cart[existingIndex].quantity++;
      } else {
        // New item, add with quantity 1
        AppData.cart.add(CartItem(item: item, quantity: 1));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

// Cart Page
class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get total {
    return AppData.cart.fold(0, (sum, item) => sum + (item.item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    if (AppData.cart.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🛒', style: TextStyle(fontSize: 64)),
            SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: AppData.cart.length,
            itemBuilder: (context, index) {
              final cartItem = AppData.cart[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: Text(cartItem.item.image, style: TextStyle(fontSize: 32)),
                  title: Text(cartItem.item.name),
                  subtitle: Text('₹${cartItem.item.price} each'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setState(() {
                            if (cartItem.quantity > 1) {
                              cartItem.quantity--;
                            } else {
                              AppData.cart.removeAt(index);
                            }
                          });
                        },
                      ),
                      Text('${cartItem.quantity}', style: TextStyle(fontSize: 16)),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() {
                            cartItem.quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('₹${total.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Place Order', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _placeOrder() {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: AppData.currentUser!.id,
      userName: AppData.currentUser!.name,
      items: List.from(AppData.cart),
      total: total,
      timestamp: DateTime.now(),
    );

    setState(() {
      AppData.orders.add(order);
      AppData.cart.clear();
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Placed! 🎉'),
        content: Text('Your order has been placed successfully.\nOrder ID: ${order.id.substring(0, 8)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Order History Page
class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userOrders = AppData.orders
        .where((order) => order.userId == AppData.currentUser!.id)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (userOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('📋', style: TextStyle(fontSize: 64)),
            SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: userOrders.length,
      itemBuilder: (context, index) {
        final order = userOrders[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ExpansionTile(
            title: Text('Order #${order.id.substring(0, 8)}'),
            subtitle: Text('${_formatDate(order.timestamp)} • ₹${order.total.toStringAsFixed(2)}'),
            trailing: Chip(
              label: Text(order.status.toUpperCase()),
              backgroundColor: _getStatusColor(order.status),
            ),
            children: [
              ...order.items.map((item) => ListTile(
                leading: Text(item.item.image, style: TextStyle(fontSize: 24)),
                title: Text(item.item.name),
                trailing: Text('${item.quantity}x ₹${item.item.price}'),
              )),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange.shade200;
      case 'preparing':
        return Colors.blue.shade200;
      case 'ready':
        return Colors.green.shade200;
      case 'completed':
        return Colors.grey.shade300;
      default:
        return Colors.grey;
    }
  }
}

// Profile Page
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser!;
    final totalOrders = AppData.orders.where((o) => o.userId == user.id).length;
    final totalSpent = AppData.orders.where((o) => o.userId == user.id).fold(0.0, (sum, o) => sum + o.total);

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange,
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                Text(user.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(user.email, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.shopping_bag, color: Colors.orange),
                title: Text('Total Orders'),
                trailing: Text('$totalOrders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.account_balance_wallet, color: Colors.orange),
                title: Text('Total Spent'),
                trailing: Text('₹${totalSpent.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          icon: Icon(Icons.logout),
          label: Text('Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}

// Admin Dashboard
class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminOrdersPage(onUpdate: () => setState(() {})),
      AdminMenuPage(onUpdate: () => setState(() {})),
      AdminStatsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.orange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }
}

// Admin Orders Page
class AdminOrdersPage extends StatefulWidget {
  final VoidCallback onUpdate;

  AdminOrdersPage({required this.onUpdate});

  @override
  _AdminOrdersPageState createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  String _filter = 'all';

  List<Order> get filteredOrders {
    var orders = AppData.orders;
    if (_filter != 'all') {
      orders = orders.where((o) => o.status == _filter).toList();
    }
    return orders..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(8),
            children: ['all', 'pending', 'preparing', 'ready', 'completed'].map((status) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(status.toUpperCase()),
                  selected: _filter == status,
                  onSelected: (selected) => setState(() => _filter = status),
                  selectedColor: Colors.orange,
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: filteredOrders.isEmpty
              ? Center(child: Text('No orders'))
              : ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ExpansionTile(
                  title: Text('${order.userName} • #${order.id.substring(0, 8)}'),
                  subtitle: Text('₹${order.total.toStringAsFixed(2)} • ${_formatDate(order.timestamp)}'),
                  trailing: _buildStatusDropdown(order),
                  children: [
                    ...order.items.map((item) => ListTile(
                      leading: Text(item.item.image, style: TextStyle(fontSize: 24)),
                      title: Text(item.item.name),
                      trailing: Text('${item.quantity}x'),
                    )),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(Order order) {
    return DropdownButton<String>(
      value: order.status,
      onChanged: (newStatus) {
        setState(() {
          order.status = newStatus!;
          widget.onUpdate();
        });
      },
      items: ['pending', 'preparing', 'ready', 'completed']
          .map((status) => DropdownMenuItem(
        value: status,
        child: Text(status.toUpperCase()),
      ))
          .toList(),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Admin Menu Page
class AdminMenuPage extends StatefulWidget {
  final VoidCallback onUpdate;

  AdminMenuPage({required this.onUpdate});

  @override
  _AdminMenuPageState createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final priceController = TextEditingController();
    String selectedEmoji = '🍕';

    final emojis = ['🍕', '🍔', '🌮', '🍜', '🍱', '🍛', '🍝', '🥗', '🍿', '🥪',
      '🌯', '🥙', '🍳', '🥞', '🧇', '🍞', '☕', '🥤', '🧃', '🍵'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Add New Menu Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Snacks, Beverages',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price (₹)',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                Text('Select Emoji:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Container(
                  height: 200,
                  width: double.maxFinite,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1,
                    ),
                    itemCount: emojis.length,
                    itemBuilder: (context, index) {
                      final emoji = emojis[index];
                      return GestureDetector(
                        onTap: () => setDialogState(() => selectedEmoji = emoji),
                        child: Container(
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedEmoji == emoji ? Colors.orange : Colors.grey,
                              width: selectedEmoji == emoji ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(emoji, style: TextStyle(fontSize: 32)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    categoryController.text.isEmpty ||
                    priceController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final newItem = MenuItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  category: categoryController.text,
                  price: double.tryParse(priceController.text) ?? 0,
                  image: selectedEmoji,
                );

                setState(() {
                  AppData.menuItems.add(newItem);
                  widget.onUpdate();
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${newItem.name} added successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text('Add Item', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteItem(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete ${AppData.menuItems[index].name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                AppData.menuItems.removeAt(index);
                widget.onUpdate();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Item deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: ElevatedButton.icon(
            onPressed: _showAddItemDialog,
            icon: Icon(Icons.add),
            label: Text('Add New Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: AppData.menuItems.length,
            itemBuilder: (context, index) {
              final item = AppData.menuItems[index];
              return Card(
                child: ListTile(
                  leading: Text(item.image, style: TextStyle(fontSize: 32)),
                  title: Text(item.name),
                  subtitle: Text('${item.category} • ₹${item.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: item.available,
                        onChanged: (value) {
                          setState(() {
                            AppData.menuItems[index] = MenuItem(
                              id: item.id,
                              name: item.name,
                              category: item.category,
                              price: item.price,
                              image: item.image,
                              available: value,
                            );
                            widget.onUpdate();
                          });
                        },
                        activeColor: Colors.orange,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Admin Stats Page
class AdminStatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final totalOrders = AppData.orders.length;
    final totalRevenue = AppData.orders.fold(0.0, (sum, o) => sum + o.total);
    final pendingOrders = AppData.orders.where((o) => o.status == 'pending').length;
    final completedOrders = AppData.orders.where((o) => o.status == 'completed').length;

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildStatCard('Total Orders', '$totalOrders', Icons.shopping_bag, Colors.blue),
        _buildStatCard('Total Revenue', '₹${totalRevenue.toStringAsFixed(2)}', Icons.attach_money, Colors.green),
        _buildStatCard('Pending Orders', '$pendingOrders', Icons.pending, Colors.orange),
        _buildStatCard('Completed Orders', '$completedOrders', Icons.check_circle, Colors.teal),
        SizedBox(height: 16),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Popular Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ..._getPopularItems().map((entry) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key, style: TextStyle(fontSize: 16)),
                      Text('${entry.value} orders', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600)),
                SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<MapEntry<String, int>> _getPopularItems() {
    final itemCounts = <String, int>{};

    for (var order in AppData.orders) {
      for (var item in order.items) {
        itemCounts[item.item.name] = (itemCounts[item.item.name] ?? 0) + item.quantity;
      }
    }

    final sorted = itemCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(5).toList();
  }
}