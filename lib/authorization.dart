import 'package:flutter/material.dart';
import 'package:project_energy/home.dart';

class Authorization extends StatelessWidget {
  const Authorization({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Екран авторизації'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Логотип
            Image.asset(
              'assets/images/logo.jpg',
              width: 200, // Розмір логотипу
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20), // Відступ між логотипом і текстом
            // Жирний текст
            const Text(
              'Вітаємо в додатку!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10), // Відступ між текстами
            // Звичайний текст
            const Text(
              'Ви вже на шляху до заощадження електроенергії',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Відступ між текстами і кнопками
            // Кнопка "Увійти через Google"
            ElevatedButton.icon(
              onPressed: () {
                // Додайте логіку для авторизації через Google
              },
              icon: Image.asset(
                'assets/images/googleLogo.png',
                width: 24,
                height: 24,
              ),
              label: const Text('Увійти через Google'),
            ),
            const SizedBox(height: 10), // Відступ між кнопками
            // Кнопка "Продовжити без авторизації"
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: const Text('Продовжити без авторизації'),
            ),
          ],
        ),
      ),
    );
  }
}
