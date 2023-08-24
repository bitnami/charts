package ginkgo_utils

import (
	"fmt"
	"regexp"
	"time"
)

// containsPattern checks that a given pattern is inside an array of string
func containsPattern(haystack []string, pattern string) (bool, error) {
	var err error

	for _, s := range haystack {
		match, err := regexp.MatchString(pattern, s)
		if match {
			return true, err
		}
	}
	return false, err
}

// Other functions

// Retry performs an operation a given set of attempts
func Retry(name string, attempts int, sleep time.Duration, f func() (bool, error)) (res bool, err error) {
	for i := 0; i < attempts; i++ {
		fmt.Printf("[retriable] operation %q executing now [attempt %d/%d]\n", name, (i + 1), attempts)
		res, err = f()
		if res {
			fmt.Printf("[retriable] operation %q succedeed [attempt %d/%d]\n", name, (i + 1), attempts)
			return res, err
		}
		fmt.Printf("[retriable] operation %q failed, sleeping for %q now...\n", name, sleep)
		time.Sleep(sleep)
	}
	fmt.Printf("[retriable] operation %q failed [attempt %d/%d]\n", name, attempts, attempts)
	return res, err
}
