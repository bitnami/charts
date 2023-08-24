package ginkgo_utils

import (
	"regexp"
	"time"

	"k8s.io/apimachinery/pkg/util/wait"
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
func Retry(name string, attempts int, sleep time.Duration, f func() (bool, error)) (err error) {
	backoff := wait.Backoff{
		Duration: sleep * time.Millisecond,
		Jitter:   0,
		Factor:   2,
		Steps:    attempts,
	}
	err = wait.ExponentialBackoff(backoff, f)
	return err
}
