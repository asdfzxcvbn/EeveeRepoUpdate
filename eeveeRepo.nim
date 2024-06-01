import std/[os, json, strutils, strformat, httpclient]
import jsony

type
  AssetDict = object
    size: int
    created_at: string
    browser_download_url: string

  RelResp = object
    assets: seq[AssetDict]

  NimAsset {.requiresInit.} = object
    size: int
    date: string
    link: string
    version: string

proc extractVersion(url: string): string =
  return splitFile(url).name.split("-")[2]

proc getLatestAssets(): seq[NimAsset] =
  let client = newHttpClient()
  defer: client.close()

  client.headers = newHttpHeaders({
    "accept": "application/vnd.github+json",
    "x-github-api-version": "2022-11-28"
  })

  let
    req = client.getContent("https://api.github.com/repos/whoeevee/EeveeSpotify/releases/latest")
    resp = req.fromJson(RelResp)

  for asset in resp.assets:
    let url = asset.browser_download_url
    if url.endsWith(".ipa") and not url.contains("debug"):
      result.add(NimAsset(
        size: asset.size,
        date: asset.created_at.split("T")[0],
        version: url.extractVersion(),
        link: url
      ))

# hey, now that i think about it, i dont know why im looping?
# i mean, theres only one ipa per release, and im not uploading the debug version
# whatever lol!!!!
var repo = parseFile("repo.json")
repo["apps"] = newJArray()
for asset in getLatestAssets():
  repo["apps"].add(%*{
    "name": "EeveeSpotify",
    "type": 1,
    "bundleIdentifier": "com.spotify.client",
    "version": asset.version,
    "versionDate": asset.date,
    "size": asset.size,
    "downloadURL": asset.link,
    "iconURL": "https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/0c/1f/61/0c1f6144-af80-f395-3204-1d14fd8b2be7/AppIcon-0-0-1x_U007emarketing-0-6-0-0-85-220.png/512x512bb.jpg",
    "localizedDescription": fmt"Spotify v{asset.version} injected with EeveeSpotify",
    "developerName": "Eevee"
  })

writeFile("repo.json", repo.pretty())
