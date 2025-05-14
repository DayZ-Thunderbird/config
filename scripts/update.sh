#!/bin/bash

STEAMCMD="/root/docker/games/dayz/steamcmd/steamcmd.sh"
INSTALL_DIR="/root/docker/games/dayz/server"
WORKSHOP_DIR="$INSTALL_DIR/steamapps/workshop/content/221100"
KEYS_DIR="$INSTALL_DIR/keys"

# Mod list: [ID]=Comment (optional)
declare -A MODS=(
  # Frameworks
  [1559212036]="CF"
  [2545327648]="Dabs Framework"

  # Expansion mods
  [2116151222]="DayZ-Expansion"
  [2291785308]="DayZ-Expansion-Core"
  [2116157322]="DayZ-Expansion-Licensed"
  [2572328470]="DayZ-Expansion-Market"
  [2792983824]="DayZ-Expansion-Map-Assets"
  [2572324799]="DayZ-Expansion-Book"
  [2804241648]="DayZ-Expansion-Spawn-Selection"
  [2792983364]="DayZ-Expansion-Groups"
  [2792984722]="DayZ-Expansion-Navigation"
  [2792982513]="DayZ-Expansion-BaseBuilding"

  # Weapons
  [3444350187]="TGK WeaponPack"

  # Gameplay
  [1710977250]="BBP"
  [1646187754]="Code Lock"
  [3471358849]="GlobalChatPlus"
  [2536780687]="SkyZ"
  [2345073965]="CJ187-LootChest"
  [1644467354]="Summer Chernorus"

  # Admin tools
  [1564026768]="Community-Online-Tools"
  
  # Custom buildings
  [2276010135]="DayZ Editor Loader"
  [3469320529]="Military Objects Pack"
  [3436495227]="Large 7 Storey Building"

  # Events
  [2491484149]="Helicrash Licensed"

  # Server optimization
  [2469730533]="DayZRedux"
)

# --- SteamCMD mod downloads ---
"$STEAMCMD" +force_install_dir "$INSTALL_DIR" +login anonymous +app_update 223350 \
  $(for ID in "${!MODS[@]}"; do echo "+workshop_download_item 221100 $ID"; done) +quit

# --- Link mod folders ---
for ID in "${!MODS[@]}"; do
  ln -sf "$WORKSHOP_DIR/$ID" "$INSTALL_DIR/$ID"
done

# --- Clean up old keys ---
if [ -d "$KEYS_DIR" ]; then
  find "$KEYS_DIR" -type f ! -name "dayz.bikey" -exec rm -f {} \;
  echo "Old keys (except dayz.bikey) removed from $KEYS_DIR"
else
  echo "Creating keys directory: $KEYS_DIR"
  mkdir -p "$KEYS_DIR"
fi

# --- Link keys from mods ---
for ID in "${!MODS[@]}"; do
  for dir in keys Keys key Key; do
    KEY_SRC="$WORKSHOP_DIR/$ID/$dir"
    if [ -d "$KEY_SRC" ]; then
      ln -sf "$KEY_SRC"/* "$KEYS_DIR/" 2>/dev/null
    fi
  done
done
