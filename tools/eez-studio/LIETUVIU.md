# EEZ Studio LVGL 9.40 Pataisymas - Lietuvių kalba

## Problema

EEZ Studio generuoja kodą, kuris neveikia su LVGL 9.40 versija. Klaida:
```
error: invalid conversion from 'int' to 'lv_part_t' [-fpermissive]
```

## Sprendimas - Tik 2 Pakeitimai!

Reikia pakeisti tik **2 vietas** sugeneruotame kode (ne 5 eilutes, bet principas tas pats - labai paprastai).

### 1. Pakeitimas: ~3837 eilutė

**Buvo (neteisingai):**
```cpp
static int32_t anim_callback_get_opacity(lv_anim_t * a) { 
    return lv_obj_get_style_opa((lv_obj_t *)a->user_data, 0); 
}
```

**Dabar (teisingai):**
```cpp
static int32_t anim_callback_get_opacity(lv_anim_t * a) { 
    return lv_obj_get_style_opa((lv_obj_t *)a->user_data, LV_PART_MAIN); 
}
```

**Kas pasikeitė:** `0` → `LV_PART_MAIN`

---

### 2. Pakeitimas: ~4404 eilutė

**Buvo (neteisingai):**
```cpp
int32_t opa = (int32_t)lv_obj_get_style_opa(obj, 0);
```

**Dabar (teisingai):**
```cpp
int32_t opa = (int32_t)lv_obj_get_style_opa(obj, LV_PART_MAIN);
```

**Kas pasikeitė:** `0` → `LV_PART_MAIN`

---

## Kaip Automatiškai Pataisyti

### Paprasčiausias būdas (Windows):

1. Atidarykite Command Prompt
2. Eikite į Arduino projekto katalogą:
   ```cmd
   cd C:\Users\regte\OneDrive\Documents\Arduino\ESP32C3_1_44_Vandens_Lygis
   ```
3. Paleiskite pataisymo scriptą:
   ```cmd
   python \path\to\fix-lvgl940.py --in-place eez-flow.cpp eez-flow.h
   ```

### Linux/Mac:

```bash
cd ~/Arduino/ESP32C3_1_44_Vandens_Lygis
python3 fix-lvgl940.py --in-place eez-flow.cpp eez-flow.h
```

### Arba rankiniu būdu:

1. Atidarykite `eez-flow.cpp` failą
2. Spauskite Ctrl+H (Find & Replace)
3. Ieškokite: `lv_obj_get_style_opa(` ir pakeiskite visus `, 0)` į `, LV_PART_MAIN)`
4. Išsaugokite failą
5. Kompiliuokite projektą - turėtų veikti!

## Po Pataisymo

Kompiliavimas turėtų veikti be klaidų:
```bash
# Arduino IDE: Spauskite "Verify" mygtuką
# PlatformIO: pio run
```

## Kas Vyksta?

LVGL 9.40 versijoje funkcija `lv_obj_get_style_opa()` nebepriima paprasto skaičiaus `0`, 
ji nori specialaus tipo `lv_part_t`. Standartinė reikšmė yra `LV_PART_MAIN`.

## Daugiau Informacijos

- Pilnas vadovas anglų kalba: [LVGL_9.40_MIGRATION.md](../LVGL_9.40_MIGRATION.md)
- Automatiniai įrankiai: [README.md](../README.md)

## Kontaktai

Jei kyla problemų, žiūrėkite:
- EEZ Studio forumas: https://github.com/eez-open/studio/discussions
- LVGL forumas: https://forum.lvgl.io/
