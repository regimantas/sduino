# GREITAS SPRENDIMAS - 1 KOMANDA

## Windows (Command Prompt arba PowerShell)

Eikite į savo Arduino projekto folderį ir paleiskite:

```cmd
python fix-lvgl940.py --in-place eez-flow.cpp eez-flow.h
```

Arba naudodami pilną kelią:
```cmd
cd C:\Users\regte\OneDrive\Documents\Arduino\ESP32C3_1_44_Vandens_Lygis
python C:\path\to\sduino\tools\eez-studio\fix-lvgl940.py --in-place eez-flow.cpp eez-flow.h
```

## Linux/Mac

```bash
cd ~/Arduino/YourProject
python3 /path/to/sduino/tools/eez-studio/fix-lvgl940.py --in-place eez-flow.cpp eez-flow.h
```

## Arba Arduino IDE

1. Atidarykite `eez-flow.cpp`
2. Edit → Find (Ctrl+F)
3. Ieškokite: `, 0)` po `lv_obj_get_style_opa`
4. Pakeiskite į: `, LV_PART_MAIN)`
5. Replace All
6. Išsaugokite
7. Compile - veiks!

---

**Tiek! Projektas turėtų kompiliuotis be klaidų.**
