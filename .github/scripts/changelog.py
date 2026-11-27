#!/usr/bin/env python3
"""Génère / met à jour les CHANGELOG.md des add-ons Home Assistant.

Sous-commandes :
  copy        <url> <fichier>                       copie brute d'un CHANGELOG distant
  jdownloader <fichier> [max_versions]              reconstruit depuis appdefs.yml (jlesage)
  release     <owner/repo> <tag> <titre> <fichier>  ajoute en tête les notes d'une release GitHub

Le format produit suit l'usage des add-ons Home Assistant :
    # Changelog
    ## <version>
    - changement
"""
import json
import os
import re
import sys
import urllib.error
import urllib.request

import yaml

HEADER = "# Changelog\n"


def fetch(url: str, accept: str | None = None) -> bytes:
    headers = {"User-Agent": "ha-addons-changelog"}
    token = os.environ.get("GH_TOKEN")
    if token and "api.github.com" in url:
        headers["Authorization"] = f"Bearer {token}"
    if accept:
        headers["Accept"] = accept
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=30) as resp:
        return resp.read()


def write_if_changed(path: str, content: str) -> None:
    old = None
    if os.path.exists(path):
        with open(path, encoding="utf-8") as f:
            old = f.read()
    if old == content:
        print(f"{path} : inchangé")
        return
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"{path} : mis à jour")


# --- jdownloader ------------------------------------------------------------
JD_APPDEFS = "https://raw.githubusercontent.com/jlesage/docker-jdownloader-2/master/appdefs.yml"


def cmd_jdownloader(path: str, max_versions: str = "20") -> None:
    data = yaml.safe_load(fetch(JD_APPDEFS))
    entries = data.get("app").get("changelog") or []
    out = [HEADER]
    for entry in entries[: int(max_versions)]:
        version = str(entry.get("version", "")).strip()
        date = str(entry.get("date", "")).strip()
        out.append(f"\n## v{version}" + (f" ({date})" if date else "") + "\n\n")
        for change in entry.get("changes") or []:
            change = str(change)
            # Convention jlesage : "2:texte" = sous-élément de niveau 2, etc.
            m = re.match(r"^(\d+):(.*)$", change)
            level, text = (int(m.group(1)), m.group(2)) if m else (1, change)
            out.append("  " * (level - 1) + f"- {text.strip()}\n")
    write_if_changed(path, "".join(out))


# --- release GitHub ---------------------------------------------------------
def cmd_release(repo: str, tag: str, title: str, path: str) -> None:
    content = HEADER
    if os.path.exists(path):
        with open(path, encoding="utf-8") as f:
            content = f.read()
    if not content.startswith("# "):
        content = HEADER + "\n" + content

    heading = f"## {title}"
    if re.search(rf"^{re.escape(heading)}\s*$", content, re.M):
        print(f"{path} : {title} déjà présent")
        return

    url = f"https://api.github.com/repos/{repo}/releases/tags/{tag}"
    try:
        release = json.loads(fetch(url, "application/vnd.github+json"))
        body = (release.get("body") or "").replace("\r\n", "\n").strip()
        link = release.get("html_url") or f"https://github.com/{repo}/releases/tag/{tag}"
    except urllib.error.HTTPError as e:
        if e.code != 404:
            raise
        print(f"::warning::Release {tag} introuvable sur {repo}, lien seul")
        body = ""
        link = f"https://github.com/{repo}/releases"

    # Décale les titres de la release pour qu'ils restent sous "## <version>"
    body = re.sub(r"^(#{1,5}) ", lambda m: "#" + m.group(1) + " ", body, flags=re.M)
    section = f"{heading}\n\n{body or 'Pas de notes de version publiées.'}\n\n[Notes complètes]({link})\n"

    # Insère la nouvelle section juste après le titre principal
    first_line, _, rest = content.partition("\n")
    new_content = f"{first_line}\n\n{section}\n{rest.lstrip()}".rstrip() + "\n"
    write_if_changed(path, new_content)


if __name__ == "__main__":
    commands = {"jdownloader": cmd_jdownloader, "release": cmd_release}
    if len(sys.argv) < 2 or sys.argv[1] not in commands:
        sys.exit(__doc__)
    commands[sys.argv[1]](*sys.argv[2:])
