# Caja de Herramientas (Flutter)

**Autor:** Israel Vargas Castro · Matrícula 2023-1861

Aplicación multiusos hecha en Flutter con 8 vistas, accesibles desde el menú lateral:

| # | Vista | API |
|---|-------|-----|
| 1 | Inicio: foto de una caja de herramientas | — (imagen local) |
| 2 | Predecir género por nombre (azul = masculino, rosa = femenino) | `https://api.genderize.io/?name=irma` |
| 3 | Persona aleatoria: nombre, apellido, foto, fecha de nacimiento y edad | `https://randomuser.me/api/?results=1` |
| 4 | Universidades por país (en inglés): nombre, dominio y enlace web | `https://adamix.net/proxy.php?country=Dominican+Republic` |
| 5 | Clima de hoy en Santo Domingo, RD | `https://api.open-meteo.com/v1/forecast` (sin API key) |
| 6 | Pokémon: foto, experiencia base, habilidades y sonido (`cries.latest`) | `https://pokeapi.co/api/v2/pokemon/pikachu` |
| 7 | Logo y últimas 3 noticias de un sitio WordPress con botón "Visitar" | `https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3` |
| 8 | Acerca de: foto y datos de contacto | — |

**API de WordPress para el foro:** `https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3`
(blog oficial de WordPress.org, hecho con WordPress).

## Ejecutar

```bash
flutter pub get
flutter run
```

## Personalizar

- **Tu foto:** reemplaza `assets/images/mi_foto.png` (cuadrada, ~1024×1024).
- **Ícono de la app:** después de cambiar la foto, ejecuta `dart run flutter_launcher_icons`.
- **Tus datos de contacto:** edita las constantes al inicio de `lib/views/acerca_view.dart`.

## Paquetes

`http`, `url_launcher`, `audioplayers`, `intl`, `flutter_launcher_icons`.
