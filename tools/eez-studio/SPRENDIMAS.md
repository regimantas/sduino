# EEZ Studio + LVGL 9.40 - Pilnas Sprendimas

## Problema

Arduino projektas su EEZ Studio sugeneruotu kodu meta klaidą kompiliuojant su LVGL 9.40:

```
error: invalid conversion from 'int' to 'lv_part_t' [-fpermissive]
lv_obj_get_style_opa((lv_obj_t *)a->user_data, 0);
                                                 ^
```

## Sprendimai (3 būdai)

### ✅ Sprendimas 1: Automatinis (Rekomenduojamas)

**Po kiekvieno kodo generavimo su EEZ Studio, paleiskite:**

```bash
python fix-lvgl940.py --in-place eez-flow.cpp eez-flow.h
```

**Windows:**
```cmd
cd C:\Users\regte\OneDrive\Documents\Arduino\ESP32C3_1_44_Vandens_Lygis
python C:\path\to\sduino\tools\eez-studio\fix-lvgl940.py --in-place eez-flow.cpp eez-flow.h
```

✅ **Privalumai:** Greita, automatinė, 100% veikia  
⚠️ **Trūkumai:** Reikia paleisti po kiekvieno regeneravimo

---

### ✅ Sprendimas 2: Rankinis (Arduino IDE)

1. Atidarykite `eez-flow.cpp`
2. Spauskite **Ctrl+H** (Find & Replace)
3. **Ieškokite:** `lv_obj_get_style_opa(`
4. Pakeiskite visas `, 0)` į `, LV_PART_MAIN)`
5. Išsaugokite ir kompiliuokite

✅ **Privalumai:** Nereikia papildomų įrankių  
⚠️ **Trūkumai:** Reikia daryti rankiniu būdu, lengva praleisti vietą

---

### ✅ Sprendimas 3: EEZ Studio Šablonų Keitimas (Ilgalaikis)

**Pakeiskite EEZ Studio šablonus, kad sugeneruotas kodas iš karto veiktų.**

#### Kur rasti šablonus:
- Windows: `%APPDATA%\eez-studio\templates\`
- Linux/Mac: `~/.config/eez-studio/templates/`

#### Kas keisti:

**Raskite:** `lv_obj_get_style_opa({{object}}, 0)`  
**Pakeiskite į:** `lv_obj_get_style_opa({{object}}, LV_PART_MAIN)`

Arba taikykite mūsų patch'ą:
```bash
cd /path/to/eez-studio/templates
patch < /path/to/sduino/tools/eez-studio/templates/eez-flow-lvgl940.patch
```

✅ **Privalumai:** Vieną kartą pataisai, daugiau problemų nekyla  
⚠️ **Trūkumai:** Reikia rasti ir keisti EEZ Studio šablonus

---

## Kas Konkretus Keičiasi?

### Pakeitimas 1: ~3837 eilutė
```cpp
// Buvo:
return lv_obj_get_style_opa((lv_obj_t *)a->user_data, 0);

// Dabar:
return lv_obj_get_style_opa((lv_obj_t *)a->user_data, LV_PART_MAIN);
```

### Pakeitimas 2: ~4404 eilutė
```cpp
// Buvo:
int32_t opa = (int32_t)lv_obj_get_style_opa(obj, 0);

// Dabar:
int32_t opa = (int32_t)lv_obj_get_style_opa(obj, LV_PART_MAIN);
```

**Tiek!** Tik `0` → `LV_PART_MAIN` dviejose vietose.

---

## Greiti Linkai

- 🚀 [Quick Fix (English)](QUICK_FIX.md)
- 🇱🇹 [Lietuviškas Vadovas](LIETUVIU.md)
- 📖 [Pilnas Migravimo Vadovas](LVGL_9.40_MIGRATION.md)
- 🔧 [EEZ Studio Šablonų Keitimas](templates/EEZ_STUDIO_TEMPLATES.md)
- 🐍 [Python Script README](README.md)

---

## Kodėl Tai Nutinka?

LVGL 9.40 versijoje funkcija `lv_obj_get_style_opa()` pakeitė antrą parametrą:
- **Seniau:** Priėmė `int` (pvz., `0`)
- **Dabar:** Reikalauja `lv_part_t` tipo (pvz., `LV_PART_MAIN`)

EEZ Studio dar negeneruoja kodo, kuris būtų suderinamas su nauja LVGL versija.

---

## Pagalba

Jei kyla klausimų:
- GitHub Issues: https://github.com/regimantas/sduino/issues
- EEZ Studio: https://github.com/eez-open/studio/discussions
- LVGL Forumas: https://forum.lvgl.io/

---

**Sėkmės su jūsų Arduino projektu! 🎉**
