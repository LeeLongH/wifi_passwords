import subprocess
import os

"""
Return value from a string "screen" where key matches extractable
<extractable> : <value>
"""
def extract_value(screen, extractable):
    value = [line.split(":")[1].strip() 
        for line in screen.stdout.splitlines() 
        if extractable in line]
    return value

# netsh wlan show profiles
show_wifis = subprocess.run(
    ["netsh", "wlan", "show", "profiles"],
    capture_output=True,
    text=True,
    encoding="utf-8"
)

# get list of wifi names only
wifi_names = extract_value(show_wifis, "All User Profile")

# Prepare string with SSIDs and passwords
wifis_and_passwords = ""

for wifi in wifi_names:
    password_screen = subprocess.run(
        ["netsh", "wlan", "show", "profiles", f"name={wifi}", "key=clear"],
        capture_output=True,
        text=True,
        encoding="utf-8"
    )
    
    # get wifi password
    wifi_password_list = extract_value(password_screen, "Key Content")

    # extract from the list
    wifi_password = wifi_password_list[0] if wifi_password_list else ""

    # concatenate SSIDs and passwords
    wifis_and_passwords += f"{wifi:>30} : {wifi_password}\n"

# Create file "wifi_passwords.txt" in Downloads
with open(r"Downloads/wifi_passwords.txt", "w") as f:
    f.write(wifis_and_passwords)
    
print("Succefully written")
