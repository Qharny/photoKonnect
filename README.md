# 📸 PhotoConnect

PhotoConnect is a Flutter + Supabase-powered mobile platform that connects clients with professional photographers. It features real-time booking, portfolio management, reviews, and secure payments — all in a beautifully responsive UI.

---
![Visitor Count](https://visitor-badge.laobi.icu/badge?page_id=qharny.photoConnect.)

## 🚀 Screenshots

| Client View | Photographer View | Booking Flow |
|-------------|-------------------|--------------|
| ![client](screenshots/client.png) | ![photographer](screenshots/photographer.png) | ![booking](screenshots/booking.png) |

---

## 📱 Features

### 👤 Authentication
- Email/password & social login (Google, Facebook)
- Role-based signups: Photographer & Client

### 📸 Photographer Dashboard
- Profile and portfolio management
- Set availability calendar
- Manage incoming bookings
- View analytics (views, bookings, revenue)

### 🔍 Client Experience
- Search photographers by location, price, or specialty
- View detailed profiles & image galleries
- Book sessions and make secure payments
- Leave reviews and manage bookings

### 💬 Interaction & Engagement
- Likes, comments, reviews, ratings
- Share photographer profiles

---

## 🛠️ Built With

- [Flutter](https://flutter.dev/)
- [Supabase](https://supabase.io/) – Backend (auth, database, storage)
- [Stripe](https://stripe.com/) – Payment integration

[//]: # (- [GoRouter]&#40;https://pub.dev/packages/go_router&#41; – Navigation)

[//]: # (- [Riverpod]&#40;https://riverpod.dev/&#41; – State management)

---

## 🧑‍💻 Getting Started

### ✅ Prerequisites
- Flutter SDK
- Dart
- Supabase account
- Stripe account (for payment testing)

### 🔧 Installation

```bash
git clone  https://github.com/Qharny/photoConnect..git
cd photo-connect
flutter pub get
````

### ⚙️ Environment Setup

Create a `.env` file with your Supabase project credentials:

```
SUPABASE_URL=your-project-url
SUPABASE_ANON_KEY=your-anon-key
STRIPE_PUBLIC_KEY=your-stripe-publishable-key
```

---

## 🗃️ Project Structure

```
/lib
 ┣ /auth             # Auth pages and logic
 ┣ /client           # Client-side UI
 ┣ /photographer     # Photographer dashboard
 ┣ /core             # Reusable components, themes, utils
 ┣ /services         # Supabase and API interactions
 ┣ main.dart
```

---

## 🧪 Testing

```bash
flutter test
```

For widget/UI testing, run:

```bash
flutter test --coverage
```

---

## 📈 Roadmap

* [ ] Real-time chat between clients and photographers
* [ ] AI-powered photographer recommendations
* [ ] Admin dashboard
* [ ] Flutter Web support

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.

### 📄 License

[MIT](LICENSE)

---

## 💡 Author

**Manasseh Kwame Kabutey**
📍 Ghana
🎓 Computer Science & Engineering
📬 [kabuteymanasseh5@gmail.com](mailto:kabuteymanasseh5@gmail.com)

---

### ⭐ If you like this project, give it a star and follow my journey!

\#FlutterDev #Supabase #BuildInPublic #PhotoConnect

```