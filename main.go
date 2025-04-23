package main

import (
	"encoding/json"
	"log"
	"os"
	"slices"
)

func main() {
	file, err := os.ReadFile("repo.json")
	if err != nil {
		log.Fatal(err)
	}

	var uni *Universal
	if err = json.Unmarshal(file, &uni); err != nil {
		log.Fatal(err)
	}

	urls := AllDownloadURLs(uni)

	assets, err := GetLatestAssets()
	if err != nil {
		log.Fatal(err)
	}

	for _, asset := range assets {
		// prevent duplicate version when running workflow
		if slices.Contains(urls, asset.URL) {
			continue
		}

		desc := "Spotify v" + asset.Version + " injected with EeveeSpotify"
		uni.Apps = slices.Insert(uni.Apps, 0, UniversalApp{
			Name:          "EeveeSpotify",
			DeveloperName: "Eevee",
			BundleID:      "com.spotify.client",
			Caption:       desc,
			Description:   desc,
			DownloadURL:   asset.URL,
			IconURL:       "https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/0c/1f/61/0c1f6144-af80-f395-3204-1d14fd8b2be7/AppIcon-0-0-1x_U007emarketing-0-6-0-0-85-220.png/512x512bb.jpg",
			Version:       asset.Version,
			Date:          asset.UpdatedAt,
			Size:          asset.Size,
		})
	}

	formatted, err := json.MarshalIndent(uni, "", "  ")
	if err != nil {
		log.Fatal(err)
	}

	if err = os.WriteFile("repo.json", formatted, 0644); err != nil {
		log.Fatal(err)
	}
}
