package main

type GitHubAsset struct {
	URL       string `json:"browser_download_url"`
	UpdatedAt string `json:"updated_at"`
	Size      int64  `json:"size"`

	// will manually be set
	Version string
}
