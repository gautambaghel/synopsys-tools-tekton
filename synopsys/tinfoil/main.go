package main

import (
	"os"
	"fmt"
	"time"
    "strconv"
    "net/http"
	"encoding/json"
)

// ScanStartResponse holds the construct for response on scan start
type ScanStartResponse struct {
	Scan struct {
		EndTime   interface{} `json:"end_time"`
		ID        string      `json:"id"`
		ScanType  string      `json:"scan_type"`
		StartTime interface{} `json:"start_time"`
		Status    string      `json:"status"`
	} `json:"scan"`
}

// ScanRunningResponse holds the construct for response on scan start
type ScanRunningResponse struct {
	Scans []struct {
		Scan struct {
			ID               string    `json:"id"`
			StartTime        time.Time `json:"start_time"`
			ScannerIPAddress string    `json:"scanner_ip_address"`
			EndTime          time.Time `json:"end_time"`
			ScanType         string    `json:"scan_type"`
			Status           string    `json:"status"`
			CancelReason     string    `json:"cancel_reason"`
		} `json:"scan,omitempty"`
	} `json:"scans"`
	TotalPages int `json:"total_pages"`
	PageNumber int `json:"page_number"`
}

func main() {

	const baseURL = "https://www.tinfoilsecurity.com/api/v1"

	token := os.Getenv("TOKEN")
	if len(token) == 0 {
		fmt.Println("TOKEN has not been set. Aborting.")
		return
	}

	accessKey := os.Getenv("ACCESS_KEY")
	if len(accessKey) == 0 {
		fmt.Println("ACCESS_KEY has not been set. Aborting.")
		return
	}

	siteID := os.Getenv("SITE_ID")
	if len(siteID) == 0 {
		fmt.Println("SITE_ID has not been set. Aborting.")
		return
	}

	severityThreashold := os.Getenv("SEVERITY_THRESHOLD")
	if len(severityThreashold) == 0 {
		severityThreashold = "High"
		fmt.Println("SEVERITY_THRESHOLD has not been set. Setting it to HIGH.")
	}

	pollWindow := 5
	pollWindowInput := os.Getenv("POLL_WINDOW")
	if len(pollWindowInput) == 0 {
		fmt.Println("POLL_WINDOW has not been set. Setting it to 5.")
	} else {
		i, err := strconv.Atoi(pollWindowInput)
		if err != nil {
			i = 5
		}
		pollWindow = i		
	}

	url := fmt.Sprintf("%s/sites/%s/scans", baseURL, siteID)
	authorization := fmt.Sprintf("Token token=%s, access_key=%s", token, accessKey)
	
	scanstartJSON := new(ScanStartResponse)
	respCode, err := getJSON(url, authorization, scanstartJSON, http.MethodPost)
	if err != nil {
		panic(err)
	}

	if respCode != 201 {
		panic ("Failed to initiate a scan")
	}

	scanID := scanstartJSON.Scan.ID
	scanShouldEndNow := false

	fmt.Println("Scan initiated successfully with ID ", scanID)

	status := "unknown"
	for scanShouldEndNow != true {
		scanRunningJSON := new(ScanRunningResponse)
		respCode, err := getJSON(url, authorization, scanRunningJSON, http.MethodGet)
		if err != nil {
			panic(err)
		}

		fmt.Print("Scan run response: ", respCode)
		for _, scanDetails := range scanRunningJSON.Scans {
			if (scanDetails.Scan.ID == scanID) {
				status = scanDetails.Scan.Status
			}
		}
		
		fmt.Print(" Scan ID: ", scanID)
		fmt.Println(" Current status: ", status)
		if (status != "scanning") {
			scanShouldEndNow = true
		}

		time.Sleep(time.Duration(pollWindow) * time.Second)
	}

	if status == "cancelled" {
		panic("Scan cancelled. Aborting.")
	} else if status == "done" {
		fmt.Println("Scan succeeded.")
	} else {
		panic("Unknown status. Aborting.")
	}
}

func getJSON (url string, authorization string, target interface{}, requestType string) (int, error) {
	client := &http.Client{}
	req, _ := http.NewRequest(requestType, url, nil)
	req.Header.Set("Authorization", authorization)
	resp, err := client.Do(req)
    if err != nil {
		fmt.Println("Response error")
        panic(err)
    }
    defer resp.Body.Close()
    return resp.StatusCode, json.NewDecoder(resp.Body).Decode(target)
}