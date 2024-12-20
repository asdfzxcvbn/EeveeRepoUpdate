package main

import (
	"encoding/json"
	"io"
	"net/http"
	"path/filepath"
	"strings"
)

func AllVersions(uni *Universal) []string {
	versions := make([]string, 0, len(uni.Apps))
	for _, app := range uni.Apps {
		versions = append(versions, app.Version)
	}
	return versions
}

func GetLatestAssets() (*[]GitHubAsset, error) {
	req, _ := http.NewRequest(
		http.MethodGet,
		"https://api.github.com/repos/whoeevee/EeveeSpotify/releases/latest",
		nil,
	)
	req.Header.Set("Accept", "application/vnd.github+json")
	req.Header.Set("X-GitHub-Api-Version", "2022-11-28")

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	rbody, _ := io.ReadAll(resp.Body)

	var ghresp struct {
		Assets []GitHubAsset `json:"assets"`
	}
	if err = json.Unmarshal(rbody, &ghresp); err != nil {
		return nil, err
	}

	assets := make([]GitHubAsset, 0)
	for _, asset := range ghresp.Assets {
		if !strings.HasSuffix(asset.URL, ".ipa") || strings.Contains(asset.URL, "debug") {
			continue
		}

		filename := strings.Replace(filepath.Base(asset.URL), ".ipa", "", 1)
		asset.Version = strings.Split(filename, "-")[2]
		assets = append(assets, asset)
	}

	return &assets, nil
}
