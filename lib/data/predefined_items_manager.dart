import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shopping_item.dart';

class PredefinedItemsManager {
  static const _key = 'predefined_items';

  static final List<ShoppingItem> _initialItems = [
  ShoppingItem(name: 'بطاطس'),
  ShoppingItem(name: 'طماطم'),
  ShoppingItem(name: 'بصل'),
  ShoppingItem(name: 'ثوم'),
  ShoppingItem(name: 'جزر'),
  ShoppingItem(name: 'خيار'),
  ShoppingItem(name: 'فلفل'),
  ShoppingItem(name: 'كوسة'),
  ShoppingItem(name: 'باذنجان'),
  ShoppingItem(name: 'خس'),
  ShoppingItem(name: 'سبانخ'),
  ShoppingItem(name: 'قرنبيط'),
  ShoppingItem(name: 'بروكلي'),
  ShoppingItem(name: 'فاصوليا خضراء'),
  ShoppingItem(name: 'بازلاء'),
  ShoppingItem(name: 'تفاح'),
  ShoppingItem(name: 'موز'),
  ShoppingItem(name: 'برتقال'),
  ShoppingItem(name: 'يوسفي'),
  ShoppingItem(name: 'ليمون'),
  ShoppingItem(name: 'فراولة'),
  ShoppingItem(name: 'عنب'),
  ShoppingItem(name: 'بطيخ'),
  ShoppingItem(name: 'شمام'),
  ShoppingItem(name: 'خوخ'),
  ShoppingItem(name: 'مشمش'),
  ShoppingItem(name: 'تمر'),
  ShoppingItem(name: 'لحم بقر'),
  ShoppingItem(name: 'لحم غنم'),
  ShoppingItem(name: 'دجاج'),
  ShoppingItem(name: 'ديك رومي'),
  ShoppingItem(name: 'سمك'),
  ShoppingItem(name: 'سردين'),
  ShoppingItem(name: 'تونة'),
  ShoppingItem(name: 'كفتة'),
  ShoppingItem(name: 'نقانق'),
  ShoppingItem(name: 'حليب'),
  ShoppingItem(name: 'لبن'),
  ShoppingItem(name: 'زبادي'),
  ShoppingItem(name: 'جبن'),
  ShoppingItem(name: 'جبن مطبوخ'),
  ShoppingItem(name: 'زبدة'),
  ShoppingItem(name: 'قشدة'),
  ShoppingItem(name: 'بيض'),
  ShoppingItem(name: 'خبز'),
  ShoppingItem(name: 'خبز توست'),
  ShoppingItem(name: 'سميد'),
  ShoppingItem(name: 'دقيق'),
  ShoppingItem(name: 'أرز'),
  ShoppingItem(name: 'مكرونة'),
  ShoppingItem(name: 'كسكس'),
  ShoppingItem(name: 'شوفان'),
  ShoppingItem(name: 'عدس'),
  ShoppingItem(name: 'حمص'),
  ShoppingItem(name: 'فول'),
  ShoppingItem(name: 'فاصوليا يابسة'),
  ShoppingItem(name: 'سكر'),
  ShoppingItem(name: 'ملح'),
  ShoppingItem(name: 'زيت'),
  ShoppingItem(name: 'زيت زيتون'),
  ShoppingItem(name: 'خل'),
  ShoppingItem(name: 'خميرة'),
  ShoppingItem(name: 'بيكنغ باودر'),
  ShoppingItem(name: 'نشا'),
  ShoppingItem(name: 'فلفل أسود'),
  ShoppingItem(name: 'كمون'),
  ShoppingItem(name: 'كركم'),
  ShoppingItem(name: 'قرفة'),
  ShoppingItem(name: 'زنجبيل'),
  ShoppingItem(name: 'بابريكا'),
  ShoppingItem(name: 'زعتر'),
  ShoppingItem(name: 'رأس الحانوت'),
  ShoppingItem(name: 'ماء'),
  ShoppingItem(name: 'شاي'),
  ShoppingItem(name: 'قهوة'),
  ShoppingItem(name: 'حليب شوكولاتة'),
  ShoppingItem(name: 'عصير'),
  ShoppingItem(name: 'مشروب غازي'),
  ShoppingItem(name: 'بسكويت'),
  ShoppingItem(name: 'شوكولاتة'),
  ShoppingItem(name: 'كيك'),
  ShoppingItem(name: 'مربى'),
  ShoppingItem(name: 'عسل'),
  ShoppingItem(name: 'فواكه جافة'),
  ShoppingItem(name: 'مكسرات'),
  ShoppingItem(name: 'رقائق البطاطس'),
  ShoppingItem(name: 'مسحوق غسيل'),
  ShoppingItem(name: 'سائل غسيل'),
  ShoppingItem(name: 'منظف أرضيات'),
  ShoppingItem(name: 'منظف زجاج'),
  ShoppingItem(name: 'جافيل'),
  ShoppingItem(name: 'صابون'),
  ShoppingItem(name: 'سائل جلي'),
  ShoppingItem(name: 'ورق مرحاض'),
  ShoppingItem(name: 'مناديل'),
  ShoppingItem(name: 'مناديل مطبخ'),
  ShoppingItem(name: 'معجون أسنان'),
  ShoppingItem(name: 'فرشاة أسنان'),
  ShoppingItem(name: 'شامبو'),
  ShoppingItem(name: 'صابون سائل'),
  ShoppingItem(name: 'مزيل عرق'),
  ShoppingItem(name: 'كريم'),
];


  List<ShoppingItem> _items = [];

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsString = prefs.getString(_key);

    if (itemsString == null) {
      _items = List.from(_initialItems);
      await _saveItems();
    } else {
      final List<dynamic> itemsJson = jsonDecode(itemsString);
      _items = itemsJson.map((json) => ShoppingItem.fromMap(json)).toList();
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String itemsString = jsonEncode(_items.map((item) => item.toMap()).toList());
    await prefs.setString(_key, itemsString);
  }

  List<ShoppingItem> get items => _items;

  Future<void> addItem(ShoppingItem item) async {
    if (!_items.any((i) => i.name == item.name)) {
      _items.add(item);
      await _saveItems();
    }
  }

  Future<void> removeItem(ShoppingItem item) async {
    _items.removeWhere((i) => i.name == item.name);
    await _saveItems();
  }
}
