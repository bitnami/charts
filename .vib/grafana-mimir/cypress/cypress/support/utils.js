/// <reference types="cypress" />

export let lastMinuteTimestamp = (Date.now() - 1000) * 1e6; // Date.now() returns the date in miliseconds
export let random = Math.floor(Math.random() * 1000); // Random integer between 0 and 999