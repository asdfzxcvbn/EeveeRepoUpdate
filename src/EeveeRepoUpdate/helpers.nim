import std/[os, json, strutils, httpclient]
import jsony

type
  AssetDict = object
    size: int
    created_at: string
    browser_download_url: string

  RelResp = object
    assets: seq[AssetDict]

  NimAsset* {.requiresInit.} = object
    size*: int
    date*, link*, version*: string

proc extractVersion(url: string): string =
  return splitFile(url).name.split("-")[2]

proc getLatestAssets*(): seq[NimAsset] =
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
        version: extractVersion url,
        link: url
      ))

proc insertFirstApp*(parent, child: JsonNode): void =
  ## this was pretty much my first thought
  assert parent.contains("apps")
  let apps = copy parent["apps"]

  parent["apps"] = %*[child]
  for old in apps:
    parent["apps"].add(old)
