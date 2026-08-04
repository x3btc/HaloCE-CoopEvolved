# 🎮 Halo CE Custom Edition + Coop Evolved

Instalador automatizado para **Halo Custom Edition** + el mod **Coop Evolved** que permite co-op de campaña para hasta **16 jugadores** en LAN o Internet.

---

## 📦 ¿Qué instala este script?

| Componente | Descripción |
|---|---|
| **Halo CE Custom Edition** | Versión standalone gratuita de Halo: Combat Evolved para PC (2004) |
| **Parche v1.0.10** | Patch oficial — elimina la necesidad del CD y corrige compatibilidad |
| **Mercury** | Gestor de paquetes/mods para Halo CE (por Sledmine) |
| **Chimera** | Mod de mejoras gráficas, FOV, y compatibilidad Win10/11 (instalado automáticamente con Coop Evolved) |
| **Coop Evolved** | Mod que habilita co-op de campaña completo (hasta 16 jugadores) |

---

## 🚀 Instrucciones de instalación

### Método automático (recomendado)

1. **Clona o descarga** este repositorio
2. Haz **clic derecho** en `instalar_haloce_coop.bat`
3. Selecciona **"Ejecutar como administrador"**
4. Sigue las instrucciones en pantalla

```bash
# Si tienes Git:
git clone https://github.com/TuUsuario/HaloCE-CoopEvolved.git
cd HaloCE-CoopEvolved
# Clic derecho en instalar_haloce_coop.bat -> Ejecutar como administrador
```

### Método manual (si el automático falla)

**Paso 1 — Halo CE:**
- Descarga desde [HaloMaps.org](https://hce.halomaps.org/index.cfm?pg=3&fid=410)
- Instala en: `C:\Program Files (x86)\Microsoft Games\Halo Custom Edition`
- Descarga el [Parche 1.0.10](https://hce.halomaps.org/index.cfm?pg=3&fid=6798) y aplícalo

**Paso 2 — Mercury:**
- Descarga desde [GitHub Releases](https://github.com/Sledmine/mercury/releases/latest)
- Instala y abre **Mercury Console**

**Paso 3 — Coop Evolved:**
```
mercury install coopevolved
```

---

## 🎮 Cómo jugar en co-op

1. Lanza **Halo CE**
2. Ve a **Multijugador → Unirse a un juego**
3. Busca servidores con "coop" en el nombre
4. O crea tu propio servidor con los mapas de campaña

Para crear servidor local:
```
# Todos los jugadores deben tener Coop Evolved instalado
# El host ejecuta: halo.exe -window -console
# En consola: sv_map a10 slayer
```

---

## 📁 Estructura del repositorio

```
HaloCE-CoopEvolved/
├── instalar_haloce_coop.bat   ← Script principal de instalación
├── README.md                   ← Este archivo
├── downloads/                  ← Carpeta donde se guardan los instaladores
│   └── (se llena al ejecutar el .bat)
└── .gitignore
```

---

## ⚙️ Requisitos del sistema

- **OS:** Windows 10 / Windows 11 (64-bit)
- **RAM:** 512 MB mínimo (2 GB recomendado)
- **Almacenamiento:** ~2 GB libres
- **Privilegios:** Administrador (necesario para instalar el juego)
- **Internet:** Conexión activa para descargar los componentes

---

## 🔗 Créditos y fuentes oficiales

- **Coop Evolved:** [github.com/Sledmine/coop-evolved](https://github.com/Sledmine/coop-evolved)
- **Mercury:** [github.com/Sledmine/mercury](https://github.com/Sledmine/mercury)
- **Halo CE:** [hce.halomaps.org](https://hce.halomaps.org)
- **Comunidad:** [opencarnage.net](https://opencarnage.net)

---

## ⚠️ Notas importantes

> Halo Custom Edition es software gratuito distribuido por la comunidad. Los archivos del juego base son de Microsoft/Bungie.

> El mod Coop Evolved está en desarrollo activo. Algunos bugs conocidos: sincronización de IA y animaciones de vehículos pueden tener desfases en la red.

---

*Script creado con ❤️ — Funcionamiento verificado en Windows 10/11*
