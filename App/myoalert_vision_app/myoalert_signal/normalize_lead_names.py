import re

def normalize_lead_names(hea_file):

    with open(hea_file, "r", encoding="utf-8") as f:
        lines = f.readlines()

    # Mapeo flexible 
    mapping = {
        "i": "I",
        "ii": "II",
        "iii": "III",
        "avr": "aVR",
        "avl": "aVL",
        "avf": "aVF",
        "v1": "V1",
        "v2": "V2",
        "v3": "V3",
        "v4": "V4",
        "v5": "V5",
        "v6": "V6",
    }

    normalized_lines = []
    for line in lines:
        if ".dat" in line:
            parts = line.strip().split()
            if len(parts) >= 9:
                lead_name_raw = parts[-1].strip()
                # Extraer solo letras
                lead_name_clean = re.sub(r"[^a-zA-Z0-9]", "", lead_name_raw).lower()

                # Reemplazar por el nombre estándar si existe
                if lead_name_clean in mapping:
                    parts[-1] = mapping[lead_name_clean]
                else:
                    parts[-1] = lead_name_raw 

                line = " ".join(parts) + "\n"
        normalized_lines.append(line)

    # Guardar versión limpia
    temp_file = hea_file.replace(".hea", "_normalized.hea")
    with open(temp_file, "w", encoding="utf-8") as f:
        f.writelines(normalized_lines)

    return temp_file
