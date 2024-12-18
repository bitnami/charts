/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

export let lastMinuteTimestamp = Date.now() * 1e6 - 6e1 * 1e9; // Date.now() returns the date in miliseconds
