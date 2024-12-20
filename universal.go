package main

// https://github.com/asdfzxcvbn/UniversalRepoFmt/blob/main/repos/universal.go

type UniversalPermissions struct {
	Entitlements []string          `json:"entitlements"`
	Privacy      map[string]string `json:"privacy"`
}

type UniversalApp struct {
	Name          string `json:"name"`
	DeveloperName string `json:"developerName"`
	BundleID      string `json:"bundleID"`
	Caption       string `json:"caption,omitempty"`
	Description   string `json:"description"`
	DownloadURL   string `json:"downloadURL"`
	IconURL       string `json:"iconURL"`
	Version       string `json:"version"`
	Date          string `json:"date"`
	Size          int64  `json:"size"`
}

type Universal struct {
	Name        string                          `json:"name"`
	Identifier  string                          `json:"identifier"`
	IconURL     string                          `json:"iconURL"`
	Caption     string                          `json:"caption"`
	Description string                          `json:"description"`
	Apps        []UniversalApp                  `json:"apps"`
	Permissions map[string]UniversalPermissions `json:"permissions"`
}
