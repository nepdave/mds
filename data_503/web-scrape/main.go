package main

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
	"time"
)

const (
	searchURL  = "https://api.discogs.com/database/search?sort=have&sort_order=desc&type=release&page=%d&per_page=25"
	releaseURL = "https://api.discogs.com/releases/%d"
	userAgent  = "DiscogsCSVExport/1.0"
	rateDelay  = 3 * time.Second
	maxRetries = 3
)

type SearchResponse struct {
	Results []SearchResult `json:"results"`
}

type SearchResult struct {
	ID    int    `json:"id"`
	Title string `json:"title"`
	URI   string `json:"uri"`
}

type ReleaseResponse struct {
	Community struct {
		Rating struct {
			Average float64 `json:"average"`
			Count   int     `json:"count"`
		} `json:"rating"`
	} `json:"community"`
}

type Record struct {
	AlbumName  string
	ArtistName string
	AlbumLink  string
	AvgRating  string
	NumRatings string
}

func fetchJSON(url string, target interface{}) error {
	for attempt := 0; attempt < maxRetries; attempt++ {
		req, err := http.NewRequest("GET", url, nil)
		if err != nil {
			return err
		}
		req.Header.Set("User-Agent", userAgent)

		resp, err := http.DefaultClient.Do(req)
		if err != nil {
			return err
		}

		if resp.StatusCode == 429 {
			resp.Body.Close()
			wait := 30 * time.Second
			fmt.Printf("    Rate limited, waiting %v...\n", wait)
			time.Sleep(wait)
			continue
		}

		if resp.StatusCode != 200 {
			resp.Body.Close()
			return fmt.Errorf("HTTP %d", resp.StatusCode)
		}

		err = json.NewDecoder(resp.Body).Decode(target)
		resp.Body.Close()
		return err
	}
	return fmt.Errorf("max retries exceeded")
}

func main() {
	var records []Record

	// Fetch search pages 1-4
	for page := 1; page <= 4; page++ {
		fmt.Printf("Fetching search page %d...\n", page)
		var sr SearchResponse
		if err := fetchJSON(fmt.Sprintf(searchURL, page), &sr); err != nil {
			log.Fatalf("search page %d: %v", page, err)
		}

		for _, r := range sr.Results {
			artist, album := splitTitle(r.Title)
			records = append(records, Record{
				AlbumName:  album,
				ArtistName: artist,
				AlbumLink:  "https://www.discogs.com" + r.URI,
			})
		}
		time.Sleep(rateDelay)
	}

	// Fetch detail pages for ratings
	for i := range records {
		// Extract release ID from the URI
		id := extractID(records[i].AlbumLink)
		if id == 0 {
			fmt.Printf("  Skipping %s (no ID)\n", records[i].AlbumName)
			continue
		}

		fmt.Printf("  [%d/%d] Fetching ratings for: %s\n", i+1, len(records), records[i].AlbumName)
		var rr ReleaseResponse
		if err := fetchJSON(fmt.Sprintf(releaseURL, id), &rr); err != nil {
			fmt.Printf("    Error: %v\n", err)
			time.Sleep(rateDelay)
			continue
		}

		records[i].AvgRating = fmt.Sprintf("%.2f", rr.Community.Rating.Average)
		records[i].NumRatings = fmt.Sprintf("%d", rr.Community.Rating.Count)

		time.Sleep(rateDelay)
	}

	// Write CSV
	f, err := os.Create("discogs_releases.csv")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	w := csv.NewWriter(f)
	w.Write([]string{"album_name", "artist_name", "album_link", "avg_rating", "num_ratings"})

	for _, r := range records {
		w.Write([]string{r.AlbumName, r.ArtistName, r.AlbumLink, r.AvgRating, r.NumRatings})
	}
	w.Flush()

	if err := w.Error(); err != nil {
		log.Fatal(err)
	}

	fmt.Printf("\nDone! Wrote %d records to discogs_releases.csv\n", len(records))
}

func splitTitle(title string) (artist, album string) {
	parts := strings.SplitN(title, " - ", 2)
	if len(parts) == 2 {
		return strings.TrimSpace(parts[0]), strings.TrimSpace(parts[1])
	}
	return "", title
}

func extractID(url string) int {
	// URL format: https://www.discogs.com/release/4570366-Daft-Punk-Random-Access-Memories
	parts := strings.Split(url, "/release/")
	if len(parts) != 2 {
		return 0
	}
	idStr := strings.SplitN(parts[1], "-", 2)[0]
	var id int
	fmt.Sscanf(idStr, "%d", &id)
	return id
}
