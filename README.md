# Fix CWG Saves

A small Windows tool that repairs save problems with the **CWG** custom map in **Warcraft III**.

You double-click it, answer one question, and it does the rest. It always makes a backup of your saves first, so you can undo everything if needed.

---

## What does it do?

In plain terms, the tool:

1. **Asks for your permission** before touching anything.
2. **Checks that Warcraft III is closed.**
3. **Finds your CWG save folder** (`Documents\Warcraft III\CustomMapData\CWG2`).
4. **Makes a backup copy** of that folder, right next to the original.
5. **Deletes the files whose names start with `ACCOUNT_` and `LEGACY_`** inside the `CWG2` folder. Removing these does not break your save data.

Nothing else on your computer is changed. If any step fails, the tool stops and tells you why. It never deletes anything unless the backup was created successfully.

---

## Before you start

- You need a **Windows** PC.
- **Close Warcraft III completely.** The tool will refuse to run while the game is open.

---

## How to use it

1. **Download** `Fix_CWG_Saves1.1.bat` from this page.
2. **Double-click** the file to run it.
3. If Windows shows a blue **"Windows protected your PC"** box, click **More info**, then **Run anyway**. This appears for most downloaded script files.
4. A black window opens and asks:

   ```
   Are you okay with your save folder being modified? [y/N]:
   ```

   Type **`y`** and press **Enter** to continue.
   (Pressing Enter on its own, or typing anything else, cancels and changes nothing.)
5. Wait a few seconds. When you see **`DONE!`**, press any key to close the window.

### After it finishes

Launch Warcraft III and run the CWG map in **Multiplayer**, in a **solo lobby**: host the game with just yourself in it.

---

## Where is my backup?

The backup is saved in the same place as your save folder:

```
Documents\Warcraft III\CustomMapData\
```

It is named `CWG2-backup` followed by today's date, for example:

```
CWG2-backup20261113
```

If you run the tool more than once on the same day, the earlier backup is kept and the new one gets the time added to its name (for example `CWG2-backup20261113-142530`).

---

## How to undo it (restore your backup)

If the fix doesn't work, or you just want things back the way they were:

1. Close Warcraft III.
2. Open `Documents\Warcraft III\CustomMapData`.
3. Delete the `CWG2` folder.
4. Rename your backup folder (for example `CWG2-backup20261113`) to `CWG2`.

The tool also shows these steps, with the exact folder names, when it finishes.

---

## Troubleshooting

| Message you see | What it means | What to do |
| --- | --- | --- |
| `Warcraft III is currently running` | The game is still open. | Close Warcraft III completely, then run the tool again. |
| `Could not find your Documents folder` | Windows didn't report where your Documents folder is. | Check that your Documents folder exists and is accessible, then try again. |
| `No "Warcraft III" folder was found` | There is no Warcraft III folder inside Documents. | Start Warcraft III at least once on this PC, then try again. |
| `No "CustomMapData" folder was found` | No custom map has saved data on this PC yet. | Play the CWG map once so the folder is created. |
| `No "CWG2" folder was found` | There are no CWG saves on this PC. | Play the CWG map once, or check that you are on the right Windows account. |
| `The backup could not be created` | The copy failed. **Nothing was deleted.** | Make sure you have free disk space and that the folder isn't open in another program, then try again. |
| `Some ACCOUNT_* or LEGACY_* files could not be deleted` | Some files were locked or read-only. | Make sure Warcraft III is closed and try again. Your backup is safe. |
| `No ACCOUNT_* or LEGACY_* files were found` | There was nothing to remove. | No action needed. A backup was still made. |

---

## Is it safe?

- It only works inside your `Documents\Warcraft III\CustomMapData` folder.
- It always backs up first and stops if the backup fails.
- It asks before doing anything, and the default answer is **No**.
- It does not connect to the internet or install anything.
- It is a plain text file. Right-click it and choose **Edit** to read exactly what it does.

---

## FAQ

**My Documents folder is in OneDrive (or I moved it). Will it still work?**
Yes. The tool asks Windows where your Documents folder really is.

**Will I lose my progress?**
The tool only removes the `ACCOUNT_` and `LEGACY_` files, and a full backup is made beforehand. If anything looks wrong afterwards, follow the restore steps above.

**Can I delete the backup folders later?**
Yes. Once you're sure everything works, the `CWG2-backup...` folders can be deleted.

**I typed `y` and the window closed right away. Is that normal?**
No. The window always waits for a key press before closing. Run it again and read the last message shown.
