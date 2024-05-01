/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

export let lastMinuteTimestamp = (Date.now() - 1000) * 1e6; // Date.now() returns the date in miliseconds
export let random = Math.floor(Math.random() * 1000).toString(); // String with random integer between 0 and 999