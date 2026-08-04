# 🎮 Halo CE Custom Edition + Coop Evolved

> Instalador automatico — by **bt pr3ttywhit3**

## ⚡ Instalacion rapida (PowerShell — 1 linea)

Abre PowerShell **como Administrador** y pega:

```powershell
irm https://raw.githubusercontent.com/x3btc/HaloCE-CoopEvolved/main/instalar_haloce_coop.bat -OutFile "$env:TEMP\haloce.bat"; Start-Process "$env:TEMP\haloce.bat" -Verb RunAs
```

O descargalo al escritorio primero:

```powershell
irm https://raw.githubusercontent.com/x3btc/HaloCE-CoopEvolved/main/instalar_haloce_coop.bat -OutFile "$HOME\Desktop\instalar_haloce_coop.bat"
```

---

## 📦 Que instala

| Componente | Descripcion |
|---|---|
| **Halo CE Custom Edition** | Juego gratuito standalone |
| **Parche v1.0.10** | Elimina CD check, compatibilidad Win10/11 |
| **Mercury** | Gestor de mods para Halo CE |
| **Chimera** | Mejoras graficas y FOV |
| **Coop Evolved** | Co-op campaña hasta 16 jugadores LAN/Internet |

## 🧠 Deteccion inteligente

- ✅ Ya instalado y actualizado → **solo instala el mod**
- ⚠️ Instalado pero desactualizado → **aplica parche + mod**
- ❌ No instalado → **instala todo desde cero**

## ⚙️ Requisitos

- Windows 10 / 11 (64-bit)
- PowerShell o ejecutar el .bat como Administrador
- Conexion a internet

## 🎮 Como jugar en co-op

1. Lanza Halo CE
2. Multijugador → Unirse a juego → busca "coop"
3. O crea servidor: `halo.exe -window -console` → `sv_map a10 slayer`

---

## 🔗 Creditos

- [Coop Evolved](https://github.com/Sledmine/coop-evolved) by Sledmine
- [Mercury](https://github.com/Sledmine/mercury) by Sledmine
- [HaloMaps.org](https://hce.halomaps.org)

---

*by bt pr3ttywhit3*