import std/[json, strformat]
import EeveeRepoUpdate/[helpers]

# hey, now that i think about it, i dont know why im looping?
# i mean, theres only one ipa per release, and im not uploading the debug version
# whatever lol!!!!
let repo = parseFile("repo.json")
for asset in getLatestAssets():
  repo.insertFirstApp(%*{
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
